########################################
# 1) IAM role + instance profile (SSM)
########################################
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
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

  vpc_security_group_ids = var.security_group_ids

  # user_data minimal : installation de httpd pour test load balancer
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from GreenLeaf Dev!</h1><p>Instance ID: $(curl http://169.254.169.254/latest/meta-data/instance-id)</p>" > /var/www/html/index.html
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

  # If an ALB target group is provided, attach the ASG to it.
  target_group_arns = var.alb_target_group_arn == null ? [] : [var.alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.environment}-asg"
    propagate_at_launch = true
  }
}
