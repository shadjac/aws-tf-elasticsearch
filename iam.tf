resource "aws_iam_role" "elasticsearch_discovery_role" {
  name               = "s3-role"
  assume_role_policy = "${file("${path.module}/files/ec2-assume-role-policy.json")}"
}

resource "aws_iam_policy" "elasticsearch_discovery_policy" {
  name        = "elasticsearch_discovery_policy"
  description = "elasticsearch_discovery_policy"
  policy      = "${file("${path.module}/files/elasticsearch-discovery-policy.json")}"
}

resource "aws_iam_policy_attachment" "elasticsearch_discovery_policy_attachment" {
  name       = "elasticsearch_discovery_policy_attachment"
  roles      = ["${aws_iam_role.elasticsearch_discovery_role.name}"]
  policy_arn = "${aws_iam_policy.elasticsearch_discovery_policy.arn}"
}

resource "aws_iam_instance_profile" "elasticsearch_discovery_instance_profile" {
  name  = "elasticsearch_discovery_instance_profile"
  role = "${aws_iam_role.elasticsearch_discovery_role.name}"
}
