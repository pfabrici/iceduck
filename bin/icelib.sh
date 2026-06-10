_usage() {
	ECODE=$1

	echo "Parameter :"
	echo "	-f <Filename> : executes the contents of <Filename> "
	echo " 	-c '<command>' :  executes the single command that ios given in the parameter."
	echo "                   <command> should be put in brackets"
	echo "                   Can not be combined with -f"

	case "$ECODE" in
		0)	echo "Show help" ;;
		11)	echo "Error: File $FNAME does not exit" ;;
		*) echo "Unknown error code" ;;
	esac

	exit $ECODE
}

_parseargs() {
	ARGS=$(getopt -o hf:c:o: --long file:,command:,opts: -- "$@")
	[ $? -ne 0 ] && _usage
	POS=0

	eval set -- "$ARGS"
	while [ 1 == 1 ]; do
	POS=$(( POS + 1 ))
	case "$1" in
		duckdb|trino|psql|mc| \
		iceshell|sparkshell| \
		pyspark|sparksql|trino)	if [ $POS -eq 1 ] ; then 
									APP=$1
								else
									_usage 10
								fi
								shift
								;;
		-f | --filename)   	EXEC="file"
							FNAME="$2"
							[ ! -f $FNAME ] && { ECODE=11; _usage; }
							shift  
							;;
		-c | --command)     EXEC="clicmd"
							CLICMD="${2}"
							echo "+++ 1 :$CLICMD"
							shift 
							;;
		-o | --opts) 		CLIOPTS="${CLIOPTS} $2"
							shift; 
							break ;;
		-h | --help)		_usage 0 ;;
		--) shift; break ;;
		*) shift; break ;;
	esac
	shift  
	done

	[ "X${FNAME}" != "X" -a "X${CLICMD}" != "X" ] && _usage
	[ "X${EXEC}" == "X" ] && EXEC="shell"
}