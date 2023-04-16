; This file is part of RAETSELx86 <https://github.com/monsieuremre/raetselx86>
; RAETSELx86 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
; RAETSELx86 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
; You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

DEFAULT REL

SECTION .text
extern malloc
extern reflect, left, middle, right, plugboard, pos_l, pos_m, pos_r
global enigma

enigma:
    push rbp
    mov rbp, rsp ; Build the new stack frame
    push rbx ;
    push r12 ;
    push r13 ; These are the callee saved registered. as of convention, we restore them before the program terminates
    push rdi ;
    push rsi ; We save these just in case before we call malloc
    mov rbx, rsp ; Save stack
    and rsp, -16 ; Align stack before malloc
    call malloc ; We call malloc to allocate memory to the result we will return
    mov rsp, rbx ; Restore stack
    mov rbx, rax
    pop r12 ; Address of the original message now in r12
    pop r14 ; Message length now in r14
    mov r13, 0
    mov rcx, 0
loop:
    ; We loop through all characters. use rcx as iterator and r14 has the length of the string
    cmp rcx, r14
    je end
check_space:
    ; If there is space, we don't encrypt. this was also the case with the historical enigma machine
    cmp BYTE[r12 + rcx], 32
    jne plugboard_plain
    mov BYTE[rbx + rcx], 32
    inc rcx
    jmp loop
plugboard_plain:
    ; We apply the plugboard configuration to the plain character
    mov r13b, [r12 + rcx]
    sub r13b, 65
    mov r13b, [plugboard + r13]
rotate:
    ; We rotate the three rotating motors
    ; We rotate the first rotor one step. if a full rotation is made, the second rotors is rotated one step.
    ; If the second rotor has come a full circle, the third rotor is moved
    inc QWORD[pos_r]
    cmp QWORD[pos_r], 26
    jb rotate_end
    mov QWORD[pos_r], 0
    inc QWORD[pos_m]
    cmp QWORD[pos_m], 26
    jb rotate_end
    mov QWORD[pos_m], 0
    inc QWORD[pos_l]
    cmp QWORD[pos_l], 26
    jb rotate_end
    mov QWORD[pos_l], 0
rotate_end:
right_normal:
    ; The message is first encrypted using the right rotor. analog in the following rotors
    sub r13, 65
    add r13, [pos_r]
    cmp r13, 26 ; We us this as a modulo operator to check we are not over 26 as this would go out the alphabet. when we reach 26 we set to 0. analog in the following rotors
    jb right_mod
    sub r13, 26
right_mod:
    mov r13b, [right + r13]
middle_normal:
    sub r13, 65
    add r13, [pos_m]
    cmp r13, 26
    jb middle_mod
    sub r13, 26
middle_mod:
    mov r13b, [middle + r13]
left_normal:
    sub r13, 65
    add r13, [pos_l]
    cmp r13, 26
    jb left_mod
    sub r13, 26
left_mod:
    mov r13b, [left + r13]
reflector:
    ; The reflector is applied. the reflector has to configured like the plugboard to be self mapping to ensure symmetrie, so that messages can be decrypted in the future
    sub r13, 65
    mov r13b, [reflect + r13]
left_reverse:
    ; To apply the rotors now in reverse, we would have to know the index of the character
    ; We achieve this with a small loop. we iterate through all characters in order in the rotor until we reach the desired character
    ; Then the value of iterator would be the index of the character. there is no simpler way of achieving this in low level programming
    mov rax, 0
l1:
    cmp [left + rax], r13b
    je l1_end
    inc rax
    jmp l1
l1_end:
    add rax, 26
    sub rax, [pos_l]
    cmp rax, 26
    jb left_reverse_mod
    sub rax, 26
left_reverse_mod:
    add rax, 65
    mov r13, rax
middle_reverse:
    mov rax, 0
l2:
    cmp [middle + rax], r13b
    je l2_end
    inc rax
    jmp l2
l2_end:
    add rax, 26
    sub rax, [pos_m]
    cmp rax, 26
    jb middle_reverse_mod
    sub rax, 26
middle_reverse_mod:
    add rax, 65
    mov r13, rax
right_reverse:
    mov rax, 0
l3:
    cmp [right + rax], r13b
    je l3_end
    inc rax
    jmp l3
l3_end:
    add rax, 26
    sub rax, [pos_r]
    cmp rax, 26
    jb right_reverse_mod
    sub rax, 26
right_reverse_mod:
    add rax, 65
    mov r13, rax
plugboard_encrypted:
    ; We apply the plugboard once more, after encryption
    sub r13b, 65
    mov r13b, [plugboard + r13]
result:
    ; The result is moved to the memory place we allocated
    mov [rbx + rcx], r13b
    inc rcx
    jmp loop
end:
    mov rax, rbx
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
