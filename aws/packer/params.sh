ami=`cat ami.txt`
echo ami=$ami
#ami=$GO_PACKAGE_ASGARD_HACKATHON_BANK_MICROSERVICE_PYTHON_20150708084603_VERSION
user_mail=$(git --no-pager show -s --format='%ae' ${TRAVIS_COMMIT})

domain="asgard.hackathon.schibsted.io"
show_url="http://${domain}"

url="http://${domain}"
region="eu-west-1"
monitorBucketType="application"
app_type="Web+Service"
desiredCapacity=1

appParams='name='${app}'&type='${app_type}'&description='${app}'&owner='${user_mail}'&email='${user_mail}'&monitorBucketType='${monitorBucketType}'&ticket='

autoScalingParams='ticket=&requestedFromGui=true&appWithClusterOptLevel=false&appName='${app}'&stack=&newStack=&detail=&countries=&devPhase=&hardware=&partners=&revision=&min=1&max=1&desiredCapacity='${desiredCapacity}'&defaultCooldown=10&healthCheckType=EC2&healthCheckGracePeriod=600&terminationPolicy=Default&subnetPurpose=external&selectedZones=eu-west-1a&selectedZones=eu-west-1b&selectedZones=eu-west-1c&azRebalance=enabled&imageId='${ami}'&instanceType=t2.micro&keyName=team8&pricing=ON_DEMAND&kernelId=&ramdiskId=&iamInstanceProfile=&_action_save='

params='{"deploymentOptions":{"clusterName":"'${app}'","notificationDestination":"'${user_mail}'","steps":[{"type":"CreateAsg"},{"type":"Resize","targetAsg":"Next","capacity":'${desiredCapacity}',"startUpTimeoutMinutes":10},{"type":"DisableAsg","targetAsg":"Previous"},{"type":"DeleteAsg","targetAsg":"Previous"}]},"asgOptions":{"autoScalingGroupName":"'${version}'","launchConfigurationName":null,"minSize":1,"maxSize":1,"desiredCapacity":1,"defaultCooldown":10,"availabilityZones":["eu-west-1c","eu-west-1a","eu-west-1b"],"loadBalancerNames":[],"healthCheckType":"EC2","healthCheckGracePeriod":600,"placementGroup":null,"subnetPurpose":"external","terminationPolicies":["Default"],"tags":[],"suspendedProcesses":[]},"lcOptions":{"launchConfigurationName":null,"imageId":"'${ami}'","keyName":"team8","securityGroups":["AllowAccessTo5000","SSHAccessToInstance","AllowAccessTo8080"],"userData":"null","instanceType":"t2.micro","kernelId":"","ramdiskId":"","blockDeviceMappings":null,"instanceMonitoringIsEnabled":false,"instancePriceType":"ON_DEMAND","iamInstanceProfile":null,"ebsOptimized":false,"associatePublicIpAddress":null}}'
