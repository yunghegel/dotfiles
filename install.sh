#!/bin/bash

set -e

# Helper: Prompt with default, and assign to variable
prompt() {
  local var="$1"
  local prompt_text="$2"
  local default="$3"
  local value
  if [ -z "$default" ]; then
    read -rp "$prompt_text: " value
  else
    read -rp "$prompt_text [$default]: " value
    value=${value:-$default}
  fi
  eval $var="'$value'"
}

# Helper: Prompt for password (masked input)
prompt_password() {
  local var="$1"
  local prompt_text="$2"
  local value
  read -rsp "$prompt_text: " value
  echo
  eval $var="'$value'"
}

echo "====== Interactive Dotfiles Installation ======"
echo

# 1. Username
prompt username "Enter your username for git and SSH" "$(whoami)"

# 2. Email
prompt email "Enter your email for git config" ""

# 3. Optional: Git Credential Helper
PS3="Choose your preferred Git credential helper (you can change this later): "
select cred_helper in "cache" "store (plain-text)" "osxkeychain" "manager-core" "None"
do
  case $REPLY in
    1) git_cred_helper="cache"; break ;;
    2) git_cred_helper="store"; break ;;
    3) git_cred_helper="osxkeychain"; break ;;
    4) git_cred_helper="manager-core"; break ;;
    5) git_cred_helper=""; break ;;
    *) echo "Invalid choice. Try again." ;;
  esac
done

# 4. Github/Git Server Password or Personal Access Token (if needed)
echo "If your dotfiles need to clone private repositories, provide your GitHub Personal Access Token."
prompt_password github_token "Enter your GitHub Personal Access Token (leave blank to skip)"

# 5. Dotfiles Directory
prompt dotfiles_dir "Where should your dotfiles be installed?" "$HOME/.dotfiles"

# 6. Symlink dotfiles? (y/n)
while true; do
  read -rp "Do you want to symlink dotfiles into your \$HOME directory? (recommended) [y/n]: " yn
  case $yn in
    [Yy]* ) symlink_dotfiles=true; break;;
    [Nn]* ) symlink_dotfiles=false; break;;
    * ) echo "Please answer yes or no.";;
  esac
done

# 7. (Optional) Install extra tools/modules?
extras=("vim/neovim setup" "tmux config" "custom scripts" "None/Skip")
echo "Which extra modules would you like to install? (Enter numbers separated by spaces):"
select extra in "${extras[@]}"; do
  [ "$REPLY" -le "${#extras[@]}" ] && break
  echo "Invalid choice."
done

# 8. (Optional) Ask for more config, e.g., npm registry, aliases, etc.

# ---------- SUMMARY ----------
echo ""
echo "====== Summary ======"
echo "Username:        $username"
echo "Email:           $email"
echo "Git Credential:  $git_cred_helper"
echo "Dotfiles dir:    $dotfiles_dir"
echo "Symlink home:    $symlink_dotfiles"
if [ -n "$extra" ] && [ "$extra" != "None/Skip" ]; then
  echo "Extras:          $extra"
fi

read -rp "Proceed with the installation? [y/n]: " go
if [[ ! "$go" =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 1
fi

# ---------- INSTALLATION BEGINS HERE ----------
echo "Installing dotfiles..."

# 1. Make dotfiles dir, clone/copy if needed
mkdir -p "$dotfiles_dir"
# (Insert actual cloning logic here if applicable)

# 2. Set git config if possible
git config --global user.name "$username"
git config --global user.email "$email"
if [ -n "$git_cred_helper" ]; then
  git config --global credential.helper "$git_cred_helper"
fi

# 3. Symlink logic (example for .bashrc)
if [ "$symlink_dotfiles" = true ]; then
  for f in .bashrc .zshrc .vimrc; do
    if [ -f "$dotfiles_dir/$f" ]; then
      ln -sf "$dotfiles_dir/$f" "$HOME/$f"
      echo "Symlinked $f"
    fi
  done
fi

# 4. Install requested extras
if [ -n "$extra" ] && [ "$extra" != "None/Skip" ]; then
  case "$extra" in
    "vim/neovim setup")
      echo "Installing Vim/Neovim configs..."
      # Insert your install logic here
      ;;
    "tmux config")
      echo "Installing tmux config..."
      # Insert your tmux logic here
      ;;
    "custom scripts")
      echo "Copying custom scripts..."
      # Insert custom script logic here
      ;;
  esac
fi

echo "Done! Your dotfiles have been installed interactively!"
