# MyCPSetup
My personal competitve programming setup (man, I actually don't know anything about configuration).

## My setup
OS: Windows 10.<br>
WSL: Ubuntu 26.04 LTS.<br>
Code editor: Neovim, or Nvim-Qt sometimes.<br>
File manager: Midnight Commander
Programming language: C++17 and Python 3.14.4.<br>

## Install what I install
### Windows (install in Windows Powershell):
(If you use Linux instead of Windows, skip this part)
WSL with default distro is Ubuntu.
```powershell
wsl --install
```
Neovim. (for Windows editing)
```powershell
winget install Neovim.Neovim
```
Neovim-qt. (if you want)
```powershell
winget install Neovim.Neovim-qt
```
### Ubuntu (install in Ubuntu Terminal):
This is the main workspace, where I code.<br>
Update package manager.
```bash
sudo apt update && sudo apt upgrade -y
```
C++ tools.
```bash
sudo apt install build-essential gdb -y
```
Python 3.14.4
```bash
sudo apt install python3
```
Neovim
```bash
sudo apt install neovim
```
Midnight Commander (mc)
```bash
sudo apt install mc
```
```
```
