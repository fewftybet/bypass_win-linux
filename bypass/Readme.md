### 二、在 Linux 上用 GCC 编译
#### 编译 Linux x64 版本
g++ loader_linux.cpp -o loader_x64 -z execstack -fno-stack-protector
#### 编译 Linux x86 版本（需要 multilib）
```
sudo apt install g++-multilib  #（需要 multilib）
g++ -m32 loader_linux.cpp -o loader_x86 -z execstack -fno-stack-protector
```
### 三、在 Linux 下输出 Windows 可执行文件（Win32 / Win64）

#### 在 Linux 上想生成 Windows 程序，需要用 MinGW 交叉编译器：
安装：
sudo apt install mingw-w64
#### 编译 Win32
i686-w64-mingw32-g++ loader_win.cpp -o loader_win32.exe -static
#### 编译 Win64
x86_64-w64-mingw32-g++ loader_win.cpp -o loader_win64.exe -static

# 注意
#### 32位的程序用32位的加载器
eg: 将程序转为shellcodexxx_32.exe->exe2shellcode
	编译加载器loader_win.cpp->loader_win32.exe