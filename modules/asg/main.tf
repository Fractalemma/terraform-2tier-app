resource "aws_launch_template" "launch_tpl" {
  name          = "${var.module_prefix}-tpl"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = var.user_data

  # Just for debugging purpose, attach IAM role to instance to allow secure SSM access:
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_ssm_profile.arn
  }

  vpc_security_group_ids = [var.web_sg_id]
  tags = {
    Name = "${var.module_prefix}-launch-tpl"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template



resource "aws_autoscaling_group" "this" {
  name                      = "${var.module_prefix}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_cap
  health_check_grace_period = 300 # seconds = 5 minutes
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = [var.pri_sub_web_a_id, var.pri_sub_web_b_id]
  target_group_arns         = [var.tg_arn]

  launch_template {
    id      = aws_launch_template.launch_tpl.id
    version = aws_launch_template.launch_tpl.latest_version
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
