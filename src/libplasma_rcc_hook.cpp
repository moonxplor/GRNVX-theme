#define _GNU_SOURCE
#include <dlfcn.h>
#include <QResource>
#include <cstdio>
#include <cstring>

static void register_rcc() {
    bool ok = QResource::registerResource("/home/moonxplor/.local/share/plasma/overrides.rcc");
    fprintf(stderr, "=== [libplasma_rcc_hook] QResource::registerResource result: %d ===\n", ok);
}

__attribute__((constructor))
static void on_load() {
    register_rcc();
}

typedef void* (*dlopen_func_t)(const char*, int);

extern "C" void* dlopen(const char* filename, int flags) {
    static dlopen_func_t real_dlopen = (dlopen_func_t)dlsym(RTLD_NEXT, "dlopen");
    if (!real_dlopen) {
        real_dlopen = (dlopen_func_t)dlsym(RTLD_DEFAULT, "dlopen");
    }
    void* handle = real_dlopen(filename, flags);
    if (filename && strstr(filename, "systemtray.so")) {
        fprintf(stderr, "=== [libplasma_rcc_hook] systemtray.so loaded, re-registering overrides.rcc ===\n");
        register_rcc();
    }
    return handle;
}
