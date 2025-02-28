# WingLang Project

## 📌 Description

This project leverages **Winglang**, a cloud-oriented programming language that streamlines the definition and management of cloud resources. It automates infrastructure deployment and execution through Winglang's declarative approach.

## ✨ Features

- 🛠 **Infrastructure as Code**: Define your infrastructure programmatically.
- ☁ **Cloud-Native**: Built specifically for cloud environments.
- 🚀 **Simple Deployment**: Effortless deployment processes.
- 🖥 **Local Execution**: Test and run your code locally before deploying.

## 🔧 Installation

Before you begin, ensure Winglang is installed on your system.

### 📜 Prerequisites

- **Node.js**: JavaScript runtime environment.
- **Docker**: Required for DynamoDB Local.
- **Winglang**: Follow the [Winglang Installation Guide](https://www.winglang.io/docs/getting-started).

Install Winglang globally:

```sh
npm install -g winglang
```
📥 Clone the Repository

Clone this repository and navigate into its directory:

```sh
git clone https://github.com/pedramha/wing-crud-backend.git
cd wing-crud-backend
```

📦 Install Dependencies
```sh
npm install
```

🚀 Usage

🏃 Running Locally
To execute the project locally:

```sh
wing it main.w
```

☁ Deploying to the Cloud
Once satisfied with local testing, deploy to the cloud. Winglang supports various target platforms, including AWS CDK and Terraform. This project uses Terraform for AWS deployment.

Compile the project to generate a Terraform configuration:

```sh
wing compile -t tf-aws
```

Inspect the generated Terraform file located at target/main.tfaws.

☁ Setting Up Remote State
Storing the Terraform state file remotely is recommended for collaboration. Use AWS S3 for the state file and DynamoDB for state locking.

A script (script.sh) is provided to create the necessary S3 bucket and DynamoDB table:

```sh
./script.sh
```

After running the script, verify the .env file contains the correct values. You can use this file to provide S3 bucket and DynamoDB table names to Terraform or set up GitHub secrets to supply these values during deployment.

☁ Applying Terraform Configuration
Ensure you're authenticated with your AWS account and the necessary environment variables are set. Deploy the project with:

```sh
cd target/main.tfaws
terraform init
terraform apply
```

📜 License

This project is licensed under the MIT License.