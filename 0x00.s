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

        # afisare
        pushl %ebx
        pushl $formatprintf
        call printf
        addl $8, %esp

        push $0
        call fflush
        addl $4, %esp

        # j++ si loop
        incl j
        jmp et_for_col_w
    et_for_col_w_cont:

    # print endl
    pushl $endl
    call printf
    addl $4, %esp

    pushl $0
    call fflush
    addl $4, %esp

    # i++ si loop
    incl i
    jmp et_for_linii_w
et_for_linii_w_cont:
et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
    