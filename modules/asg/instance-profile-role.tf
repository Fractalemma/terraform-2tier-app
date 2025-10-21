# IAM Role for EC2 instances to use SSM
resource "aws_iam_role" "ec2_ssm_role" {
  name               = "${var.module_prefix}-ec2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.module_prefix}-ec2-ssm-role"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role



# Attach AWS managed policy for SSM
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment



# Instance Profile to attach the role to EC2 instances
resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.module_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name

  tags = {
    Name = "${var.module_prefix}-ec2-ssm-profile"
  }
}

# See:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile