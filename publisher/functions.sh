SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
configfile=$SCRIPT_DIR/config.sh

handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

verify_config() {
    echo "known array 'config':"
    for item in "${!config[@]}";
     do
       printf "\t$item\t=>\t${config[$item]} \n"
     done

    required_configs=(
      # TEST
      #somethingMISSING
      gitrepo
      graphdb
      modelpath
      repo_prod
      repo_staging
    )

    for c in "${required_configs[@]}" ;
       do
         if [ -z "${config[$c]}" ]
         then
           echo "ERR: configuration missing: 'config[$c]' expected" >&2
           exit 2
         fi
      done
}

function checkCurlCall {
  local expectedCode=$1
  local http_code=$2
  local tempfile=$3

  if [ ! -f $tempfile ] ;
  then 
     exit " not a file $tempfile"
     exit 4
  fi

  if [ "$expectedCode" != "$http_code" ];
  then
    cat $tempfile
    rm $tempfile
    echo "FAILED curl call:  expected http_code $expectedCode, but was $http_code"
    exit 3
  fi
  rm $tempfile
}


# TEST
#configfile="config-NOT.sh"

# INIT config ----------
if [ ! -f "${configfile}" ]
  then
    echo "ERR: file '${configfile}' missing. did you copy config.template to ${configfile}?" >&2
    exit 4
  fi 

source ${configfile}
verify_config

