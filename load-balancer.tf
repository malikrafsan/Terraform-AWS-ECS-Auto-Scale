resource "aws_lb" "ecs_lb" {
  name               = "ecs-lb-13520105"
  internal           = false
  subnets            = aws_subnet.ecs_public_subnet.*.id
  security_groups    = [aws_security_group.ecs_lb_sg.id]
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "ecs_lb_tg" {
  name        = "ecs-lb-tg-13520105"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_lb_tg.arn
    type             = "forward"
  }
}
