module "inspector_assessment_target_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = concat(module.this.attributes, ["inspector", "assessment", "target"])
  context    = module.this.context
}

resource "aws_inspector_assessment_target" "target" {
  count = local.create ? 1 : 0

  name = module.inspector_assessment_target_label.id
}

module "inspector_assessment_template_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = concat(module.this.attributes, ["inspector", "assessment", "template"])
  context    = module.this.context
}

resource "aws_inspector_assessment_template" "assessment" {
  count = local.create ? 1 : 0

  name               = module.inspector_assessment_template_label.id
  target_arn         = aws_inspector_assessment_target.target[0].arn
  duration           = var.assessment_duration
  rules_package_arns = local.rules_package_arns

  dynamic "event_subscription" {
    for_each = var.assessment_event_subscription

    iterator = item

    content {
      event     = item.value.event
      topic_arn = item.value.topic_arn
    }
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# Create a scheduled event to run inspector
#-----------------------------------------------------------------------------------------------------------------------
module "inspector_schedule_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = concat(module.this.attributes, ["inspector", "schedule"])
  context    = module.this.context
}

resource "aws_cloudwatch_event_rule" "schedule" {
  count               = local.create ? 1 : 0
  name                = module.inspector_schedule_label.id
  description         = var.event_rule_description
  schedule_expression = var.schedule_expression

  tags = module.this.tags
}

resource "aws_cloudwatch_event_target" "target" {
  count    = local.create ? 1 : 0
  rule     = aws_cloudwatch_event_rule.schedule[0].name
  arn      = aws_inspector_assessment_template.assessment[0].arn
  role_arn = local.create_iam_role ? module.iam_role[0].arn : var.iam_role_arn
}

#-----------------------------------------------------------------------------------------------------------------------
# Optionally create an IAM Role
#-----------------------------------------------------------------------------------------------------------------------
module "iam_role" {
  count   = local.create_iam_role ? 1 : 0
  source  = "cloudposse/iam-role/aws"
  version = "0.16.2"

  principals = {
    "Service" = ["events.amazonaws.com"]
  }

  use_fullname = true

  policy_documents = [
    data.aws_iam_policy_document.start_assessment_policy[0].json,
  ]

  policy_document_count = 1
  policy_description    = "AWS Inspector IAM policy"
  role_description      = "AWS Inspector IAM role"

  context = module.this.context
}

data "aws_iam_policy_document" "start_assessment_policy" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid       = "StartAssessment"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["inspector:StartAssessmentRun"]
  }
}

data "aws_region" "current" {}
