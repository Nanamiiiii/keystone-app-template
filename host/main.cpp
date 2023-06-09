#include "edge/edge_call.h"
#include "host/keystone.h"

int main(int argc, char **argv)
{
    Keystone::Enclave enclave;
    Keystone::Params params;

    params.setFreeMemSize(1024 * 1024);
    params.setUntrustedMem(DEFAULT_UNTRUSTED_PTR, 1024 * 1024);

    enclave.init(argv[1], argv[2], params);

    enclave.registerOcallDispatch(incoming_call_dispatch);
    edge_call_init_internals(
        (uintptr_t)enclave.getSharedBuffer(), enclave.getSharedBufferSize());

    enclave.run();

    return 0;
}
