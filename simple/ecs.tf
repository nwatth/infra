data "template_file" "web" {
  template = file("./simple/templates/ecs/web.json.tpl")

  vars = {
    cpu         = var.web_cpu
    memory      = var.web_memory
    host_port   = var.web_port
    logs_group  = aws_cloudwatch_log_group.log_group_web.name
    logs_region = var.aws_region
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.name}-web-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.web_cpu
  memory                   = var.web_memory
  container_definitions    = data.template_file.web.rendered
}

resource "aws_ecs_service" "web" {
  name            = "${var.name}-web"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.web_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.web_ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.id
    container_name   = "web"
    container_port   = var.web_port
  }

  depends_on = [aws_alb_listener.web, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

