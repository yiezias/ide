
chcp 65001
@echo off

pacman --version
if not %errorlevel%==0 (
	echo.
	echo.
	echo msys2 未安装或没有添加环境变量
	pause
	exit)

call npm --version
if not %errorlevel%==0 (
	echo.
	echo.
	echo nodejs未安装
	pause
	exit)

:update
yes|pacman -Syu
if not %errorlevel% == 0 (goto :update)

:clangd
clangd --version
if not %errorlevel% == 0 (
	yes|pacman -Su mingw-w64-x86_64-clang-tools-extra
	goto :clangd)

:cmake
cmake --version
if not %errorlevel% == 0 (
	yes|pacman -Su mingw-w64-x86_64-cmake
	goto :cmake)

:git
git --version
if not %errorlevel% == 0 (
	yes|pacman -Su git
	goto :git)

:yarn
call yarn --version
if not %errorlevel% == 0 (
	call npm.cmd install -g yarn
	goto :yarn)

:cocnvim
if not exist c:\Users\%username%\vimfiles\pack\coc.nvim\start\coc.nvim (
mkdir c:\Users\%username%\vimfiles\pack\coc.nvim\start
git clone https://github.com/neoclide/coc.nvim c:\Users\%username%\vimfiles\pack\coc.nvim\start\coc.nvim
:yi
cd c:\Users\%username%\vimfiles\pack\coc.nvim\start\coc.nvim
call yarn install
if not %errorlevel%==0 (goto :yi)
goto :cocnvim)

:autopairs
if not exist c:\Users\%username%\vimfiles\pack\auto-pairs\start\auto-pairs (
mkdir c:\Users\%username%\vimfiles\pack\auto-pairs\start
git clone https://github.com/jiangmiao/auto-pairs c:\Users\%username%\vimfiles\pack\auto-pairs\start\auto-pairs
goto :autopairs
)

:ccls
c:\Users\%username%\ccls\Release\ccls --version
if not %errorlevel%==0 (
if not exist c:\Users\%username%\ccls (
	git clone https://github.com/MaskRay/ccls c:\Users\%username%\ccls
	:sub
	cd c:\Users\%username%\ccls
	git submodule update --init
	if not %errorlevel%==0 (goto :sub)
	goto :ccls
)
cd c:\Users\%username%\ccls
cmake -H. -BRelease -G Ninja -DCMAKE_CXX_FLAGS=-D__STDC_FORMAT_MACROS
ninja -C Release
	goto :ccls)

if exist c:\Users\%username%\_vimrc (
	mv c:\Users\%username%\_vimrc c:\Users\%username%\vimrcbkp
)

if exist c:\Users\%username%\vimfiles\coc-settings.json (
	mv c:\Users\%username%\vimfiles\coc-settings.json c:\Users\%username%\vimfiles\coc-settings.json.bk
)

echo {"languageserver": {"ccls": {"command": "ccls", >> c:\Users\%username%\vimfiles\coc-settings.json
echo "filetypes": ["c", "cpp", "cuda", "objc", "objcpp"], >> c:\Users\%username%\vimfiles\coc-settings.json
echo "rootPatterns": [".ccls-root", "compile_commands.json"], >> c:\Users\%username%\vimfiles\coc-settings.json
echo "initializationOptions": { >> c:\Users\%username%\vimfiles\coc-settings.json
echo "cache": {"directory": ".ccls-cache"}, >> c:\Users\%username%\vimfiles\coc-settings.json
echo "client": {"snippetSupport": true}}}}} >> c:\Users\%username%\vimfiles\coc-settings.json

echo source $VIMRUNTIME/defaults.vim >> c:\Users\%username%\_vimrc
echo set guifont=Consolas:h20 >> c:\Users\%username%\_vimrc

pause
