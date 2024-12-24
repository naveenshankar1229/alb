resource "aws_lb" "network" {
  name = "naveen-network-loadbalancer"
  internal = false
  load_balancer_type = "network"
  security_groups = [aws_security_group.sg.id]
  subnets = [aws_subnet.public[0].id,aws_subnet.public[1].id]
  tags = {
    Name = "${var.vpc_name}-loadbalancer"
  }
}

resource "aws_lb_target_group" "nav" {
  name = "naveen-target"
  port = 8080
  protocol = "TCP"
  vpc_id = aws_vpc.dev.id
  target_type = "instance"
  health_check {
    protocol = "TCP"
    interval =30
    healthy_threshold =2
    unhealthy_threshold =2
  }
  tags = {
   Name = "${var.vpc_name}-target"
  }
}

resource "aws_lb_target_group_attachment" "instances" {
    target_group_arn = aws_lb_target_group.nav.arn
    target_id = aws_instance.server[0].id
    port = 8080
  
}

resource "aws_lb_listener" "TCP" {
    load_balancer_arn = aws_lb.network.arn
    port = 80
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.nav.arn
    }
}