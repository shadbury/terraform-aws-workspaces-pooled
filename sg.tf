resource "aws_security_group" "workspace_sg" {
  name        = "workspace-sg"
  description = "Security group for workspaces"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "workspace_sg_ingress" {
  count = length(var.security_group.ingress)

  type              = "ingress"
  from_port         = var.security_group.ingress[count.index].from_port
  to_port           = var.security_group.ingress[count.index].to_port
  protocol          = var.security_group.ingress[count.index].protocol
  cidr_blocks       = var.security_group.ingress[count.index].cidr_blocks
  security_group_id = aws_security_group.workspace_sg.id
}

resource "aws_security_group_rule" "workspace_sg_egress" {
  count = length(var.security_group.egress)

  type              = "egress"
  from_port         = var.security_group.egress[count.index].from_port
  to_port           = var.security_group.egress[count.index].to_port
  protocol          = var.security_group.egress[count.index].protocol
  cidr_blocks       = var.security_group.egress[count.index].cidr_blocks
  security_group_id = aws_security_group.workspace_sg.id
}
