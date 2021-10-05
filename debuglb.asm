 ;
 ; DEBUGGING STUFF
 ;

 .MAC RSAVE
   PHA
   TXA
   PHA
   TYA
   PHA
 .ENDM

 .MAC RREST
   PLA
   TAY
   PLA
   TAX
   PLA
 .ENDM

;
; Debugging strings/messages
;
RMDMSG .BYTE "ROOM=",0
CMDMSG .BYTE "CMD='",0
NVMSG  .BYTE "NV='",0
VMMSG  .BYTE "MATCH='",0

MSGEND .BYTE "'",CR,0

SDMSG  .BYTE "-- START DAEMONS --",CR,0
EDMSG  .BYTE "-- END DAEMONS --",CR,0

;
; Debugging code snippets
;

; Print the verb and noun numbers just typed
DB_CMD
 RSAVE
 PRINT CMDMSG
 LDA VERB
 JSR DPRINT
 LDA NOUN
 JSR DPRINT
 PRINT MSGEND
 RREST
 RTS
;

; Print the room number
DB_ROOMN
 RSAVE
 PRINT RMDMSG
 LDA ROOM
 JSR DPRINT
 JSR CRLF
 RREST
 RTS
;

; Mark start and stop of Daemon checks
DB_STD
 RSAVE
 PRINT SDMSG
 RREST
 RTS
;
DB_EDD
 RSAVE
 PRINT EDMSG
 RREST
 RTS
;

DB_VMAT
 RSAVE
 PRINT VMMSG
 SEC
 LDA INDEX2
 SBC #<SENMAT
 STA VTMP
 LDA INDEX2+1
 SBC #>SENMAT
 STA VTMP+1

 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 
 LDA VTMP+1
 ASL
 ROR VTMP+1
 ROR VTMP 

 LDA VTMP
 JSR DPRINT
 PRINT MSGEND 
 RREST
 RTS

DB_PHEX
 PHA
 LSR
 LSR
 LSR
 LSR
 JSR DB_PNYB
 PLA
 JSR DB_PNYB
 RTS
;
DB_PNYB
 AND #15
 CMP #10
 BCC DB_PDIG
 ADC #6
DB_PDIG
 ADC #$30
 JSR OUTCH
 RTS
 
VTMP
 .WORD 0
;
