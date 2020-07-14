const win = @import("std").os.windows;

usingnamespace win;

pub const LPMODULEENTRY32 = *MODULEENTRY32;
pub const PMEMORY_BASIC_INFORMATION = *MEMORY_BASIC_INFORMATION;

pub const MAX_MODULE_NAME32 = 255;
pub const TH32CS_SNAPMODULE = 0x00000008;
pub const TH32CS_SNAPMODULE32 = 0x00000010;

pub const MODULEENTRY32 = extern struct {
    dwSize: DWORD,
    th32ModuleID: DWORD,
    th32ProcessID: DWORD,
    GlblcntUsage: DWORD,
    ProccntUsage: DWORD,
    modBaseAddr: *BYTE,
    modBaseSize: DWORD,
    hModule: HMODULE,
    szModule: [MAX_MODULE_NAME32 + 1]CHAR,
    szExePath: [MAX_PATH]CHAR,
};

pub const MEMORY_BASIC_INFORMATION = extern struct {
    BaseAddress: PVOID,
    AllocationBase: PVOID,
    AllocationProtect: DWORD,
    PartitionId: WORD,
    RegionSize: SIZE_T,
    State: DWORD,
    Protect: DWORD,
    Type: DWORD,
};

pub extern "kernel32" fn ReadProcessMemory(
    hProcess: HANDLE,
    lpBaseAddress: LPCVOID,
    lpBuffer: LPVOID,
    nSize: SIZE_T,
    lpNumberOfBytesRead: *SIZE_T
) callconv(.Stdcall) BOOL;

pub extern "kernel32" fn WriteProcessMemory(
    hProcess: HANDLE,
    lpBaseAddress: LPCVOID,
    lpBuffer: LPCVOID,
    nSize: SIZE_T,
    lpNumberOfBytesRead: ?*SIZE_T
) callconv(.Stdcall) BOOL;

pub extern "kernel32" fn CreateToolhelp32Snapshot(
    dwFlags: DWORD,
    th32ProcessID: DWORD,
) callconv(.Stdcall) HANDLE;

pub extern "kernel32" fn Module32First(
    hSnapshot: HANDLE,
    lpme: LPMODULEENTRY32,
) callconv(.Stdcall) BOOL;

pub extern "kernel32" fn Module32Next(
    hSnapshot: HANDLE,
    lpme: LPMODULEENTRY32,
) callconv(.Stdcall) BOOL;

pub extern "kernel32" fn OpenProcess(
    dwDesiredAccess: DWORD,
    bInheritHandle: BOOL,
    dwProcessId: DWORD,
) callconv(.Stdcall) HANDLE;

pub extern "kernel32" fn VirtualQueryEx(
    hProcess: HANDLE,
    lpAddress: LPCVOID,
    lpBuffer: PMEMORY_BASIC_INFORMATION,
) callconv(.Stdcall) SIZE_T;

pub extern "kernel32" fn VirtualProtectEx(
    hProcess: HANDLE,
    lpAddress: LPVOID,
    dwSize: SIZE_T,
    flNewProtect: DWORD,
    lpflOldProtect: LPDWORD, // LPWORD missing
) callconv(.Stdcall) BOOL;

pub extern "psapi" fn EnumProcesses(
    lpidProcess: *DWORD,
    cb: DWORD,
    cbNeeded: *DWORD,
) callconv(.Stdcall) BOOL;