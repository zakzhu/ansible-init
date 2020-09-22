#!/usr/bin/env bash
# @Author: Zak Zhu
# @Date:   2020-09-23 04:56:26
# @Last Modified by:   Zak Zhu
# @Last Modified time: 2020-09-23 06:35:16

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

cd ../
# lint the playbook of ansible-init 
printf ${green}"TASK 1: lint the playbook of ansible-init\n"${neutral}
printf ${green}"EXCUTE: ansible-lint -c .ansible-lint site.yml\n"${neutral}
ansible-lint -c .ansible-lint site.yml
if [ $? -ne 0 ]; then
    exit 1
fi

printf "\n"
printf "===================================================================================================================================================\n"
printf "===================================================================================================================================================\n"
printf "\n"

# test ansible-init
printf ${green}"TASK 2: test ansible-init\n"${neutral}
printf ${green}"EXCUTE: ansible-playbook -e project=test-test -e author=test site.yml\n"${neutral}
ansible-playbook -e project=test-test -e author=test site.yml
if [ $? -ne 0 ]; then
    exit 2
fi 

printf "\n"
printf "===================================================================================================================================================\n"
printf "===================================================================================================================================================\n"
printf "\n"

# test the new project which created by ansible-init
printf ${green}"TASK 3: test the new project which created by ansible-init\n"${neutral}
printf ${green}"EXCUTE: ansible-playbook ../test-test/site.yml\n"${neutral}
ansible-playbook ../test-test/site.yml
if [ $? -ne 0 ]; then
    exit 3
fi 

printf "\n"
printf "===================================================================================================================================================\n"
printf "===================================================================================================================================================\n"
printf "\n"

# test the idempotence of the new project
printf ${green}"TASK 4: test the idempotence of the new project\n"${neutral}
printf ${green}"EXCUTE: ansible-playbook ../test-test/site.yml\n"${neutral}
ansible-playbook ../test-test/site.yml
if [ $? -ne 0 ]; then
    exit 4
fi 

printf "\n"
printf "===================================================================================================================================================\n"
printf "===================================================================================================================================================\n"
printf "\n"

# remove test files  
printf ${green}"TASK 5: remove test files\n"${neutral}
printf ${green}"EXCUTE: rm -rf ../test-test /etc/ansible/facts.d/test_test-*.fact /tmp/playbook-content\n"${neutral}
rm -rf ../test-test \
    /etc/ansible/facts.d/test_test-*.fact \
    /tmp/playbook-content
if [ $? -ne 0 ]; then
    exit 5
fi

printf "\n"
printf ${green}"--------------------------TEST SUCESS--------------------------\n"${neutral}
printf "\n"