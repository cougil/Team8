
function show(){
    local asg_type=$1
    local asg_type_w=$2
    echo show ${asg_type}
	curl -sL   ${url}/$region/${asg_type}/show/${asg_type_w}.json
}

function create(){
    local asg_type=$1
    local params=$2
    echo curl -sL  -w \"%{http_code}\" -d \"${params}\" ${url}/${region}/${asg_type}/save -o a.html
    http_code=$(curl -sL  -w "%{http_code}" -d "${params}" ${url}/${region}/${asg_type}/save -o a.html )
	echo Create ${asg_type} ${app} ${http_code} 
}

function exist(){
    local asg_type=$1
    local asg_type_w=$2
	code=$(curl -sL -w "%{http_code}" ${url}/$region/${asg_type}/show/${asg_type_w}.json -o b.html)
	case ${code} in
		200 )
			return 0;;
		*)
			return 1;;
	esac
}

function getNextVersion(){
	   version=$(set -e ;curl -s "${url}/$region/deployment/prepare/${app}.json?deploymentTemplateName=CreateAndCleanUpPreviousAsg&includeEnvironment=true" |  python -m json.tool | grep nextGroupName | cut -f4 -d\")
		echo $version | grep ${app} || return 1
}

function deploy(){
		echo Prepare to deploy ${version}
		path="/${region}/deployment/start"
		result=$(curl -sL -H 'Content-Type: application/json;charset=UTF-8'  -H 'Accept: application/json, text/plain, */*'  --data-binary  "${params}" ${url}${path} --compressed  )
		deploy=$(echo $result | grep deploymentId | cut -f4 -d\") 
		echo ${show_url}/$region/ng#/deployment/detail/${deploy}
        waitdeploy $deploy
}
function waitdeploy(){
        getLog $1
        status=$( cat log.txt | grep '"status"' | cut -f4 -d'"')
        getStatus
        getLog $1
        echo $status
        until [ $status == "0" ] ; do
              echo $log
              printf '.'
              grep -Fvf log.old log.txt | grep -v durationString
              sleep 10
              getLog $1
              status=$( cat log.txt | grep '"status"' | cut -f4 -d'"')
              getStatus
        done
        grep -Fvf log.old log.txt
        exitStatus
}

function exitStatus(){
    statusLog=$( cat log.txt | grep '"status"' | cut -f4 -d'"')
    case $statusLog in
        completed)
                exit 0
        ;;
        terminated|failed)
                exit 1
        ;;
        *)
                exit 1
        ;;
    esac
}
function getStatus(){
    statusLog=$( cat log.txt | grep '"status"' | cut -f4 -d'"')
    case $statusLog in
        completed|terminated|failed)
                status=0
        ;;
        *)
                status=1
        ;;
    esac
}

function getLog(){
    mv log.txt log.old 2>/dev/null || echo "old"
    curl -s ${show_url}/$region/task/show/$1.json --output log.txt
}



