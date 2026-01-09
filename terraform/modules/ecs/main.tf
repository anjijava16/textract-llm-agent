resource "aws_ecs_cluster" "this" {
  name = "textract-api-cluster"
}

resource "aws_ecs_task_definition" "api" {
  family                   = "textract-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = var.execution_role

  container_definitions = jsonencode([
    {
      name  = "api"
      image = var.image
      portMappings = [{ containerPort = 8000 }]
      environment = [
        { name = "UPLOAD_BUCKET", value = var.upload_bucket },
        { name = "SNS_TOPIC_ARN", value = var.sns_topic_arn },
        { name = "TEXTRACT_ROLE_ARN", value = var.textract_role_arn }
      ]
    }
  ])
}
