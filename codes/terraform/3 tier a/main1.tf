# Create a listener for the load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

# Create an autoscaling group for the backend instances
resource "aws_autoscaling_group" "asg" {
  name                   = "my-autoscaling-group"
  max_size               = 3
  min_size               = 1
  desired_capacity       = 2
  vpc_zone_identifier    = aws_subnet.private_subnet.*.id
  launch_configuration   = "${aws_launch_configuration.lc.name}"
  target_group_arns      = [aws_lb_target_group.tg.arn]
  health_check_type      = "EC2"
}

# Create a launch configuration for the backend instances
resource "aws_launch_configuration" "lc" {
  name                 = "my-launch-configuration"
  image_id             = "ami-12345678"
  instance_type        = "t2.micro"
  security_groups      = ["sg-12345678"]
  key_name             = "my-key-pair"
  associate_public_ip_address = false
  user_data            = "${file("userdata.sh")}"
}

# Create a security group for the backend instances
resource "aws_security_group" "sg" {
  name        = "my-security-group"
  description = "Security group for the backend instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
