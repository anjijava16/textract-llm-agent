variable "queue_name" {
  type = string
}

variable "dlq_name" {
  type = string
}

variable "max_receive_count" {
  type    = number
  default = 5
}
