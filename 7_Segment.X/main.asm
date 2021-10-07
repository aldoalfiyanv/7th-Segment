STATUS equ 03h ; STATUS merujuk ke alamat memori 03h
PORTA equ 05h ; PORTA merujuk ke alamat memori 05h
PORTB equ 06h ; PORTB merujuk ke alamat memori 06h
PORTC equ 07h ; PORTC merujuk ke alamat memori 07h
PORTE equ 09h ; PORTE merujuk ke alamat memori 07h
TRISA equ 85h ; TRISA merujuk ke alamat memori 85h
TRISB equ 86h ; TRISB merujuk ke alamat memori 86h
TRISC equ 86h ; TRISC merujuk ke alamat memori 87h
TRISE equ 89h ; TRISE merujuk ke alamat memori 89h
ADCON1 equ 9Fh ; ADCON1 merujuk ke alamat memori 9Fh
 
    cblock h'20'
    delay_1
    delay_2
    endc
    
    org 00		; origin register
    clrw		; Clear the working register
    bsf STATUS,5	; ke Bank1
    movlw 0x06		; konfigurasi seluruh PIN
    movwf ADCON1	; sebagai digital inputs
    movlw 0x1F		;
    movwf TRISA		; TRISA bit 4-0 bernilai 1
			; menyebabkan PORTA bit 4-0 menjadi INPUT
    movlw 0x00		;
    movwf TRISB		; TRISB seluruh bitnya diberi nilai 0
			; menyebabkan Seluruh Pin PORTB menjadi OUTPUT
    movlw b'000'	;
    movwf TRISE		; TRISC bit<0-2> bernilai 0 bit<3-7> bernilai 1
			; menyebabkan PORTC bit<0-2> sbg OUTPUT
			; dan PORTC bit<3-7> sbg INPUT
    bcf STATUS,5	; ke Bank0 (karena PORTA dan PORTB ada di Bank0)
    clrf PORTA		; PORTA di-clear
    clrf PORTB		; PORTB di-clear
			;clrf PORTC
    call tampil_0
    
loop
    movlw b'111'	;
    movwf PORTE		; PORTE aktif (menuju keypad kolom 1,2,3)
			; Cek apakah ada salah satu Push Button yang ditekan
    btfsc PORTA,0	; Jika diantara PB baris A ditekan
    call scan_keypad	; maka lakukan proses scanning
    btfsc PORTA,1	; Jika diantara PB baris B ditekan
    call scan_keypad	; maka lakukan proses scanning
    btfsc PORTA,2	; Jika diantara PB baris C ditekan
    call scan_keypad	; maka lakukan proses scanning
    btfsc PORTA,4	; Jika diantara PB baris D ditekan
    call scan_keypad	; maka lakukan proses scanning
    nop			; jika tidak ada yang ditekan maka tidak melakukan proses scanning
    
    goto loop
    
scan_keypad
	    movlw b'000'    ;
	    movwf PORTE	    ; PORTE nonaktif
	    
	    movlw b'001'    ; kolom 1 aktif
	    movwf PORTE
	    btfsc PORTA,0   ; baris A (keypad 1)
	    call tampil_1
	    btfsc PORTA,1   ; baris B (keypad 4)
	    call tampil_4
	    btfsc PORTA,2   ; baris C (keypad 7)
	    call tampil_7
	    btfsc PORTA,4   ; baris D (keypad *)
	    nop

	    movlw b'010'    ; kolom 2 aktif
	    movwf PORTE
	    btfsc PORTA,0   ; baris A (keypad 2)
	    call tampil_2
	    btfsc PORTA,1   ; baris B (keypad 5)
	    call tampil_5
	    btfsc PORTA,2   ; baris C (keypad 8)
	    call tampil_8
	    btfsc PORTA,4   ; baris D (keypad 0)
	    call tampil_0
	    nop

	    movlw b'100'    ; kolom 3 aktif
	    movwf PORTE
	    btfsc PORTA,0   ; baris A (keypad 3)
	    call tampil_3
	    btfsc PORTA,1   ; baris B (keypad 6)
	    call tampil_6
	    btfsc PORTA,2   ; baris C (keypad 9)
	    call tampil_9
	    btfsc PORTA,4   ; baris D (keypad #)
	    nop
	    call delay
	    return
    
tampil_0
	movlw b'00111111'
	movwf PORTB
	return
tampil_1
	movlw b'00000110'
	movwf PORTB
	return
tampil_2
	movlw b'01011011'
	movwf PORTB
	return
tampil_3
	movlw b'01001111'
	movwf PORTB
	return
tampil_4
	movlw b'01100110'
	movwf PORTB
	return
tampil_5
	movlw b'01101101'
	movwf PORTB
	return
tampil_6
	movlw b'01111101'
	movwf PORTB
	return
tampil_7
	movlw b'00000111'
	movwf PORTB
	return
tampil_8
	movlw b'01111111'
	movwf PORTB
	return
tampil_9
	movlw b'01101111'
	movwf PORTB
	return
	
delay
	movlw d'255'	; isi w-reg dengan desimal 255 (nilai maksimal 255)
			; menentukan waktu delay.
	movwf delay_1	; isi memori delay_1 dengan nilai w-reg
	movwf delay_2	; isi memori delay_2 dengan nilai w-reg
delay_loop
	decfsz delay_1, f   ; delay_1 = delay_1 ? 1, jika delay_1 = 0 maka lompat
	    goto delay_loop ; kembali kurangi delay_1
	decfsz delay_2, f   ; delay_2 = delay_2 ? 1, jika delay_2 = 0 maka lompat
	    goto delay_loop ; kembali kurangi delay_2
	return
	
	end