#!/bin/bash
set -e

#see: https://github.com/<tenant>/<repo>/settings/actions/runners/new?arch=x64&os=linux

GH_RUNNER_VERSION="2.311.0"
GH_RUNNER_HASH="29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278"

GH_RUNNER_TARFILE="actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz"
GH_DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/${GH_RUNNER_TARFILE}"


echo "github runner version: ${GH_RUNNER_VERSION}"

if [ ! -f ${GH_RUNNER_TARFILE} ] ; then
  echo "downloading ${GH_RUNNER_TARFILE}..."
  curl -o ${GH_RUNNER_TARFILE} -L ${GH_DOWNLOAD_URL}
fi

echo "verify hash..."
# TWO whitespaces     >  <
echo "${GH_RUNNER_HASH}  ${GH_RUNNER_TARFILE}" | shasum -a 256 -c
echo "ok"

#repo="https://github.com/<tenant>/<repo>"
#token="BC4..."

read -p "Enter repo, e.g. https://github.com/<tenant>/<repo>: " repo
read -sp "Enter token, e.g. BC4Q.... : " token
echo


#echo "repo: $repo"
#echo "token: $token"

if [ -z ${repo} ] ; 
then
  echo "repo missing";
  exit 1
fi

if [ -z ${token} ] ;
then
  echo "token missing";
  exit 1
fi


now=$(date '+%Y%m%d_%H%M%S')
imagename="${HOSTNAME}-ghrunner:${now}"
runnername="${HOSTNAME}-ghrunner_${now}"

echo "Thank you. Building image '$imagename'"

if [ -d tmp-extracted ] ; then
  rm -rf ./tmp-extracted
fi

old=$(pwd)
mkdir tmp-extracted && cd tmp-extracted
echo "extracting (because docker-build did not extract properly) $GH_RUNNER_TARFILE"
tar xfz ${old}/${GH_RUNNER_TARFILE}
cd $old

cat > launch-helper.sh << EOF
#!/bin/bash
set -e
if [ ! -f launched.txt ] ; then
  echo "first start - call config.sh "
  ./config.sh --url $repo --token $token --name $runnername --work _work --unattended
  date > launched.txt
fi
echo "now calling run.sh"
./run.sh
EOF

chmod +x launch-helper.sh

sudo docker build -t $imagename .

rm launch-helper.sh


launchfile="run-${imagename}.sh"
cat << EOF >> $launchfile
sudo docker run \
  --network auto-publisher \
  --name githubrunner-$imagename \
  $imagename
EOF

chmod +x $launchfile

echo "bye!"
