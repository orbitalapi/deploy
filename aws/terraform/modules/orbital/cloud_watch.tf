resource "aws_cloudwatch_log_group" "main" {
   name              = "${var.system_name}_${var.environment}"
   retention_in_days = 5
}
