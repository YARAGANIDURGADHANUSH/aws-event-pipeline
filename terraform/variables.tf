variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "aws-event-pipeline"
}

variable "lambda_runtime" {
  description = "Lambda runtime version"
  type        = string
  default     = "python3.10"
}
