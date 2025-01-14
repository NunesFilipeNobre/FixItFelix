.data
.include "Assets/Sprites/predio.data"
.include "Assets/Sprites/felixParado.data"

.text
SETUP:		
		la s0,predio
		li s1,52
		li s2,24
		li s3,0
		jal PRINT

		la s0,felixParado
		li s1,0
		li s2,0
		li s3,0
		jal PRINT

GAME_LOOP:

#
#	s0 = endereço imagem
#	s1 = x
#	s2 = y
#	s3 = frame (0 ou 1)
#
##
#
#	t0 = endereço do bitmap display
#	t1 = endereço imagem (pulando para a parte dos pixel)
#	t2 = contador linha
#	t3 = contador coluna
#	t4 = largura
#	t5 = altura
PRINT:		li t0, 0xFF0	#Inicio do endereço do bitmap display
		add t0,t0,s3	#0xFF0 ou 0xFF1 dependendo do frame s3
		slli t0,t0,20	#Preenche o restante do endereço com zeros (0xFF000000 ou 0xFF100000)
		
		add t0,t0,s1	#Coordenada x da imagem
		
		li t1,320	#Largura da tela
		mul t1,t1,s2	#Largura da tela * y
		add t0,t0,t1	#Endereço no bitmap dislay (x + y * largura da tela)
		
		addi t1,s0,8	#Endereço imagem (Pula os 2 bytes no inicio da imagem)
		
		mv t2,zero	#Zera os contadores de linha
		mv t3,zero
		
		lw t4,0(s0)	#Recebe a largura especificada no arquivo (primeiro byte)
		lw t5,4(s0)	#Receba a altura especificada no arquivo (segundo byte)
		
PRINT_LINHA:	lw t6,0(t1)	#Pega 4 bytes (word) do arquivo da imagem
		sw t6,0(t0)	#Salva 4 bytes (word) no endereço da bitmap display
		
		addi t0,t0,4	#Pula pros proximos 4 bytes da imagem
		addi t1,t1,4	#Pula pros proximos 4 bytes do display
		
		
		addi t3,t3,4	#Soma 4 ao contador de coluna
		blt t3,t4,PRINT_LINHA	#Se for menor que a largura da imagem, volta pro loop
		
		addi t0,t0,320	#Se não, pula para a proxima linha no bitmap display (soma 320 e subtrai a largura dele)
		sub t0,t0,t4	
		
		mv t3,zero	#Zera o contador de coluna
		addi t2,t2,1	#Soma 1 ao contador de linha
		bgt t5,t2,PRINT_LINHA	#Se a altura da imagem for maior que o contador de linha, volta pro loop
		
		ret		#return
		
