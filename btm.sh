#!/bin/bash
# -*- coding: utf-8 -*-

## Flags
IS_VERBOSE=false
JUMP_REQUIREMENTS=false
IS_TO_USE_SNAPCRAFT_STORE=false
##

## Constants
BANNER_MSG="b00t the m4chine"
REQUIREMENTS_TO_INSTALL=(
  dialog
  figlet
  apt-transport-https
  curl
)
# usage:
#   "key used on install function" "whatis" on/off
PROGRAM_OPTIONS=(
  # Terminal/Shell
  "terminator" "Multiple GNOME terminals in one window" on
  "konsole" "X terminal emulator" off
  "tmux" "Terminal multiplexer" off
  "ohmyzsh" "zsh + Oh My Zsh" on
  "nvm" "Node Version Manager - https://github.com/nvm-sh/nvm" on
  "gh" "Github CLI - https://cli.github.com/manual/" on

  # Comunication
  "discord" "Chat for Communities and Friends" on
  "slack" "Team communication for the 21st century." on
  "telegram" "Fast and secure messaging application" on
  "teams" "Microsoft Teams for Linux is your chat-centered workspace in Office 365." off

  # Midia
  "spotify" "Music for everyone" on
  "vlc" "Multimedia player and streamer" on
  "gimp" "GNU Image Manipulation Program" on

  # Browsers
  "brave" "Browse faster by blocking ads and trackers that cost you time and money." on
  "chrome" "_" on
  "chromium" "_" off
  "opera" "_" off

  # IDE's
  "code" "Code editing. Refined." on
  "vim" "Vi IMproved - enhanced vi editor" on
  "spacevim" "SpaceVim (w/ nvim) " off
  "sublime" "_" off

  # O.S.
  "htop" "Interactive processes viewer" on
  "netcat-traditional" "TCP/IP swiss army knife (used on backtrack)" on
  "docker" "The open-source application container engine" on
  "httpie" "CLI, cURL-like tool for humans" on

  # I3
  "i3" "Metapackage (i3 window manager, screen locker, menu, statusbar)" off
  "nnn" "Free, fast, friendly file manager" off

  # Others
  "vokoscreen" "Easy to use screencast creator" on
  "flameshot" "Powerful yet simple-to-use screenshot software" on
  "keepassxc" "Cross Platform Password Manager" on
  "postman" "API Development Environment" on
  "insomnia" "Kinda Postman Open-source" off
  "streamio" "⚠️ Freedom To Watch Everything You Want. - https://www.stremio.com/downloads" off
)

function _btm::log() {
  echo -e "$*"
}

function _btm::usage() {
  _btm::log """
    usage: $0 [-v] [--snap]

  -j | --jump \t\t\t Skip the requirements (update and installation of tools). Good for development.o.
  -h | --help \t\t\t This help message.
  -s | --snap \t\t\t Prefer use the Snapcraft.io to install (see https://snapcraft.io/store).
  -v | --verbose \t\t\t Make verbosity.
"""
  exit
}

function _btm::check_command_existance_or_install() {
  if [ $(command -v $1) ]; then
    $IS_VERBOSE && _btm::log "\t ✅ $1."
    return 0
  else
    $IS_VERBOSE && _btm::log "❌ \"$1\" command does not exist, trying to install it."
    sudo apt-get install -y $1
  fi
}

function _btm::show_progress_bar() {
  dialog --gauge "Please wait while installing" 6 70
}

function _btm::if_verbose_print_to_clear() {
  $IS_VERBOSE &&
    echo &&
    _btm::press_enter &&
    clear
}

function _btm::update_os() {
  if [ $IS_VERBOSE = true ]; then
    sudo apt-get update -y
  else
    sudo apt-get -qq update
  fi
}

function _btm::install_requirements() {
  if [ $JUMP_REQUIREMENTS = true ]; then
    return 0
  fi

  _btm::update_os
  if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
    if [ !$(command -v snap) ]; then
      _btm::log "🔗 Check https://snapcraft.io/docs/installing-snapd to install."
      _btm::press_enter
      exit
    fi

  fi

  $IS_VERBOSE && _btm::log "\n🏗️  Installing requirements ...\n"

  for item in "${REQUIREMENTS_TO_INSTALL[@]}"; do
    _btm::check_command_existance_or_install "${item}"
  done

  if [ $IS_VERBOSE = true ]; then
    _btm::if_verbose_print_to_clear
  else
    sleep 1
  fi

  return 0
}

function _btm::press_enter() {
  read -p " < press ENTER to continue > " FAKEINPUT
  return 0
}

function _btm::sudo_agreement_or_exit() {
  if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    _btm::log "🚫 It's necessary running as root. Try again (sudo !!)."
    exit
  else
    return 0
  fi
}

function _btm::select_programs() {
  local selected=$(dialog \
    --stdout \
    --clear \
    --title 'Seleção das ferramentas' \
    --checklist 'O que você quer instalar?' \
    0 0 0 \
    "${PROGRAM_OPTIONS[@]}")

  _btm::log $selected
}

function _btm::banner() {
  clear # first clear
  _btm::sudo_agreement_or_exit
  _btm::install_requirements

  figlet $BANNER_MSG
  sleep 1
}

##
# The function receives a key that has a preconfigured option to install it.
# If you want to add some program, just remember to add to $PROGRAM_OPTIONS list.
##
function _btm::install() {
  local item_to_install="$1"
  case "$item_to_install" in

  brave)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install brave
    else
      sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
      _btm::update_os
      sudo apt install brave-browser
    fi
    ;;

  chrome)
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    ;;

  code)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install code --classic
    else
      curl "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" >visualcode-linux-deb-x64.deb
      sudo dpkg -i visualcode-linux-deb-x64.deb
    fi
    ;;

  discord)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install discord
    else
      curl "https://discord.com/api/download?platform=linux&format=deb" >discord.deb
      sudo dpkg -i discord.deb
    fi
    ;;

  docker)
    sudo apt-get remove docker docker-engine docker.io containerd runc -y &&
      sudo apt-get update &&
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    _btm::update_os &&
      sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    docker run hello-world
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ;;

  flameshot) sudo apt-get install -y flameshot ;;

  gimp) sudo apt install -y gimp ;;

  gh) # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install -y gh
    ;;

  httpie) sudo apt install -y httpie ;;

  htop) sudo apt install -y htop ;;

  insomnia)
    sudo snap install insomnia
    sudo snap install insomnia-designer
    ;;

  keepassxc)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install keepassxc
    else
      sudo apt install -y keepassxc
    fi
    ;;

  spotify) snap install spotify ;;

  slack) sudo snap install slack --classic ;;

  spacevim)
    sudo apt install -y nvim
    curl -sLf https://spacevim.org/install.sh | bash -s -- --install neovim
    ;;

  streamio)
    wget https://dl.strem.io/shell-linux/v4.4.137/stremio_4.4.137-1_amd64.deb ./

    _btm::log "⚠️ This package can cause conflicts that will need to be resolved via the command line."
    _btm::log "If you accept, ignore this warning. Otherwise, it's your last chance to Ctrl+C."
    _btm::press_enter

    sudo dpkg -i stremio_4.4.137-1_amd64.deb
    ;;

  nvm)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    echo """
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
""" >>~/.bashrc
    ;;

  netcat-traditional) sudo apt install -y netcat-traditional netcat ;;

  ohmyzsh)
    sudo apt install -y zsh &&
      chsh -s zsh &&
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ;;

  postman)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install postman
    else
      wget https://dl.pstmn.io/download/latest/linux64 postman.tar.gz
      tar -C ./ -xzvf postman.tar.gz
    fi
    ;;

  terminator) sudo apt install -y terminator ;;

  telegram)
    if [ $IS_TO_USE_SNAPCRAFT_STORE = true ]; then
      sudo snap install telegram-desktop
    else
      sudo apt install -y telegram-desktop
    fi
    ;;

  teams) sudo snap install teams ;;

  vlc) sudo apt install -y vlc ;;

  vim) sudo apt install -y vim ;;

  vokoscreen) sudo apt-get install -y vokoscreen ;;

  *) $IS_VERBOSE && echo -e "❌ Option \"$item_to_install\" not recognized or does not exist." ;;
  esac
}

function _btm::display_recommendations() {
  _btm::log """\r

🧠 Some ideas to what do now: smile! :D

\t\t Contribute at https://github.com/andersonbosa/btm
\t\t Fork and start your own btm!
"""
}

function _btm::installation() {
  _btm::banner

  local array_to_install=$(_btm::select_programs)

  for item in ${array_to_install[@]}; do
    _btm::install $item # ← put the command whos exit code you want to check here &>/dev/null
    if [ $? -eq 0 ]; then
      _btm::log "✅ $item"
    else
      _btm::log "❌ $item"
    fi
  done

  _btm::display_recommendations
}

POSITIONAL_ARGS=() # Processes the arguments before invoking the installation.
while [[ $# > 0 ]]; do
  case "${1}" in
  -j | --jump)
    JUMP_REQUIREMENTS=true
    shift
    ;;

  -h | --help) _btm::usage ;;

  -s | --snap)
    IS_TO_USE_SNAPCRAFT_STORE=true
    shift
    ;;

  -v | --verbose)
    IS_VERBOSE=true
    shift
    ;;
  # -s | --switch)
  #   _btm::log "switch: ${1} with value: ${2}"
  #   shift 2 # shift twice to bypass switch and its value
  #   ;;
  *) # unknown flag/switch
    POSITIONAL_ARGS+=("${1}")
    shift
    ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional_ARGS params / process flags
_btm::installation             # Start installation
