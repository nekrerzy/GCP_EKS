#!/bin/bash
# setup-environment.sh
# 
# Script to prepare the GCP environment for Terraform project
# Verifies prerequisites and helps set up the project

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display prerequisites and ask for confirmation
cat << EOF
#############################################################
# PREREQUISITES:
# - Google Cloud SDK (gcloud) - https://cloud.google.com/sdk/docs/install
# - Terraform - https://developer.hashicorp.com/terraform/install
# - Docker (recommended) - https://docs.docker.com/get-docker/
# - kubectl (recommended) - https://kubernetes.io/docs/tasks/tools/install-kubectl/
# - Active Google Cloud account with billing enabled
#############################################################
EOF

read -p "Do you have all the required prerequisites installed? (y/n): " confirm_prereq
if [[ "$confirm_prereq" != "y" && "$confirm_prereq" != "Y" ]]; then
  echo -e "${RED}Please install all prerequisites before running this script.${NC}"
  exit 1
fi

# OS detection for cross-platform compatibility 
PLATFORM="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="macos"
fi
echo -e "${BLUE}Detected platform: $PLATFORM${NC}"

echo -e "${BLUE}=========================================================${NC}"
echo -e "${BLUE}  GCP Infrastructure Environment Setup                   ${NC}"
echo -e "${BLUE}=========================================================${NC}"

# Function to check if a tool is installed
check_command() {
  if command -v $1 &> /dev/null; then
    echo -e "✅ ${GREEN}$1 is installed${NC}"
    return 0
  else
    echo -e "❌ ${RED}$1 is not installed${NC}"
    return 1
  fi
}

# Function to prompt user
ask() {
  local prompt=$1
  local default=$2
  local var_name=$3
  local input

  if [ -n "$default" ]; then
    echo -e "${YELLOW}$prompt (default: $default)${NC}"
    read input
    input=${input:-$default}
  else
    echo -e "${YELLOW}$prompt${NC}"
    read input
  fi
  
  eval $var_name=\$input
}

# Function to check if user is authenticated in gcloud
check_gcloud_auth() {
  if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q "@"; then
    echo -e "✅ ${GREEN}Authenticated in gcloud as: $(gcloud auth list --filter=status:ACTIVE --format="value(account)")${NC}"
    return 0
  else
    echo -e "❌ ${RED}Not authenticated in gcloud${NC}"
    return 1
  fi
}

# Function to check and create application-default authentication
create_auth_application_default() {
  # Check if credentials file already exists
  local credentials_file="${HOME}/.config/gcloud/application_default_credentials.json"
  
  if [ -f "$credentials_file" ]; then
    echo -e "✅ ${GREEN}Application default credentials already exist at $credentials_file${NC}"
    return 0
  else
    echo -e "${YELLOW}Application default credentials not found, creating now...${NC}"
    if gcloud auth application-default login; then
      echo -e "✅ ${GREEN}Authenticated with application default credentials${NC}"
      return 0
    else
      echo -e "❌ ${RED}Could not authenticate with application default credentials${NC}"
      return 1
    fi
  fi
}

# Function to check if a project exists
check_project_exists() {
  local project_id=$1
  if gcloud projects describe $project_id &> /dev/null; then
    echo -e "✅ ${GREEN}Project $project_id exists${NC}"
    return 0
  else
    echo -e "❌ ${RED}Project $project_id does not exist${NC}"
    return 1
  fi
}

# Function to check if billing is enabled
check_billing_enabled() {
  local project_id=$1
  local billing_enabled=$(gcloud beta billing projects describe $project_id --format="value(billingEnabled)" 2>/dev/null || echo "false")
  
  if [ "$billing_enabled" == "True" ]; then
    echo -e "✅ ${GREEN}Billing enabled for $project_id${NC}"
    return 0
  else
    echo -e "❌ ${RED}Billing NOT enabled for $project_id${NC}"
    return 1
  fi
}

# Verify required tools
echo -e "\n${BLUE}Verifying required tools...${NC}"
check_command "gcloud" || { echo -e "${RED}Google Cloud SDK is required. Install it from https://cloud.google.com/sdk/docs/install${NC}"; exit 1; }
check_command "terraform" || { echo -e "${RED}Terraform is required. Install it from https://developer.hashicorp.com/terraform/install${NC}"; exit 1; }
check_command "docker" || { echo -e "${YELLOW}⚠️ Docker is recommended for building images, but not mandatory for infrastructure${NC}"; }
check_command "kubectl" || { echo -e "${YELLOW}⚠️ kubectl is recommended for managing the cluster, but can be installed later${NC}"; }

# Verify gcloud authentication
echo -e "\n${BLUE}Verifying Google Cloud authentication...${NC}"
if ! check_gcloud_auth; then
  echo -e "${YELLOW}Starting Google Cloud authentication...${NC}"
  gcloud auth login
  if ! check_gcloud_auth; then
    echo -e "${RED}Could not authenticate with Google Cloud. Aborting.${NC}"
    exit 1
  fi
fi

# Verify application default credentials authentication
echo -e "\n${BLUE}Verifying application default credentials authentication...${NC}"
if ! create_auth_application_default; then
  echo -e "${RED}Could not authenticate with application default credentials. Aborting.${NC}"
  echo -e "${YELLOW}This is required for Terraform to interact with Google Cloud APIs.${NC}"
  exit 1
fi

# Get list of projects
projects=$(gcloud projects list --format="value(projectId)" 2>/dev/null || echo "")

# Configure project
echo -e "\n${BLUE}Project configuration...${NC}"
if [ -n "$projects" ]; then
  echo -e "${YELLOW}Available projects:${NC}"
  echo "$projects"
  ask "Enter the project ID to use (or 'new' to create a new one)" "" PROJECT_ID
else
  echo -e "${YELLOW}No projects found. You need to create a new one.${NC}"
  PROJECT_ID="new"
fi

# Create new project if needed
if [ "$PROJECT_ID" == "new" ]; then
  ask "Enter an ID for the new project" "my-terraform-gcp-project" PROJECT_ID
  ask "Enter a name for the new project" "My Terraform GCP Project" PROJECT_NAME
  
  echo -e "${YELLOW}Creating project $PROJECT_ID...${NC}"
  gcloud projects create $PROJECT_ID --name="$PROJECT_NAME"
  
  if ! check_project_exists $PROJECT_ID; then
    echo -e "${RED}Could not create the project. Aborting.${NC}"
    exit 1
  fi
fi

# Set current project
gcloud config set project $PROJECT_ID

# Check if billing is enabled
echo -e "\n${BLUE}Verifying billing...${NC}"
if ! check_billing_enabled $PROJECT_ID; then
  echo -e "${YELLOW}Billing is not enabled for this project.${NC}"
  
  # List available billing accounts
  billing_accounts=$(gcloud billing accounts list --format="table[no-heading](name,displayName,open)" --filter="open=True" 2>/dev/null || echo "")
  
  if [ -z "$billing_accounts" ]; then
    echo -e "${RED}No billing accounts available. You must have an active billing account.${NC}"
    echo -e "${YELLOW}Visit: https://console.cloud.google.com/billing${NC}"
    exit 1
  fi
  
  echo -e "${YELLOW}Available billing accounts:${NC}"
  echo "$billing_accounts"
  
  ask "Enter the billing account ID (first column)" "" BILLING_ACCOUNT_ID
  
  echo -e "${YELLOW}Enabling billing for $PROJECT_ID...${NC}"
  gcloud billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT_ID
  
  if ! check_billing_enabled $PROJECT_ID; then
    echo -e "${RED}Could not enable billing. Aborting.${NC}"
    exit 1
  fi
fi

# Enable required APIs
echo -e "\n${BLUE}Enabling required APIs...${NC}"
echo -e "${YELLOW}This process may take a few minutes...${NC}"
apis=(
  "compute.googleapis.com"
  "container.googleapis.com"
  "servicenetworking.googleapis.com"
  "sqladmin.googleapis.com"
  "spanner.googleapis.com"
  "artifactregistry.googleapis.com"
  "aiplatform.googleapis.com"
  "iam.googleapis.com"
)

for api in "${apis[@]}"; do
  echo -e "Enabling $api..."
  gcloud services enable $api
done

# Create service account for Terraform
echo -e "\n${BLUE}Configuring service account for Terraform...${NC}"
SA_NAME="terraform-deployer"
SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# Check if service account already exists
if gcloud iam service-accounts describe $SA_EMAIL &>/dev/null; then
  echo -e "✅ ${GREEN}Service account $SA_EMAIL already exists${NC}"
else
  echo -e "${YELLOW}Creating service account for Terraform...${NC}"
  gcloud iam service-accounts create $SA_NAME --display-name="Terraform Deployer"
fi

# Assign required roles
echo -e "${YELLOW}Assigning required roles to service account...${NC}"
roles=(
  "roles/compute.admin"
  "roles/container.admin"
  "roles/iam.serviceAccountAdmin"
  "roles/iam.serviceAccountUser"
  "roles/servicenetworking.serviceAgent"
  "roles/storage.admin"
  "roles/spanner.admin"
  "roles/cloudsql.admin"
  "roles/artifactregistry.admin"
  "roles/aiplatform.admin"
)

for role in "${roles[@]}"; do
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SA_EMAIL" --role="$role"
done

# Ask if they want to create a key for the service account
ask "Do you want to create a key for the service account? (y/n)" "n" CREATE_KEY
if [[ "$CREATE_KEY" == "y" || "$CREATE_KEY" == "Y" ]]; then
  KEY_FILE="$SA_NAME-key.json"
  gcloud iam service-accounts keys create $KEY_FILE --iam-account=$SA_EMAIL
  echo -e "✅ ${GREEN}Key created and saved in $KEY_FILE${NC}"
  echo -e "${YELLOW}Keep this file secure and do not share it.${NC}"
fi

# Configure Terraform
echo -e "\n${BLUE}Configuring Terraform files...${NC}"

# Configure environment (dev/prod)
ask "Which environment do you want to configure? (dev/prod)" "dev" ENVIRONMENT

# Update Terraform variables
TFVARS_FILE="environments/$ENVIRONMENT/terraform.tfvars"
if [ -f "$TFVARS_FILE" ]; then
  # Make a backup
  cp $TFVARS_FILE ${TFVARS_FILE}.bak
  
    # Update project_id - with cross-platform sed support
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS requires an empty string after -i
    sed -i '' "s|project_id = \".*\"|project_id = \"$PROJECT_ID\"|" $TFVARS_FILE
  else
    # Linux version
    sed -i "s|project_id = \".*\"|project_id = \"$PROJECT_ID\"|" $TFVARS_FILE
  fi
  
  # Ask for region
  ask "Which region do you want to use for the infrastructure?" "us-central1" REGION
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|region = \".*\"|region = \"$REGION\"|" $TFVARS_FILE
  else
    sed -i "s|region = \".*\"|region = \"$REGION\"|" $TFVARS_FILE
  fi
  
  # Update database password
  DB_PASSWORD=$(openssl rand -base64 16)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|db_password = \".*\"|db_password = \"$DB_PASSWORD\"|" $TFVARS_FILE
  else
    sed -i "s|db_password = \".*\"|db_password = \"$DB_PASSWORD\"|" $TFVARS_FILE
  fi
  
  echo -e "✅ ${GREEN}Terraform configuration updated in $TFVARS_FILE${NC}"
  echo -e "${YELLOW}Generated database password: $DB_PASSWORD${NC}"
else
  echo -e "❌ ${RED}File $TFVARS_FILE not found${NC}"
  mkdir -p "environments/$ENVIRONMENT"
  cat > $TFVARS_FILE << EOF
project_id = "$PROJECT_ID"
region     = "$REGION"

# Network configuration
subnet_cidr  = "10.0.0.0/16"
pod_cidr     = "10.1.0.0/16"
service_cidr = "10.2.0.0/16"
master_ipv4_cidr_block = "172.16.0.0/28"

# Database configuration
db_name     = "app-database"
db_user     = "app-user"
db_password = "$DB_PASSWORD"

# Spanner configuration
spanner_db_name = "app-spanner-db"
EOF
  echo -e "✅ ${GREEN}Created new file $TFVARS_FILE${NC}"
fi

# Apply Terraform?
ask "Do you want to initialize Terraform now? (y/n)" "y" INIT_TERRAFORM
if [[ "$INIT_TERRAFORM" == "y" || "$INIT_TERRAFORM" == "Y" ]]; then
  cd environments/$ENVIRONMENT
  terraform init

  ask "Do you want to create a Terraform plan now? (y/n)" "y" PLAN_TERRAFORM
  if [[ "$PLAN_TERRAFORM" == "y" || "$PLAN_TERRAFORM" == "Y" ]]; then
    terraform plan
    
    ask "Do you want to apply the Terraform plan now? (y/n)" "n" APPLY_TERRAFORM
    if [[ "$APPLY_TERRAFORM" == "y" || "$APPLY_TERRAFORM" == "Y" ]]; then
      terraform apply
    fi
  fi
  
  cd ../..
fi

echo -e "\n${GREEN}Configuration completed!${NC}"
echo -e "${YELLOW}Summary:${NC}"
echo -e "- Project: ${GREEN}$PROJECT_ID${NC}"
echo -e "- Region: ${GREEN}$REGION${NC}"
echo -e "- Environment: ${GREEN}$ENVIRONMENT${NC}"
echo -e "- Configuration file: ${GREEN}$TFVARS_FILE${NC}"

if [[ "$CREATE_KEY" == "y" || "$CREATE_KEY" == "Y" ]]; then
  echo -e "- Service account key file: ${GREEN}$KEY_FILE${NC}"
  echo -e "${YELLOW}To use this key, update the path in environments/$ENVIRONMENT/main.tf file:${NC}"
  echo -e "  provider \"google\" {"
  echo -e "    credentials = file(\"$(pwd)/$KEY_FILE\")"
  echo -e "    ..."
  echo -e "  }"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo -e "1. Get config file to access the GKE cluster"
echo -e " - gcloud container clusters get-credentials synthaud-dev-gke --region us-central1-a"
echo -e "2. Install Certmanager for Let's Encrypt"
echo -e " - kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml"
echo -e "3. Install Nginx Ingress Controller"
echo -e " - kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml"

echo -e "\n${GREEN}Good luck with your project!${NC}"