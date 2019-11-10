#!/usr/bin/env bash

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_kafka