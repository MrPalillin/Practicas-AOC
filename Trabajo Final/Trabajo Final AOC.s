.data

Pregunta:	.asciiz "Escriba la fecha en la que calcular: \n"

De:		.asciiz " de "

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
Eyear:	.asciiz "Error,ese year es negativo \n"

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

Erroryear:
la $a0,Eyear
li $v0 4
syscall
j Fin


	CadenaAFecha:
	add $s0,$zero,$a0
	
	Dia:
	lb $t0,0($s0)			#$t0 Dia caracter a caracter
	beq $t0,47,PasoMes
	addi $t0,$t0,-48
	blt $t0,0,ErrorDia
	bge $t0,10,ErrorDia
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 Dia
	addi $s0,$s0,1
	j Dia
	
	PasoMes:
	div $s1,$t1,10			#$s1 Dia aparte
	add $t1,$zero,$zero
	addi $s0,$s0,1
	
	Mes:
	lb $t0,0($s0)			#$s0 Mes caracter a caracter
	beq $t0,47,Pasoyear
	addi $t0,$t0,-48
	blt $t0,0,ErrorMes
	bge $t0,10,ErrorMes
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 Mes
	addi $s0,$s0,1
	j Mes
	
	Pasoyear:
	div $s2,$t1,10			#$s2 Mes aparte
	add $t1,$zero,$zero
	addi $s0,$s0,1
	
	year:
	lb $t0,0($s0)			#$s0 year caracter a caracter
	beq $t0,10,Paso1
	addi $t0,$t0,-48
	blt $t0,0,Erroryear
	add $t1,$t1,$t0
	mul $t1,$t1,10			#$t1 year
	addi $s0,$s0,1
	j year

Paso1:
div $s3,$t1,10				#$s3 year aparte
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

jal DiaSemana

	DiaSemana:
	div $t0,$s3,100		#Paso 1:Siglo
	bge $t0,22,Resta4
	bge $t0,21,Resta2
	bge $t0,20,Cero
	bge $t0,19,Suma1
	bge $t0,18,Suma3
	
	Resta4:
	li $t0,-4
	j yearSemana
	
	Resta2:
	li $t0,-2
	j yearSemana
	
	Cero:
	li $t0,0
	j yearSemana
	
	Suma1:
	li $t0,1
	j yearSemana
	
	Suma3:
	li $t0,3
	j yearSemana			#A en $t0
	
	yearSemana:			#Paso 2:year
	li $t6,100
	div $s3,$t6
	mfhi $t1
	li $t6,4
	div $t1,$t6
	mflo $t2
	add $t1,$t1,$t2		#B en $t1
	li $t2,0
	
	li $t6,100
	div $s3,$t6		#Paso 3:Bisiesto(enero y febrero)
	mfhi $t7
	beqz $t7,MesSemana
	li $t6,4
	div $s3,$t6
	mfhi $t7
	bne $t7,$zero,MesSemana
	bgt $s2,2,MesSemana
	li $t2,-1		#C en $t2
	
	MesSemana:			#Paso 4:Mes
	li $t3,-1
	
	seq $t3,$s2,1
	mul $t3,$t3,6
	beq $t3,6,ResultadoMes
	
	seq $t3,$s2,2
	mul $t3,$t3,2
	beq $t3,2,ResultadoMes
	
	seq $t3,$s2,3
	mul $t3,$t3,2
	beq $t3,2,ResultadoMes
	
	seq $t3,$s2,4
	mul $t3,$t3,5
	beq $t3,5,ResultadoMes
	
	beq $s2,5,MesMayo			#Debido a que aqui el $t2 debe dar cero,el procedimiento en mayo es un poco diferente
	
	seq $t3,$s2,6
	mul $t3,$t3,3
	beq $t3,3,ResultadoMes
	
	seq $t3,$s2,7
	mul $t3,$t3,5
	beq $t3,5,ResultadoMes
	
	seq $t3,$s2,8
	mul $t3,$t3,1
	beq $t3,1,ResultadoMes
	
	seq $t3,$s2,9
	mul $t3,$t3,4
	beq $t3,4,ResultadoMes
	
	seq $t3,$s2,10
	mul $t3,$t3,6
	beq $t3,6,ResultadoMes
	
	seq $t3,$s2,11
	mul $t3,$t3,2
	beq $t3,2,ResultadoMes
	
	seq $t3,$s2,12
	mul $t3,$t3,4		#Mes en $t3
	j ResultadoMes
	MesMayo:
	li $t3,0
	
	ResultadoMes:		#Paso 5:Dia
	add $t4,$t4,$s1		#Dia en $t4

	add $s4,$zero,$t0
	add $s4,$s4,$t1
	add $s4,$s4,$t2
	add $s4,$s4,$t3
	add $s4,$s4,$t4
	add $s4,$s4,$t5		#Dia de la semana en $s4
	
	bge $s4,7,Resta7
	j Paso3
	
	Resta7:
	addi $s4,$s4,-7
	bge $s4,7,Resta7
	blt $s4,7,Paso3
	
	jr $ra
	
Paso3:				#Dia de la semana terminado en $s4
add $t0,$zero,$zero
add $t1,$zero,$zero
add $t2,$zero,$zero
add $t3,$zero,$zero
add $t4,$zero,$zero
jal Imprimir

	Imprimir:
	beq $s4,1,ImprimeLunes
	beq $s4,2,ImprimeMartes
	beq $s4,3,ImprimeMiercoles
	beq $s4,4,ImprimeJueves
	beq $s4,5,ImprimeViernes
	beq $s4,6,ImprimeSabado
	beq $s4,0,ImprimeDomingo
	
	ImprimeLunes:
	la $a0,Lunes
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeMartes:
	la $a0,Martes
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeMiercoles:
	la $a0,Miercoles
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeJueves:
	la $a0,Jueves
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeViernes:
	la $a0,Viernes
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeSabado:
	la $a0,Sabado
	li $v0,4
	syscall
	j ImprimeDia
	
	ImprimeDomingo:
	la $a0,Domingo
	li $v0,4
	syscall
	j ImprimeDia
	
	
	ImprimeDia:
	add $a0,$zero,$s1
	li $v0 1
	syscall
	
	la $a0,De
	li $v0 4
	syscall
	
	beq $s2,1,ImprimeEnero
	beq $s2,2,ImprimeFebrero
	beq $s2,3,ImprimeMarzo
	beq $s2,4,ImprimeAbril
	beq $s2,5,ImprimeMayo
	beq $s2,6,ImprimeJunio
	beq $s2,7,ImprimeJulio
	beq $s2,8,ImprimeAgosto
	beq $s2,9,ImprimeSeptiembre
	beq $s2,10,ImprimeOctubre
	beq $s2,11,ImprimeNoviembre
	beq $s2,12,ImprimeDiciembre
	
	ImprimeEnero:
	la $a0,Enero
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeFebrero:
	la $a0,Febrero
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeMarzo:
	la $a0,Marzo
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeAbril:
	la $a0,Abril
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeMayo:
	la $a0,Mayo
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeJunio:
	la $a0,Junio
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeJulio:
	la $a0,Julio
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeAgosto:
	la $a0,Agosto
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeSeptiembre:
	la $a0,Septiembre
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeOctubre:
	la $a0,Octubre
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeNoviembre:
	la $a0,Noviembre
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	ImprimeDiciembre:
	la $a0,Diciembre
	li $v0,4
	syscall
	la $a0,De
	li $v0 4
	syscall
	j Imprimeyear
	
	Imprimeyear:
	add $a0,$zero,$s3
	li $v0 1
	syscall
	j Fin
	
	jr $ra
