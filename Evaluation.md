# Red Team Infrastructure Evaluation Survey

## Identity and Access Management (IAM)

### IAM Security Evaluation

1. Are IAM policies designed to grant the least privilege necessary for users to perform their tasks?
2. Are access keys used? Are they reviewed and rotated regularly?
3. Are users are organized into groups with appropriate permissions, rather than assigning permissions individually?
4. Is MFA Enabled?
5. Is Cloudtrail enabled to log IAM actions and review logs for suspicious activity?
6. Is Cloudtrail enabled to log billing actions and review logs for suspicious activity?
7. Are service control policies sufficiently enabled for AWS Organizations?
8. What could be added to Identity and Access Management to make it more secure?
9. Is root used?

### IAM Scalability Evaluation

1. Are new users easy to add?
2. Are new roles easy to add?
3. Are new AWS accounts easy to add?
4. Are permissions for users easy to add?

### IAM Efficacy Evaluation

1. Does this IAM structure work to help a red team perform effectively?
2. Is there anything you don’t like about this IAM structure?
3. Is the IAM structure clearly explained in the ReadMe? What more could be added?
4. What can be added to Identity and Access Management to make it more effective?

## Network & Storage Services

### N&S Security Evaluation

1. Is public access to S3 blocked?

### N&S Scalability Evaluation

1. Are new network services easy to add?

## N&S Efficacy Evaluation

1. Does this network structure work to help a red team perform effectively?
2. Is there anything you don’t like about this network structure?
3. Is the network structure clearly explained in the ReadMe? What more could be added?
4. What can be added to the network to make it more effective?

## Compute & EC2 Services

### EC2 Security Evaluation

### EC2 Scalability Evaluation

1. Are new compute resources easy to add?

### EC2 Efficacy Evaluation

1. Does this compute structure work to help a red team perform effectively?
2. Is there anything you don’t like about this compute structure?
3. Is the compute structure clearly explained in the ReadMe? What more could be added?
4. What can be added to the compute structure to make it more effective?

## Terraform/Other

### Other Security Evaluation

1. Does code contain hardcoded credentials or give away any secrets?
2. Does console access for Terraform only require the use of short-term credentials?

### Other Scalability Evaluation

1. Can you see this solution being helpful for other red teams? Why or why not?
2. Is terraform stored in a remote state?

### Other Efficacy Evaluation

1. Is terraform readable and easy to build on?
2. Are underscores used instead of dashes in naming ?
3. Are resource types repeated in resource names?
4. Are variable names easy to understand? Was the “wheel reinvented?”
5. Are plural variable names used?
6. Is terraform fmt applied to all files?

## Sources

The questions in this survey are based off of Terraform and AWS best practices

1. (Terraform)<https://www.terraform-best-practices.com/>
2. (AWS)<https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html>

With any questions, please reach out to [nvaccaro3@gatech.edu](mailto:nvaccaro3@gatech.edu)
