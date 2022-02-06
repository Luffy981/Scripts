#!/bin/bash
if [[ $1 ]]; then
  export FLASK_APP=$2
  export FLASK_DEBUG=1
  flask run
elif [[ !$1 ]]; then
  
  echo "Usage: ./init_flask.sh [filename]"
  echo "Try again please..."
fi 




