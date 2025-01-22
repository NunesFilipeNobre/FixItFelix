.data
.include "Assets/Sprites/amogus.data"
.include "Assets/Sprites/chao.data"
.include "Assets/Sprites/mapa.data"
CHAR_POS:	.half 0,0			#Posição do personagem
OLD_CHAR_POS:	.half 0,0			#Posição antiga do personagem (no ultimo frame)

.text
SETUP:		
		la s0,mapa			#Carrega endereço .data do mapa
		li s1,0				#Posição x = 0
		li s2,0				#Posição y = 0
		li s3,0				#Frame 0
		jal PRINT			#Função print
		li s3,1				#Frame 1
		jal PRINT			#Mapa gerado nos 2 frames

GAME_LOOP:	jal KEY2			#Função KEY2
		
		xori s4,s4,1			#Troca 0 por 1 e 1 por 0

		la t0,CHAR_POS			#Carrega posição do perosnagem CHAR_POS em t0

		la s0,amogus			#Carrega edereço do .data do amogus
		lh s1,0(t0)			#Posição x = primeiro half do CHAR_POS
		lh s2,2(t0)			#Posição y = segundo half do CHAR_POS
		mv s3,s4			#Frame = s4 (Fica trocando entre frame 0 e 1 por causa do xor acima)
		jal PRINT			#Função print
		
		li t0,0xFF200604		#Endereço do frame a ser mostrado no bitmap display
		sw s4,0(t0)			#Salva 1 ou 0 no frame (troca pra esse frame)
		
		la t0,OLD_CHAR_POS		#Carrega posição antiga do perosnagem OLD_CHAR_POS em t0

		la s0,chao			#Carrega endereço .data do chao
		lh s1,0(t0)			#Posição x = primeiro half do OLD_CHAR_POS
		lh s2,2(t0)			#Posição y = segundo half do OLD_CHAR_POS
		xori s3,s3,1			#Usa o frame oposto
		jal PRINT			#Função print
		
		j GAME_LOOP			#Volta pro inicio loop
		
KEY2:		li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
  	
  		li t0,'a'			
  		beq t2,t0,CHAR_ESQ		#Se 'a' for pressionado vai apra CHAR_ESQ
  		
  		li t0,'d'
  		beq t2,t0,CHAR_DIR		#Se 'd' for pressionado vai apra CHAR_DIR
  		
  		li t0,'w'
  		beq t2,t0,CHAR_CIMA		#Se 'w' for pressionado vai apra CHAR_CIMA
  		
  		li t0,'s'
  		beq t2,t0,CHAR_BAIXO		#Se 's' for pressionado vai apra CHAR_BAIXO
  	
FIM:		ret  				#retorna
 
CHAR_ESQ:	la t0,CHAR_POS			#Carrega endereço da posição do personagem
 		la t1,OLD_CHAR_POS		#Carrega endereço da posição antiga do personagem
 		lw t2,0(t0)			#Carrega os 2 half words da posição atual
 		sw t2,0(t1)			#Coloca os 2 na nova posição antiga
 		
 		lh t1,0(t0)			#Carrega o primeiro half word (x) da posição do personagem atual
 		addi t1,t1,-32			#Diminui ele em 4
 		sh t1,0(t0)			#Atualiza a posição do personagem
 		ret				#Retorna
 		
CHAR_DIR:	la t0,CHAR_POS
 		la t1,OLD_CHAR_POS
 		lw t2,0(t0)
 		sw t2,0(t1)
 		
 		lh t1,0(t0)
 		addi t1,t1,32
 		sh t1,0(t0)
 		ret
 		
CHAR_CIMA:	la t0,CHAR_POS
 		la t1,OLD_CHAR_POS
 		lw t2,0(t0)
 		sw t2,0(t1)
 		
 		lh t1,2(t0)
 		addi t1,t1,-32
 		sh t1,2(t0)
 		ret
 		
CHAR_BAIXO:	la t0,CHAR_POS
 		la t1,OLD_CHAR_POS
 		lw t2,0(t0)
 		sw t2,0(t1)
 		
 		lh t1,2(t0)
 		addi t1,t1,32
 		sh t1,2(t0)
 		ret
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
PRINT:		li t0, 0xFF0		#Inicio do endereço do bitmap display
		add t0,t0,s3		#0xFF0 ou 0xFF1 dependendo do frame s3
		slli t0,t0,20		#Preenche o restante do endereço com zeros (0xFF000000 ou 0xFF100000)
		
		add t0,t0,s1		#Coordenada x da imagem
		
		li t1,320		#Largura da tela
		mul t1,t1,s2		#Largura da tela * y
		add t0,t0,t1		#Endereço no bitmap dislay (x + y * largura da tela)
		
		addi t1,s0,8		#Endereço imagem (Pula os 2 bytes no inicio da imagem)
		
		mv t2,zero		#Zera os contadores de linha
		mv t3,zero
		
		lw t4,0(s0)		#Recebe a largura especificada no arquivo (primeiro byte)
		lw t5,4(s0)		#Receba a altura especificada no arquivo (segundo byte)
		
PRINT_LINHA:	lw t6,0(t1)		#Pega 4 bytes (word) do arquivo da imagem
		sw t6,0(t0)		#Salva 4 bytes (word) no endereço da bitmap display
		
		addi t0,t0,4		#Pula pros proximos 4 bytes da imagem
		addi t1,t1,4		#Pula pros proximos 4 bytes do display
		
		
		addi t3,t3,4		#Soma 4 ao contador de coluna
		blt t3,t4,PRINT_LINHA	#Se for menor que a largura da imagem, volta pro loop
		
		addi t0,t0,320		#Se não, pula para a proxima linha no bitmap display (soma 320 e subtrai a largura dele)
		sub t0,t0,t4	
		
		mv t3,zero		#Zera o contador de coluna
		addi t2,t2,1		#Soma 1 ao contador de linha
		bgt t5,t2,PRINT_LINHA	#Se a altura da imagem for maior que o contador de linha, volta pro loop
		
		ret			#return
		
