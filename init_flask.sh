#!/bin/bash
if [[ $2 ]]; then
  export FLASK_APP=$2
  export FLASK_DEBUG=1
  flask run
elif [[ !$2 ]]; then
  
  echo "Usage: ./init_flask.sh [filename]"
  echo "Try again please..."
fi 




