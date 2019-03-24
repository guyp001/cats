TITLE CATS
; Copyright 1986 by William C. Parke
;
; find buffer structure (functions 4E, 4F)
; DB 21 DUP(?) ; reserved
; DB ? ; attribute at +15H +21
; DW ? ; time at +16H +22
; DW ? ; date at +18H +24
; DW ? ; size low at +1AH +26
; DW ? ; size high at +1CH +28
; DB 13 DUP(?) ; packed name at +1EH +30
; end ; at +2BH +43
;ARC FILE STRUCTURE
; compression code and styles (to date)
; 0 = archive EOF -------- no more files
; 1 = old, no compression, short header store extract
; 2 = new, no compression Store Extract
; 3 = dle for repeat chars Pack Un-Pack
; 4 = huffman encoding Squeeze unSqueeze
; 5 = lz, no dle (Lempel, Ziv) crunch uncrunch
; 6 = lz with dle (delete repeats) Crunch unCrunch
; 7 = lz with readjust urunch Uncrunch
; 8 = lz with readjust and dle Crunch UnCrunch
; 9 = modified lzw, no dle (Welch) Squash UnSquash
HEADER STRUC ; archive header
PREFIX DB 1AH ; signature byte +0
MBRCODE DB 1 DUP(?) ; compression code +1
MBRNAME DB 13 DUP(?) ; file name +2
MBRSIZE DD 1 DUP(?) ; file size in archive +15
MBRDATE DW 1 DUP(?) ; creation date +19
MBRTIME DW 1 DUP(?) ; creation time +21
MBRCRC DW 1 DUP(?) ; CRC for true file +23
MBRLEN DD 1 DUP(?) ; true file size, bytes +25
HEADER ENDS ; +29
ZHEADER STRUC
ZSIGN DD 04034B50H ; local file header signature +0
ZVERS DW 0 ; version to extract (os/ver) +4
ZBITF DW 0 ; general purpose bit flag +6
ZCOMP DW 0 ; compression method +8
ZMTIM DW 0 ; last mod file time +10
ZMDAT DW 0 ; last mod file date +12
ZCRC DD 0 ; crc-32 +14
ZCSIZ DD 0 ; compressed size +18
ZTSIZ DD 0 ; uncompressed size +22
ZFNS DW 0 ; filename length +26
ZEFS DW 0 ; extra field length +28
ZHEADER ENDS
LF EQU 0AH
CR EQU 0DH
ESCP EQU 1BH
NUL EQU 0
;
CATS SEGMENT
ASSUME DS:CATS, SS:CATS ,CS:CATS ,ES:CATS
ORG 93H
PUBLIC
VATT,FILCHR,ARCFLG,HIDFLG,SYSFLG,VOLFLG,PATHSW,SECSW,MAXCOL,SATTR
PUBLIC
DIRSW,DIRFLG,FILSP,FLGSP,FIELD,FREL,FREE,NCATBUF,CATDIR,NCATSB,CATS
DR
PUBLIC CATHAN,CATHI,CATLO,NFSIZ,FPTR,CURDSK,MAXDR,DRINX,ROWSW,SFLAG
PUBLIC
FREF,VASK,RASK,NOLAB,CATSW,NDRSW,DFLAG,MFLAG,MGFLG,MSIZ,MSERBCD,SAV
CTLC
PUBLIC
SAVCTLS,STRBEG,FILEW,SFILE,WNAME,FNAM,BUFFR,SIZN,SIZF,ROOT,VFCB
PUBLIC
NVFCB,NVBUF,CPATHR,CPATH,VLABS,VLAB,BLANK,DVAL,NUMFILE,LBUFN,LBUFF
PUBLIC ARCFIL
PUBLIC HELP1$,INSW$,NODOS$,CRLF$,NODR$,NODRM$,NOCAT$,NOCAT2$,BADCAT$
PUBLIC
APPEND$,APPDR,APPLB$,APPTO$,VFILE$,NOVOL$,NOVDR,VPRES$,NEWVOL$
PUBLIC
MSTER$,MSTART$,LIST$,CURVOL$,CURVDR,CHVOL$,USVOL$,ZVOL$,SAMVOL$
PUBLIC
INVOL$,FIN$,FDR,FPR$,FPS$,FPT$,ERR$,OLDCAT$,COLN$,GIVCAT$,NCATS$
PUBLIC NCATT$,INCAT$,NEWCAT$
VATT DB 1 DUP(?)
ORG 100H
START: JMP BEGIN
FILCHR DB '.' ; fill line character 103
ARCFLG DB ' ' ; archive flag char 104
HIDFLG DB 'h' ; hidden flag char 105
SYSFLG DB 'S' ; system flag char 106
VOLFLG DB 'V' ; volume flag char 107
PATHSW DB 0FFH ; show paths switch 108
SECSW DB 0 ; show seconds in 1 109
MAXCOL DB 78 ; columns 10A
SATTR DW 0FFH ; search subset of this attribute 10B
DIRSW DB 1 ; show directories if 1 10D
DIRFLG DB 'D' ; directory flag char 10E
FILSP DB 1 ; add space before file ext if 1 10F
FLGSP DB 2 ; space reserved for attrib field 110
VRECL DB 1 ; variable record length flag 111
FIELD DB ' ' ; field separator 112
QMARK DB '?' ; numeric overflow 113
NODAT DB '*' ; no date char 114
NOTIM DB '*' ; no time char 115
ARCHF DB 'a' ; archive internal file 116
ARCFIL DB 4 ; not processing arc file 117
VASK DB 0 ; ask for volume label 118
CATSW DB 0 ; change default cat name 119
DFLAG DB 0 ; display files 11A
MFLAG DB 0 ; make serial numbers 11B
NOLAB DB 0 ; do not write label 11C
QFLG DB 0 ; quiet flag 11D
ARCHZ DB 'z' ; zip internal file 11E
DB 2 dup(0)
DOSVER DB 0
FREL DW 15
FREE DB '\ <- Free Space',0
DB 14 DUP(0)
NCATBUF DB 64,0
CATDIR DB '\CAT\CATS.DIR',0
DB 52 DUP(0)
NCATSB DB 64,0
CATSDR DB 'CATS.COM',0
DB 56 DUP(0)
CATHAN DW 0
CATHI DW 0
CATLO DW 0
NFSIZ DW 0
FPTR DW 0
CURDSK DB 0
MAXDR DB 0
DRINX DB 0
ROWSW DB 0
SFLAG DB ' ' ; store current file flag symbol
DOTLEN DW 0 ;
FREF DB 0
RASK DB 0
NCATSW DB 0
NDRSW DB 0
MGFLG DB 0
ARCHAN DW 0
ARCPTR DW 0
MSIZ DB 0
MVASCI DB 0
MSERBCD DW 0
SAVCTLC DW 0
SAVCTLS DW 0
STRBEG DW 0081H
FILEW DB '*.*',0
SFILE DB '\',64 DUP(0)
DB 32 DUP(0)
WNAME DB 'A:\*.*',0
FNAM DB 0,'*.*',0,0,0,0,0,0,0,0,0
BUFFR DB 16 DUP(0)
SIZN DW 0
SIZF DB ' ',0
ROOT DB '\',0
VFCB DB 0FFH,0,0,0,0,0,8,0,'???????????' ; search first vol
DB 25 DUP(0)
NVFCB DB 0FFH,0,0,0,0,0,8,0,' '
DB 25 DUP(0)
NVBUF DB 16 DUP(0)
SBUF DB 16 DUP(0)
CPATHR DB '\'
CPATH DB 64 DUP(0)
NVLAB DB 0
VLABS DB ' '
VLAB DB 11 DUP(20H),0
BLANK DB 11 DUP(20H),0
DVAL DW 0
NUMFILE DW 0
LBUFN DW 0
LBUFF DB CR,LF ; HELP$
DB 'CATS is designed to catalog multiple disks. Command Syntax:
',CR,LF,CR,LF
DB ' CATS x: [catname][/s]',CR,LF,CR,LF
DB 'where x: is a valid drive name'
DB ' for the disk you wish cataloged, and',CR,LF
DB ' [catname] is the optional'
DB ' drive:\path\filename for your catalog file.',CR,LF
DB 'If no catname is given, the default: ',NUL
HELP1$ DB ' is used.',CR,LF
DB ' [/s] represents optional switches. s=',CR,LF
DB ' A to Add compressed-file directories (ARC or ZIP) to
catalog',CR,LF
DB ' C to Change the default Catname within ',NUL
HELP2$ DB CR,LF
DB ' D to Display disk files onto the console',CR,LF
DB ' F to Force comma Field separator in catalog',CR,LF
DB ' M to Make sequential numerical volume labels',CR,LF
DB ' N to Not write your New volume label onto current
disk',CR,LF
DB ' Q to Quit after single disk is finished in Quiet
mode',CR,LF
DB ' R to Record fixed length Records in catalog',CR,LF
DB ' V to Verify current disk Volume label',CR,LF
DB ' All switches can be combined (e.g. /NVC ).',CR,LF,NUL
INSW$ DB CR,LF,'Invalid switch.',CR,LF,NUL
NODOS$ DB 'MS-DOS version above 2.0 required.'
CRLF$ DB CR,LF,NUL,8
NODR$ DB ' : is an invalid drive. Current drives are A: to '
NODRM$ DB ' :.',CR,LF,NUL
NOCAT$ DB CR,LF,'Catalog file: ',NUL
NOCAT2$ DB ' not found. Create it (Y or N) ? ',NUL
BADCAT$ DB 'Bad catalog drive, path, or file name.',CR,LF,NUL
APPEND$ DB CR,LF,'Appending files from disk in drive '
APPDR DB ' : ',NUL
APPLB$ DB 'with volume label: ',NUL
APPTO$ DB CR,LF,' to catalog file: ',NUL
VFILE$ DB CR,LF,'Volume name matches a file name. ',NUL
NOVOL$ DB CR,LF,'Current disk in drive '
NOVDR DB ' : has no volume label. '
VPRES$ DB ' Press:',CR,LF
DB ' -> <RETURN> to exit program, or'
NEWVOL$ DB CR,LF
DB ' -> Give a new volume label for current disk: '
DB '-> ___________ <-'
DB 14 DUP(08),NUL
MSTER$ DB CR,LF,'Volume label error. Sample format: VOLUME 000'
MSTART$ DB CR,LF
DB ' -> Give a new volume label and starting volume serial
number',CR,LF
DB 'using last three characters:'
DB ' -> '
MST DB '_______ 000 <-'
DB 14 DUP(08),NUL
LIST$ DB 'Do you wish to display current files on the console (Y or N) ?
',NUL
CATL$ DB 'Do you wish to catalog this disk (Y or N) ? ',NUL
CURVOL$ DB 'Current volume label in drive '
CURVDR DB ' : is: ',NUL
CHVOL$ DB 'Do you wish to change this volume label (Y or N) ? ',NUL
USVOL$ DB 'Do you wish to use a different label in catalog (Y or N)
? ',NUL
ZVOL$ DB 'Exiting without adding a volume label.',CR,LF,NUL
SAMVOL$ DB 'Volume label left unchanged.',CR,LF,NUL
INVOL$ DB 'Error creating volume label.',CR,LF
DB 'Possible conflict with a file name. Also,',CR,LF
DB 'Check for invalid characters in label or foreign disk.',CR,LF,NUL
FIN$ DB CR,LF,' Finished cataloging disk in drive '
FDR DB ' : with volume label: ',NUL
FPR$ DB CR,LF,'Press:',CR,LF
 DB ' -> <A drive letter> to catalog disk in new drive;',NUL
FPS$ DB CR,LF
 DB ' -> <SPACE> to catalog disk in the same drive;'
FPT$ DB ' or',CR,LF
 DB ' -> <RETURN> to exit program.',CR,LF,NUL
ERR$ DB CR,LF,'Error writing to catalog file: ',NUL
OLDCAT$ DB CR,LF,'Current default catalog file name is'
COLN$ DB ':',CR,LF,NUL
GIVCAT$ DB CR,LF,'Give a new default catalog name in
form:',CR,LF,CR,LF
DB ' drive:\path\filename',CR,LF,CR,LF,NUL
NCATS$ DB CR,LF,'The catalog program, ',NUL
NCATT$ DB CR,LF,'was not found.',CR,LF,NUL
INCAT$ DB CR,LF,'Catalog name was not changed.',CR,LF,NUL
NEWCAT$ DB CR,LF,CR,LF,'New default catalog path name is: ',NUL
PUBLIC BEGIN,CAT1,CATO,CAT1A,CAT12,CAT13S,CAT18,CAT14A,CAT14B,CAT15
PUBLIC CAT15A,CAT15M,CAT15B,CAT15C,CAT15D,CAT16,CAT1O,CAT13,CAT13F
PUBLIC CAT14,CAT2,CAT4,CAT4A,CAT4B,CAT4C,CAT5R,CAT5AA,CAT5AB,CAT5AG
PUBLIC CAT52,CAT53,CAT71,CAT72,CAT73,CAT74,GETSRA,GETSRB,GETSRC
PUBLIC GETSRN,GETSRE,GETSRP
BEGIN: CLD
MOV DVAL,AX ; save drive validity bytes
MOV AH,30H
INT 21H ; get dos version
 MOV DOSVER,AL
 CMP AL,2 ; dos errorlevel=2
JNC CAT1
MOV DX,OFFSET NODOS$ ; incorrect dos version
CALL STRCON
MOV AX,WORD PTR 4C01H ; incorrect dos errorlevel=1
INT 21H ; terminate process
CAT1: MOV AH,19H
INT 21H ; get current disk
MOV CURDSK,AL ; save current disk index
JMP CAT1A
CATO: MOV DI,80H
MOV AL,' '
MOV CL,[DI] ; command tail length
XOR CH,CH
INC DI
REPZ CMPSB ; skip spaces
MOV AL,[DI] ; get specified drive
MOV DI,OFFSET NODR$
MOV [DI],AL ; put in error message
MOV DX,DI
MOV AL,3 ; drive errorlevel=3
JMP DDEXIT
CAT1A: MOV SI,80H ; set up command tail string
MOV CL,[SI] ; get length
XOR CH,CH
MOV DI,SI
INC DI
ADD DI,CX ; point to end of string
MOV [DI],BYTE PTR 0 ; terminate string with null
AND CX,CX ; see if any tail
JNZ CAT12
JMP DHELP ; show help screen
CAT12: PUSH CX
MOV DI,SI
INC DI
MOV AL,'/'
REPNZ SCASB ; look for switches
AND CX,CX
MOV BX,CX
POP CX
JNZ CAT13S
JMP CAT16 ; no switches
CAT13S: MOV CX,BX ; get back remaining byte count
PUSH DI ; save sw ptr
DEC DI ; point to '/'
MOV BYTE PTR [DI],0 ; add new terminator over '/'
MOV CX,DI
SUB CX,SI
DEC CX ; si starts at 80
MOV AL,' '
CMP BYTE PTR [DI-1],AL ; is there a space before '/'
JNZ CAT18 ; no
STD
DEC DI ; point to space
PUSH CX
REPZ SCASB ; back up through spaces
POP CX
CLD
INC DI ; point to first space
INC DI ; point to sw location
CAT18: MOV CX,DI
SUB CX,SI
DEC CX ; new string length
MOV BYTE PTR [DI],0 ; new string terminator
POP DI ; get back first sw ptr
CAT14A:
MOV AL,[DI]
INC DI
AND AL,AL
JZ CAT16
CMP AL,'a'
JC CAT14B
AND AL,5FH ; make switch upper case
CAT14B: CMP AL,'V'
JNZ CAT15
XOR VASK,1 ; ask for new label
JMP SHORT CAT14A
CAT15: CMP AL,'C'
JNZ CAT15A
XOR CATSW,1 ; change default cat name
JMP SHORT CAT14A
CAT15A: CMP AL,'D'
JNZ CAT15M
XOR DFLAG,1 ; display files on console
JMP SHORT CAT14A
CAT15M: CMP AL,'M'
JNZ CAT15B
XOR MFLAG,1 ; make serial numbered labels
JMP SHORT CAT14A
CAT15B: CMP AL,'N'
JNZ CAT15C
XOR NOLAB,1 ; no writing new label
JMP SHORT CAT14A
CAT15C: CMP AL,'F'
JNZ CAT15O
MOV FIELD,',' ; use comma separator
JMP SHORT CAT14A
CAT15O: CMP AL,'R'
JNZ CAT15Q
XOR VRECL,1 ; use fixed record length
JMP SHORT CAT14A
CAT15Q: CMP AL,'A'
JNZ CAT15R
XOR ARCFIL,1 ; expand archive files
JMP SHORT CAT14A
CAT15R: CMP AL,'Q'
JNZ CAT15P
XOR QFLG,1
JMP SHORT CAT14A
CAT15P: CMP AL,' '
JZ CAT14A
CMP AL,'/'
JZ CAT14A
CAT15D: MOV DX,OFFSET INSW$
CALL STRCON ; show error in switch syntax
JMP DHELP
CAT16: MOV AX,DVAL
CMP AL,0FFH
JNZ CAT1O
JMP CATO ; incorrect drive given
CAT1O: INC CX ; must be 1 higher for SCASB
MOV AL,' '
MOV DI,SI
INC DI
REPZ SCASB ; skip spaces
DEC DI ; pt to char after space
JCXZ CAT13
MOV AL,':'
MOV SI,DI ; save di
MOV BP,CX ; save cx
INC CX
REPNZ SCASB ; look for ':'
AND CX,CX
JNZ CAT14
CAT13: TEST CATSW,1
JZ CAT13F
JMP GETCAT
CAT13F: JMP DHELP
CAT14: DEC DI
DEC DI ; point to X:
INC CX
CMP BYTE PTR [DI+2],0; end of tail
JZ CAT2
CMP BYTE PTR [DI+2],' ' ; see if space follows ':'
JNZ CAT13
CAT2: MOV NDRSW,1 ; show drive was given
MOV AL,[DI] ; get proposed drive label
INC DI
INC DI
DEC CX
DEC CX
AND AL,5FH
SUB AL,'A' ; make a drive index
MOV SI,DI ; save di
MOV BP,CX ; save cx
MOV DRINX,AL ; save it
ADD AL,'A'
MOV APPDR,AL
MOV NODR$,AL
MOV FDR,AL
MOV CURVDR,AL
MOV NOVDR,AL
MOV AL,' '
MOV DI,SI ; restore di
MOV CX,BP ; restore cx
CAT4: JCXZ CAT5R
MOV AL,' '
CMP [DI],AL
JNZ CAT4A
REPZ SCASB
DEC DI
JCXZ CAT5R
CAT4A: CMP BYTE PTR [DI],0
JZ CAT5R
INC CX
INC CX ; include terminating 0
MOV SI,DI
MOV DI,OFFSET CATDIR
CAT4B: LODSB
CMP AL,'a'
JC CAT4C
AND AL,5FH
CAT4C: STOSB
LOOP CAT4B
MOV NCATSW,1 ; show we have a new catalog
CAT5R: TEST CATSW,1
JZ CAT5AA
JMP GETCAT
CAT5AA: CALL GIVCR
CAT5AB: MOV AX,3D02H
MOV DX,OFFSET CATDIR
INT 21H ; open catdir for rd/wr
JNC CAT53
CAT5AG: MOV DX,OFFSET NOCAT$
CALL STRCON ; say can't open, create ?
CALL SHOCAT
MOV DX,OFFSET NOCAT2$
CALL STRCON
MOV AX,0C01H
INT 21H
AND AL,5FH
CMP AL,'Y'
JZ CAT52
CMP AL,'N'
JNZ CAT5AG
CALL CONCRL
MOV AL,5 ; no cats.dir given errorlevel=5
JMP EXIT
CAT52: CALL CONCRL
MOV DX,OFFSET CATDIR
MOV AX,3C00H
XOR CX,CX ; file attribute
INT 21H ; create catdir
JNC CAT53
MOV DX,OFFSET BADCAT$
MOV AL,5 ; bad cats.dir open errorlevel=5
JMP DEXIT
CAT53: MOV CATHAN,AX
MOV BX,AX
MOV AX,4202H
XOR CX,CX
MOV DX,CX
INT 21H ; set ptr to end of file
MOV CATHI,DX
MOV CATLO,AX ; catdir size in bytes DX:AX
MOV AL,MAXCOL
SUB AL,46
CMP AL,6
JNC CAT71
MOV AL,33
CAT71: TEST SECSW,1
JZ CAT72 ; show no seconds
DEC AL
DEC AL
DEC AL
CAT72: TEST FILSP,1
JZ CAT73
DEC AL
CAT73: MOV AH,FLGSP
AND AH,3
SUB AL,AH
XOR AH,AH
CMP BYTE PTR FIELD,' '
JZ CAT74
MOV AH,FIELD
MOV FREE,AH
XOR AH,AH
CAT74: TEST BYTE PTR VRECL,1
JZ CAT74F
MOV AX,254
CAT74F: MOV DOTLEN,AX ; comment width
MOV AH,35H
PUSH ES
INT 21H
MOV SAVCTLC,BX
MOV SAVCTLS,ES
POP ES
MOV AX,2523H
MOV DX,OFFSET CTLCH ; control C handler
INT 21H
TEST MFLAG,1 ; make numeric sequence ?
JNZ CAT7M
JMP CATC
CAT7M: CALL GETSR0
JC CAT7N
JMP CATC
CAT7N: CALL CONCRL
JMP CAT54
GETSER:
MOV CX,6
MOV SI,OFFSET NVBUF+2
MOV DI,OFFSET SBUF ; save current serial name
REP MOVSW
XOR AL,AL
STOSB
MOV SI,OFFSET MST ; dashes
MOV DI,OFFSET NVBUF+2
MOV CX,6
REP MOVSW ; save dashes
MOV CX,11
MOV SI,OFFSET SBUF
MOV DI,OFFSET MST
REP MOVSB ; put in current vol ser
MOV DX,OFFSET MSTART$
CALL STRCON
MOV CX,11
MOV SI,OFFSET NVBUF+2
MOV DI,OFFSET MST
REP MOVSB ; restore dashes
MOV MGFLG,1 ; show this is a repeat
JMP SHORT GETSRR
GETSR0: MOV DX,OFFSET MSTART$
GETSRA: CALL STRCON
GETSRR: MOV AX,0C0AH
MOV DI,OFFSET NVBUF
MOV DX,DI
MOV BYTE PTR [DI],12 ; vol name with number ext
INT 21H ; flush and input to buffer
CMP BYTE PTR [DI+1],0
JNZ GETSRB
JMP GETSRE ; exit
GETSRB: CMP BYTE PTR [DI+2],' '
JNZ GETSRC
JMP GETSRH
GETSRC: CALL CONCRL
MOV AL,[DI+1]
MOV MSIZ,AL ; save input buffer size
CMP AL,8
JA GETSR1
XOR CX,CX
MOV CL,BYTE PTR 8
SUB CL,AL
AND CL,CL
JZ GETSR2
PUSH DI
MOV BL,AL
XOR BH,BH
ADD DI,BX
INC DI
INC DI
MOV AL,' '
REP STOSB
POP DI
GETSR2: MOV AL,'0'
MOV CX,3
PUSH DI
ADD DI,10
REP STOSB
POP DI
MOV [DI+1],BYTE PTR 11
GETSR1: CMP BYTE PTR [DI+1],11
JNZ GETSRH
ADD DI,9 ; point to ext-1
MOV CX,4
MOV BL,[DI]
CMP BL,'0'
JAE GETSRD
GETSRI: MOV MVASCI,BL
MOV CX,3
INC DI
JMP SHORT GETSRF
GETSRD: CMP BL,'9'
JA GETSRI
GETSRF: XOR AX,AX
MOV BP,10
GETSRN: MOV BL,[DI]
SUB BL,'0'
JAE GETSRP
GETSRH: MOV DX,OFFSET MSTER$
JMP GETSRA
GETSRP: CMP BL,9
JA GETSRH
XOR BH,BH
MUL BP
ADD AX,BX
INC DI
LOOP GETSRN
MOV SI,OFFSET NVBUF+9
LODSW
MOV DX,0F30H
MOV CX,4
SUB AH,DL
SUB AL,DL
AND AH,DH
AND AL,DH
SHL AL,CL
ADD AL,AH
MOV BH,AL
LODSW
SUB AH,DL
SUB AL,DL
AND AL,DH
SHL AL,CL
ADD AL,AH
MOV BL,AL
CMP MSIZ,BYTE PTR 8
JA GETSR5
TEST MGFLG,1
JZ GETSR5
GETSR4: MOV DI,OFFSET NVBUF+2
MOV SI,OFFSET SBUF
MOV BL,MSIZ
XOR BH,BH
ADD DI,BX
ADD SI,BX
MOV CX,11
SUB CL,MSIZ
REP MOVSB
MOV DI,OFFSET NVBUF
MOV AL,BYTE PTR 11
MOV [DI+1],AL
INC AL
MOV [DI],AL
XOR AL,AL
MOV [DI+13],AL
RET
GETSR5: MOV MSERBCD,BX ; BCD volume serial number
MOV DI,OFFSET NVBUF
RET
GETSRE: TEST MGFLG,1
JNZ GETSRG
STC
RET
GETSRG: MOV MSIZ,BYTE PTR 0
JMP SHORT GETSR4
PUBLIC CATC,CATE,CATTLA,CATTLQ,CATTLY,CATTLY,CATTL,CATD,CATTD,CATDA
PUBLIC
CAT54,CAT55,CAT55M,CAT5L,CAT5M,CAT56,CAT57,CAT58,CAT5P,CAT59N,CAT60
PUBLIC
CAT60R,CAT61,CAT63,CAT63C,CAT62,CAT63A,CAT64,CAT65,CAT65M,CAT6L
PUBLIC CAT6M,CAT66,CAT67,CAT68,CAT7,CAT8,CAT81,CAT9,CAT91,CAT10
; loop re-entry point for cataloging different disks
CATC:
MOV DL,CURDSK
MOV AH,0EH
INT 21H ; assure we are back on org disk
MOV AL,DRINX
ADD AL,'A'
MOV APPDR,AL
MOV NODR$,AL
MOV FDR,AL
MOV CURVDR,AL
MOV NOVDR,AL
MOV WNAME,AL ; use wild name to check disk ready
MOV AH,1AH ; without selecting that drive
MOV DX,80H
INT 21H ; set DTA at default
MOV AH,4EH
MOV DX,OFFSET WNAME
MOV CX,0FFH ; find anything
INT 21H ; find first match
; if we are here, then disk is in drive (and not Aborted by user)
MOV DL,DRINX
MOV AH,0EH
INT 21H ; select disk for first file
DEC AL
AND AL,31
MOV MAXDR,AL ; maximum number of drives - 1
CMP AL,DL
JNC CATE
MOV AL,3 ; drive errorlevel=3
JMP DDEXIT
CATE: MOV AH,47H
MOV SI,OFFSET CPATH
MOV DL,DRINX
INC DL
INT 21H ; get current directory
MOV AH,3BH
MOV DX,OFFSET ROOT
INT 21H ; go to root
MOV BYTE PTR VFCB+7,0; set to default drive
MOV DX,OFFSET VFCB
MOV AH,11H
INT 21H ; search first volume label for list
INC AL
MOV CX,11
MOV SI,WORD PTR 88H ; fcb volume name
JNZ CATTLA ; found label
MOV NVLAB,1 ; flag no label
MOV SI,OFFSET BLANK ; blank label
CATTLA:
MOV DI,OFFSET VLAB
PUSH DI
REP MOVSB ; save volume label
POP DI
TEST DFLAG,1
JZ CATTL
; SHOW LIST
CATTLQ: MOV DX,OFFSET LIST$
CALL ANSWER
JC CATTLQ
JNZ CATTLR
CATTLY: PUSH CATHAN
MOV CATHAN,1 ; console
MOV BX,OFFSET SFILE+1
MOV DX,0 ; flag to set up DTA
CALL FILES ; main program to catalog files
CALL CONCRL
MOV AH,3BH
MOV DX,OFFSET ROOT
INT 21H ; go to root
MOV AH,1AH
MOV DX,80H
INT 21H ; set DTA at default
POP CATHAN
CATTLR: MOV DX,OFFSET CATL$
CALL ANSWER
JC CATTLR
JZ CATTL
JMP CAT7Z
CATTL: MOV BYTE PTR VFCB+7,0; set to default
MOV DX,OFFSET VFCB
MOV AH,11H
INT 21H ; search first volume label
INC AL
MOV NVLAB,1 ; flag no label
JZ CATD ; volume label not found
MOV NVLAB,0 ; flag label found
JMP CAT60
CATD: TEST MFLAG,1
JZ CATTD
MOV DI,OFFSET NVBUF
TEST VASK,1
JZ CAT55M
CALL GETSER
JMP CAT55M
CATTD: MOV DX,OFFSET NOVOL$
CATDA: CALL STRCON
MOV AX,0C0AH
MOV DI,OFFSET NVBUF
MOV DX,DI
MOV BYTE PTR [DI],12
INT 21H ; flush and input to buffer
CMP BYTE PTR [DI+1],0
JNZ CAT55
CMP BYTE PTR [DI+2],' '
JNZ CAT55
CAT54: XOR AX,AX
MOV DX,OFFSET ZVOL$ ; say volume label not changed
CALL STRCON
MOV AL,7 ; volume label errorlevel=7
JMP EXIT
CAT55: CALL CONCRL
CALL CONCRL
CAT55M: INC DI ; point to number typed
MOV CL,[DI]
XOR CH,CH
INC DI
MOV SI,DI ; point to input buffer
MOV DI,OFFSET NVFCB+8; put here
PUSH CX
MOV CX,11
PUSH DI
MOV AL,' '
REP STOSB ; put spaces in
POP DI
POP CX
AND CX,15
JZ CAT54
XOR BX,BX
CAT5L: LODSB
CMP AL,' '
JC CAT56
CMP AL,'A'
JC CAT5M
AND AL,5FH ; make upper case
CAT5M: INC BX
STOSB
LOOP CAT5L
CAT56: TEST NOLAB,1 ; check for no label write
JNZ CAT59N
MOV DX,OFFSET NVFCB
MOV BYTE PTR NVFCB+7,0 ; set to default drive
MOV BYTE PTR NVFCB+6,37H ; search for all but volume
MOV AH,11H
INT 21H ; search for it
MOV BYTE PTR NVFCB+6,8 ; put back vol attrib
INC AL
JZ CAT58 ; not found, that's good
CAT57: MOV DX,OFFSET VFILE$ ; volume label is a file
CALL STRCON
MOV DX,OFFSET VPRES$
JMP CATDA
CAT58: MOV BYTE PTR NVFCB+7,0 ; set for default drive
MOV DX,OFFSET NVFCB
MOV AH,16H
INT 21H ; create new volume label
INC AL
MOV NVLAB,0
JNZ CAT59N
CAT5P: MOV NVLAB,1
MOV AL,7 ; errorlevel=7: cannot create label
MOV DX,OFFSET INVOL$
CALL STRCON
MOV DX,OFFSET VPRES$
JMP CATDA
CAT59N:
MOV CX,11
MOV SI,OFFSET NVFCB+8
MOV DI,88H
REP MOVSB ; put vol name in DTA
MOV RASK,1 ; show we already asked for VLab
CAT60: MOV CX,11
MOV SI,WORD PTR 88H
MOV DI,OFFSET VLAB
PUSH DI
REP MOVSB ; save volume label
POP DI
TEST VASK,1
JNZ CAT61 ; ask for new label
TEST MFLAG,1
JNZ CAT60M
JMP CAT7
CAT60R: MOV RASK,0
JMP CAT7
CAT60M: MOV DI,OFFSET NVBUF
JMP CAT65M
CAT61: TEST RASK,1 ; already asked for label
JNZ CAT60R
CAT62A: MOV DX,OFFSET CURVOL$
CALL STRCON
MOV DX,DI
CALL STRCON
CAT63: CALL CONCRL
MOV DX,OFFSET CHVOL$
TEST NOLAB,1
JZ CAT63C
MOV DX,OFFSET USVOL$
CAT63C: CALL ANSWER
JC CAT63
JZ CAT62
JMP CAT7
CAT62: TEST MFLAG,1
JZ CAT62C
CALL GETSER
JNC CAT65
JMP CAT54
CAT62C: MOV DX,OFFSET NEWVOL$
CAT63A: CALL STRCON
MOV AX,0C0AH
MOV DI,OFFSET NVBUF
MOV DX,DI
MOV BYTE PTR [DI],12
INT 21H ; flush and input to buffer
CMP BYTE PTR [DI+1],0
JNZ CAT65
CMP BYTE PTR [DI+2],' '
JNZ CAT65
CAT64: XOR AX,AX
MOV DX,OFFSET SAMVOL$
CALL STRCON
JMP CAT7
CAT65: CALL CONCRL
CAT65M: PUSH DI ; save ptr to buffer
MOV SI,OFFSET VLAB
MOV DI,OFFSET NVFCB+8
MOV CX,11
REP MOVSB ; move old volume name into FCB
POP DI
INC DI ; point to number typed
MOV CL,[DI]
XOR CH,CH
INC DI
MOV SI,DI ; point to input buffer
MOV BX,CX
MOV BYTE PTR [DI+BX],0 ; add terminating 0
MOV DI,OFFSET NVFCB+7+17 ; put new volume name into FCB
AND CX,15
JZ CAT64
MOV CX,11 ; max count
XOR BX,BX ; counter
CAT6L: LODSB
AND AL,AL
JZ CAT66
CMP AL,'a'
JC CAT6M
AND AL,5FH ; make upper case
CAT6M: INC BX
STOSB
LOOP CAT6L
CAT66: JCXZ CAT67
MOV AL,' '
REP STOSB ; fill with spaces
CAT67: TEST NOLAB,1
JNZ CAT68
MOV DX,OFFSET NVFCB
MOV BYTE PTR NVFCB+7,0 ; set for default drive
MOV AH,17H
INT 21H ; try to rename volume label
AND AL,AL
JZ CAT68
MOV DX,OFFSET INVOL$
CALL STRCON
MOV DX,OFFSET NEWVOL$
JMP CAT63A ; try again
CAT68: MOV CX,11
MOV SI,OFFSET NVFCB+7+17
MOV DI,OFFSET VLAB
REP MOVSB ; save volume label
CAT7:
MOV AH,3BH
MOV DX,OFFSET CPATHR
INT 21H ; go back to current dir
TEST QFLG,1
JNZ CAT7Q
MOV DX,OFFSET APPEND$
CALL STRCON ; say appending
MOV DX,OFFSET APPLB$
CALL STRCON
CALL SHOLAB
MOV DX,OFFSET APPTO$
CALL STRCON
CALL SHOCAT
CALL CONCRL
CAT7Q: MOV BX,OFFSET SFILE+1
MOV DX,0 ; flag to set up DTA
CALL FILES ; main program to catalog files
TEST NVLAB,1 ; see if no vol label
JZ CAT7V ; label exists
CALL ADDVO ; put in fake volume label line
CAT7V: INC FREF ; show we want free space
CALL ADDFS ; add free space
XOR AL,AL
MOV FREF,AL ; reset
TEST QFLG,1
JNZ CAT81
MOV DX,OFFSET FIN$
CALL STRCON ; say finished
CALL SHOLAB
CAT7Z: MOV DX,OFFSET FPR$
CALL STRCON
MOV DX,OFFSET FPS$
CALL STRCON ; ask for more
MOV AX,0C01H
INT 21H ; get response
CMP AL,' '
JNZ CAT8
MOV DL,8
MOV AH,2
INT 21H
MOV DL,DRINX
ADD DL,'A'
MOV AH,2
INT 21H
JMP CAT10
CAT8: CMP AL,CR
JZ CAT81
CMP AL,ESCP
JNZ CAT9
CAT81: CALL CONCRL
XOR AL,AL
JMP EXIT
CAT9: CMP AL,'a'
JC CAT91
AND AL,5FH
CAT91: CMP AL,'A'
JC CAT7Z
MOV BYTE PTR NODR$,AL
SUB AL,'A'
MOV DRINX,AL
CMP MAXDR,AL
JNC CAT10
MOV AL,MAXDR
ADD AL,'@'
MOV BYTE PTR NODRM$,AL
MOV DX,OFFSET NODR$-1
CALL STRCON
JMP CAT7Z
CAT10: MOV DX,OFFSET COLN$
CALL STRCON
MOV AX,MSERBCD ; make serial volumes
ADD AL,1
DAA
XCHG AH,AL
ADC AL,0
DAA
XCHG AH,AL
MOV CX,AX
AND CX,0F000H
JZ CAT112 ; new number less than 1000
MOV MVASCI,BYTE PTR 0 ; start using 4 digit serial #
CAT112: MOV MSERBCD,AX
MOV DI,OFFSET NVBUF+12
MOV BX,AX
MOV DX,0300FH
MOV CX,4
CAT11:
MOV AL,BL
AND AL,DL
ADD AL,DH
MOV [DI],AL
DEC DI
ROR BX,1
ROR BX,1
ROR BX,1
ROR BX,1
LOOP CAT11
MOV AL,MVASCI
AND AL,AL
JZ CAT122
INC DI
MOV [DI],AL ; Use ascii char for 1000 th place
CAT122: JMP CATC
PUBLIC
GETCAT,GETC1,GETC1A,GETC2,GETC3,GETC4,GETC5,GETCW,GETC6,GETC6A
PUBLIC GETC7,GETC8
GETCAT:
CALL GIVCR
 MOV DX,OFFSET CATSDR
 CALL CLNAME ; get CATS.COM name in DX
MOV AX,3D02H
INT 21H ; try to open CATS.COM
JNC GETC1
MOV DX,OFFSET NCATS$
CALL STRCON
MOV DX,OFFSET CATSDR
CALL STRCON
MOV DX,OFFSET NCATT$
MOV AL,4 ; open cats.com errorlevel=4
JMP DEXIT
GETC1: MOV BX,AX
MOV AX,4200H ; move ptr from beginning
MOV DX,OFFSET CATDIR-START
XOR CX,CX
INT 21H ; set ptr to CATDIR
TEST NCATSW,1
JZ GETC1A
MOV DX,OFFSET CATDIR
JMP GETCW
GETC1A: MOV DX,OFFSET OLDCAT$
CALL STRCON
CALL SHOCAT
CALL CONCRL
MOV DX,OFFSET GIVCAT$
CALL STRCON
MOV AX,0C0AH
MOV DI,OFFSET NCATBUF
MOV DX,DI
MOV BYTE PTR [DI],64
INT 21H
INC DI
MOV CL,[DI] ; size of buffer
AND CL,CL
JNZ GETC3
GETC2: MOV DX,OFFSET INCAT$ ; cats.dir name not given
MOV AL,5 ; cats.dir errorlevel=5
JMP DEXIT
GETC3: XOR CH,CH
INC DI
MOV SI,DI
ADD SI,CX
MOV BYTE PTR [SI],0
INC SI
PUSH DI
MOV DI,SI
MOV AX,64
SUB AX,CX
MOV CX,AX
XOR CH,CH
MOV AL,CH
REP STOSB ; erase excess from old name
POP DI
MOV SI,DI
MOV DX,DI ; save ptr to new name
MOV CX,64
MOV AH,'a'
GETC4: LODSB
CMP AL,AH
JC GETC5
AND AL,5FH
GETC5: STOSB ; make upper case
LOOP GETC4
MOV DI,OFFSET CATDIR
MOV SI,DX ; new cat name
MOV DX,DI ; save ptr to name for write
MOV CX,32
REP MOVSW
GETCW: MOV CX,64
MOV AX,4000H
INT 21H ; write over old CAT.COM file
MOV DX,OFFSET NEWCAT$
CALL STRCON
CALL SHOCAT
CALL CONCRL
GETC6: TEST NDRSW,1
JZ GETC6A
JMP GETC8
GETC6A: MOV DX,OFFSET FPR$
CALL STRCON
MOV DX,OFFSET FPT$
CALL STRCON
MOV AX,0C01H
INT 21H
CMP AL,CR
JNZ GETC7
XOR AL,AL
JMP EXIT
GETC7: MOV DX,OFFSET COLN$
CALL STRCON
AND AL,5FH
SUB AL,'A'
JC GETC6
MOV DRINX,AL ; save it
ADD AL,'A'
MOV APPDR,AL
MOV NODR$,AL
MOV FDR,AL
MOV CURVDR,AL
MOV NOVDR,AL
GETC8: MOV CATSW,0
JMP CAT5AB
PUBLIC FILES,FILS1,FILS2,FILS3,FILS4,FILS5
FILES: ; main subroutine to catalog files on a disk
; in: BX = current temp path name buffer
; DX = current DTA buffer pointer for functions 4E, 4F or
0
;
PUSH SI
PUSH DX ; current DTA pointer or 0
CALL MOVF1 ; move FNAM to [bx]
CALL FNDF ; get first directory or file name
JC FILS2
CALL WRIFILE ; record file or directory in catalog
FILS1: CALL FNDNXT ; get next directory or file
name
JC FILS2 ; no more dir or file names
CALL WRIFILE ; record file or directory in catalog
JMP SHORT FILS1 ; go for more
FILS2: POP DX ; restore DTA offset
PUSH DX
CALL MOVFIL ; move wild card file name to [bx]
CALL FNDF ; get first wild sub directory or file
JC FILS5 ; no files in here
MOV SI,DX ; set up DTA pointer
TEST BYTE PTR [SI+15H],10H ; test dir attribute of found file
JNZ FILS4 ; found a directory
; dir search loop
FILS3: CALL FNDNXT ; find next directory
JC FILS5 ; no more in this dir
TEST BYTE PTR [SI+15H],10H ; test attribute bit
JZ FILS3 ; skip non directories here
FILS4: CMP BYTE PTR [SI+1EH],2EH ; see if this is a dot directory
name
JZ FILS3 ; if so, skip it
CALL SHOFLS ; show files in this sub directory
MOV AH,1AH
INT 21H ; reset DTA to current DX
JMP SHORT FILS3
FILS5: POP DX
POP SI
RET
PUBLIC SHOFLS,SHOFLL
SHOFLS: ; show files in this dir (recursive call FILES)
PUSH DI
PUSH SI ; save pointer to directory name block
PUSH BX ; save pointer to path name buffer
CLD
MOV SI,DX ; get current DTA
ADD SI,1EH ; point to packed file name
MOV DI,BX ; destination directory file name buffer
SHOFLL: LODSB
STOSB
OR AL,AL
JNZ SHOFLL
MOV BX,DI ; new destination file buffer
STD ; reverse direction
STOSB ; add a null
MOV AL,'\'
STOSB ; put a '\' before null
CALL FILES
POP BX
MOV BYTE PTR [BX],0
POP SI
POP DI
WRIFE: RET
PUBLIC WRIFD,WRIFE,WRIFD1
WRIFD: TEST DIRSW,1
JZ WRIFE
PUSH SI
MOV SI,DX
CMP BYTE PTR [SI+1EH],'.'
POP SI
JZ WRIFE
MOV AH,DIRFLG
TEST AL,2
JZ WRIFD1 ; not hidden
OR AH,20H ; set to lower case
WRIFD1: JMP WRIFA1
PUBLIC WRIFILE,WRIFB,WRIFA,WRIFA1,WRIFG,WRIFW,WRIFK,WRIFS,WRIFNS
PUBLIC WRIFNF,WRIF1,WRIF1A,WRIF3,WRIF4,WRIFF,WRIFF1,WRIFF2,WRIFV
WRIFILE:
; in: BX = current temp path name buffer
; DX = current DTA buffer pointer for functions 4E, 4F or
0
PUSH SI ; save file info buffer
MOV SI,DX
MOV AH,VOLFLG
MOV AL,[SI+15H] ; attrib flag
POP SI
TEST AL,8 ; volume ?
JZ WRIFB
TEST AL,2 ; hidden set if no label on disk
JZ WRIFU
OR AH,' ' ; set bit 5 for lower case
WRIFU: JMP WRIFV
WRIFB: MOV AH,SYSFLG
TEST AL,4 ; system ?
JNZ WRIFA
MOV AH,ARCFLG
TEST AL,20H ; archive ?
JNZ WRIFA
MOV AH,' '
WRIFA: TEST AL,10H ; directory ?
JNZ WRIFD
TEST AL,2 ; hidden ?
JZ WRIFA1 ; not hidden
OR AH,' ' ; set bit 5 to make lower case
CMP AH,' ' ; no other flags if ' '
JNZ WRIFA1
MOV AH,HIDFLG
WRIFA1: TEST BYTE PTR ARCFIL,4
JNZ WRIFG ; not processing an arc
MOV AH,ARCHF
TEST BYTE PTR ARCFIL,8; zip?
JZ WRIFG
MOV AH,ARCHZ
WRIFG: MOV SFLAG,AH
PUSH DX
ADD DX,1EH ; packed name pointer
PUSH SI
PUSH DI
MOV SI,DX
MOV DI,OFFSET BUFFR
MOV AX,2901H
INT 21H ; parce file name
MOV DX,DI
INC DX
WRIFW: POP DI
POP SI
PUSH DI
MOV DI,DX
MOV BP,[DI+8] ; save ext char
MOV BYTE PTR [DI+8],0
CALL WRIS0 ; write name
TEST FILSP,1
JZ WRIFK
MOV DL,' '
CALL WRITC ; write name-extension separator
WRIFK: MOV [DI+8],BP ; write extension
ADD DI,8
MOV DX,DI
MOV AL,BYTE PTR ARCFIL
TEST AL,4 ; processing?
JZ WRIFK1
TEST AL,1 ; expand arcs?
JZ WRIFK1
AND BYTE PTR ARCFIL,NOT 8+2 ; drop 'got an ARC or ZIP' bit
CMP WORD PTR [DI],5241H ;`RA' in ARC
JNZ WRIFKZ
CMP BYTE PTR [DI+2],'C' ;
JNZ WRIFKZ
OR BYTE PTR ARCFIL,2; set 'got an ARC file'
WRIFKZ: CMP WORD PTR [DI],495AH ; 'IZ' in ZIP
JNZ WRIFK1
CMP BYTE PTR [DI+2],'P'
JNZ WRIFK1
OR BYTE PTR ARCFIL,8+2 ; set 'got ZIP file'
WRIFK1: CALL WRIS0 ; write extension
MOV DL,FLGSP
AND DL,DL
JZ WRIFNS
DEC DL
JZ WRIFS
MOV DL,FIELD
CALL WRITC
WRIFS: MOV DL,SFLAG
CALL WRITC ; write flag
WRIFNS: POP DI
POP DX ; get file DTA pointer back
PUSH DX
CALL SHOFS ; show file stats
MOV DL,FIELD
CALL WRITC
MOV DX,OFFSET VLAB
CALL WRIS0
TEST BYTE PTR FREF,1
JZ WRTNF
JMP WRIFF ; this is a free space request
WRTNF: TEST BYTE PTR PATHSW,1
JZ WRIF4
MOV DX,OFFSET SFILE ; ptr to full path name
TEST BYTE PTR ARCFIL,4
JNZ WRTFN
MOV DX,OFFSET ARCPATH
WRTFN: MOV AL,FIELD
CMP AL,' '
JZ WRIFNF
PUSH BX
MOV BX,DX
MOV [BX],AL
POP BX
WRIFNF: MOV AX,BX ; ptr to current path name
SUB AX,DX ; size of path name to print
CMP AX,DOTLEN
JC WRIF1 ; extra space for path name
PUSH BX
MOV BX,DX
ADD BX,DOTLEN
MOV CL,[BX] ; save char here
MOV BYTE PTR [BX],0
CALL WRIS0 ; write path name from [dx]
MOV SFILE,'\'
MOV [BX],CL ; restore char in SFILE field
POP BX
JMP SHORT WRIF3 ; write cat line
WRIF1: MOV CL,[BX] ; get last byte
MOV BYTE PTR [BX],0 ; add null terminator
CALL WRIS0 ; write string to null from [dx]
MOV [BX],CL ; replace last byte
MOV SFILE,'\'
MOV AX,BX
SUB AX,DX ; size of path field
MOV CX,DOTLEN
SUB CX,AX
JC WRIF3
WRIF1A: TEST BYTE PTR VRECL,1
JNZ WRIF3
MOV DL,FILCHR
CALL WRICX ; write cx characters
PUBLIC WRIF3
WRIF3: CALL WRITCR
MOV AL,ARCFIL
AND AL,111B
CMP AL,7 ; not processing, got arc, expand arc
JNZ WRIF3E
POP DX
PUSH DX ; get DTA ptr
CALL WRIFARC
WRIF3E: POP DX
RET
WRIF4: MOV CX,DOTLEN
JMP SHORT WRIF1A
WRIFF: MOV DX,OFFSET FREE
MOV AX,FREL
CMP AX,DOTLEN
JC WRIFF1
PUSH BX
MOV BX,DX
ADD BX,DOTLEN
MOV CL,[BX] ; save char here
MOV BYTE PTR [BX],0
CALL WRIS0
MOV [BX],CL ; restore char in FREE field
POP BX
JMP SHORT WRIFF2
WRIFF1: CALL WRIS0
WRIFF2: MOV CX,DOTLEN
SUB CX,FREL
JNC WRIF1A
JMP SHORT WRIF3
WRIFV: MOV BYTE PTR SFLAG,AH
PUSH DX
PUSH SI
PUSH DI
PUSH CX
MOV SI,OFFSET VLAB
MOV DI,OFFSET BUFFR
MOV DX,SI
MOV CX,11
REP MOVSB
MOV BYTE PTR [DI],0
POP CX
JMP WRIFW
WRTFAE:
MOV AH,3EH ; close
MOV BX,ARCHAN
INT 21H
WRTFAEE:
OR BYTE PTR ARCFIL,4; set 'not processing' bit
POP DI
POP SI
POP DX
POP BX
RET
PUBLIC WRIFARC
WRIFARC:
; in: BX = current temp path name buffer
; DX = current DTA buffer pointer for functions 4E, 4F or
0
AND BYTE PTR ARCFIL,NOT 4 ; reset 'not processing' bit
PUSH BX
PUSH DX
PUSH SI
PUSH DI
MOV SI,OFFSET SFILE ; start of full path name
MOV CX,BX
SUB CX,SI ; size of current path name
MOV DI,OFFSET ARCPATH
REP MOVSB
MOV AL,'\'
CMP BYTE PTR [DI-1],AL
JZ WRTA1
STOSB
WRTA1: ADD DX,1EH ; packed name pointer
MOV SI,DX ; arc file name
CALL MOV0D ; set up extended path name
XOR AL,AL
STOSB
MOV DX,OFFSET ARCPATH
MOV AX,3D00H ; open handle for read only
INT 21H
JC WRTFAEE
MOV BX,AX ; handle
MOV WORD PTR ARCHAN,AX
SUB DI,4 ; back up to '.' in '.ARC',0
MOV ARCPTR,DI ; save ptr to end of path
MOV AL,'\'
STOSB
MOV SI,OFFSET FILEW
CALL MOV0D
TEST ARCFIL,8 ; zip?
JZ WRTAL
JMP WRTZL
WRTAL: MOV CX,29 ; arc file header size
MOV DX,OFFSET FILBUF
MOV AH,3FH ; read 29 bytes of file
INT 21H
JC WRTFAE
CMP CX,AX
JNZ WRTFAE
XCHG BX,DX
MOV AX,[BX]
CMP AL,1AH ; arc code
JNZ WRTFAE
AND AH,AH ; end of files ?
JZ WRTFAE
CALL WRTSAR
MOV DX,[BX+15] ; compressed file size low
MOV CX,[BX+17] ; compressed file size high
MOV BX,ARCHAN
MOV AX,4201H ; move ptr from present position
INT 21H
JNC WRTAL
JMP WRTFAE
WRTSAR:
; bx points to arc header buffer
PUSH BX
MOV SI,BX
MOV DI,BX
ADD DI,128+21 ; new fake file DTA
MOV AL,0
STOSB ; attrib byte
ADD SI,21 ; point to arc date-time time field
MOVSW
SUB SI,4 ; date field
MOVSW
ADD SI,4 ; skip time and crc
MOVSW
MOVSW ; move true file size
MOV SI,BX
ADD SI,2 ; arc name field
MOV CX,13
REP MOVSB
MOV DX,OFFSET ARCDTA
MOV BX,WORD PTR ARCPTR
CALL WRIFILE
POP BX
RET
WRTFZE: JMP WRTFAE
PUBLIC WRTZL
WRTZL: MOV CX,44 ; zip file header size PAST filename
MOV DX,OFFSET FILBUF
MOV AH,3FH ; read 44 bytes of file
INT 21H
JC WRTFZE
CMP CX,AX
JNZ WRTFZE
XCHG BX,DX
MOV AX,[BX]
CMP AX,'KP' ; arc code
JNZ WRTFZE
MOV AX,[BX+2]
CMP AX,0403H
JNZ WRTFZE
CALL WRTSZR
MOV DX,[BX+18] ; compressed file size low
MOV CX,[BX+20] ; compressed file size high
MOV AX,30 ; zip header size to file name
ADD AX,[BX+26] ; file name length
ADD AX,[BX+28] ; extra length
SUB AX,44 ; amount of zip already read
JNC WRTZLN
NEG AX
SUB DX,AX
SBB CX,0
JMP SHORT WRTZLC
WRTZLN: ADD DX,AX
ADC CX,0 ; bytes to move
WRTZLC: MOV BX,ARCHAN
MOV AX,4201H ; move ptr from present position
INT 21H
JNC WRTZL
JMP WRTFZE
PUBLIC WRTSZR
WRTSZR:
; bx points to arc header buffer
PUSH BX
MOV SI,BX
MOV DI,BX
ADD DI,128+21 ; new fake file DTA
MOV AL,0
STOSB ; attrib byte
ADD SI,10 ; point to date-time time field
MOVSW ; time
MOVSW ; date
ADD SI,8 ; skip to true file size
MOVSW
MOVSW ; move true file size
LODSW ; get file name length
XOR AH,AH
ADD SI,2
MOV CX,AX
REP MOVSB ; move zip name
XOR AL,AL
STOSB
MOV DX,OFFSET ARCDTA
MOV BX,WORD PTR ARCPTR
CALL WRIFILE
POP BX
RET
PUBLIC CPYR
; critical data area
CPYR: DB 0F2H,0F5H,0BCH,0BEH,0ABH,0ACH,0DFH
DB 0CDH,0D1H,0CBH
DB 0DFH,0D7H,09CH,0D6H
DB 0DFH,0CEH,0C6H,0C7H,0C9H,0D2H,0C7H,0C6H,0DFH,0A8H,096H
DB 093H,093H,096H,09EH,092H,0DFH,0BCH,0D1H
DB 0DFH,0AFH,09EH,08DH,094H,09AH,0F2H,0F5H,000H
DB 0C7H
DB 094H,09AH,0DFH,0D7H,09CH,0D6H,0DFH,0BCH
DB 090H,08FH,086H,08DH,096H,098H,097H,08BH
DB 0DFH,0CEH,0C6H,0C7H,0C9H,0DFH,099H,090H
DB 08DH,0DFH,0BCH,0B7H,0AAH,0B8H,0F2H,0F5H
DB 0F6H,0F6H,0DFH,0DFH,0DFH,0DFH,0BCH,09EH
DB 08FH,096H,08BH,09EH,093H,0DFH,0B7H,09AH
DB 09EH,08BH,097H,0DFH,0AAH,08CH,09AH,08DH
DB 08CH,0DFH,0B8H,08DH,090H,08AH,08FH,0F2H
DB 0F5H,0F6H,0F6H,0F6H,0DFH,0DFH,0DFH,0A9H
DB 09AH,08DH,0DFH,0CDH,0D1H,0CCH
DB 0F2H,0F5H,000H,0C7H
PUBLIC CTLCH
CTLCH: IRET
PUBLIC MOVF1,MOVFIL,MOV0
MOVF1: PUSH SI
MOV SI,OFFSET FNAM+1
CALL MOV0
POP SI
RET
MOVFIL: PUSH SI
MOV SI,OFFSET FILEW
CALL MOV0
POP SI
RET
MOV0D: ; mov [si] to [di] until 0
LODSB
STOSB
OR AL,AL
JNZ MOV0D
DEC DI ; point to 0
RET
MOV0: ; move [si] to [bx] until 0
PUSH AX
PUSH DI
MOV DI,BX
CLD
CALL MOV0D
POP DI
POP AX
RET
MOVSP: ; move until space OR cx=0
PUSH AX
MOV AH,20H
MOVSP1: LODSB
CMP AL,AH
JZ MOVSP2
STOSB
LOOPNZ MOVSP1
MOVSP2: MOV BYTE PTR [DI],0
POP AX
RET
PUBLIC FNDF,FNDF1
FNDF: ; find directory
PUSH CX
AND DX,DX
JNZ FNDF1
MOV DX,OFFSET DTAB ; set up DTA
FNDF1: ADD DX,43 ; add size of previous find buffer
MOV CX,SATTR ; attrib
MOV AH,1AH
INT 21H ; set DTA for functions 4E and 4F
PUSH DX
MOV DX,OFFSET SFILE
MOV AH,4EH
INT 21H ; find first dir
POP DX
POP CX
RET
PUBLIC FNDNXT
FNDNXT: PUSH CX
PUSH DX
MOV DX,OFFSET SFILE
MOV CX,0F7H ; find all but volume
MOV AH,4FH
INT 21H ; find subseq. DIR match
POP DX
POP CX
RET
PUBLIC DDEXIT,DHELP,DEXIT,EXIT0,EXIT
DDEXIT:
MOV DL,CURDSK
MOV AH,0EH
INT 21H ; select current disk
ADD AL,'@'
MOV NODRM$,AL ; max drive index
MOV DX,OFFSET NODR$
MOV AL,3 ; drive errorlevel=3
JMP DEXIT
DHELP: CALL GIVCR
MOV DX,OFFSET LBUFF
CALL STRCON
CALL SHOCAT
MOV DX,OFFSET HELP1$
CALL STRCON
MOV DX,OFFSET CATSDR
CALL STRCON
MOV DX,OFFSET HELP2$
MOV AL,2 ; help errorlevel=2
DEXIT: PUSH AX
CALL STRCON ; show message
POP AX
JMP SHORT EXIT
EXIT0: MOV AL,0
EXIT: PUSH AX
MOV BX,CATHAN
MOV AH,3EH
INT 21H
MOV DL,CURDSK
MOV AH,0EH
INT 21H ; select disk
PUSH DS
LDS DX,DWORD PTR SAVCTLC
MOV AX,2523H
INT 21H ; restore old ctl-c handler
POP DS
POP AX
MOV AH,4CH
INT 21H ; terminate process
PUBLIC SKPATH,SKP1,SKP1A,SKP2,SKP3,SKPE
SKPATH: PUSH DI
MOV AL,'!'
DEC SI
SKP1: INC SI
CMP [SI],AL
JC SKP1 ; skip spaces or below
MOV AL,CURDSK
MOV DRINX,AL
CMP [SI+1],BYTE PTR ':'
JNZ SKP1A
MOV AL,[SI]
AND AL,5FH
SUB AL,'A'
MOV DRINX,AL ; set drive index
SKP1A: MOV DI,SI
XOR AL,AL
CLD
MOV CX,0020H
DEC DI
SKP2: INC DI
CMP [DI],CL ; find space
JZ SKP3
CMP [DI],CH ; or null terminator
JNZ SKP2
SKP3: MOV CX,DI
SUB CX,SI ; size of name
INC DI
MOV STRBEG,DI ; set up for next file
DEC DI
MOV NFSIZ,CX
STC
JZ SKPE
MOV AL,'\'
STD
REPNZ SCASB ; search for '\'
CLD
JCXZ SKPE
INC DI
INC DI
MOV SI,DI
MOV NFSIZ,CX
SKPE: POP DI
MOV CX,NFSIZ
MOV FPTR,SI
RET
PUBLIC ADDFS
ADDFS: MOV WORD PTR SFILE,'\'
XOR AX,AX
MOV DX,OFFSET CPYR ; spare buffer
MOV DI,DX
MOV CX,24
REP STOSW ; zero out buffer
MOV AL,' '
MOV DI,DX
ADD DI,1EH ; packed name ptr
MOV CX,11
REP STOSB
MOV DI,DX
PUSH DX
MOV AH,36H
MOV DL,DRINX
INC DL
INT 21H ; get file size
XOR DX,DX
MUL CX ; bytes/sector * sectors/cluster
XOR DX,DX
MUL BX ; free clusters * bytes/cluster
MOV BX,DX ; save high word of bytes free
POP DX
MOV [DI+1AH],AX ; low byte of bytes free
MOV [DI+1CH],BX ; high byte of size
CALL SETDT ; set date and time to current dt
MOV [DI+16H],AX
MOV BX,OFFSET SFILE+1
MOV DX,OFFSET CPYR
JMP WRIFILE
PUBLIC ADDVO
ADDVO: MOV WORD PTR SFILE,'\'
XOR AX,AX
MOV DX,OFFSET CPYR ; buffer to simulate file search DTA
MOV DI,DX
MOV CX,24
REP STOSW
MOV SI,OFFSET VLAB
MOV DI,DX
ADD DI,1EH ; packed name ptr
MOV CX,11
REP STOSB
MOV DI,DX
MOV [DI+15H],BYTE PTR 1010B ; hidden volume
XOR AX,AX
MOV [DI+1AH],AX ; low byte of bytes free
MOV [DI+1CH],AX ; high byte of size
CALL SETDT ; set date and time fields to current dt
MOV BX,OFFSET SFILE+1
MOV DX,OFFSET CPYR
JMP WRIFILE
SETDT: ; set date and time fields in find buffer
PUSH DX
MOV AH,2AH
INT 21H ; get date
XOR AX,AX
MOV BX,CX ; year
SUB BX,1980 ; make offset from 1980
AND BX,7FH
MOV CX,9
SHL BX,CL
OR AX,BX ; fix year
MOV BX,DX
AND BX,0F00H
MOV CX,3
SHR BX,CL
OR AX,BX ; fix month
MOV BX,DX
AND BX,001FH
OR AX,BX ; fix day
POP DX
MOV [DI+18H],AX ; put in date
PUSH DX
MOV AH,2CH
INT 21H ; get time
XOR AX,AX
PUSH CX ; save a copy
MOV BX,CX
AND BX,1F00H
MOV CX,3
SHL BX,CL
OR AX,BX ; fix hour
POP CX
MOV BX,CX
AND BX,003FH
MOV CX,5
SHL BX,CL
OR AX,BX ; fix mins
MOV BX,DX
AND BX,0FF00H
SHR BX,1 ; make half secs
AND BX,1F00H
XCHG BH,BL
OR AX,BX ; fix half secs
POP DX
MOV [DI+16H],AX
RET
PUBLIC SHOFS,SHOFS0,SHOFS1,SHOFSA,SHOFS2
SHOFS: ; show file stats
PUSH AX
PUSH BX
PUSH CX
PUSH SI
PUSH DI
PUSH BP
PUSH DX
ADD DX,1AH ; file size ptr
MOV DI,OFFSET SIZF
MOV AX,2020H
MOV CX,4
REP STOSW
MOV SI,DX
MOV DI,[SI+2] ; size high word
MOV SI,[SI] ; size low word
MOV AX,SI
OR AX,DI
JNZ SHOFS0
MOV AL,SFLAG
AND AL,0DFH ; make upper case
CMP AL,VOLFLG
JZ SHOFS1
CMP AL,DIRFLG
JZ SHOFS1
SHOFS0: CALL SETSIZ
SHOFS1: MOV DX,OFFSET SIZF
MOV AL,FIELD
CMP AL,' '
JZ SHOFS2
PUSH DX
MOV DL,FIELD
CALL WRITC
POP DX
PUSH DI
MOV DI,DX
MOV AL,[DI]
CMP AL,' '
JZ SHOFSA
MOV AL,QMARK ; use ? to show overflow
PUSH CX
MOV CX,8
REP STOSB
POP CX
SHOFSA: POP DI
INC DX
SHOFS2: CALL WRIS0 ; write string to null
MOV DL,FIELD
CALL WRITC ; size-date separator
POP DX
PUSH DX
ADD DX,18H ; find buffer date ptr
MOV SI,DX
MOV AX,[SI]
CALL SHODATE
MOV DL,FIELD
CALL WRITC ; date-time separator
POP DX
PUSH DX
ADD DX,16H ; find buffer time ptr
MOV SI,DX
MOV AX,[SI]
CALL SHOTIME
POP DX
POP BP
POP DI
POP SI
POP CX
POP BX
POP AX
RET
PUBLIC SETSIZ,SETS1,SETS2,SETS3,SET4,SET5
SETSIZ: ; set file size into buffer
; SI,DI file size
MOV WORD PTR SIZN,0
XOR AX,AX
MOV BX,AX ; start with 0 in BX
MOV BP,AX ; start with 0 in BP
MOV CX,32 ; use all 32 bits of double word
SETS1: SHL SI,1 ; shift low word left
RCL DI,1 ; rotate hi word left through carry
; carry now has current high bit of double
word
XCHG BP,AX ; use BP first
CALL MDAX ; al+al+c, ah+ah+c', DAA each
XCHG BP,AX ; save resultant BCD quartet
XCHG BX,AX ; now use BX
CALL MDAX ; al+al+c'',ah+ah+c''', DAA each
XCHG BX,AX ; and save in BX
ADC AL,0 ; accum last carry in AL
LOOP SETS1
MOV CX,WORD PTR 1710H
MOV AX,BX ; [never mind AL=0.1 to 9.9 billion]
CALL SETS2 ; do BX BCD quartet
MOV AX,BP ; now do BP quartet
SETS2: PUSH AX
MOV DL,AH ; start with high BCD doublet
CALL SETS3
POP DX ; then do low BCD doublet
SETS3: MOV DH,DL ; repeat doublet
SHR DL,1
SHR DL,1
SHR DL,1
SHR DL,1
CALL SET4 ; do high BCD singlet in bits 0-3
MOV DL,DH ; now do low singlet
SET4: AND DL,0FH ; drop bits 4-7
JZ SET5 ; have first of BCD pair
MOV CL,0 ; CL=0 for second of BCD pair
SET5: DEC CH
AND CL,CH
OR DL,30H ; set '0' offset bits
SUB DL,CL ; drop by 16 for first of BCD pair
PUSH DI
MOV DI,OFFSET SIZF ; ascii file size buffer
ADD DI,WORD PTR SIZN
INC WORD PTR SIZN
MOV [DI],DL ; put in decimal digit
POP DI
RET
PUBLIC MDAX
MDAX: ADC AL,AL ; add al to al with carry bit
DAA ; decimal adj al
XCHG AL,AH ; now do the same with ah
ADC AL,AL
DAA
XCHG AL,AH
RET
PUBLIC SHODATE,SHODAT1,WRIHEX
SHODATE:
OR AX,AX
JNZ SHODAT1
MOV DL,NODAT
MOV CX,8
CALL WRICX
RET
SHODAT1:
PUSH AX
AND AX,WORD PTR 0FE00H
MOV CL,9
SHR AX,CL
ADD AX,80 ; dates start with 1980
CALL WRIHEX ; write year
MOV DL,'/'
CALL WRITC
POP AX
PUSH AX
AND AX,WORD PTR 01E0H
MOV CL,5
SHR AX,CL
CALL WRIHEX ; write month
MOV DL,'-'
CALL WRITC
POP AX
AND AX,1FH
WRIHEX: AAM
OR AX,WORD PTR 3030H ; '00'
PUSH AX
MOV DL,AH
CALL WRITC ; write tens of day
POP AX
MOV DL,AL
CALL WRITC ; write ones of day
RET
GIVCR: MOV SI,OFFSET CPYR
GIVCRL: LODSB
AND AL,AL
JZ GIVCRE
NOT AL
MOV AH,2
MOV DL,AL
INT 21H
JMP SHORT GIVCRL
GIVCRE: RET
PUBLIC SHOTIME,SHOTS,SHOTIM1,SHOWTIM2
SHOTIME:
OR AX,AX
JNZ SHOTIM1
MOV DL,NOTIM
MOV CX,5
TEST SECSW,1
JZ SHOTS
MOV CX,8
SHOTS: CALL WRICX
RET
SHOTIM1:
PUSH AX
AND AX,WORD PTR 0F800H
MOV CL,0BH
SHR AX,CL
CALL WRIHEX ; write hour
MOV DL,':'
CALL WRITC
POP AX
PUSH AX
AND AX,WORD PTR 07E0H
MOV CL,5
SHR AX,CL
CALL WRIHEX ; mins
TEST SECSW,1
JZ SHOWTIM2
MOV DL,':'
CALL WRITC
POP AX
PUSH AX
AND AX,1FH ; secs
SHL AX,1
CALL WRIHEX
SHOWTIM2:
POP AX
RET
PUBLIC WRITC,WRITCE,WRICXR,WRICX,WRICZR,WRIS0,WRIS0G,WRIS0E,WRIS0T
PUBLIC WRITCR,WRITCRC
WRITC: ; write dl to buffer
PUSH BX
MOV BX,LBUFN
AND BH,BH
JNZ WRITCE
PUSH DI
MOV DI,OFFSET LBUFF
MOV [DI+BX],DL
INC LBUFN
POP DI
WRITCE: POP BX
WRICXR: RET
WRICX: ; write cx bytes from DL to buffer
JCXZ WRICXR
PUSH BX
MOV BX,LBUFN
MOV AX,BX
ADD AX,CX
AND AH,AH
JNZ WRICZR
ADD LBUFN,CX
PUSH DI
MOV DI,OFFSET LBUFF
ADD DI,BX
MOV AL,DL
REP STOSB
POP DI
WRICZR: POP BX
RET
WRIS0: ; write from [dx] to buffer
; stop at 0 in [dx]
PUSH BX
PUSH CX
PUSH DX
PUSH SI
PUSH DI
MOV DI,DX
XOR AL,AL
XOR CX,CX
INC CH ; 256
REPNZ SCASB
MOV CX,DI
DEC CX
SUB CX,DX ; bytes to 0
JZ WRIS0E
MOV SI,DX
MOV BX,LBUFN
MOV AX,BX
ADD AX,CX ; anticipated new length
AND AH,AH
JNZ WRIS0T
WRIS0G: ADD LBUFN,CX
MOV DI,OFFSET LBUFF
ADD DI,BX
REP MOVSB
WRIS0E: POP DI
POP SI
POP DX
POP CX
POP BX
RET
WRIS0T: XOR CX,CX
INC CX ; 256
SUB CX,BX ; sub LBUFN
JC WRIS0E
JMP WRIS0G
WRITCR: ; write cr, lf to buffer, then send to device
PUSH BX
PUSH CX
PUSH DX
PUSH DI
MOV BX,WORD PTR LBUFN
MOV DI,OFFSET LBUFF
MOV BYTE PTR [DI+BX],CR
MOV BYTE PTR [DI+BX+1],LF
INC BX
INC BX
MOV CX,BX
MOV BX,CATHAN
MOV DX,DI
MOV AH,40H
PUSH CX
INT 21H
POP CX
CMP AX,CX
MOV LBUFN,0
POP DI
POP DX
POP CX
POP BX
JNZ WRITCRC
RET
WRITCRC:
MOV DX,OFFSET ERR$
CALL STRCON
CALL SHOCAT
CALL CONCRL
MOV AL,6 ; cats.dir write errorlevel=6
JMP EXIT
PUBLIC SHOCAT,SHOLAB,CONCRL,STRCON,STRCL,STRCE
SHOCAT: ; send catdir buffer to console to
null
PUSH DX
MOV DX,OFFSET CATDIR
CALL STRCON
POP DX
RET
SHOLAB: ; send vlab buffer to console to null
PUSH CX
PUSH DX
PUSH DI
MOV DI,OFFSET VLAB
MOV DX,DI
XOR AL,AL
MOV CX,48
REPNZ SCASB
DEC DI
CALL STRCON ; to catalog
POP DI
POP DX
POP CX
RET
PUBLIC CLNAME ; get program name from environment
 ; and put into DX if DOSVER=3
CLNAME: CMP DOSVER,3
JNC CLN1
RET
CLN1: PUSH ES
PUSH DS
PUSH DI
PUSH SI
MOV ES,DS:2CH
XOR AX,AX
MOV DI,AX
MOV CX,4096
REPNZ SCASW
JCXZ CLNF
MOV SI,DI ; save di
MOV DI,AX ; zero di
MOV CX,4096
INC DI
REPNZ SCASW
JCXZ CLNF
CMP SI,DI
JNC CLN2
MOV DI,SI
CLN2: ADD DI,2
MOV SI,DX
XCHG SI,DI
MOV AX,ES
MOV CX,DS
MOV ES,CX
MOV DS,AX
MOV CX,78
CLNM: LODSB
STOSB
AND AL,AL
JZ CLNS
LOOP CLNM
CLNF: STC
CLNS: POP SI
POP DI
POP DS
POP ES
RET
ANSWER: CALL STRCON ; show question
MOV AH,1
INT 21H
PUSH AX
CALL CONCRL
POP AX
AND AL,5FH
CMP AL,'Y'
JZ ANSWY ; zero means Yes
CMP AL,'N'
JZ ANSWN
STC ; carry means no answer
ANSWY: RET
ANSWN: AND AL,AL ; not zero means No
RET
CONCRL: ; send cr, lf to console
PUSH DX
MOV DX,OFFSET CRLF$
CALL STRCON
POP DX
RET
STRCON:
PUSH AX
MOV AH,6
PUSH SI
PUSH DX
MOV SI,DX
STRCL: LODSB
AND AL,AL
JZ STRCE
MOV DL,AL
INT 21H
JMP STRCL
STRCE: POP DX
POP SI
POP AX
RET
EVEN
DW 0
FILBUF EQU $
ARCDTA EQU $+128
ARCPATH EQU $+256
PUBLIC DTAB
DTAB EQU FILBUF+512 ; DTA find buffers
CATS ENDS
END START
;