#!/bin/sh
# Claude Code status line: agent name, output style, project dir, git branch, wait time, total cost

input=$(cat)

agent_name=$(echo "$input" | jq -r '.agent.name // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
wait_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Get current git branch from the project dir (skip optional locks for safety)
git_branch=""
if [ -n "$project_dir" ] && [ -d "$project_dir" ]; then
  git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$project_dir" symbolic-ref --short HEAD 2>/dev/null || GIT_OPTIONAL_LOCKS=0 git -C "$project_dir" rev-parse --short HEAD 2>/dev/null)
fi

# Shorten project_dir: replace $HOME with ~
home="$HOME"
short_dir="${project_dir#$home}"
if [ "$short_dir" != "$project_dir" ]; then
  short_dir="~$short_dir"
fi

# Format wait time as seconds if available
if [ -n "$wait_ms" ] && [ "$wait_ms" != "null" ]; then
  wait_display=$(echo "$wait_ms" | awk '{printf "%.1fs", $1/1000}')
else
  wait_display=""
fi

# Format total cost if available
if [ -n "$total_cost" ] && [ "$total_cost" != "null" ]; then
  cost_display=$(echo "$total_cost" | awk '{printf "$%.4f", $1}')
else
  cost_display=""
fi

# Build output parts
parts=""

if [ -n "$agent_name" ]; then
  parts="${parts}\033[35magent: ${agent_name}\033[0m  "
fi

if [ -n "$output_style" ]; then
  parts="${parts}\033[32mstyle: ${output_style}\033[0m  "
fi

if [ -n "$short_dir" ]; then
  parts="${parts}\033[36mdir: ${short_dir}\033[0m  "
fi

if [ -n "$git_branch" ]; then
  parts="${parts}\033[34mbranch: ${git_branch}\033[0m  "
fi

if [ -n "$wait_display" ]; then
  parts="${parts}\033[33mapi-duration: ${wait_display}\033[0m  "
fi

if [ -n "$cost_display" ]; then
  parts="${parts}\033[33mcost: ${cost_display}\033[0m"
fi

# Trim trailing spaces and print
printf "%b" "$parts" | sed 's/[[:space:]]*$//'
