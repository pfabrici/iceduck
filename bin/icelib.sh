_usage() {
	exit 2
}

_parseargs() {
	ARGS=$(getopt -o f:c:o: --long file:,command:,opts: -- "$@")
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
									_usage
								fi
								shift
								;;
		-f | --filename)   	EXEC="file"
							FNAME="$2"
							[ ! -f $FNAME ] && { ECODE=10; _usage; }
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
		--) shift; break ;;
		*) shift; break ;;
	esac
	shift  
	done

	[ "X${FNAME}" != "X" -a "X${CLICMD}" != "X" ] && _usage
	[ "X${EXEC}" == "X" ] && EXEC="shell"
}