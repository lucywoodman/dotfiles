#!/usr/bin/env bash

# `.aliases` is used to provide custom aliases.

# === Navigation Aliases ===
alias home="cd $HOME"
alias dotfiles="cd $HOME/.dotfiles"
alias library="cd $HOME/Library"
alias notes="cd $HOME/notes"
alias notes='tmux new -A -s pm -c "$HOME/notes"'
alias work='tmux new -A -s work -c "$HOME/workspace"'
alias downloads='cd /private/tmp/downloads'

# === System Commands ===
# Sorts directories in top:
alias ll='lsd -la --group-dirs first'

# Use syntax highlight for `cat`:
alias cat='bat --paging never --decorations never --plain'

# Use `lsd` for tree:
alias tree='lsd --tree'

# Lock the screen (when going AFK)
alias afk='pmset displaysleepnow'

# === Docker Aliases ===
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcdc='docker compose down --remove-orphans -v'
alias dcr='docker compose restart'
alias dcb='docker compose build'
alias dcl='docker compose logs -f'

# === Kubernetes Aliases ===
alias k=kubectl
alias kontainers="kubectl get pods -o=jsonpath='{range .items[*]}{\"\n\n\"}{.metadata.name}{\":\t\"}{range .status.containerStatuses[*]}{\"\n\t\"}{.ready}{\" \"}{.name}{\"  \trestarts:\"}{.restartCount}{\"\tstartedAt: \"}{.state.running.startedAt}{end}{end}' | sed -e 's/true/✅/g' -e 's/false/❌/g'"

# === Terraform Aliases ===
alias tf=terraform
alias tfi='tf init'
alias tff='tf fmt'
alias tfv='tf validate'
alias tfp='tf plan'
alias tfa='tf apply'
alias tfd='tf destroy'
alias tfo='tf output'

# === GCP Aliases ===
alias gca='gcloud config configurations activate'
alias gcl='gcloud config configurations list'
alias gcs='gcloud config configurations activate $(gcloud config configurations list --format="value(name)" | fzf)'
alias gcd='gcloud config configurations describe $(gcloud config configurations list --filter=is_active:true --format="value(name)")'
alias sa-token='gcloud auth print-identity-token --include-email --impersonate_service_account'
alias sa-access='gcloud auth print-access-token --impersonate_service_account'
alias gcloud-as='gcloud --impersonate_service_account'
alias sa-become='gcloud config set auth/impersonate_service_account'
alias sa-stop='gcloud config unset auth/impersonate_service_account'
alias sa-who='gcloud config get-value auth/impersonate_service_account'
alias sa-list='gcloud iam service-accounts list --format="table(email,displayName)"'
alias sa-list-project='gcloud iam service-accounts list --project'

# Load private aliases if they exist
[ -f "$HOME/.private/private.aliases" ] && source "$HOME/.private/private.aliases"
