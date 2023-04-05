#!/bin/bash
FUNCTION_NAME="producer"
awslocal lambda invoke --function-name $FUNCTION_NAME output.txt
