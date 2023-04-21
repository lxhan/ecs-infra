/* -------------------------------------------------------------------------- */
/*                                   Common                                   */
/* -------------------------------------------------------------------------- */
variable "app_name" {
  type    = string
  default = "api-server"
}
variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_profile" {
  type    = string
  default = "naonow"
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

/* -------------------------------------------------------------------------- */
/*                                   Network                                  */
/* -------------------------------------------------------------------------- */
variable "az_count" {
  type    = string
  default = "2"
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}

variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "app_port" {
  type    = number
  default = 4000
}

/* -------------------------------------------------------------------------- */
/*                                     ECS                                    */
/* -------------------------------------------------------------------------- */
variable "ecs_task_execution_role_name" {
  type    = string
  default = "ecs-task-exec-role"
}

variable "ecs_auto_scale_role_name" {
  type    = string
  default = "ecs-auto-scale-role"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "app_count" {
  type    = string
  default = "1"
}

variable "container_name" {
  type    = string
  default = "api-server-container"
}
