#!/bin/bash
pyenv virtualenv 3.9.16 lambda
pyenv local lambda
pip install awscli awscli-local
