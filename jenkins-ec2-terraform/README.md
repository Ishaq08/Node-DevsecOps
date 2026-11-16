# Jenkins server on AWS EC2 (Terraform)

1. Install Terraform and AWS CLI, then run `aws configure` (use an IAM user's keys, not root).
2. Find your IP: `curl ifconfig.me`
3. Run:
       terraform init
       terraform apply -var="my_ip_cidr=YOUR.IP.HERE/32"
4. Wait ~3 minutes, then open the `jenkins_url` output.
5. Get the unlock password:
       ssh -i jenkins-server-key.pem ubuntu@<public_ip>
       sudo cat /var/lib/jenkins/secrets/initialAdminPassword
6. When finished: `terraform destroy -var="my_ip_cidr=YOUR.IP.HERE/32"`
