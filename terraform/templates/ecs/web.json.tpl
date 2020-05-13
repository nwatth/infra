[
  {
    "name": "web",
    "image": "dockersamples/static-site",
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${logs_group}",
          "awslogs-region": "${logs_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": ${host_port}
      }
    ],
    "environment" : [
      { "name" : "string", "value" : "string" },
      { "name" : "string", "value" : "string" }
    ]
  }
]
