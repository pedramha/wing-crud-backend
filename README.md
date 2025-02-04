# WingLang Project

## 📌 Description
This project is built using **Winglang**, a cloud-oriented programming language designed to define and manage cloud resources efficiently. The project automates infrastructure deployment and execution using Winglang's declarative approach.

## ✨ Features
- 🛠 **Infrastructure as Code**
- ☁ **Cloud-Native**
- 🚀 **Simple Deployment** 
- 🖥 **Local Execution**

## 🔧 Installation
Ensure you have Winglang installed before running this project.

### 📜 Prerequisites
- **Node.js** 
- **Docker** (required for Dynamodb Local)
- **Winglang** (Follow the [Winglang Installation Guide](https://www.winglang.io/docs/getting-started))

```sh
npm install -g winglang
```

### 📥 Clone the Repository
```sh
git clone https://github.com/your-repo.git
cd your-repo
```

### 📦 Install Dependencies (If applicable)
```sh
npm install
```

## 🚀 Usage
### 🏃 Running Locally
To execute the project locally:
```sh
wing it main.w
```
### ☁ Creating a remote state
Generally speaking, it is not a good idea to store the state file locally. It is recommended to store the state file in a remote location. You can use AWS S3 to store the state file. This also enables collaborative workflow and allows multiple team members to work on the same project.

The following script creates a s3 bucket for the state file and a dynamodb table for state locking.

```hcl
```sh
./script.sh
```
After running the script, examing the .env file and ensure the values are populated correctly.
### ☁ Deploying to the Cloud
Make sure you are logged in to your AWS account and environment variables are there.

```sh
wing compile -t tf-aws -t platform.static-backend.js main.w
```

To deploy the project to AWS:
```sh
cd target/main.tfaws
terraform init && terraform apply
```
## 📜 License
[MIT](LICENSE)
