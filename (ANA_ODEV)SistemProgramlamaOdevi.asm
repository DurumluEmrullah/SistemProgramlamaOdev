                                 ; multi-segment executable file template.

data segment   
    
    hataliSecimMesaji db "Hatali secim yaptiniz$"  

  
    
    ilkString db "Lutfen dili seciniz/ Please select language$" 
    dil db "1 - Turkce$"
    dil2 db "2 - English$"
    turkceMenu1 db "1 - Sayi -> yazi :$"
    turkceMenu2 db "2 - Yazi -> sayi :$"
    turkceMenu3 db "3-Yazi ile islem:$"
    turkceMenu3_1 db "1-Toplama$"
    turkceMenu3_2 db "2-Cikarma$"
    
    
    ingilizceMenu1 db "1 - Number -> text :$"
    ingilizceMenu2 db "2 - Text -> Number :$"
    ingilizceMenu3 db "3 - Operation with text:$"
    ingilizceMenu3_1 db "1-Addition$"
    ingilizceMenu3_2 db "2-Subtraction$"

	   
    islemMesaji1 db "Lutfen yaziya cevrilecek sayiyi giriniz. (Max trilyona kadar, trilyon dahi)$"	    
    islemMesaji2 db "Lutfen sayiya cevirilecek yazi karsiligini giriniz (Max trilyona kadar, trilyon dahil)$"  
    
    islemMesaji1Eng db "Please enter the number to be translated to the text. (Up to max trillion, even trillion)$"
      

    birler   db  "bir$","iki$","uc$","dort$","bes$","alti$","yedi$","sekiz$","dokuz$"
    onlar    db  "on$","yirmi$","otuz$","kirk$","elli$","altmis$","yetmis$","seksen$","doksan$"
    yuzler   db  "yuz$","iki yuz$","uc yuz$","dort yuz$","bes yuz$","alti yuz$","yedi yuz$","sekiz yuz$","dokuz yuz$" 
    buyukler db  "trilyon$","milyar$","milyon$","bin$"           
    
    
    ingilizceBirler   db  "one$","two$","three$","four$","five$","six$","seven$","eight$","nine$"
    ingilizceOnlar    db  "twenty$","thirty$","forty$","fifty$","sixty$","seventy$","eighty$","ninety$" 
    ingilizceOnlar2   db  "ten$","eleven$","twelve$","thirteen$","fourteen$","fifteen$","sixteen$","seventeen$","eigteen$","nineteen$"
    ingilizceYuzler   db  "one hundred$","two hundred$","three hundred$","four hundred$","five hundred$","six hundred$","seven hundred$","eight hundred$","nine hundred$" 
    ingilizceBuyukler db  "trillion$","billion$","million$","thousand$" 
     
    
    stringCevap db "Cevap: $"
    stringCevapEng db "Answer: $"    
    basamakSayisi dw ?
    toplamBasamakSayisi dw ?
    konum dw ? 
    konumOnlar dw ?  
    konumYuzler dw ? 
    konumOnlarEng dw ? 
    dilTercihi db ?
    rakamDegeri db ?          
    
    flag db 0
     
   ;operand1 db ?  
   
   operand1 db 150 dup(32)
   operand2 db 150 dup(32)
     
ends

stack segment   
 
    dw   128  dup(0)
ends

code segment
start:    

    mov ax, data
    mov ds, ax
    mov es, ax
  
    jmp atla_fonksiyon    
    
    sayiYazdir proc
        mov ah,09   ; bu fonksiyonun amaci programin birinci kisminda yaziya cevrilen sayilarin yazi karsiliklarini 21h k�t�phanesinin string yazma komutu olan 09 ile  yazdirmak i�in kullanilmistir
        lea dx,di   ; fonksiyon �agrildigi yerin bir satir �ncesinde g�nderilcek olan degisken di ye atilmistir bu sekilde fonksiyona deger g�nderme islemi ger�eklestirilecektir
        int 21h
        
        mov ah,02
        mov dl,32  ; sayilar arasinda bir bosluk birakmak i�in 21h,02 nolu karakter yazdirma fonksiyonu kullanilmistir
        int 21h
        ret
    sayiYazdir endp    
     
    degeriKontrolEt proc 	
        
        cmp dilTercihi,'2'
        jz _eng
        cmp dilTercihi,'1'
        jz _tur
        
        
        _eng:
    	cmp cx,15
    	jz __15
    	cmp cx,14
    	jz __14
    	cmp cx,13
    	jz __13
    	cmp cx,12
    	jz __12
    	cmp cx,11
    	jz __11
    	cmp cx,10		; Basamak sayisini kontrol etme islemi
    	jz __10
    	cmp cx,9
    	jz __9
    	cmp cx,8
    	jz __8
    	cmp cx,7
    	jz __7
    	cmp cx,6
    	jz __6
    	cmp cx,5
    	jz __5
    	cmp cx,4
    	jz __4
    	cmp cx,3
    	jz __3
    	cmp cx,2
    	jz __2
    	cmp cx,1
    	jz __1
                                             ; sayaiya bak fonksiyonunda g�ndermis oldugum degerler bu noktada kullanilacak (konum,konumOnlar, konumY�zler)
    
    	__15:
    	    mov di,offset ingilizceYuzler  ; ingilizceYuzler dizisini baslangi� adresi di ye kayit ediliyor
        	add di,konumYuzler           ; basamaklar kendini 3 basamakta bir tekrarladigi i�in burada konum y�zler degiskenini kullandim ve sayiya bak fonksiyonunda g�nderilen konuma g�re yuzler dizisinin ilgili string i yazilmistir  
        	call sayiYazdir             ; sayi yazdirma fonksiyonu fonksiyonu di nin i�indegi stringi ekrana yazdirir
        jmp __son
    	__14:    
    	
        cmp rakamDegeri,1       ; burda rakam degerine bakiyoruz eger rakam degeri birden farkli ise sayiya bak fonksiyonunda g�ndermis oldugum konumOnlar ile ilgili konumu yazdiriyorum
        jz _1_
            mov di, offset ingilizceOnlar
            add di,konumOnlar
            call sayiYazdir
            jmp _flagAtla
        _1_:                ;Eger rakam degeri bir ise 11,12,13,....,19 gibi rakamlardir demkki
            mov flag,1      ; Bu noktada sadece tuttugum flag i set ettim ve yazi yazdirma isini bir alttaki basamaga biraktim 
            _flagAtla:
        
    	jmp __son   
    	
    	__13:            
    	   cmp flag,1        ;Eger Flag degeri bir ise bu sayinin 11,12,13,....,19 gibi bir sayi oldugunu g�stermektedir 
    	   jz _13flag1
    	     
    	     mov di,offset ingilizceBirler   
    	     add di,konum    ; Eger flag 0 ise normal islemler devam edicek sayiyaBak da g�ndermis oldugum konuma g�re birler dizisinin ilgili elemaninin baslangic adresine konumlanicak ve yazdiricak
    	     call sayiYazdir
    	       
    	     jmp _13flaggec  
    	   _13flag1: 
            mov di,offset ingilizceOnlar2
            add di,konumOnlarEng         ; Flag =1 ise bu kisimdaki kodlar �alisacak ve birler basamaginin degerine g�re g�nderilmis olan konumun isaret ettigi dizi elemani yazdirilacak 
            mov flag,0
            call sayiYazdir
    	    
    	    _13flaggec:
    	    lea di,ingilizceBuyukler   ; trillion lar basamaginin birler basamagina ulastigimiz i�in burada trillion etiketi yazilacak sayi yazdir fonksiyonu vasitasiyla 
    	    call sayiYazdir
        jmp __son                        
        
                                    ; ----------  Bu noktadan sonra basamk degeri%3 � esit olan  basamaklarda ayni islemler tekrarlanmistir -------------------------
    	__12:
            mov di,offset ingilizceYuzler
        	add di,konumYuzler         ;Sayiya bak fonksiyonunda g�nderilmis olan konum ile g�sterilen dizi elemanini yazdirir 
        	call sayiYazdir
        jmp __son
    	__11:
     
        cmp rakamDegeri,1
        jz _11_
            mov di, offset ingilizceOnlar
            add di,konumOnlar
            call sayiYazdir
            jmp _11flagAtla
        _11_:
            mov flag,1              ; Yukarida bahsettigim 11,12,13,....,19 a okadar olan �zel durum i�in
            _11flagAtla:
        
    	jmp __son     
    	
    	__10:  
    	
    	   cmp flag,1               ; Yukarida bahsettigim 11,12,13,....,19 a okadar olan �zel durum i�in
    	   jz _10flag1
    	     
    	     mov di,offset ingilizceBirler                         
    	     add di,konum
    	     call sayiYazdir
    	       
    	     jmp _10flaggec  
    	   _10flag1: 
            mov di,offset ingilizceOnlar2    
            add di,konumOnlarEng  
            mov flag,0
            call sayiYazdir
    	    
    	    _10flaggec:
    	    lea di,ingilizceBuyukler
    	    add di,9
    	    call sayiYazdir
        jmp __son
    	
    	__9:
            mov di,offset ingilizceYuzler
        	add di,konumYuzler
        	call sayiYazdir
        jmp __son
    	__8:
     
        cmp rakamDegeri,1
        jz _8_
            mov di, offset ingilizceOnlar
            add di,konumOnlar
            call sayiYazdir
            jmp _8flagAtla
        _8_:
            mov flag,1   
            _8flagAtla:
        
    	jmp __son     
    	
    	__7:
    	   cmp flag,1
    	   jz _7flag1
    	     
    	     mov di,offset ingilizceBirler
    	     add di,konum
    	     call sayiYazdir
    	       
    	     jmp _7flaggec  
    	   _7flag1: 
            mov di,offset ingilizceOnlar2
            add di,konumOnlarEng  
            mov flag,0
            call sayiYazdir
    	    
    	    _7flaggec:
    	    lea di,ingilizceBuyukler
    	    add di,17
    	    call sayiYazdir
        jmp __son
    	__6:
            mov di,offset ingilizceYuzler
        	add di,konumYuzler
        	call sayiYazdir
        jmp __son
    	__5:
        cmp rakamDegeri,1
        jz _5_
            mov di, offset ingilizceOnlar
            add di,konumOnlar
            call sayiYazdir
            jmp _5flagAtla
        _5_:
            mov flag,1   
            _5flagAtla:
        
    	jmp __son    
    	
    	__4:         
    	   cmp flag,1
    	   jz _4flag1
    	     
    	     mov di,offset ingilizceBirler
    	     add di,konum
    	     call sayiYazdir
    	       
    	     jmp _4flaggec  
    	   _4flag1: 
            mov di,offset ingilizceOnlar2
            add di,konumOnlarEng  
            mov flag,0
            call sayiYazdir
    	    
    	    _4flaggec:
    	    lea di,ingilizceBuyukler
    	    add di,25
    	    call sayiYazdir
        jmp __son
    	__3:
            mov di,offset ingilizceYuzler
        	add di,konumYuzler
        	call sayiYazdir
        jmp __son
    	__2:
        cmp rakamDegeri,1
        jz _2_
            mov di, offset ingilizceOnlar
            add di,konumOnlar
            call sayiYazdir
            jmp _2flagAtla
        _2_:
            mov flag,1   
            _2flagAtla:
        
    	jmp __son    
    	
    	__1:
    	   cmp flag,1
    	   jz _1flag1
    	     
    	     mov di,offset ingilizceBirler
    	     add di,konum
    	     call sayiYazdir
    	       
    	     jmp _1flaggec  
    	   _1flag1: 
            mov di,offset ingilizceOnlar2
            add di,konumOnlarEng  
            mov flag,0
            call sayiYazdir
    	    
    	    _1flaggec:

        jmp __son
    	
    	
        _tur: 
        cmp cx,15
    	jz ___15
    	cmp cx,14
    	jz ___14
    	cmp cx,13
    	jz ___13
    	cmp cx,12
    	jz ___12
    	cmp cx,11
    	jz ___11
    	cmp cx,10
    	jz ___10
    	cmp cx,9
    	jz ___9
    	cmp cx,8
    	jz ___8
    	cmp cx,7
    	jz ___7
    	cmp cx,6
    	jz ___6
    	cmp cx,5
    	jz ___5
    	cmp cx,4
    	jz ___4
    	cmp cx,3
    	jz ___3
    	cmp cx,2
    	jz ___2
    	cmp cx,1
    	jz ___1
                             ; sayaiya bak fonksiyonunda g�ndermis oldugum degerler bu noktada kullanilacak (konum,konumOnlar, konumY�zler)
    
    	___15:
	    mov di,offset yuzler
    	add di,konumYuzler    ; basamaklar kendini 3 basamakta bir tekrarladigi i�in burada konum y�zler degiskenini kullandim ve sayiya bak fonksiyonunda g�nderilen konuma g�re yuzler dizisinin ilgili string i yazilmistir  
    	call sayiYazdir     ; sayi yazdirma fonksiyonu fonksiyonu di nin i�indegi stringi ekrana yazdirir
        jmp __son
    	___14:
    	mov di,offset onlar
    	add di,konumOnlar    ; onlar dizisinin ilgili koumundaki elemani ekrana yazmaya hazir hale getirmek
    	call sayiYazdir
    	jmp __son
    	___13:
    	mov di,offset birler
    	add di,konum
    	call sayiYazdir
    	
    	lea di,buyukler    ; Bu noktada basmk sayisi%3 = 1 durumunda basamagin alms oldugu �zel adi yazdirmak i�in di ye buyukler dizisi atiliyor ve suan trilyon basamaginda oldugumuz i�in herhangi bir ekleme �ikarma yapilmiyor , ilk eleman olan trilyon yaziliyor
    	call sayiYazdir
        jmp __son
    	___12:
    	mov di,offset yuzler
    	add di,konumYuzler
    	call sayiYazdir
    	___11:
    	mov di,offset onlar
    	add di,konumOnlar
    	call sayiYazdir
    	jmp __son
    	___10:
    	mov di,offset birler
    	add di,konum
    	call sayiYazdir
    	
    	lea di,buyukler
    	add di,8            ; burada di +8 eklememizin nedeni dizinin bir sonraki stringi olan milyarin baslama adresine ulasmak i�indir
    	call sayiYazdir
        jmp __son
    	___9:
    	mov di,offset yuzler
    	add di,konumYuzler
    	call sayiYazdir
        jmp __son
    	___8:
    	mov di,offset onlar
    	add di,konumOnlar
    	call sayiYazdir
    	jmp __son
    	___7:
    	mov di,offset birler
    	add di,konum
    	call sayiYazdir
    	
    	lea di, buyukler
    	add di,15         ; milyonun baslama adresine ulasmak i�in
    	call sayiYazdir
        jmp __son
    	___6:
    	mov di,offset yuzler
    	add di,konumYuzler
    	call sayiYazdir
        jmp __son
    	___5:
    	mov di,offset onlar
    	add di,konumOnlar
    	call sayiYazdir
    	jmp __son
    	___4:         

        cmp konum,0                      ; ----- Buradaki islemler -------
        jz __rakamDegeri1                ; burada yaptigim islemlerin amaci bin sayisi ni girdi olarak verince bir bin diye �ikti vermesin diye
        jmp _birDegil                    ; O sorunu ��zd�m ama s�yle bir sikinti oldu bu seferde eger binler basamaginda vr kendi kapsama alanindaki onlar ve y�zler basamagi (onbinler ve y�zbinler) in %10 u = 0 ise sayi yi yazar iken bin yazmiyor  
        __rakamDegeri1:
        cmp toplamBasamakSayisi,4        ; Bu sorunu ��zmeye �alistim ama bi t�rl� yapamadim, ��z�mlerim de iki sonuca ulastim ikiside hatali bir hata 1000 girdisi verdigimde bir bin olarak yaziyordu , �b�r hata da bahsetmis oldugum hata
        jz _dortBasamakli
        _birDegil:
    	mov di,offset birler
    	add di,konum
    	call sayiYazdir
        _dortBasamakli:
    	
    	lea di, buyukler      
    	add di,22             ; bin ' in baslama adresine ulasmak 
    	call sayiYazdir
    	jmp __son
    	___3:
    	mov di,offset yuzler
    	add di,konumYuzler
    	call sayiYazdir
        jmp __son
    	___2:
    	mov di,offset onlar
    	add di,konumOnlar
    	call sayiYazdir
    	jmp __son
    	___1:
    	mov di,offset birler
    	add di,konum
    	call sayiYazdir
    	jmp __son
          
        
          
    	__son:	
    	
       RET
    degeriKontrolEt endp 	
    
    
    sayiyaBak proc 
        mov bx ,offset operand1    ; operand1 in baslangi� adresi bx registerine ataniyor , Bunun amaci operandin i�inde tutulan sayinin basamaklarini gezebilmektir
        mov cx,basamakSayisi     ; basamak sayisi sayi klavyeden girlirken sayilmistir ve bu degiskene saklanmistir. Burda da d�ng� degiskeni olarak kullandim . Bu sayede karakterler  yaiya konvert edilirken basamk degerlerinin ne oldugunu bilmis olacagim  
       
        basamakDegerleriniKontrolEt: 
        mov dx,[bx]   ;operand1 in adresinin tutuldugu bx registerinin g�sterdigi adresteki degeri dx registerine atiyorum bu sayede hemen alt satirlarda bu degerlerin ne oldugunu kontrol edebilecegiz 
        
        cmp dilTercihi,'1'   ; burada dil tercihinin atanmis oldugu degisken in i�indeki deger kontrol ediliyor dil tercihine g�re fonksiyondaki islem g�recegi yere program dallanicak
        jz __tur
        cmp dilTercihi,'2'
        jz __eng
        
        __tur:
        cmp dl,'0'        ;
        jz _0   
        cmp dl,'1'         ;
        jz _1                       
        cmp dl,'2'         ;
        jz _2
        cmp dl,'3'        ;
        jz _3
        cmp dl,'4'        ;  Basamak degerlerinin ne oldugu kontrol ediliyor
        jz _4
        cmp dl,'5'        ;
        jz _5
        cmp dl,'6'        ;
        jz _6             
        cmp dl,'7'        ;
        jz _7
        cmp dl,'8'        ;
        jz _8
        cmp dl,'9'         ;
        jz _9
        _0:                 ;
        
    
         jmp _son
        _1:   
       
        mov konumYuzler,0    ;Eger degeri 1 ise y�zler fonksiyonunun 0 konumundaki olan degeri degeri kontrol et fonksiyonuna yollayacagiz bu sekilde eger basamak sayisi 3 ve katiysa bu noktalarda  sayinin basamak degeri bu degikenin g�stermis oldugu deger sayesinde yazilabilecek 
    	mov konum,0          ; bu degiskende birler basamaginin konumlarini tutuyor bu nun sayesiinde degeriKontrolEt fonksiyonunda birler basamak sayisi birler basamagina denk gelen yerde ise birlik degerini yazdiriyoruz    
    	mov konumOnlar,0     ;bu degisken ise onlar basamaginin konumunun 1 oldugu yeri tutuyor
    	call degeriKontrolEt ;Bu fonksiyon basamak sayisina g�re hemen ust satirlarinda g�nderilmis olan konumlara g�re islem yapiyor ve basamk sayisi hangi konumlari kullanmasi gerektiriyorsa onlari kullaniyor fonksiyonun i�inde
            		    
        jmp _son
        _2:              
        mov konumYuzler,4   ;
    	mov konum,4             ; Basamak degeri 2 olan sayi i�in islemler
    	mov konumOnlar,3        ;
    	call degeriKontrolEt     ;
         
        jmp _son
        _3:              
        mov konumYuzler,12
    	mov konum,8             ;Basamak degeri 3 olan sayi i�in islemler
    	mov konumOnlar,9
    	call degeriKontrolEt
    	
        jmp _son
        _4:               
        mov konumYuzler,19
    	mov konum,11            ;Basamak degeri 4 olan sayi i�in islemler
    	mov konumOnlar,14
    	call degeriKontrolEt
        jmp _son
        _5:               
        mov konumYuzler,28
    	mov konum,16            ;Basamak degeri 5 olan sayi i�in islemler
    	mov konumOnlar,19
    	call degeriKontrolEt
        jmp _son
        _6:               
        mov konumYuzler,36
    	mov konum,20            ;Basamak degeri 6 olan sayi i�in islemler
    	mov konumOnlar,24
    	call degeriKontrolEt
        jmp _son
        _7:               
        mov konumYuzler,45
    	mov konum,25           ;Basamak degeri 7 olan sayi i�in islemler
    	mov konumOnlar,31
    	call degeriKontrolEt
        jmp _son
        _8:               
        mov konumYuzler,54
    	mov konum,30           ;Basamak degeri 8 olan sayi i�in islemler
    	mov konumOnlar,38
    	call degeriKontrolEt
        jmp _son
        _9:               
        mov konumYuzler,64
        mov konum,36
    	mov konumOnlar,45     ;Basamak degeri 9 olan sayi i�in islemler
    	call degeriKontrolEt 
    	jmp _son
    	
    	__eng:          ;bu noktada ise dil se�imi ingilizce ise yukaridaki islemlerin aynisi az bisey farkla yapiyor 
    	                ; bu fark ise ingilizcede ondan yirmiye kadar olan sayilarin bizim dilimizdekine g�re farkli sekilde adlandirilmasindan dolayidir
    	cmp dl,'0'
        jz _eng0   
        cmp dl,'1'
        jz _eng1
        cmp dl,'2'
        jz _eng2
        cmp dl,'3'
        jz _eng3
        cmp dl,'4'
        jz _eng4
        cmp dl,'5'
        jz _eng5
        cmp dl,'6'
        jz _eng6
        cmp dl,'7'
        jz _eng7
        cmp dl,'8'
        jz _eng8
        cmp dl,'9'
        jz _eng9
        _eng0: 
         mov rakamDegeri,0    ; rakamDegeri degiskeni onlar basamagindaki degeri degerikontrolEt fonksiyonu i�inde kontrol etmek i�in dir  . 
         mov konumOnlarEng,0   ; flag =1 ve basamak degeri = birler ise "ten" yazdirmak i�in , (Bu degiskenin kullanilis amaci hemen alt satirdaki a�iklamada daha net anlatilmistir) 
    
         jmp _son
        _eng1:            
        mov rakamDegeri,1       ; Eger rakam degeri bir ve bu sayi onlar basamagi ve t�revlerinde ise onlar basamaginda bir tane flag tuttum bu flag set edilcek ve herhangi bir yazi yazma islemi ger�eklesmeyecek ,Sayilari buyuk basamaktan k��ege kontrol ettigim i�in hemen pesindeki birler basamagina gelince bu flagin degeri kontrol edilecek ve flag set edilmis ise (flag =1) ise konumOnlarEng dizisindeki ilgili konumdaki string yazdirilacak ekrrana
        mov konumOnlarEng,4     ; Bu degiskende eger flag =1 ve basamak degeri = birler ise "eleven"   yazdirmak i�in
        mov konumYuzler,0       ; T�rkce islemlerdeki ile ayni g�revde kullanildi. Yuzler basamagi ve t�revlerinde ise bu konumdan baslayan string yazilacak 
    	mov konum,0             ; Birler basamagi konumu 
    	call degeriKontrolEt    ; basamak degeri kontrol� i�in fonksiyona yollaniyor
            		    
        jmp _son
        _eng2:           
        mov rakamDegeri,2        ; Burada rakam degerini her rakamda g�ndermemin nedeni eger �st basamklardan birinde rakam degeri 1 e ayarlanmis ise programda hata olmasinin �ng�ne ge�mek i�in
        mov konumOnlarEng,11   ; flag =1 ve basamak degeri bireler ise "twelve"
        mov konumYuzler,12
    	mov konum,4
    	mov konumOnlar,0
    	call degeriKontrolEt
         
        jmp _son
        _eng3:           
        mov rakamDegeri,3
        mov konumOnlarEng,18    ; flag =1 ve birler ise thirteen
        mov konumYuzler,24
    	mov konum,8
    	mov konumOnlar,7
    	call degeriKontrolEt
    	
        jmp _son
        _eng4:           
        mov rakamDegeri,4
        mov konumOnlarEng,27   ; fourteen  
        mov konumYuzler,38
    	mov konum,14
    	mov konumOnlar,14
    	call degeriKontrolEt
        jmp _son
        _eng5:           
        mov rakamDegeri,5    
        mov konumOnlarEng,36    ;fifteen
        mov konumYuzler,51
    	mov konum,19
    	mov konumOnlar,20
    	call degeriKontrolEt
        jmp _son
        _eng6:           
        mov rakamDegeri,6
        mov konumOnlarEng,44    ;sixteen
        mov konumYuzler,64
    	mov konum,24
    	mov konumOnlar,26
    	call degeriKontrolEt
        jmp _son
        _eng7:           
        mov rakamDegeri,7    
        mov konumOnlarEng,52    ;Seventeen
        mov konumYuzler,76
    	mov konum,28
    	mov konumOnlar,32
    	call degeriKontrolEt
        jmp _son
        _eng8:           
        mov rakamDegeri,8
        mov konumOnlarEng,62   ;eighteen 
        mov konumYuzler,90
    	mov konum,34
    	mov konumOnlar,40
    	call degeriKontrolEt
        jmp _son
        _eng9:           
        mov rakamDegeri,9
        mov konumOnlarEng,70  ;nineteen  
        mov konumYuzler,104
        mov konum,40
    	mov konumOnlar,47
    	call degeriKontrolEt 
    	jmp _son
    	
    	
        _son:
        
    
        inc bx
        LOOP basamakDegerleriniKontrolEt     ; bir alt basamaga ge�is ve islemlerin tekrari
            
        ret  
    sayiyaBak endp
        
    
    
    
    yazdir proc
              
        mov ah,02
        mov dl,13		; Bu satir g�rsel a�idan iyi g�r�nmesi i��in yazilmistir (\r karakteri ekrana basilir)
        int 21h
    
        mov ah,09		; Yazdirma fonksiyonu di in vasitasiyla g�nderilen stringi 21 h k�t�phanesinin 09 nolu string yazdirma fonksiyonu ile yazdirdim
        lea dx,di	
        int 21h
        
        mov ah,02
        mov dl,10		; Bu satir g�rsel a�idan iyi g�r�nmesi i��in yazilmistir (\n karakteri ekrana basilir)
        int 21h
        
        mov ah,02
        mov dl,13		; Bu satir g�rsel a�idan iyi g�r�nmesi i��in yazilmistir (\r karakteri ekrana basilir)
        int 21h
    
        ret
    yazdir endp 
    
    degerAl proc    ;Bu fonksiyonun amaci islem birde girilecek olan sayinin degerini okumaktir 
       
        deger: 
   
        mov ah,01		; 21h k�t�phanesinin 01 nolu karakter okuma fonksiyonuyla girilen deger okunmustur
        int 21h
        
         
        cmp al,13		; Girilen karakterin  \r(Enter) ye esit olup olmadigi kontrol edilir eger esit ise karakter alma bitmistir
        jz degerAlmaBitti
       
             
        mov [si],al		; okunan degeri si de baslangi� adresi tutulan karaktere yazma islemi
        inc si 			; bir sonraki basamaga ge�mek i�in  si ; bir arttirilir. 
        inc basamakSayisi     ; Girilen karkaterin bsamak sayisini karakteri yaziya d�n�st�r�rken rahat olsun diye okur iken kaydettim 
        jmp deger
        degerAlmaBitti:
         
        mov ah,02
        mov dl,10              ; Bir alt satira ge�irmek i�in (\n karakteri) yazildi . (Programi g�rsel a�idan biraz daha iyi hale getirebilmek i�in)
        int 21h    
        
      
        ret    
    degerAl endp      
    

    atla_fonksiyon: 
    
    
    jmp gec
    hata:                        ; menulerde hatali bir se�im yapilirsa bu dallanma komutu ile program bu kisma dallanicak ve hata mesajini yazdircak 
    lea di,hataliSecimMesaji     ; di, ye hata mesajinin baslangi� adresini y�kl�yoruz bunun amaci yazdir fonksiyonuna deger g�nderebilmek i�in 
    call yazdir
    gec:    

     
    lea di,ilkString    ; yazdir fonksiyonuna ilk programin dil se�imini barindiran bu stringin baslangi� adresini di araciligi ile yolluyoruz 
    call yazdir
    
    lea di ,dil     ; dil (T�rkce )
    call yazdir
    
    lea di, dil2   ;(ingilizce )
    call yazdir     
    

    mov ah,01    ; burada kullanicinin dil se�imini 21h k�t�phanesinin 01 numarali karakter okuma komutu ile aliyoruz 
    int 21h
    
    
    mov dilTercihi,al ; se�ilen dili dil tercihi degiskenine atiyoruz bunun amaci fonksiyonlarin i�indede dile g�re dallanma ger�eklesecegi i�in bir sabitte dil tercihini program boyunca tutup ihtiya� durumunda kullanmak
    cmp al,'1'   ; dil tercihi t�rk�e mi ?
    jz turkceMenu  ; eger turkce ise bu dallanma komutu ile t�rkce islemlerin ger�eklescegi yere dallanilacak
    cmp al,'2'     ; dil tercihi ingilizcemi ?
    jz ingilizceMenu 
    jmp hata
    
    turkceMenu:
        mov ah,02
        mov dl,10    ;bu komut sadece bir satir(iki tane pes pese oldugu i�in totalde iki satir) assagi inmek i�in (g�rsel a�idan programin menusunu g�zellestirmek i�in)
        int 21h  
        
        mov ah,02
        mov dl,10
        int 21h
    
        jmp gec1    ; bu dallanma komutu ile hatali se�im durumunda yapilacak olan islemleri atliyoruz  
        hataliIslem: ; bu etiket sayesinde programi hatali bir giris olmasina karsi g�sterilecek mesajin oldugu yere dallandiriyoruz ve ardindan tercihi yeniden aliyoruz
        lea di,hataliSecimMesaji    
        call yazdir                 ; hata mesaji yaz
        gec1:
        lea di,turkceMenu1
        call yazdir        ; ilk islemi yazdir
        
        lea di,turkceMenu2
        call yazdir       ; ikinci islemi yazdr
        
        lea di,turkceMenu3
        call yazdir        ; ���nc� islemi yazdir
        
        mov ah,01
        int 21h       ; islem tercihini al
          
        cmp al,'1'        ;
        jz islem1         ;
        cmp al,'2'        ;  Hangi islem se�ildi kontrol et
        jz islem2         ;
        cmp al,'3'        ;
        jz islem3
        jmp hataliIslem
        
        islem1:   
            
            mov ah,02
            mov dl,10
            int 21h   
            
            mov ah,02
            mov dl,10
            int 21h
            
            lea di,islemMesaji1
            call yazdir
            
            mov cx,0 
            lea si,operand1    ; operand1 degiskeninin baslangi� adresini si ye y�kl�yoruz , Bunun amaci degerAl fonksiyonunda alinan degerin yazilacagi degiskeni yollamak
            call degerAl   
            
            mov ah,09
            lea dx,stringCevap  ; Taslakta olan "Cevap :" yaisini ekrana basmak i�in 
            int 21h
             
            mov bx,basamakSayisi
            mov toplamBasamakSayisi,bx 
            call sayiyaBak              ;
            
         -
          
    
        ;isler
        jmp bitti
        islem2:    
        
        lea di,islemMesaji2
        call yazdir     
        
     
        
        
        
        jmp bitti
        islem3:      
        mov ah,02
        mov dl,10
        int 21h
        
        mov ah,02
        mov dl,10
        int 21h
        
        lea di,turkceMenu3_1
        call yazdir
        
        lea di,turkceMenu3_2
        call yazdir
        
     
        
        mov ah,01
        int 21h
        
    jmp bitti
    
    ingilizceMenu: 
    
    mov ah,02
    mov dl,10
    int 21h
    
    mov ah,02
    mov dl,10
    int 21h
    
    jmp go
    error:
    lea di,hataliSecimMesaji
    call yazdir
    go:
    lea di,ingilizceMenu1
    call yazdir
    
    lea di,ingilizceMenu2
    call yazdir
    
    lea di,ingilizceMenu3
    call yazdir   
    
    mov ah,01
    int 21h
    
    cmp al,'1'
    jz operation1
    cmp al,'2'
    jz operation2
    cmp al,'3'
    jz operation3 
    jmp error
    
    operation1: 
            mov ah,02
            mov dl,10
            int 21h   
            
            mov ah,02
            mov dl,10
            int 21h
            
            lea di,islemMesaji1Eng
            call yazdir
            
            mov cx,0 
            lea si,operand1
            call degerAl   
            
            mov ah,09
            lea dx,stringCevapEng
            int 21h
             
            mov bx,basamakSayisi
            mov toplamBasamakSayisi,bx 
            call sayiyaBak   
            
    jmp bitti
    operation2:
    jmp bitti
    operation3:
    
    lea di,ingilizceMenu3_1
    call yazdir  
    
    lea di,ingilizceMenu3_2
    call yazdir  
    

    mov ah,01
    int 21h
    
    bitti:
    
ends

end start ; set entry point and stop the assembler.