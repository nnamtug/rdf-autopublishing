SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
configfile=$SCRIPT_DIR/config.sh

handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

verify_config() {
    echo "known array 'config[]':"
    for item in "${!config[@]}"
    do
      printf "\t$item\t=>\t${config[$item]} \n"
    done


    echo "nrOf config_modelfolders: ${#config_modelfolders[@]}"
    keys=${!config_modelfolders[@]}
    keys_sorted=$(echo $keys | tr ' ' '\n' | sort | xargs)
    for key in $keys_sorted
    do
      printf "\tconfig_modelfolders[$key]: ${config_modelfolders[$key]} \n"
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

  if [ ! "${#config_modelfolders[@]}" -gt "0" ] ;
  then 
    echo "config_modelfolders must be an array with at least 1 entry"; 
    exit 2
  fi
}

function checkCurlCall {
  local expectedCode=$1
  local http_code=$2
  local tmpfile=$3

  #echo "tmpfile: ${tmpfile}"

  if [ ! -f $tmpfile ] ;
  then 
     exit " not a file $tmpfile"
     exit 4
  fi

  if [ "$expectedCode" != "$http_code" ];
  then
    cat $tmpfile
    rm $tmpfile
    echo "FAILED curl call:  expected http_code $expectedCode, but was $http_code"
    exit 3
  fi
  rm $tmpfile
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

