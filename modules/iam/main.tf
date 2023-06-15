resource "aws_iam_user" "user1" {
  name = var.user_1_name
  path = var.path
  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_user" "user2" {
  name = var.user_2_name
  path = var.path
  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_group" "administrator" {
  name = var.iam_group_name
  path = var.path_2
}
resource "aws_iam_group_membership" "team" {
  name = var.group-membership
  users = [
    aws_iam_user.user1.name
  ]
  group = aws_iam_group.administrator.name
}
resource "aws_iam_group_policy" "my_developer_policy" {
  name  = var.group_policy_name
  group = aws_iam_group.administrator.name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [ "*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
data "aws_iam_policy_document" "doc" {
  statement {
    effect   = "Allow"
    actions  = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "policy" {
  name        = var.user_policy_name
  description = "user 2 policy"
  policy      = data.aws_iam_policy_document.doc.json
}
resource "aws_iam_policy_attachment" "test-attach" {
  name       = var.policy_attachment_name
  users      = [aws_iam_user.user2.name]
  policy_arn = aws_iam_policy.policy.arn
}