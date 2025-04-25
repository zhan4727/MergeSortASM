.text

.globl merge
merge:
	pushq %rbp		# %rdi = arr, %rsi = left, %rdx = mid, %rcx = right
	movq %rsp, %rbp
	pushq %rbx		# Use callee saved registers
	pushq %r12
	pushq %r13
	pushq %r14

	# Save parameters
	movq %rdi, %rbx		# %rbx = arr
	movq %rsi, %r12		# %r12 = left
	movq %rdx, %r13		# %r13 = mid
	movq %rcx, %r14		# %r14 = right

	subq %rsi, %rdx		# %rdx = n1 = mid - left + 1
	addq $1, %rdx		

	subq %r13, %rcx		# %rcx = n2 = right - mid

	movq %rdx, %r8
	imulq $8, %r8		# sizeof(long) = 8
	movq %r8, %rdi
	pushq %rdx		# Save n1 and n2 before calling malloc
	pushq %rcx
	movq $0, %rax
	call malloc
	movq %rax, %r8		# long *L = malloc(n1 * sizeof(long)), %r8 = L
	popq %rcx
	popq %rdx		# Restore n1 and n2

	movq %rcx, %r9
	imulq $8, %r9
	movq %r9, %rdi
	movq $0, %rax
	pushq %rdx
	pushq %rcx
	call malloc
	movq %rax, %r9		# long *R = malloc(n2* sizeof(long)), %r9 = R
	popq %rcx
	popq %rdx

	movq $0, %rax		# i = 0

for_i:	cmpq %rax, %rdx		# for (i = 0; i < n1; i++)
	jle end_for_i

	movq %r12, %r10
	addq %rax, %r10
	imulq $8, %r10
	addq %rbx, %r10
	movq (%r10), %r10	# Get arr[left + i]

	movq %rax, %r11
	imulq $8, %r11
	addq %r8, %r11
	movq %r10, (%r11)	# L[i] = arr[left + i]

	addq $1, %rax
	jmp for_i
end_for_i:

	movq $0, %rax		# j = 0
for_j:	cmpq %rax, %rcx		# for (j = 0; j < n2; j++)
	jle end_for_j

	movq %r13, %r10
	addq %rax, %r10
	addq $1, %r10
	imulq $8, %r10
	addq %rbx, %r10
	movq (%r10), %r10	# Get arr[mid + 1 + j]

	movq %rax, %r11
	imulq $8, %r11
	addq %r9, %r11
	movq %r10, (%r11)	# R[j] = arr[mid + 1 + j]

	addq $1, %rax
	jmp for_j
end_for_j:

	movq $0, %rdi		# i = 0
	movq $0, %rsi		# j = 0
	movq %r12, %rax		# k = left

while1:	cmpq %rdi, %rdx		# while (i < n1
	jle end_while1		# 
	cmpq %rsi, %rcx		# && j < n2)
	jle end_while1		#

	movq %rdi, %r10		# L[i]
	imulq $8, %r10
	addq %r8, %r10
	movq (%r10), %r10

	movq %rsi, %r11
	imulq $8, %r11
	addq %r9, %r11
	movq (%r11), %r11	# R[j]

	cmpq %r10, %r11		# if (L[i] <= R[j])
	jl else
	movq %rax, %r11
	imulq $8, %r11
	addq %rbx, %r11
	movq %r10, (%r11)	# arr[k] = L[i]
	addq $1, %rdi		# i++
	jmp end_if

else:	movq %rax, %r10
	imulq $8, %r10
	addq %rbx, %r10
	movq %r11, (%r10)	# arr[k] = R[j]
	addq $1, %rsi		# j++

end_if:
	addq $1, %rax		# k++
	jmp while1
end_while1:

while2:	cmpq %rdi, %rdx		# while (i < n1)
	jle end_while2

	movq %rdi, %r10
	imulq $8, %r10
	addq %r8, %r10
	movq (%r10), %r10	# L[i]

	movq %rax, %r11
	imulq $8, %r11
	addq %rbx, %r11
	movq %r10, (%r11)	# arr[k] = L[i]

	addq $1, %rdi		# i++
	addq $1, %rax		# k++
	jmp while2		
end_while2:

while3:	cmpq %rsi, %rcx		# while (j < n2)
	jle end_while3

	movq %rsi, %r10
	imulq $8, %r10
	addq %r9, %r10
	movq (%r10), %r10	# R[j]

	movq %rax, %r11
	imulq $8, %r11
	addq %rbx, %r11
	movq %r10, (%r11)	# arr[k] = R[j]

	addq $1, %rsi		# j++
	addq $1, %rax		# k++

	jmp while3
end_while3:

	movq %r8, %rdi		# free(L)
	movq $0, %rax
	call free

	movq %r9, %rdi		# free(R)
	movq $0, %rax		
	call free		

	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	leave
	ret

.globl mergeSort
mergeSort:			# %rdi = arr, %rsi = left, %rdx = right
	pushq %rbp
	movq %rsp, %rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14

	# Move parameters to callee-saved registers
	movq %rdi, %rbx		# rbx = arr
	movq %rsi, %r12		# r12 = left
	movq %rdx, %r13		# r13 = right

	cmpq %r12, %r13		# if (left < right)
	jle end_function

	movq %r13, %r14
	subq %r12, %r14
	movq %r14, %rax
	movq $2, %rcx
	movq $0, %rdx
	idivq %rcx
	movq %rax, %r14
	addq %r12, %r14		# mid = left + (right - left) / 2

	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	call mergeSort		# mergeSort(arr, left, mid)

	movq %rbx, %rdi
	movq %r14, %rsi
	addq $1, %rsi
	movq %r13, %rdx
	call mergeSort		# mergeSort(arr, mid + 1, right)

	movq %rbx, %rdi
	movq %r12, %rsi
	movq %r14, %rdx
	movq %r13, %rcx
	call merge		# merge(arr, left, mid, right)

end_function:	

	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	leave
	ret
