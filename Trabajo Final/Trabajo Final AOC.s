.data

Pregunta:	.asciiz "Escriba la fecha en la que calcular: \n"

Lunes:		.asciiz "Lunes, "
Martes:		.asciiz "Martes, "
Miercoles:	.asciiz "Miercoles, "
Jueves:		.asciiz "Jueves, "
Viernes:	.asciiz "Viernes, "
Sabado:		.asciiz "Sabado, "
Domingo:	.asciiz "Domingo, "

Enero:		.asciiz	"Enero"
Febrero:	.asciiz	"Febrero"
Marzo:		.asciiz	"Marzo"
Abril:		.asciiz	"Abril"
Mayo:		.asciiz	"Mayo"
Junio:		.asciiz	"Junio"
Julio:		.asciiz	"Julio"
Agosto:		.asciiz	"Agosto"
Septiembre:	.asciiz	"Septiembre"
Octubre:	.asciiz	"Octubre"
Noviembre:	.asciiz	"Noviembre"
Diciembre:	.asciiz	"Diciembre"

EDia:	.asciiz "Error, ese día es incorrecto \n"
EMes:	.asciiz "Error,ese mes es incorrecto \n"
EAño:	.asciiz "Error,ese año es negativo \n"

Dato:		.space 32

.text
.globl __start
__start:			#'/'=47 en ascii
la $a0,Pregunta
li $v0 4
syscall
li $a1 20
la $a0,Dato			#$a0 Direccion de la cadena
li $v0 8
syscall
jal CadenaAFecha

Fin:
li $v0 10
syscall

ErrorDia:
la $a0,EDia
li $v0 4
syscall
j Fin

ErrorMes:
la $a0,EMes
li $v0 4
syscall
j Fin

ErrorAño:
la $a0,EAño
li $v0 4
syscall
j Fin


	CadenaAFecha:
	add $s0,$zero,$a0
	
	Dia:
	lb $t0,0($s0)			#$t0 Dia caracter a caracter
	beq $t0,47,DiaSemana
	addi $t0,$t0,-48
	blt $t0,0,ErrorDia
	bge $t0,10,ErrorDia
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 Dia
	addi $s0,$s0,1
	j Dia
	
	DiaSemana:
	div $s1,$t1,10			#$s1 Dia aparte
	add $t1,$zero,$zero
	addi $s0,$s0,1
	
	Mes:
	lb $t0,0($s0)			#$s0 Mes caracter a caracter
	beq $t0,47,MesAño
	addi $t0,$t0,-48
	blt $t0,0,ErrorMes
	bge $t0,10,ErrorMes
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 Mes
	addi $s0,$s0,1
	j Mes
	
	MesAño:
	div $s2,$t1,10			#$s2 Mes aparte
	add $t1,$zero,$zero
	addi $s0,$s0,1
	
	Año:
	lb $t0,0($s0)			#$s0 Año caracter a caracter
	beq $t0,10,Paso1
	addi $t0,$t0,-48
	blt $t0,0,ErrorAño
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 Año
	addi $s0,$s0,1
	j Año

Paso1:
div $s3,$t1,10				#$s3 Año aparte
add $t1,$zero,$zero
jal ValidarFecha
	
	jr $ra
	
	ValidarFecha:
	addi $t0,$zero,4
	div $s3,$t0
	mfhi $t0			#$t0 Comprueba si es bisiesto		"1,3,5,7,8,10,12"=31	"4,6,9,11"=30	Febrero=29 o 28 si es bisiesto
	beq $s2,1,Valida31
	beq $s2,2,ValidaFebrero
	beq $s2,3,Valida31
	beq $s2,4,Valida30
	beq $s2,5,Valida31
	beq $s2,6,Valida30
	beq $s2,7,Valida31
	beq $s2,8,Valida31
	beq $s2,9,Valida30
	beq $s2,10,Valida31
	beq $s2,11,Valida30
	beq $s2,12,Valida31
	
	Valida31:
	bgt $s1,31,ErrorDia
	j Paso2
	
	Valida30:
	bgt $s1,30,ErrorDia
	j Paso2
	
	ValidaFebrero:
	beqz $t0,ValidaBisiesto
	bgt $s1,29,ErrorDia
	j Paso2
	
	ValidaBisiesto:
	bgt $s1,28,ErrorDia
	j Paso2
	
Paso2: