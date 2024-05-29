#!/bin/bash

# Tmux session name
SESSION="multi_apps_lexmax"

# Paths to Flask applications
APP_PATHS=(
    "./api_catalog"
    "./api-cli"
    "./api-gateway"
    "./cli_admin"
    "./mic_app_business"
    "./mic_app_catalog"
    "./mic_app_report"
    "./mic_app_user"
)

# Path and command for the FastAPI app
FASTAPI_APP_PATH="./mic_app_bi_catalog"
FASTAPI_CMD="uvicorn main:app --host 0.0.0.0 --port 8000"

start_apps() {
    # Create a new tmux session in detached mode
    tmux new-session -d -s $SESSION

    # Iterate over each Flask app path and create a tmux window for each
    for i in "${!APP_PATHS[@]}"; do
        # Extract the directory name to use as the window name
        WINDOW_NAME=$(basename ${APP_PATHS[$i]})

        if [ $i -eq 0 ]; then
            # Rename the first window created by tmux
            tmux rename-window -t $SESSION:0 "$WINDOW_NAME"
            # Send the command to navigate to the app directory and start Flask
            tmux send-keys -t $SESSION:0 "cd ${APP_PATHS[$i]} && flask run --host=0.0.0.0 --port=$((5000 + $i))" C-m
        else
            # Create a new window for each subsequent app
            tmux new-window -t $SESSION:$i -n "$WINDOW_NAME"
            # Send the command to navigate to the app directory and start Flask
            tmux send-keys -t $SESSION:$i "cd ${APP_PATHS[$i]} && flask run --host=0.0.0.0 --port=$((5000 + $i))" C-m
        fi
    done

    # Calculate the index for the FastAPI app window
    WINDOW_INDEX=${#APP_PATHS[@]}

    # Create a new window for the FastAPI app
    tmux new-window -t $SESSION:$WINDOW_INDEX -n "mic_app_bi_catalog"
    # FastAPI app directory and start it using uvicorn
    tmux send-keys -t $SESSION:$WINDOW_INDEX "cd $FASTAPI_APP_PATH && $FASTAPI_CMD" C-m

    # Attach to the tmux session to make it visible in the terminal
    tmux attach-session -t $SESSION
}

stop_apps() {
    # Kill the tmux session, stopping all running applications
    tmux kill-session -t $SESSION
}

# Check the input argument to either start or stop the applications
if [ "$1" == "start" ]; then
    start_apps
elif [ "$1" == "stop" ]; then
    stop_apps
else
    echo "Usage: $0 {start|stop}"
fi
