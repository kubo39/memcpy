version(D_InlineAsm_X86_64) {} else static assert(false, "unsupported.");

void memcpy(char* dest, const(char)* src, size_t count) @nogc nothrow @system
{
    const qwordCount = count >> 3;
    const uint byteCount = count & 0b111;
    asm @nogc nothrow @system
    {
        mov RCX, qwordCount;
        mov RSI, src;
        mov RDI, dest;
        rep;
        movsq;
        mov ECX, byteCount;
        rep;
        movsb;
    }
}

void memset(char* dest, int c, size_t count) @nogc nothrow @system
{
    const qwordCount = count >> 3;
    const uint byteCount = count & 0b111;
    const _c = c * 0x0101010101010101;
    asm @nogc nothrow @system
    {
        mov RCX, qwordCount;
        mov RDI, dest;
        mov RAX, _c;
        rep;
        stosq;
        mov ECX, byteCount;
        rep;
        stosb;
    }
}

void main()
{
    import core.stdc.stdio;

    auto src = ['t', 'e', 's', 't'];
    auto dest = ['d', 'u', 'm', 'm'];

    memset(dest.ptr, 0, dest.length);
    printf("%.*s\n", cast(int)dest.length, dest.ptr);

    memcpy(dest.ptr, src.ptr, src.length);
    printf("%.*s\n", cast(int)dest.length, dest.ptr);
}
