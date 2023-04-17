variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "ecs_task_execution_role_name" {
  type    = string
  default = "ecs-task-exec-role"
}

variable "ecs_auto_scale_role_name" {
  type    = string
  default = "ecs-auto-scale-role"
}

variable "az_count" {
  type    = string
  default = "2"
}

variable "app_count" {
  type    = string
  default = "1"
}

variable "docker_image" {
  type    = string
  default = ""
}

variable "app_port" {
  type    = number
  default = 4000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "common_tags" {
  type        = map(any)
  description = "Common tags to apply to all resources"
  default = {
    Owner       = "Alex Han"
    Project     = "API Server"
    Environment = "PROD"
  }
}
