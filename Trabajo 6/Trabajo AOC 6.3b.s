.data

Pregunta:	.asciiz "Escriba un numero: \n"
dato:		.space 32
Resultado:	.space 32
Respuesta:	.asciiz	"El numero en decimal es: \n"

.text
.globl __start
__start:
la $a0,Pregunta
li $v0 4
syscall
li $a1,10
la $a0,dato
li $v0 8
syscall
jal CadenaHex

Fin:
la $a0,Respuesta
li $v0 4
syscall
add $a0,$zero,$s2
#add $a0,$a0,$t6
addi $a0,$a0,1
li $v0 4
syscall
li $v0 10
syscall

CadenaHex:
	add $s0,$zero,$a0
	addi $s1,$zero,7
	
	CargaBit:
	lb $t0,0($s0)
	slti $t1,$t0,58
	beq $t1,0,Letra
	j Numero
	
	Letra:
	addi $t0,$t0,-55
	or $t2,$t2,$t0
	beqz $s1,HexDecimal
	addi $s1,$s1,-1
	rol $t2,$t2,4
	addi $s0,$s0,1
	j CargaBit
	
	Numero:
	addi $t0,$t0,-48
	or $t2,$t2,$t0
	beqz $s1,HexDecimal
	addi $s1,$s1,-1
	rol $t2,$t2,4
	addi $s0,$s0,1
	j CargaBit
	
	jr $ra				#Numero en $t2
	
HexDecimal:
li $s1,0
li $t0,0
li $t1,0
addi $t7,$zero,10
la $s2,Resultado
li $a0,0
blt $t2,0,Negativo
jal Dividir
	
	Negativo:
	li $t1,45
	mul $t2,$t2,-1
	sb $t1,0($s2)
	li $t1,0
	addi $t6,$t6,1
	addi $s1,$s1,-1

	Dividir:
	beqz $t2,Fin
	div $t2,$t7
	mfhi $t1
	mflo $t2
	addi $t1,$t1,48
	sb $t1,0($s2)			#Cadena en $s2
	addi $t6,$t6,1
	addi $s2,$s2,-1
	j Dividir
	
	jr $ra