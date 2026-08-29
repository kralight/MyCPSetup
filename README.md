# MyCPSetup
My personal competitve programming setup (man, I actually don't know anything about configuration).

## My setup
OS: Windows 10.<br>
WSL: Ubuntu 26.04 LTS.<br>
Code editor: Neovim (Qt version), or gVim sometimes.<br>
Programming language: C++17 and Python 3.14.4.<br>

## Config file
Neovim: https://github.com/kralight/MyCPSetup/blob/main/nvim/init.lua<br>
(g)Vim: https://github.com/kralight/MyCPSetup/blob/main/(g)vim/.vimrc<br>

## Install what I install
### Windows (install in Windows Powershell):
WSL with default distro is Ubuntu.
'''powershell
wsl --install
'''
Neovim-qt.
'''powershell
winget install Neovim.Neovim-qt
'''
### Ubuntu (install in Ubuntu Terminal):
Update package manager.
'''bash
sudo apt update && sudo apt upgrade -y
'''
C++ tools.
'''bash
sudo apt install build-essential gdb -y
'''
Python 3.14.4
'''bash
sudo apt install python3
'''
