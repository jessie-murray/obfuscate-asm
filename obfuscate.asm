segment .text
global obfuscate, unobfuscate
extern printf
;--------------------------------
;   Exports are obfuscate(char*, int) and unobfuscate(char*, int)
;--------------------------------


; obfuscate(char*, int)
obfuscate:
   enter 0,0


   ;push ebp
   ;mov ebp, esp

   mov eax, [ebp+8] ; arg into EAX
   ; -- EAX = array addr
   mov ebx, [ebp+12] ; arg into EBX
   ; -- EBX = array size



   ;push eax
   ;;-----------
   ;push DWORD ebx
   ;push eax
   ;push chain
   ;call printf
   ;;-----------
   ;pop eax


   ;mov [EAX], BYTE '0'
   ;mov ebx, 3
   mov ecx, 0; -- ecx is index into array
   push eax;   -- save array addr
   mov edi, 0; -- load pass into edi
   xor edi, edi
   mainloop:
      mov dl, BYTE [eax]; current byte into 'dl'

      ;-------------------------
      push ecx
      add dl, 0x7F
      add dl, cl
      sub dl, password_len
      add dl, bh
      xor dl, bl
      ror dl, 5
      pop ecx
      ;-------------------------

      ;-------------------------
      rol dl, cl   ; number of rol = index%256
      ;-------------------------

      ;-------------------------
      xor dl, cl
      ;-------------------------

      ;-------------------------
      ror dl, cl   ; number of ror = index%256
      ;-------------------------

      ;-------------------------
      push ecx;   -- save counter to use cl

      mov cl, BYTE[edi+password]

      xor dl, cl
      rol dl, cl

         ;-- dl = processed byte
         ;-- edi points to current byte in password
      inc edi

      cmp edi, password_len
      jne cont_encoding    ; -- still in password
      xor edi, edi   ; -- or loop back

      cont_encoding:

      pop ecx;   -- current counter
      ;-------------------------


      ;-------------------------
      mov [eax], dl   ; put 'dl' back

      ;-------------------------

      inc eax   ;   next input byte
      inc ecx   ;   update index

      dec ebx ;   number of remaining loops
      cmp ebx, 0;   loop
      jne mainloop
   pop eax



   leave
   ret

; unobfuscate(char*, int)
unobfuscate:
   enter 0,0


   ;push ebp
   ;mov ebp, esp

   mov eax, [ebp+8] ; arg into EAX
   ; -- EAX = array addr
   mov ebx, [ebp+12] ; arg into EBX
   ; -- EBX = array size

   ;push eax
   ;;-----------
   ;push DWORD ebx
   ;push eax
   ;push chain
   ;call printf
   ;;-----------
   ;pop eax


   ;mov ebx, 3
   mov ecx, 0; -- index into array
   push eax
   mov edi, 0; -- load password byte into edi
   unloop:
      mov dl, BYTE [eax]; current byte into 'dl'



      ;-------------------------
      push ecx;   -- again save counter to use cl

      mov cl, BYTE[edi+password]

      ror dl, cl
      xor dl, cl
         ;-- dl = byte to be processed
         ;-- edi points to cur byte in password
      inc edi

      cmp edi, password_len
      jne next_decode    ; -- still in password
      xor edi, edi   ; -- or loop back

      next_decode:

      pop ecx;   -- current counter
      ;-------------------------


      ;-------------------------
      rol dl, cl   ; number of rol = index%256
      ;-------------------------

      ;-------------------------
      xor dl, cl
      ;-------------------------

      ;-------------------------
      ror dl, cl   ; number of ror = index%256
      ;-------------------------


      ;-------------------------
      push ecx
      rol dl, 5
      xor dl, bl
      sub dl, bh
      add dl, password_len
      sub dl, cl
      sub dl, 0x7F
      pop ecx
      ;-------------------------

      ;-------------------------
      mov [eax], dl   ; 'dl' back into array
      ;-------------------------

      inc eax   ;   next input byte
      inc ecx   ;   counter++

      dec ebx ;   dec. number of remaining loops
      cmp ebx, 0;   loop
      jne unloop
   pop eax



   leave
   ret





segment .data
   chain db 'eax=0x%08x, ebx=0x%08x',13,10,0
   password db '�(6#�v����My&=�6�C�Y%�<N�J��w�M�c�����v�����O>A7�TNd�K��S�G�(���QwD5u����z�mT�'
   password_len equ 80; $$ - 80 seems to work here


