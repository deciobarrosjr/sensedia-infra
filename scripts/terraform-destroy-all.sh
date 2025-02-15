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

read -p "*  Clear all Terraform Layers on the end? ([y],n): " _clear_layers
_clear_layers=${_clear_layers:-y}


#####     PULLING THE fstates FROM THE REPOSITORY      #####

git pull


#####     ITERATE OVER THE ARRAY IN REVERSE ORDER     #####

_initial_path=$(pwd)

for _terraform_layer in $(echo ${TF_Layers_all} | tr -d '(' | tr -d ')' | tr -d '"' | tr ' ' '\n' | tac | tr '\n' ' ');
do
  printf "\n\n*****     Processing Layer: $CONTAINER_PATH/$_terraform_layer\n\n" >/dev/tty
  
  cd "$CONTAINER_PATH/$_terraform_layer"
 
  terraform destroy -auto-approve
done


#####     CREANING ALL TERRAFORM LAYERS     #####

printf "\n\n*****     Clearing Terraform Layers.\n" >/dev/tty

if [ "${_clear_layers}" == "y" ]; then
  for _terraform_layer in $(echo ${TF_Layers_all} | tr -d '(' | tr -d ')' | tr -d '"');
  do
    printf "          Layer: $_terraform_layer\n" >/dev/tty

    terraform-clear-all
  done
fi


#####     PUSHING THE fstates TO THE REPOSITORY      #####

git status
git add -A
git commit -m "Terraform apply of all layers"
git push

cd "$_initial_path"

printf "\n\n" >/dev/tty	


