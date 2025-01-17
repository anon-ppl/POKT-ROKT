#!/usr/bin/bash
# rokt.v1.0.1
# ========================================
function loadExternalValidators {


# = = = = manually edit / insert external nodes into eVALS list: max = 15
# format = 
#             <doublequote>
# Validator address <comma>
#   Refrence number <comma>    { any two digit number between 01 and 30 }
#         Nick name <comma>    { any 5 chars }
#	  User name <coma>     { used to ssh into remote machine }
#     Validator URL <comma>    { IP or the URL no "https://" prefix no ":port" sufix }
#               unk <comma>    { this makes space for the block height to be tracked }
#         unk <doublequote>    { this makes space for the node status to be tracked }
#
# Sample:
#         "e09ce22e0abfd8129776128c0c9b3836024d8c6e,01,POKT1,username,node1.mainnet.pocket.network,unk,unk"

        eVALS=(
"e09ce22e0abfd8129776128c0c9b3836024d8c6e,01,POKT1,username,node1.mainnet.pocket.network,unk,unk"


)
}
# =========================================
function setColorConstants {
      GRN='\033[1;32m'
      RED='\033[0;31m'
      CYA='\033[1;36m'
      NC='\033[0m' # No Color
      BLI='\033[5m' # Blink

}
# =========================================
function setDrawingConstants {
      BON='\033(0'
      BOF='\033(B'
        DASH="qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
       DASH3t="qqqqqqqqqqqqqqqqqqqqqqqqqqqqwqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqwqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"
       DASH3b="qqqqqqqqqqqqqqqqqqqqqqqqqqqqvqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqvqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq"

       SPACE="                                                                                                        "
      THIRDS="                            x                                   x                                       "
}
# =========================================
function setCursorConstants {
      CCD='\033[2J'   # Cursor Clear Down
      CCR='\033[0K'   # Cursor clear Right
      CCL='\033[1K'   # Cursor clear Left
      CGH='\033[1;1H' # Cursor Go Home
      CGT='\033['     # Cursor Go TO  x;yH
      setScrollArea='\033[20;40r'
      lockScrollArea='\033[?6h'
      releaseScrollArea='\033[r'
}
# ========================================
function error_exit()
{
#  echo "$1" 1>&2
  if $breakOnError ; then echo "$1" 1>&2; echo "Aborting";exit 1; fi
}
# =========================================
function initWindow {
	$(resize -s 40 100 >/dev/null )  
       echo -e ${CGH}${CCD}      
}
# ===========================================
function setGlobalVars {
export LC_NUMERIC="en_US.UTF-8"
breakOnError="false"
autoRestart="false"
LastHeight="0"
prow="38"
tmenu="static"
restartCounter=0
CurAUT="$restartCounter"
lscreen=(
	"STA,C,4,3,25,1,CurSTA,Status: "
	"VAL,C,7,3,63,1,CurVAL,Validator address: "
        "BAL,NC,8,3,37,1,CurBAL,Validator balance: "	
	"RUN,N,4,25,20,1,CurRUN,(PID): "
	"DOM,C,3,3,41,1,CurDOM,Domain: "
	"HEI,N,4,65,20,1,CurHEI,Local Height: "
	"FIR,C,3,67,24,1,CurFIR,UFW Status: "
	"NGI,C,3,42,23,1,CurNGI,Nginx Status: "
	"NET,C,4,47,18,1,CurNET,ChainID: "
	"NOD,B,7,65,20,1,CurNOD,Jailed: "
	"CLA,AD,12,71,6,16,CurCLA,"
	"CLB,AD,12,77,11,16,CurCLB,- "
	"STK,C,8,65,21,1,CurSTK,Staked: "
	"AUT,N,9,65,21,1,CurAUT,Restarts: "
	"24B,NC,8,38,24,1,Cur24B,24h Chg: "
	"VVV,AS,12,2,26,31,eVALS,"
	"NUM,N,5,43,20,1,CurNUM,Staked Vals: "
	"NUM,N,5,66,20,1,CurAPP,Staked Apps: "
	"TIM,MS,5,3,30,1,CurTIM,Next Block in: "
	"CHJ,AD,12,30,7,16,CurCHJ,"
	"CHU,AD,12,36,27,16,CurCHU,= "
        )
lscreentext=(
	"0,1,ROKT v1.0.1 - Ben@BenVan.com 2020/Dec/08 - Free and Open Source... enjoy!"
	"10,4,External Validators "
	"10,38,local chains.json "
	"11,30,Chain =  URL"
	"10,73,Pending Claims "
	"11,72,Chain-   Proofs "
	"11,2,N## = choice | N00=Local"
        )

qscreentext=(
        "0,1,ROKT v1.0.1 - Ben@BenVan.com 2020/Dec/08 - Free and Open Source... enjoy!"
	"3,5,Queries (see stuff)"
	"3,33,Actions (do stuff)"
	"3,68,Changes (break stuff)"
        "5,2,DIS - show ${CYA}dis${NC}k space"
	"6,2,FRE - show ${CYA}fre${NC}e memory"
	"7,2,${CYA}- - - - - - - - - - - - -${NC}"
	"5,30,RUN - Is Pocket ${CYA}run${NC}ning?"
	"6,30,STA - ${CYA}sta${NC}rt Pocket- in Background"
	"5,66,CHA - edit ${CYA}cha${NC}ins.json"
	"7,30,SIM - start Pocket- ${CYA}sim${NC}ulateRelay"
	"8,30,RES - Pocket- ${CYA}Res${NC}et[ Danger! ]"
	"6,66,CON - edit ${CYA}con${NC}fig.json"
	"7,66,GIN - edit n${CYA}gin${NC}x config"
	"8,66,${CYA}- - - - - - - - - - - - -${NC}"
	"9,30,STO - ${CYA}Sto${NC}p Pocket"
	"8,2,HEI - Pocket qery ${CYA}hei${NC}ght"
	"9,2,SEE - show ${CYA}see${NC}ds in use"
	"10,2,VAL - show ${CYA}Val${NC} address"
	"11,2,LIS - ${CYA}lis${NC}t all accounts"
	"12,2,NOD - show ${CYA}nod${NC}e status"
	"13,2,FIR - show ${CYA}fir${NC}ewall status"
	"14,2,NGI - show ${CYA}ngi${NC}nx status"
	"15,2,DOM - Show ${CYA}dom${NC}ain"
	"12,66,${CYA}- - - - - - - - - - - - -${NC}"
	"13,66,CER - ${CYA}Cer${NC}tificate expires"
	"14,66,${CYA}- - - - - - - - - - - - -${NC}"
	"15,66,111:222:333 - ${CYA}men${NC}us"
	"16,2,BAL - ${CYA}bal${NC}ance Val address"
	"17,2,CLA - show pending ${CYA}cla${NC}ims"
	"18,2,NUM - ${CYA}num${NC}ber Vals & Apps"
	"9,66,N## - external node ${CYA}##${NC}"
	"10,66,N99 - check all nodes ${CYA}99${NC}"
	"11,66,N00 - local node ${CYA}00${NC}"
	"10,30,${CYA}- - - - - - - - - - - - -${NC}"
	"11,30,DIR - ${CYA}dir${NC}ect chain.json relays"
	"12,30,BRY - ${CYA}Br${NC}eak on error (${CYA}Y${NC}ES)"
	"13,30,BRN - ${CYA}Br${NC}eak on error (${CYA}N${NC}O)"	
	"14,30,AUT - ${CYA}Au${NC}to Restart (${CYA}T${NC}rue)"
        "15,30,AUF - ${CYA}Au${NC}to Restart (${CYA}F${NC}alse)"
	"16,30,${CYA}- - - - - - - - - - - - -${NC}"
	"17,30,SEN - ${CYA}Sen${NC}d pokt"
        "18,30,T## - Terminal to node ##"
	"18,66,X - ${RED}EXIT${NC}"
)
}
# ========================================
function drawqmenuframe {
echo -e "${BON}l${DASH:1:90}k${BOF}"
echo -e "\x1b(0x${SPACE:1:90}x\x1b(B"
echo -e "\x1b(0t${DASH3t:1:90}u\x1b(B"
for i in {1..14}
do
echo -e "\x1b(0x${THIRDS:1:90}x\x1b(B"
done
echo -e "\x1b(0m${DASH3b:1:90}j\x1b(B"
}
function drawqmenutext {
  for item in "${qscreentext[@]}"
  do
     readarray -td, a <<<"$item,"; unset 'a[-1]';
     posR="${a[0]}";
     posC="${a[1]}";
     disc="${a[2]}";
     line="${CGT}${posR};${posC}H $disc"
     echo -e "$line"
  done
}
# ========================================
function drawlmenuframe {
echo -e "${BON}l${DASH:1:90}k${BOF}"
echo -e "\x1b(0x${SPACE:1:90}x\x1b(B"
echo -e "\x1b(0x${SPACE:1:90}x\x1b(B"
echo -e "\x1b(0x${SPACE:1:90}x\x1b(B"
echo -e "\x1b(0t${DASH:1:90}u\x1b(B"
for i in {1..3}
do
echo -e "\x1b(0x${SPACE:1:90}x\x1b(B"
done
echo -e "\x1b(0t${DASH3t:1:90}u\x1b(B"
echo -e "\x1b(0x${THIRDS:1:90}x\x1b(B"
for i in {1..25}
do
echo -e "\x1b(0x${THIRDS:1:90}x\x1b(B"
done
echo -e "\x1b(0m${DASH:1:90}j\x1b(B"
}
function drawlmenutext {
  for item in "${lscreentext[@]}"
  do
     readarray -td, a <<<"$item,"; unset 'a[-1]';
     posR="${a[0]}";
     posC="${a[1]}";
     disc="${a[2]}";
     line="${CGT}${posR};${posC}H $disc"
     echo -e "$line"
  done

}
# ==========================================
function createMenuStrings {
#    tmenu="static"
    Lmenu=""
    Fmenu=" \e[7m  ===== Screen & set-up Notes ================= \e[0m
    You may need to manually increese the screen size:
    Minimum screen size (100 colums 40 rows)
    Color test: ${RED}red ${GRN}green ${CYA}blue ${NC} none
    If you see:'qqqqqqqqqqq' instead of a streight line below:
    ${BON}qqqqqqqqqqq${BOF} set the terminal charset to: ISO-8859-16

    all menu choices are 3 character auto terminate no <enter> key

    3 screens available: 

    111 = This, 
    222 = live monitor, 
    333 = Direct commands
    x to exit 
    
    External validators must be set by hand 
    (see comments at the top of this file for examples)


    Thank you
    -BenVan
    "
  
   Cmenu=$Fmenu # set inital current menu to full menu
}
# ========================================================================
function showTime  {
    num=$1
    min=0
    hour=0
    day=0
    if ((num>59));then
        ((sec=num%60))
        ((num=num/60))
        if ((num>59));then
            ((min=num%60))
            ((num=num/60))
            if ((num>23));then
                ((hour=num%24))
                ((day=num/24))
            else
                ((hour=num))
            fi
        else
            ((min=num))
        fi
    else
        ((sec=num))
    fi
    if ((sec<10));then
        sec="0$sec"
    fi
    timeOut="${min}:${sec}"
}
# ========================================================================
# ==    All the case calls
#=========================================================================
function fSta {
        $(pocket start >/dev/null &)
        fRun
        CurSTA="Launched into Background"
        if [ "$localVAL" == "external" ];
        then
           CurSTA="        "
        fi

}
function fRun {
        CurRUN=$(ps -C pocket | grep "pocket")
        CurRUN="${CurRUN:0:7}"
  	if [ "$CurRUN" != "" ]
  	then 
		CurSTA="${GRN}Running local${NC}"
		localVAL="local"
  	else 
		CurSTA="${RED}Not Running${NC}"
		if [ "$autoRestart" == "true" ]
		then
			let "restartCounter = $restartCounter + 1"
			CurAUT="$restartCounter"
			CurSTA="${NC}RESTARTING${NC}"
			showlmenu RUN one $tmenu
			sleep 5
			$(pocket start >/dev/null &)

		fi
  	fi
        if [ "$localVAL" == "external" ]; 
	then
		if [ "$CurEHEI" != "" ]
		then
			CurSTA="Running xtrnl${NC}"
			CurRUN="Unknown    "
		else
		CurRUN="        "
		CurSTA="        "
		fi 
        fi
}
function fRes {
        $(pocket reset)  || error_exit "Reset failed @line $LINENO."
        CurSTA="Reset - need start"
        if [ "$localVAL" == "external" ];
        then
           CurSTA="        "
        fi
}

function fVal {
    	if [ "$localVAL" != "external" ]
    	then	    
                CurVAL=$(pocket accounts get-validator | grep 'Validator') || error_exit "Validator not found @line $LINENO."
                CurVAL=${CurVAL:18:999}
    	fi
}
function fDom {
	CurDOM=$(pocket query node $CurVAL |  grep -Po '((?<=service_url":.)|(?<=service_url":."))([^",\r\n]+)(?=[",\r\n]*)') || error_exit "No Domain for validator: $CurVAL @line $LINENO"
}
function fHei { 
	CurHEI=$(pocket query height | grep -Po '((?<=height":.)|(?<=height":."))([^",\r\n]+)(?=[",\r\n]*)') || error_exit "Failed to grep height @line $LINENO";
}
function fBal {
	  CurBAL=$(pocket query balance $CurVAL | grep -Po '((?<=balance":.)|(?<=balance":."))([^",\r\n]+)(?=[",\r\n]*)')  || error_exit "query balance failed @line $LINENO."
        	if [ $CurHEI>96 ]
  	        then
  	        	Cur24B="$(($CurHEI - 96))"
  		        Cur24B=$(pocket query balance $CurVAL $Cur24B | grep -Po '((?<=balance":.)|(?<=balance":."))([^",\r\n]+)(?=[",\r\n]*)') || error_exit "query balance at height failed @line $LINENO."
  		        let "Cur24B = $CurBAL - $Cur24B"
  	        fi
}
function fFir {
	if [[ $EUID = 0 ]] 
	then
		CurFIR=$(sudo ufw status | grep 'Status:')
		CurFIR=${CurFIR:8} 
        else
		CurFIR="Need SUDO"
	fi
        if [ "$localVAL" == "external" ]; 
	then
           	CurFIR="        "
        fi
}
function fNgi {
	CurNGI=$(service nginx status | grep "Active:") || error_exit "query nginx failed @line $LINENO."
	CurNGI=${CurNGI:13:7}
        if [ "$localVAL" == "external" ]; 
	then
           CurNGI="        "
        fi
}
function fNet {
	whatNET=$(cat .pocket/config/config.json | grep "Seeds") || error_exit "query seeds failed @line $LINENO."
	whatNET=${whatNET:22:5}
	case "$whatNET" in
		03b74 )	 CurNET="mainnet";;
		b3d86 )  CurNET="testnet";;
		* ) CurNET="Unknown"
	esac
        if [ "$localVAL" == "external" ]; 
	then
           CurNET="        "
        fi
}
function fNod {
        CurNOD=$(pocket query node $CurVAL | grep "jailed") || error_exit "query node:$CurVAL: failed @line $LINENO."
	CurNOD=${CurNOD:14:5}
	if [ "${CurNOD:0:4}" == "true" ]
	then
		CurNOD="${RED}$CurNOD${NC}"
	else
		CurNOD="${GRN}$CurNOD${NC}"
	fi
}
function fCla {
	CurCLAc=($(pocket query node-claims $CurVAL | grep -Po '((?<=chain":.)|(?<=chain":."))([^",\r\n]+)(?=[",\r\n]*)')) 
	CurCLAp=($(pocket query node-claims $CurVAL | grep -Po '((?<=total_proofs":.)|(?<=total_proofs":."))([^",\r\n]+)(?=[",\r\n]*)'))
        if [ "$CurCLAc[0]" == "" ]
	then
	     	CurCLA="none"
	     	CurCLB="none"
	else
		CurCLA=("${CurCLAc[@]}")
		CurCLB=("${CurCLAp[@]}")	       
	fi	
}
function fCer {
	echo -ne "${CGT}1;1H"
	certDOM=${CurDOM:8:999}
	echo | openssl s_client -servername $certDOM -connect $certDOM 2>/dev/null | openssl x509 -noout -dates | grep 'After'
}
function fStk {
	CurSTK=$(pocket query node $CurVAL | grep -Po '((?<=status":.)|(?<=status":."))([^",\r\n]+)(?=[",\r\n]*)') || error_exit "query node failed @line $LINENO."
	case $CurSTK in
		1 ) CurSTK="Unstaking";;
	        2 ) CurSTK="${GRN}true${NC}";;
	        * ) CurSTK="${RED}false${NC}";;
	esac 
}
function fVvv {
	CurVVV=$eVALS
}
function fNum {
	CurNUM=$(pocket query nodes --staking-status=2 | grep -Poc "false") || error_exit "query nodes failed @line $LINENO."
}
function fApp {
	CurAPP=$(pocket query apps --staking-status=2 | grep -Poc "false") || error_exit "query apps failed @line $LINENO."
}
function fTim { 
	CurTIM=$(( 900 - $SECONDS ))
}
function fChj {
	fullText=$1
        CurCHJ=($(cat .pocket/config/chains.json | grep -Po '((?<=id":.)|(?<=id":."))([^",\r\n]+)(?=[",\r\n]*)')) || error_exit "query chains.json failed @line $LINENO." 
        CurCHU=($(cat .pocket/config/chains.json | grep -Po '((?<=url":.)|(?<=url":."))([^",\r\n]+)(?=[",\r\n]*)')) || error_exit "query chains.json failed @line $LINENO."
        for ((i=0;i<${#CurCHJ[@]};++i)); 
	do
	  case "${CurCHJ[i]}" in
	  0001 ) 
		  PokBlockHeight=""
                 PokBlockHeight=$(curl -s -m 2 -XPOST "${CurCHU[$i]}/v1/query/height" | grep -Po '((?<=height":.)|(?<=height":."))([^",\r\n]+)(?=[",\r\n]*)')

		if [ "$PokBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
	        else
		CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
		then
		  ts=$(date +%s%N)
          printf \n 
          printf \n 
		  echo $(curl -s -m 2 -XPOST "${CurCHU[$i]}/v1/query/height")
                  echo "Round trip to Pocket in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
		fi
	  ;;
	  0021 ) EthBlockHeight=""
		EthBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]}  | grep -Po '((?<=result":.)|(?<=result":."))([^",\r\n]+)(?=[",\r\n]*)')
		if [ "$EthBlockHeight" != "" ]
		then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
	        else
		CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
		fi
		if [ "$fullText" == "full" ]
		then
		  ts=$(date +%s%N)
		  echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq .result)
                  echo "Round trip to ETH in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
		fi
	  ;;
          0023 ) 
                  EthROBlockHeight=""
                EthROBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]}  | grep -Po '((?<=result":.)|(?<=result":."))([^",\r\n]+)(?=[",\r\n]*)')
                if [ "$EthROBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH Ropsten in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0024 ) 
                  EthKOBlockHeight=""
                EthKOBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]}  | grep -Po '((?<=result":.)|(?<=result":."))([^",\r\n]+)(?=[",\r\n]*)')
                if [ "$EthKOBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH Kovan in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0025 ) 
                  EthRBlockHeight=""
                EthRBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]}  | grep -Po '((?<=result":.)|(?<=result":."))([^",\r\n]+)(?=[",\r\n]*)')
                if [ "$EthRBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH Rinkeby in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0026 ) 
                  EthGBlockHeight=""
                EthGBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":5}' ${CurCHU[$i]}  | grep -Po '((?<=result":.)|(?<=result":."))([^",\r\n]+)(?=[",\r\n]*)')
                if [ "$EthGBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 2 -XPOST "${CurCHU[$i]}" -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH Goerli in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0028 ) 
		  EthartrBlockHeight=""
                EthartrBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params",:[],"id":64}' ${CurCHU[$i]})
                if [ "$EthartrBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH-Archive-Trace in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0022 ) 
                  EtharARBlockHeight=""
                EtharARBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params",:[],"id":64}' ${CurCHU[$i]})
                if [ "$EtharARBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":64}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to ETH-Archive in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0052 ) 
                  NEARBlockHeight=""
                NEARBlockHeight=$(curl -s "${CurCHU[$i]}/status" | jq .sync_info.latest_block_height)
                if [ "$NEARBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  echo $(curl -s "${CurCHU[$i]}/status" | jq .sync_info.latest_block_height)
                  echo "Round trip to NEAR in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0054 ) 
                  OSMOBlockHeight=""
                OSMOBlockHeight=$(curl -s ${CurCHU[$i]}/block)
                if [ "OSMOBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  echo $(curl -s ${CurCHU[$i]}/block | jq .result.block.header.height)
                  echo "Round trip to Osmosis in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0009 ) 
                  MATICBlockHeight=""
                MATICBlockHeight=$(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}')
                if [ "$MATICBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to POLYGON in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          000B ) 
                  MATICABlockHeight=""
                MATICABlockHeight=$(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}')
                if [ "$MATICBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to POLYGON Archive in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0046 ) 
                  EVBlockHeight=""
                EVBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$EVBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Evmos in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0005 ) 
                  FUSEBlockHeight=""
                FUSEBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$FUSEBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to FUSE in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          000A ) 
                  FUSEABlockHeight=""
                FUSEABlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$FUSEABlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to FUSE Archive in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0047 ) 
                  OKEXBlockHeight=""
                OKEXBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$OKEXBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to *OkEx* in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0053 ) 
                  OPTBlockHeight=""
                OPTBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$OPTBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Optimism in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0040 ) 
                  HMBlockHeight=""
                HMBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$HMBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Harmony One in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0044 )
                  IOTEXBlockHeight=""
                IOTEXBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'  ${CurCHU[$i]})
                if [ "$IOTEXBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to *IoTeX* in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0048 ) 
                  BOBBlockHeight=""
                BOBBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$BOBBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to *Boba* in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0049 ) 
                  FANBlockHeight=""
                FANBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$FANBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Fantom in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0051 ) 
                  MRBlockHeight=""
                MRBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$MRBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to MoonRiver in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0050 ) 
                  MORBlockHeight=""
                MORBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' ${CurCHU[$i]})
                if [ "$MORBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to MoonBEAM in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          03DF ) 
                  DFBlockHeight=""
                DFBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$DFBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to DFKchain Subnet in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          000C ) 
                  GNABlockHeight=""
                GNABlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$GNABlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Gnosis Archive in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0027 ) 
                  GNBlockHeight=""
                GNBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$GNBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Gnosis in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          000F ) 
                  PMUMBlockHeight=""
                PMUMBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$PMUMBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Polygon Mumbai in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0010 ) 
                  BSCABlockHeight=""
                BSCABlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$BSCABlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Binance SC Archive in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0006 ) 
                  SOLBlockHeight=""
                SOLBlockHeight=$(curl -s -m 3 -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","id":1, "method":"getBlockHeight"}' ${CurCHU[$i]})
                if [ "$SOLBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","id":1, "method":"getBlockHeight"}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Solana in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0004 ) 
                  BSCBlockHeight=""
                BSCBlockHeight=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$BSCBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Binance SC in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0003 ) 
                  AVVER=""
                AVVER=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$AVVER" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]} | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to AVX in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
          0056 ) 
                  KlAYBlockHeight=""
                KlAYBlockHeight=t=$(curl -s -m 3 POST --insecure -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' ${CurCHU[$i]})
                if [ "$KlAYBlockHeight" != "" ]
                then
                CurCHJ[$i]="${GRN}${CurCHJ[$i]}${NC}"
                else
                CurCHJ[$i]="${RED}${CurCHJ[$i]}${NC}"
                fi
                if [ "$fullText" == "full" ]
                then
                  ts=$(date +%s%N)
                  result=$(echo $(curl -s "${CurCHU[$i]}" -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r .result))
                  printf "%d\n" $result
                  echo "Round trip to Klaytn in mili-seconds: $((($(date +%s%N) - $ts)/1000000))"
                fi
          ;;
	  esac
        done
}
function fE00 {
        CurEHEI=$(curl -s -m 2 http://$1:26657/status | grep -Po '((?<=latest_block_height":.)|(?<=latest_block_height":."))([^",\r\n]+)(?=[",\r\n]*)')
}

function fN00 {
    	valChoice=${selection:1:2}
        tlocalVAL=$localVAL
	tCurNOD=$CurNOD
	Eurl=""
	tCurEHEI=$CurEHEI
	tCurVAL=$CurVAL
    	for item in "${eVALS[@]}"
    	do
      		readarray -td, a <<<"$item,"; unset 'a[-1]';
      		if [ "$valChoice" == "${a[1]}" ] || [ "$1" == "all" ] 
      		then
	     		CurVAL="${a[0]}"
			Eurl="${a[4]}"
			fE00 $Eurl
			fNod
			for i in "${!eVALS[@]}"; 
			do
				if [ "${eVALS[$i]}" == "${item}" ] 
				then
				eVALS[$i]="${a[0]},${a[1]},${a[2]},${a[3]},${a[4]},$CurEHEI,$CurNOD}"
				localVAL="external"
				CurVAL="${a[0]}"
				fi
			done
   #          		localVAL="external"
      		fi
		if [ "$1" == "all" ]
		then
			localVAL=$tlocalVAL
			CurVAL=$tCurVAL
			CurEHEI=$tCurEHEI
			CurNOD=$tCurNOD
		fi
		if [ "$valChoice" == "00" ]
		then
			localVAL="local"
			CurEHEI=""
			fVal
		fi
    	done
}
function fT00 {
        valChoice=${selection:1:2}
        for item in "${eVALS[@]}"
        do
                readarray -td, a <<<"$item,"; unset 'a[-1]';
                if [ "$valChoice" == "${a[1]}" ]
                then
			Turl="${a[4]}"
			Tusr="${a[3]}"
                        ssh "$Tusr@$Turl"
                fi
        done
}
function f0001 {
# nothing here yet
echo ""
}
function fSen {
	j=0
	posC=0
	line="${CGT}${j};${posC}H ${NC}"
	out=$(f=${CurBAL#*[,]} printf "%'.${#f}f\n" "$CurBAL")
	line+="${GRN}Send From:${NC} $CurVAL  ${GRN}Available Balance = ${NC}$out"
	echo -e $line;
	j=2
	posC=0
          for i in "${eVALS[@]}";
          do
            readarray -td, v <<<"$i,"; unset 'v[-1]';
            line="${CGT}${j};${posC}H ${NC}"
	    ac="${v[0]:0:6}.... ";
            aa="${v[1]}";
            ab="${v[2]}";

	    line+="${CYA}$aa ${NC}$ab $ac";
            echo -e "$line"

	    posC=$((posC+22))
	    if [ $posC = 88 ]
	    then 
		    j=$((j+1));
		    posC=0;
	    fi
	  done

#  - - - - - - - add the NOT back in to test on a real vaidator != - - - -
        if [ "$localVAL" != "local" ];
        then
           echo "Can only send from local validator.. change node first please."
	   sleep 5
	else
		echo ""
		echo -ne "${GRN}Choose Destination (##): ${NC}"
    	read  toIndex
            ac="";
            ab="";
          for i in "${eVALS[@]}";
          do
            readarray -td, v <<<"$i,"; unset 'v[-1]';
            ad="${v[1]}";
            if [ "$toIndex" == "$ad" ]
            then
            aa="${v[1]}";
            ac="${v[0]}";
            ab="${v[2]}";
            fi
          done
	echo -ne "${GRN}Amount in full POKT (leave off the last 6 digits) : ${NC}"
		read  toAmount
		echo -ne "${GRN}note : ${NC}"
		read note
		echo -e "${CYA}using default fee of 10,000 uPOKT"

		echo "Send from: $CurVAL"
	    	echo "To: $ab - $ac"
		echo -e "Amount of: $toAmount POKT plus fee of 10000 uPOKT${NC}"
#		echo "pocket accounts send-tx $CurVAL $ac ${toAmount}000000 mainnet 10000 $note"
		echo -ne "${GRN}Continue with passphrase: (Y/N)?: ${NC}"
		read YorN
		YorN=${YorN^^}
		if [ "$YorN" == "Y" ]
		then
		       echo -ne "${GRN}enter passphrase: ${NC}"	
			result=$(pocket accounts send-tx $CurVAL $ac ${toAmount}000000 mainnet 10000 $note)
			echo -ne "$result ${NC}"
                fi
	echo -e "Done${NC} .. Press <enter>"
	read YorN
	fi
}
# ========================================================================
function loadStatusValues {

    fHei
    fVal
    fBal
    fDom
    fFir
    fNgi
    fNet
    fNod
    fCla
    fStk
    fVvv
    fNum
    fApp
    fTim
    fChj
    fN00 all
    fRun
}
# ======================================
function setTheBlockTimer {

     SECONDS="0"

}
function showqmenu {
	drawqmenutext
}
# =======================================================================
function showlmenu {

  b=$1; c=$2; d=$3;
if [ "$d" == "live" ]; then
  for item in "${lscreen[@]}"
  do
     readarray -td, a <<<"$item,"; unset 'a[-1]';
#    declare -p a;
     name="${a[0]}";
     vtype="${a[1]}";
     posR="${a[2]}";
     posC="${a[3]}";
     size="${a[4]}";
     depth="${a[5]}";
     Cur="${a[6]}";
     disc="${a[7]}";
     line="${CGT}${posR};${posC}H $disc"
     if [ "$b" == "$name" ] || [ "$c" == "all" ]
     then
        case "$vtype" in
	AS ) # ====== ===== ===== array sublist ==== ===== ==== ====== ==== === ====
		
	  j="$posR"
          k='{'"$Cur"'[@]}'
          eval y='$'$k
	  for i in $y
          do
	    line="${CGT}${j};${posC}H ${NC}$disc"	  
            readarray -td, v <<<"$i,"; unset 'v[-1]';
	    eVadd="${v[0]}";
            eVref="${v[1]}";
            eVnic="${v[2]}";
	    eVhei="${v[5]}";
	    eVnod="${v[6]}";
	    if [[ "$eVhei" ==  "$CurHEI" ]]; then
		    eVhei="${GRN}$eVhei${NC}"
            fi
#            if [[ "$eVnod" ==  "false" ]]; then
#                    eVnod="${GRN}$eVnod${NC}"
#            fi

	    line+="$eVref $eVnic - $eVhei - $eVnod";
	    echo -e "$line"
	    j=$((j+1))
          done
	  

	;;
        AD ) # ====== ===== ===== Array: Down ==== ===== ==== ====== ==== === ====
          j="$posR"
	  m=$((j+depth)) 
          k='{'"$Cur"'[@]}'
          eval y='$'$k
          for i in $y
          do
               line="${CGT}${j};${posC}H $disc"
#  need to clean up this hard-coded hack which prevents long urls from overprinting
#  compute the true size accounting for the non-printing color sequinces 
	       n=${i:0:22}
               line+=" $n"
               filler=$(($size - ( ${#disc} + ${#i} ) ))
               while [ $filler -gt 0 ]
               do
                 line+=" "
                 filler=$[$filler-1]
               done
               echo -e "$line"
               j=$((j+1))
          done
          line="${CGT}${j};${posC}H${BON}${DASH:1:$size}${BOF}"
          echo -e $line
	  j=$((j+1))
	  while [ $j -lt $m ]
	  do
		  line="${CGT}${j};${posC}H${BON}${SPACE:1:$size}${BOF}"
#                  line="${CGT}${j};${posC}H - - -"

		  echo -e "$line"
		  j=$((j+1))
	  done
#	  line="${CGT}${j};${posC}H${BON}${DASH:1:$size}${BOF}"
#	  echo -e $line
	;;
  	MS ) # ===== ===== ===== ===== Time: Minutes and Seconds ==== ====
          tCur=${!Cur}
     	  showTime $tCur
          line+="${CYA}$timeOut${NC}"
          filler=$(($size - ( ${#disc} + ${#timeOut} ) ))
          while [ $filler -gt 0 ] 
          do
                line+=" "
                filler=$[$filler-1]
          done
          echo -e "$line"
        ;;
        NC )  # ====== ===== ===== Number comma ==== ===== ==== ====== ==== === ====
	tCur=${!Cur}
		out=$(f=${tCur#*[,]} printf "%'.${#f}f\n" "$tCur")
#		out=$(printf "%'." ${!Cur})
          line+="${CYA}$out${NC}"
          filler=$(($size - ( ${#disc} + ${#out} ) ))
          while [ $filler -gt 0 ] 
          do
                line+=" "
                filler=$[$filler-1]
          done
          echo -e "$line"
          ;;
	* )  # ====== ===== ===== all other types==== ===== ==== ====== ==== === ====
          line+="${CYA}${!Cur}${NC}"
	  tCur=${!Cur}
	  filler=$(($size - ( ${#disc} + ${#tCur} ) ))
          while [ $filler -gt 0 ] 
	  do 
		line+=" " 
	        filler=$[$filler-1]
	  done	
	  echo -e "$line"
	  ;;
        esac
     fi
  done
fi
}

# ========================================================================
function main {
   selection=
until [ "$selection" == "X" ]; do
    echo -e "${CGH}$Cmenu"    #draw the current menu
    read -t 0.5 -n 100 discard
    echo -e -n "${CGT}${prow};3H${GRN}(111=menu) selection:${NC}      ${CGT}${prow};25H"   #draw the prompt
    read -n3 -t20 selection                                            #get the choice
    selection=${selection^^}    #uppercase the choice
    selection=${selection:0:3}
    case $tmenu in
	    static ) echo -e "${releaseScrollArea}"
		    echo -e "${CCD}"                       #remove previous results
		    ;;
	    live ) echo -e "${releaseScrollArea}"
		    echo -e -n "${CGT}${prow};3H${GRN}(111=menu) selection:${NC}      ${CGT}${prow};25H"
		    ;;
    esac	
    case $selection in

	DIR ) fChj full
	;;
	APP ) echo -e "${CYA}$CurAPP${NC}"
              showlmenu APP one $tmenu
	;;
	BRY ) breakOnError="true"
		echo -e "Break on Error:${CYA}$breakOnError${NC}"
	;;
        BRN ) breakOnError="false"
		echo -e "Break on Error:${CYA}$breakOnError${NC}"
        ;;
        DIS ) echo ""
	      df
	;;
        FRE ) echo ""
	      free 
	;;
        RUN ) fRun ; echo -e "${CYA}$CurRUN${NC}"
	;;
        STA ) fSta ; echo -e "${CYA}$CurSTA${NC}"
	;;
	RES ) fRes ; echo -e "${CYA}$CurSTA${NC}"
        ;;
	SIM ) $(pocket start --simulateRelay >/dev/null &)
	        echo -e "${CYA}pocket simuateRelay started in background${NC}"
	;;
	SEN ) fSen
		echo -e "${releaseScrollArea}"
	 Cmenu="";    tmenu="query"; echo -e ${CGH}${CCD};
                  drawqmenuframe
                  drawqmenutext
                  showqmenu nothing all $tmenu
                echo -e "${setScrollArea}"
                echo -e "${lockScrollArea}"
                echo -e "${CGT}30;3H"
	;;
	AUT ) autoRestart="true"
                echo -e "Auto Restart :${CYA}$autoRestart${NC}"
	;;
        AUF ) autoRestart="false"
                echo -e "Auto Restart :${CYA}$autoRestart${NC}"
	;;
	STO ) pkill "pocket"  # should find a safer way to kill this!!
	;;
	HEI ) fHei
		echo -e "${CYA}$CurHEI${NC}"
		showlmenu HEI one $tmenu
	;;
	SEE ) CMD=${CYA}$(cat .pocket/config/config.json | grep "Seeds")${NC}
		 echo -e "$CMD"
	;;
	CHA )   vi .pocket/config/chains.json
	;;
        CON )   vi .pocket/config/config.json
	;;
	CER )  fCer
		;;
        GIN )   vi /etc/nginx/sites-available/pocket-proxy.conf
	;;
        VAL ) fVal
		 echo -e ${CYA}$CurVAL${NC}
		 showlmenu VAL one $tmenu
	;;
        LIS ) CMD=${CYA}$(pocket accounts list)${NC}
		 echo -e "$CMD"
	;;
        BAL ) fBal
		 echo -e ${CYA}$CurBAL${NC}
		 showlmenu BAL one $tmenu
	;;
        CLA ) fCla
                 echo -e "$CurCLA"
		 showlmenu CLA one $tmenu
		 showlmenu CLB one $tmenu
        ;;
        FIR )  fFir 
		  echo -e "${CYA}$CurFIR${NC}"
		  showlmenu FIR one $tmenu
	;;
	STK )  fStk
       		  echo -e "${CYA}$CurSTK${NC}"
		  showlmenu STK one $tmenu
	;;
        NGI )  fNgi
		  echo -e "${CYA}$CurNGI${NC}"
		  showlmenu NGI one $tmenu
	;;
        111 )     Cmenu=$Fmenu;tmenu="static"
		echo -e "${releaseScrollArea}"
        ;;
	222 )     Cmenu="";    tmenu="live"; 
		echo -e "${releaseScrollArea}"
		echo -e ${CGH}${CCD};
	          drawlmenuframe
		  drawlmenutext
	          showlmenu nothing all $tmenu
	;;
        333 )     Cmenu="";    tmenu="query"; echo -e ${CGH}${CCD};
                  drawqmenuframe
                  drawqmenutext
                  showqmenu nothing all $tmenu
		echo -e "${setScrollArea}"
                echo -e "${lockScrollArea}"
                echo -e "${CGT}30;3H"

	;;
	NOD )  fNod
	          echo -e "${CYA}$CurNOD${NC}"
	          showlmenu NOD one $tmenu
	;;
	NUM )  fNum
		fApp
		  echo -e "${CYA}$CurNUM${NC} : ${CYA}$CurAPP${NC}"
		  showlmenu NUM one $tmenu
	;;
	N00|N01|N02|N03|N04|N05|N06|N07|N08|N09	) fN00
                   loadStatusValues
                   showlmenu nothing all $tmenu
	;;
        N10|N11|N12|N13|N14|N15|N16|N17|N18|N19 ) fN00
                   loadStatusValues
                   showlmenu nothing all $tmenu
        ;;
	N20|N21|N22|N23|N24|N25|N26|N27|N28|N29|N30 ) fN00
                   loadStatusValues
                   showlmenu nothing all $tmenu
        ;;
	N99 ) fN00 all
                   loadStatusValues
                   showlmenu nothing all $tmenu
        ;;
        T00|T01|T02|T03|T04|T05|T06|T07|T08|T09 ) fT00
                   showlmenu nothing all $tmenu
        ;;
        T10|T11|T12|T13|T14|T15|T16|T17|T18|T19 ) fT00
                   showlmenu nothing all $tmenu
        ;;
        T20|T21|T22|T23|T24|205|T26|T27|T28|T29|T30 ) fT00
                   showlmenu nothing all $tmenu
        ;;
	DOM )  fVal
	       fDom
		   echo -e ${CYA}$CurDOM${NC}
		   showlmenu DOM one $tmenu
	;;
        NET )  fNet
		   echo -e ${CYA}$CurNET${NC}
                   showlmenu NET one $tmenu
	;;
        X )    echo -e "${releaseScrollArea}"
		echo -e -n "${CGT}${prow};3H${NC}"
		exit 
	;;
        * )   if [ "$selection" == "" ] && [ "$tmenu" != "static" ]
	      then
		   fHei;
		   if [ "$CurHEI" != "$LastHeight" ]
		   then
			SECONDS=0
			if [ "$LastHeight" == "0" ]
			then
			    LastHeight="$CurHEI"
			    setTheBlockTimer
			fi
			LastHeight="$CurHEI"
			loadStatusValues
	                showlmenu nothing all $tmenu 
		   fi
		   fTim;
		   showlmenu TIM one $tmenu
	      else
		   echo  -n "     unrecognized Menu Choice"
	      fi
	;;
    esac
done
}
    setColorConstants
    setDrawingConstants
    setCursorConstants
    setGlobalVars
    loadExternalValidators
    loadStatusValues
    setTheBlockTimer
    createMenuStrings
    initWindow
    main

