#!/bin/bash
# Force apply of all Terraform Layers defined with the env variable TF_Layers_all.

clear
printf "\n\nForce apply of all Terraform Layers defined on the env variable TF_Layers_all.\n\n" >/dev/tty


#####     VALIDATING ENVIRONMENT VARIABLES     #####

if [ -z "$TF_Layers_all" ]; then
  echo "The variable TF_Layers_all is not defined. Exiting..."
  exit 1
fi

if [ -z "$CONTAINER_PATH" ]; then
  echo "The variable $CONTAINER_PATH is not defined. Exiting..."
  exit 1
fi


#####     QUESTION IF CLEAR ALL LAYERS BEFORE APPLYING SHOULD BE DONE    #####

read -p "*  Clear all Terraform Layers Before? ([y],n): " _clear_layers
_clear_layers=${_clear_layers:-y}


#####     PULLING THE fstates FROM THE REPOSITORY      #####

git pull


#####     CREANING ALL TERRAFORM LAYERS     #####

printf "\n\n*****     Clearing Terraform Layers.\n" >/dev/tty

if [ "${_clear_layers}" == "y" ]; then
  for _terraform_layer in $(echo ${TF_Layers_all} | tr -d '(' | tr -d ')' | tr -d '"');
  do
    printf "          Layer: $_terraform_layer\n" >/dev/tty

    rm -rf "$CONTAINER_PATH/$_terraform_layer/.terraform" 2>/dev/null
    rm -rf "$CONTAINER_PATH/$_terraform_layer/.terraform.lock.hcl" 2>/dev/null
    rm -rf "$CONTAINER_PATH/$_terraform_layer/tfstate/*.tfstate" 2>/dev/null
    rm -rf "$CONTAINER_PATH/$_terraform_layer/tfstate/*.tfstate.backup" 2>/dev/null
  done
fi


#####     LOOPING THROUGH ALL THE TERRAFORM LAYERS     #####

_initial_path=$(pwd)

for _terraform_layer in $(echo ${TF_Layers_all} | tr -d '(' | tr -d ')' | tr -d '"');
do
  printf "\n\n*****     Processing Layer: $CONTAINER_PATH/$_terraform_layer\n\n" >/dev/tty
  
  cd "$CONTAINER_PATH/$_terraform_layer"


  #####     TERRAFORM INT      #####

  terraform init

  if [ $? -ne 0 ]; then
    echo "Terraform init failed for layer $_terraform_layer. Exiting..."
    exit 1
  fi


  #####     TERRAFORM VALIDATE      #####

  terraform validate 

  if [ $? -ne 0 ]; then
    echo "Terraform validate failed for layer $_terraform_layer. Exiting..."
    exit 1
  fi


  #####     TERRAFORM APPLY      #####

  terraform apply -auto-approve

  if [ $? -ne 0 ]; then
    echo "Terraform apply failed for layer $_terraform_layer. Exiting..."
    exit 1
  fi 

done


#####     PUSHING THE fstates TO THE REPOSITORY      #####

git status
git add -A
git commit -m "Terraform apply of all layers"
git push

cd "$_initial_path"

printf "\n\n" >/dev/tty	


