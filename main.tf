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

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "ecs-nginx-service-13520105"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 1024
  container_definitions    = <<DEFINITION
  [
    {
      "name" : "nginx",
      "image" : "nginx:1.23.1",
      "cpu" : 256,
      "memory": 1024,
      "network_mode": "awsvpc",
      "essential" : true,
      "portMappings": [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_cluster" "main" {
  name = "nginx-cluster-13520105"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-nginx-service-13520105"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_task_sg.id]
    subnets         = aws_subnet.ecs_private_subnet.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_lb_tg.id
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.ecs_lb_listener
  ]
}

output "aws_lb_hostname" {
  value = aws_lb.ecs_lb.dns_name
}


