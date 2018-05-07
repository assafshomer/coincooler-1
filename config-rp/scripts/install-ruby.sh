#!/bin/bash

# --------------------------------------------------------------------------------------------
# Installs Ruby 2.5 using rbenv/ruby-build on the Raspberry Pi (Raspbian)
# --------------------------------------------------------------------------------------------

# Time the install process
START_TIME=$SECONDS

# Install git + dependencies
# See: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt update
sudo apt upgrade
sudo apt install -y git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# Check out rbenv into ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Add ~/.rbenv/bin to $PATH, enable shims and autocompletion
read -d '' String <<"EOF"
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF

# Save to ~/.bashrc
echo -e "\n${String}" >> ~/.bashrc

# Enable rbenv for current shell
eval "${String}"

# Install ruby-build as an rbenv plugin, adds `rbenv install` command
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby 2.5, don't generate RDoc to save lots of time
CONFIGURE_OPTS="--disable-install-doc --enable-shared" rbenv install 2.5.1 --verbose

# Set Ruby 2.5 as the global default
rbenv global 2.5.1

# Don't install docs for gems (saves lots of time)
echo "gem: --no-document" > ~/.gemrc

# Reminder to reload the shell
echo -e "\nReload the current shell to get access to rbenv using:"
echo "  source ~/.bashrc"

# Print the time elapsed
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo -e "\nFinished in $(($ELAPSED_TIME/60/60)) hr, $(($ELAPSED_TIME/60%60)) min, and $(($ELAPSED_TIME%60)) sec\n"
