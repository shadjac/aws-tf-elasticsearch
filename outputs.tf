output "elastic-nodes" {
	value = "${data.aws_instance.web.public_ip}"
}

