.data
    mlines: .space 4
    ncols: .space 4
    p: .space 4
    k: .space 4
    x: .space 4
    y: .space 4
    i: .space 4
    j: .space 4
    kc: .space 4
    sum: .space 4
    index: .space 4
    value: .space 4
    matrix: .zero 1600
    matrixcopy: .zero 1600
    formatprintf: .asciz "%d "
    formatscanf: .asciz "%d"
    endl: .asciz "\n"
    cheie: .space 4
    o: .space 4
    mesajstr: .space 10
    mesaj: .space 320
    criptstr: .space 20
    cript: .space 320
    len_mesaj: .long 0
    len_cheie: .long 0
    letterindex: .space 4
    formatscanfstr: .asciz "%s"
    formathexa: .asciz "%c"
    format0x: .asciz "0x"
.text
.global main
main:
# Citire matrice

    # mlines
    pushl $mlines
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # ncols
    pushl $ncols
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # bordare
    addl $2, mlines
    addl $2, ncols

    # p
    pushl $p
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # %ecx = 0 & %edi = adresa(matrix) & %esi = adresa(matrixcopy)
    xorl %ecx, %ecx
    lea matrix, %edi
    lea matrixcopy, %esi
    movl %edi, cheie

    # citire x si y de p ori
et_for_p:
    # comparatia din for i < p
    cmp p, %ecx
    je et_cont_p

    # 1. restaurare %ecx
    pushl %ecx

    # citire x
    pushl $x
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # citire y
    pushl $y
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # 2. restaurare %ecx
    popl %ecx

    # matrix[x][y] = x * ncols + y
    # incrementam x, y pentru ca 
    # avem matricea bordata
    incl x
    incl y
    movl x, %eax
    mull ncols
    addl y, %eax
    movl $1, (%edi, %eax, 4)

    # i++ si loop
    incl %ecx
    jmp et_for_p
et_cont_p:
    # citire k
    pushl $k
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # kc = 0
    movl $0, kc
et_for_k:
    # comparatia din for i < k
    movl kc, %ecx
    cmp k, %ecx
    je et_for_k_cont

    # parcurgere matrice nebordata
    # initializare i
    movl $1, i
et_for_linii:
    # comparatia din for i < m
    movl i, %ecx
    movl mlines, %ebx
    decl %ebx
    cmp %ebx, %ecx
    je et_for_linii_cont

    # initializare j
    movl $1, j
    et_for_col:

        # comparatia din for j < n
        movl j, %ecx
        movl ncols, %ebx
        decl %ebx
        cmp %ebx, %ecx
        je et_for_col_cont

        # initializare suma vecini = 0
        movl $0, sum

        # matrix[i][j] = index = i * ncols + j
        movl i, %eax
        mull ncols
        addl j, %eax
        movl %eax, index

        # suma elementelor
        # stanga
        decl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # dreapta
        incl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # sus
        subl ncols, %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # jos
        addl ncols, %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # st-sus
        subl ncols, %eax
        decl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # dr-sus
        subl ncols, %eax
        incl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # st-jos
        addl ncols, %eax
        decl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # dr-jos
        addl ncols, %eax
        incl %eax
        movl (%edi, %eax, 4), %ebx
        addl %ebx, sum
        movl index, %eax

        # comparatii 
        movl (%edi, %eax, 4), %ebx
        cmp $1, %ebx
        je cond1
            movl sum, %ebx
            cmp $3, %ebx
            je cond2
                movl $0, value
                jmp cond2_cont
                cond2:
                movl $1, value
            cond2_cont:
            jmp cond1_cont
        cond1:
            movl sum, %ebx
            cmp $1, %ebx
            jle cond3
                cmp $3, %ebx
                jg cond4
                    movl $1, value
                    jmp cond4_cont
                    cond4:
                    movl $0, value
                cond4_cont:
                jmp cond3_cont
                cond3:
                movl $0, value
            cond3_cont:
        cond1_cont:

        # muta valoarea in matrixcopy
        movl value, %ebx
        movl %ebx, (%esi, %eax, 4)

        # j++ si loop
        incl j
        jmp et_for_col
    et_for_col_cont:

    # i++ si loop
    incl i
    jmp et_for_linii
et_for_linii_cont:

    # interschimbare adrese matrici
    movl %esi, %ebx
    movl %edi, %esi
    movl %ebx, %edi
    movl %edi, cheie

    # kc++ si loop
    incl kc
    jmp et_for_k
et_for_k_cont:

    # parcurgere matrice nebordata
    # initializare i
    movl $1, i
et_for_linii_w:

    # comparatia din for i < m
    movl i, %ecx
    movl mlines, %ebx
    decl %ebx
    cmp %ebx, %ecx
    je et_for_linii_w_cont

    # initializare j
    movl $1, j
    et_for_col_w:

        # comparatia din for j < n
        movl j, %ecx
        movl ncols, %ebx
        decl %ebx
        cmp %ebx, %ecx
        je et_for_col_w_cont

        # matrix[i][j] = index = i * ncols + j
        movl i, %eax
        mull ncols
        addl j, %eax
        movl (%edi, %eax, 4), %ebx

        # j++ si loop
        incl j
        jmp et_for_col_w
    et_for_col_w_cont:

    # i++ si loop
    incl i
    jmp et_for_linii_w
et_for_linii_w_cont:

# cerinta 0x01
et_cerinta0x01:

    # citire o
    pushl $o
    pushl $formatscanf
    call scanf
    addl $8, %esp

    # if o == 0
    movl o, %eax
    cmpl $0, %eax
    jne et_decriptare

# criptare
et_criptare:

    # citire mesaj
    pushl $mesajstr
    pushl $formatscanfstr
    call scanf
    addl $8, %esp

    # incarcare adresa &mesajstr
    lea mesajstr, %edi

    # incarcare adresa &mesaj
    lea mesaj, %esi

    # %ecx = 0 & %edx = 0
    xorl %ecx, %ecx
    xorl %edx, %edx
et_for_mesajstr:

    # litera curenta in %bl
    movb (%edi, %ecx, 1), %bl
    cmpb $0, %bl
    je et_for_mesajstr_cont

        # %ecx = 0
        push %ecx
        xorl %ecx, %ecx
    et_for_letter_mesaj:
        
        # %ecx < 8
        cmpl $8, %ecx
        je et_for_letter_mesaj_cont

        # contor lungime mesaj
        incl len_mesaj
        
        # prima cif %ebx, shl %ebx
        movl $1, %eax
        shl $7, %eax
        and %ebx, %eax
        shl $1, %ebx
        shr $7, %eax

        # mutare %eax in mesaj
        movl %eax, (%esi, %edx, 4)

        # %edx++
        incl %edx
        
        # %ecx++
        incl %ecx
        jmp et_for_letter_mesaj
    et_for_letter_mesaj_cont:

    # ecx++
    pop %ecx
    inc %ecx
    jmp et_for_mesajstr
et_for_mesajstr_cont:

    # mesaj si cheie
    
    # calculare len_cheie
    xorl %edx, %edx
    movl mlines, %eax
    movl ncols, %ebx
    mull %ebx
    movl %eax, len_cheie

    # len_cheie ? len_mesaj
    cmp len_mesaj, %eax
    jl et_mesajgcheie
et_mesajngcheie:

    # adresa mesaj si cheie
    # ecx = 0
    lea mesaj, %edi
    movl cheie, %esi
    xorl %ecx, %ecx

    et_for_xor_mesajngcheie:
        # parcurgere lungime mesaj
        cmp len_mesaj, %ecx
        jge et_for_xor_mesajngcheie_cont

        # xorare
        movl (%edi, %ecx, 4), %eax
        movl (%esi, %ecx, 4), %ebx
        xor %ebx, %eax
        movl %eax, (%edi, %ecx, 4)

        # %ecx++
        incl %ecx
        jmp et_for_xor_mesajngcheie
    et_for_xor_mesajngcheie_cont:
    
    jmp et_mesajngcheie_cont
et_mesajgcheie:
    
    # adresa mesaj si cheie
    # ecx = 0
    # edx = 0
    lea mesaj, %edi
    movl cheie, %esi
    xorl %ecx, %ecx
    xorl %edx, %edx

    et_for_xor_mesajgcheie:
        # parcurgere lungime mesaj
        cmp len_mesaj, %ecx
        jge et_for_xor_mesajgcheie_cont

        # resetare %edx
        cmp len_cheie, %edx
        jl et_criptare_cheie_reset
        xorl %edx,%edx
        et_criptare_cheie_reset:

        # xorare
        movl (%edi, %ecx, 4), %eax
        movl (%esi, %edx, 4), %ebx
        xor %ebx, %eax
        movl %eax, (%edi, %ecx, 4)

        # %ecx++
        # %edx++
        incl %ecx
        incl %edx
        jmp et_for_xor_mesajgcheie
    et_for_xor_mesajgcheie_cont:

et_mesajngcheie_cont:

    # aici am in mesaj xorarea
    # afisare
    # print 0x
    pushl $format0x
    call printf
    addl $4, %esp

    lea mesaj, %edi
    xorl %ecx, %ecx
    
    # parcurgere mesaj
    et_for_biti_mesaj:
    cmp len_mesaj, %ecx
    jge et_for_biti_mesaj_cont

        xorl %eax, %eax

        movl (%edi, %ecx, 4), %ebx
        shl $3, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $2, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $1, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $0, %ebx
        addl %ebx, %eax
        incl %ecx

        push %ecx

        # ascii => hexa
        cmpl $10, %eax
        jge islit1
        iscif1:
        addl $48, %eax
        jmp iscif1_cont

        islit1:
        addl $55, %eax

        iscif1_cont:

        push %eax
        push $formathexa
        call printf
        addl $8, %esp

        push $0
        call fflush
        addl $4, %esp

        pop %ecx

    jmp et_for_biti_mesaj
    et_for_biti_mesaj_cont:

    # print endl
    pushl $endl
    call printf
    addl $4, %esp

    jmp et_criptare_cont

# decriptare
et_decriptare:

    # citire cript
    pushl $criptstr
    pushl $formatscanfstr
    call scanf
    addl $8, %esp

    # incarcare adresa &criptstr
    lea criptstr, %edi

    # incarcare adresa &cript
    lea cript, %esi

    # %ecx = 0 & %edx = 0
    movl $2, %ecx
    xorl %edx, %edx
et_for_criptstr:

    # litera curenta in %bl
    xorl %ebx, %ebx
    movb (%edi, %ecx, 1), %bl
    cmpb $0, %bl
    je et_for_criptstr_cont

        # ascii => hexa
        cmpl $58, %ebx
        jge islit
        iscif:
        subl $48, %ebx
        jmp iscif_cont

        islit:
        subl $55, %ebx

        iscif_cont:

        # %ecx = 0
        push %ecx
        xorl %ecx, %ecx
    et_for_letter_cript:
        
        # %ecx < 8
        cmpl $4, %ecx
        je et_for_letter_cript_cont

        # contor lungime mesaj
        incl len_mesaj
        
        # prima cif %ebx, shl %ebx
        movl $1, %eax
        shl $3, %eax
        and %ebx, %eax
        shl $1, %ebx
        shr $3, %eax

        # mutare %eax in cript
        movl %eax, (%esi, %edx, 4)

        # %edx++
        incl %edx
        
        # %ecx++
        incl %ecx
        jmp et_for_letter_cript
    et_for_letter_cript_cont:

    # ecx++
    pop %ecx
    inc %ecx
    jmp et_for_criptstr
et_for_criptstr_cont:

    # cript si cheie

    # calculare len_cheie
    xorl %edx, %edx
    movl mlines, %eax
    movl ncols, %ebx
    mull %ebx
    movl %eax, len_cheie

    # len_cheie ? len_cript
    cmp len_mesaj, %eax
    jl et_criptgcheie
et_criptngcheie:

    # adresa cript si cheie
    # ecx = 0
    lea cript, %edi
    movl cheie, %esi
    xorl %ecx, %ecx

    et_for_xor_criptngcheie:
        # parcurgere lungime cript
        cmp len_mesaj, %ecx
        jge et_for_xor_criptngcheie_cont

        # xorare
        movl (%edi, %ecx, 4), %eax
        movl (%esi, %ecx, 4), %ebx
        xor %ebx, %eax
        movl %eax, (%edi, %ecx, 4)

        # %ecx++
        incl %ecx
        jmp et_for_xor_criptngcheie
    et_for_xor_criptngcheie_cont:
    
    jmp et_criptngcheie_cont
et_criptgcheie:
    
    # adresa cript si cheie
    # ecx = 0
    # edx = 0
    lea cript, %edi
    movl cheie, %esi
    xorl %ecx, %ecx
    xorl %edx, %edx

    et_for_xor_criptgcheie:
        # parcurgere lungime cript
        cmp len_mesaj, %ecx
        jge et_for_xor_criptgcheie_cont

        # resetare %edx
        cmp len_cheie, %edx
        jl et_decriptare_cheie_reset
        xorl %edx,%edx
        et_decriptare_cheie_reset:

        # xorare
        movl (%edi, %ecx, 4), %eax
        movl (%esi, %edx, 4), %ebx
        xor %ebx, %eax
        movl %eax, (%edi, %ecx, 4)

        # %ecx++
        # %edx++
        incl %ecx
        incl %edx
        jmp et_for_xor_criptgcheie
    et_for_xor_criptgcheie_cont:
    
et_criptngcheie_cont:

    # aici am in cript xorarea
    # afisare
    lea cript, %edi
    xorl %ecx, %ecx
    
    # parcurgere cript
    et_for_biti_cript:
    cmp len_mesaj, %ecx
    jge et_for_biti_cript_cont

        xorl %eax, %eax

        movl (%edi, %ecx, 4), %ebx
        shl $7, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $6, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $5, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $4, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $3, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $2, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $1, %ebx
        addl %ebx, %eax
        incl %ecx

        movl (%edi, %ecx, 4), %ebx
        shl $0, %ebx
        addl %ebx, %eax
        incl %ecx

        push %ecx

        push %eax
        push $formathexa
        call printf
        addl $8, %esp
        
        push $0
        call fflush
        addl $4, %esp

        pop %ecx

    jmp et_for_biti_cript
    et_for_biti_cript_cont:

    # print endl
    pushl $endl
    call printf
    addl $4, %esp

    push $0
    call fflush
    addl $4, %esp

et_criptare_cont:
et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
