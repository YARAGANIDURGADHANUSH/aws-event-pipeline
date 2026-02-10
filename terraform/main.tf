# ---------- S3 Bucket ----------
resource "aws_s3_bucket" "input_bucket" {
  bucket = "${var.project_name}-input-bucket"
}

# ---------- IAM Role ----------
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# ---------- IAM Policy Attachment ----------
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ---------- Lambda Function ----------
resource "aws_lambda_function" "data_processor" {
  function_name = "${var.project_name}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "process_data.lambda_handler"
  runtime       = var.lambda_runtime

  filename         = "../lambda/process_data.zip"
  source_code_hash = filebase64sha256("../lambda/process_data.zip")
}

# ---------- Allow S3 to Trigger Lambda ----------
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
}
