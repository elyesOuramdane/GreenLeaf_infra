########################################
# 1) IAM role + instance profile (SSM)
########################################
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

########################################
# 2) Security Group App (pare-feu instance)
########################################
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security group for app instances in ASG"
  vpc_id      = var.vpc_id

  # TEMPORAIRE MVP: on ouvre HTTP depuis le VPC
  # plus tard: on remplacera par "depuis SG ALB uniquement"
  ingress {
    description = "HTTP from VPC (temporary until ALB SG is in place)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # large, à resserrer quand vous fixez vos CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
  }
}

########################################
# 3) AMI (Amazon Linux 2023) + Launch Template
########################################
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  # user_data minimal : juste un log pour prouver que ça boot
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "BOOT OK $(date)" > /var/log/greenleaf_boot.log
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-asg-instance"
      Environment = var.environment
      Project     = "GreenLeaf"
      ManagedBy   = "Terraform"
    }
  }
}

########################################
# 4) Auto Scaling Group
########################################
resource "aws_autoscaling_group" "app" {
  name                = "${var.environment}-asg"
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids

  health_check_type         = var.alb_target_group_arn == null ? "EC2" : "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  dynamic "target_group_arns" {
    for_each = var.alb_target_group_arn == null ? [] : [var.alb_target_group_arn]
    content  = target_group_arns.value
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-asg"
    propagate_at_launch = true
  }
}
