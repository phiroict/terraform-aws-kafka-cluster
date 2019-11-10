#!/usr/bin/env bash
# To make it secure, store your aws credentials in aws-vault and inject them into the environment when running the playbook.
aws-vault exec home -- ansible-playbook -i hosts configure_zookeepers_playbook.yml
