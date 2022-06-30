# ABI: https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf
# Important when calling any function
#
#	From left to right we use the registers:
#	Pointers & Integers: rdi, rsi, rdx, rcx, r8, r9
#	Floats: xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7
#	Additional Params are pushed on the stack

	.file "logger.s"
	.global _start		# I used main originally, but elf requires _start
	.bss				# Allocated but not defined
str: .fill 20			# Global byte array size is 20
	.text

print:					# void print()
	push %rbp			# Save the return function, while incrementing rsp by 8
	mov %rsp, %rbp		# Our current function rbp is now the current stack
	
	mov %rax, %rdx		# Read systemcall returns value in rax
						# so we want to save the number
						# of bytes read from stdin to rdx
						# which will be number of bytes to write
						# to stdout. Do this before setting up next
						# system call.

	mov $1, %rax		# Now we are setting up the write system call 
	mov $1, %rdi		# Put the file descriptor stdout as the thing
						# to write to.
	mov $str, %rsi		# Point the buffer that has the data here.
	syscall				# OS once again runs through the
						# abi and send the string to the terminal
	pop %rbp			# Restore the previous call stack
	ret

_start:
	mov $0, %rdi
	mov $str, %rsi		# RSI is where we'll store the data
	movl $20, %edx		# Number of bytes to read
	mov $0, %rax
	syscall				# OS registers 0x80 interrupt
						# and stores the required registers
						# kernel puts value into %rbx
	
	call print
	mov $60, %rax		# System call 60 is exit
	xor %rdi, %rdi		# Return 0 from exit
	syscall
