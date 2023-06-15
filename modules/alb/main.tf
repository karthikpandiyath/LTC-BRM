resource "aws_lb_target_group" "test" {
  name     = var.targetname
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.target_id1
  port             = 80
}
resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = var.target_id2
  port             = 80
}
resource "aws_lb" "test" {
  name               = var.lb1_name
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_securitygroup.id]
  subnets            = var.subnets
  tags = {
    Environment = "production"
  }
}
resource "aws_lb_listener" "HTTP_RULE" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
resource "aws_security_group" "lb_securitygroup" {
  name   = var.lb1_securitygroup_name
  vpc_id = var.vpc_id
  // To Allow SSH Transport
  ingress {
    from_port   = var.port_number_1
    protocol    = var.lb_protocol1
    to_port     = var.port_number_1
    cidr_blocks = var.lb_CIDR_1
  }
    ingress {
    from_port   = var.port_number_2
    protocol    = var.lb_protocol2
    to_port     = var.port_number_2
    cidr_blocks = var.lb_CIDR_2
  }
}