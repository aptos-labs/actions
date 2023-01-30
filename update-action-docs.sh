#!/bin/bash

set -e

# This script updates the action docs in the README.md file for each action directory

if command -v action-docs &> /dev/null
then
    echo "action-docs is installed"
else
    echo "action-docs could not be found. Please install action-docs:"
    echo "$ npm install -g action-docs@1.1.1"
    exit 1
fi

for action in $(find . -type f \( -name "action.yaml" -o -name "action.yml" \)); do
    action_dir=$(dirname $action)
    echo "Updating action in $action_dir"
    action-docs --no-banner --action $action > $action_dir/README.md
done
