# Terraform Documentation

## What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows users to define and provision data center infrastructure using a high-level configuration language. 

## Why Use Terraform?

Terraform enables users to manage and provision their infrastructure in a consistent and reproducible manner. By defining infrastructure as code, Terraform allows for version control, collaboration, and automation, which significantly reduces the risk of human error and improves the efficiency of managing resources.

## Benefits of Terraform

- **Infrastructure as Code (IaC)**: Facilitates infrastructure management using code, making it easier to version control and collaborate.
- **Automation**: Automates the provisioning and management of resources, reducing manual intervention.
- **Consistency**: Ensures that infrastructure configurations remain consistent across different environments.
- **Scalability**: Simplifies scaling infrastructure up or down based on requirements.
- **Integration**: Supports multiple cloud providers and services, offering flexibility in managing a hybrid infrastructure.

## Installation guide
Terraform works on CLI, use this guide to Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

## File Format

Terraform configuration files use HashiCorp Configuration Language (HCL) and follow a key-value syntax. These files typically have a `.tf` extension.

```bash
provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "app_instance" {
    ami                    = "ami-02f0341ac93c96375"
    instance_type          = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "lui-terraform-tech258-app"
    }
}
```

### Init, Plan, Apply, Destroy

- **`terraform init`**: Initializes a working directory containing Terraform configuration files. This command downloads necessary plugins and sets up the backend.

- **`terraform plan`**: Creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in the configuration files. It helps to verify the changes before applying them.

- **`terraform apply`**: Applies the changes required to reach the desired state of the configuration. It provisions or modifies the infrastructure accordingly.

- **`terraform destroy`**: Destroys the infrastructure managed by the configuration files. It is used to clean up and remove all resources defined in the configurations.

### AWS Environment Variables

You can use AWS environment variables to configure Terraform to use AWS credentials without hardcoding them directly in your configuration files. This approach enhances security and flexibility, especially when working in a team or across different environments.

To set AWS environment variables for Terraform, you can use the following:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="your-preferred-region"
```
Replace "your-access-key-id", "your-secret-access-key", and "your-preferred-region" with your actual AWS credentials and preferred region. Terraform automatically detects these environment variables and uses them to authenticate with AWS when executing commands like terraform plan and terraform apply.

Make sure to set these environment variables in your terminal session or in your CI/CD environment before running Terraform commands.

### AWS Credentials Warning

```bash
# aws-access-key-id = MUST NOT HARDCODE THE KEY
# aws-secret-access-key = MUST NOT HARDCODE THE KEY
# MUST NOT PUSH ANYTHING TO GITHUB UNTIL WE HAVE CREATED A .gitignore FILE TOGETHER.
```

**Important**: Never hardcode AWS credentials directly in your Terraform files. Always use environment variables or a secrets management service to securely manage your keys.

### Example: Launch an EC2 Instance on AWS

Below is an example Terraform configuration to create a service on the cloud by launching an EC2 instance on AWS.

```bash
# Define the AWS provider and region
provider "aws" {
    region = "eu-west-1"
}

# Define the EC2 instance resource
resource "aws_instance" "app_instance" {
    ami                    = "ami-02f0341ac93c96375"  # Specify the AMI to use
    instance_type          = "t2.micro"              # Specify the instance type
    associate_public_ip_address = true               # Associate a public IP address
    tags = {
        Name = "luixhiano-terraform-tech258-app"     # Tag the EC2 instance
    }
}
```

### HCL Syntax

Terraform configuration files use HCL (HashiCorp Configuration Language), which follows a simple key-value format. Here’s an example:

```bash
key = "value"
```

Ensure that you do not push any configurations containing sensitive information to version control systems such as GitHub until a `.gitignore` file is set up to exclude sensitive files.

### AWS Provider Configuration

The `provider` block is used to define the AWS provider and specify the region for resource deployment.

```bash
provider "aws" {
    region = "eu-west-1"
}
```

### EC2 Instance Resource

The `resource` block defines the AWS EC2 instance. It includes attributes like `ami`, `instance_type`, `associate_public_ip_address`, and `tags`.

```bash
resource "aws_instance" "app_instance" {
    ami                    = "ami-02f0341ac93c96375"
    instance_type          = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "luixhiano-terraform-tech258-app"
    }
}
```
## Terraform Configuration Files

### `variables.tf`
#### Purpose of Variables

Variables in Terraform allow you to parameterize your configuration, making it more flexible and reusable. They provide a way to input values dynamically, allowing users to customize deployments without modifying the underlying configuration.


**Snippet from variables.tf:**
```bash
# Create Variables to be used in main.tf

variable "app_ami_id" {
    description = "The AMI ID for the application instance"
    default     = "ami_id"
}

variable "key_name" {
    description = "The key name to use for the instance"
    default     = "key"
}

variable "region_name" {
    description = "The AWS region to deploy resources in"
    default     = "region"
}
```
### `main.tf`

#### Purpose of `main.tf`

The `main.tf` file contains the main configuration for your Terraform deployment. It defines the infrastructure resources to be provisioned, their properties, and any associated configurations such as security groups, subnets, and instances.


**Snippet from main.tf:**
```bash
iii
provider "aws" {
    region = var.region_name
}

# Create a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name = var.vpc_name
    }
}

# Create two subnets within the VPC
resource "aws_subnet" "app_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.app_subnet_cidr_block
    availability_zone = var.app_subnet_availability_zone

    tags = {
        Name = var.app_subnet_name
    }
}

resource "aws_subnet" "db_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.db_subnet_cidr_block
    availability_zone = var.db_subnet_availability_zone

    tags = {
        Name = var.db_subnet_name
    }
}
```


### GitHub Best Practices

To ensure sensitive files such as `variables.tf` and Terraform state files are not pushed to GitHub, create a `.gitignore` file in the root directory of your project with the following content:

```bash
# .gitignore file

# Ignore Terraform state files
*.tfstate
*.tfstate.backup

# Ignore variable files
variables.tf

# Ignore .terraform directory
.terraform/

# Ignore any other sensitive files
*.tfvars
terraform.tfvars
```

### Terraform Architecture and State Management

#### Terraform Architecture

1. **Configuration Files**: Written in HCL, defining the desired state of infrastructure.
2. **Terraform CLI**: Command-line interface to execute commands like `init`, `plan`, `apply`, and `destroy`.
3. **Providers**: Plugins to interact with APIs of cloud providers like AWS, Azure, GCP, etc.
4. **State File**: Keeps track of the current state of infrastructure resources.

#### Desired State vs. Current State

Terraform manages state by comparing the desired state (defined in configuration files) with the current state (tracked in the state file). When you run `terraform plan`, Terraform generates an execution plan showing the differences between the desired and current state. Running `terraform apply` will then reconcile these differences, ensuring the actual infrastructure matches the desired state.

#### Diagram


#### Diagram Description

1. **User writes configuration**: Using HCL to define infrastructure resources.
2. **Terraform CLI**: Executes `terraform init` to set up the environment.
3. **Terraform State**: Maintains a record of the infrastructure.
4. **Plan and Apply**: `terraform plan` shows proposed changes, and `terraform apply` enacts them.
5. **Providers**: Interface with cloud services to provision resources.
6. **Infrastructure**: The actual cloud resources managed by Terraform.


### Multiple Providers

Terraform allows you to use multiple providers within a single configuration file. This is useful when you need to manage resources across different cloud providers or services in a unified manner.

Here's an example of how you can use multiple providers in Terraform:

```bash
# Define the AWS provider
provider "aws" {
  region = var.aws_region
}

# Define the GitHub provider
provider "github" {
  token = var.github_token
}

# Create an AWS S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}

# Create the GitHub repository
resource "github_repository" "iac_github_automated_repo" {
  name        = "IaC-github-automated-repo"
  description = "Automated repository creation with Terraform"
  visibility  = "public"
}
```

In this example:

- We define an AWS provider to manage AWS resources like S3 buckets.
- We define a GitHub provider to manage GitHub resources like repositories.
- We create an AWS S3 bucket using the AWS provider.
- We create a GitHub repository using the GitHub provider.

#### Generating GitHub Personal Access Token

To generate a GitHub personal access token, follow these steps:

1. Log in to your GitHub account.
2. Click on your profile icon in the top-right corner of the page and select "Settings" from the dropdown menu.
3. In the left sidebar, click on "Developer settings."
4. From the submenu, click on "Personal access tokens."
5. Click on the "Generate new token" button.
6. Enter a name for the token and select the necessary scopes or permissions (e.g., `repo` for creating repositories).
7. Click on the "Generate token" button.
8. Copy the generated token and store it securely.

#### Adding GitHub Token to Variables File

To use the GitHub personal access token in your Terraform configuration, add it to your variables file (`variables.tf` or any other file you use to declare variables):

```bash
variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  default = "string"
}
```

#### How It Works

The provided Terraform configuration file defines two providers: AWS and GitHub. Each provider is configured with the necessary authentication details (e.g., AWS region, GitHub personal access token).

The configuration then creates resources using these providers. For example, it creates an AWS S3 bucket using the AWS provider and a GitHub repository using the GitHub provider. This demonstrates how you can manage resources across different providers within the same Terraform configuration file.


## Conclusion

By using Terraform, you can efficiently manage and provision your infrastructure in a reliable and automated manner. Always remember to secure your credentials and use best practices for infrastructure management.







