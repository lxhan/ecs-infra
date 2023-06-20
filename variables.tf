/* -------------------------------------------------------------------------- */
/*                                   Common                                   */
/* -------------------------------------------------------------------------- */
variable "app_name" {
  type    = string
  default = "appname"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "common_tags" {
  type        = map(any)
  description = "Common tags to apply to all resources"
  default = {
    Owner       = "Alex Han"
    Project     = "appname"
    Environment = "dev"
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Network                                  */
/* -------------------------------------------------------------------------- */
variable "az_count" {
  type    = string
  default = 2
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "health_check_matcher" {
  type    = number
  default = 200
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
variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "app_count" {
  type    = number
  default = 1
}
