#/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 10-03-2015

# A script for patching Magento

sftp=`which sftp`
php=`which php`
sh=`which sh`

REMOTEHOST='www.example.com'
REMOTEUSER='magentopatch'
DATE=`date +"%y-%m-%d"`

# Function for applying the patch and saving the output details to log file
function patchapply {
	
        patchName=$1
        patchCode=$2
	patchOutput="patch_output.txt"
	patchLog="patch_log.txt"
	
	echo -e "#Applying $patchName on $DATE \n" > $patchOutput
        /bin/sh $patchName >> $patchOutput
	echo -e "\n" >> $patchOutput

	cat $patchOutput >> $patchLog

        if grep -q "Patch was applied/reverted successfully" $patchOutput; then
		echo $patchCode >> $appliedpatch
        else
                echo "$patchCode no"
        fi

	rm -f $patchOutput

}

function gitexists {
	
	gitExists=`command -v git >/dev/null 2>&1 || { echo 0; }`
	if [[ $gitExists == 0 ]]; then
		return 0
	else
		return 1
	fi

}

function gitinitcheck {
	
	findGit=`find . -maxdepth 1 -type d -name .git`
	if [[ ${findGit##*.} == 'git' ]]; then
		return 1
	else
		return 0
	fi

}

function gitstcheck {

	git=`which git`
	gitStatus=`$git status --short | wc -l`
	gitCommitMsg="$1"

	if [[ $gitStatus -gt 0 ]]; then
		$git add .
		$git add -u
		$git commit -m "$gitCommitMsg"
	fi

}

gitexists
gitexistsReturn=$?

gitinitcheck
gitinitcheckReturn=$?

if [[ $gitexistsReturn == 1 && $gitinitcheckReturn == 1 ]]; then
	gitFlag=1
else
	gitFlag=0
fi

mageversion=`$php patch_version.php`
appliedpatch="app/etc/applied.patch.num"
pathArray=`echo ls | $sftp $REMOTEUSER'@'$REMOTEHOST | grep 'magento'`

# Checking if the connection to the remote server can be established
if [[ `echo version | $sftp $REMOTEUSER'@'$REMOTEHOST | grep 'sftp>'` == 'sftp> version' ]]; then
	for env in $pathArray; do
		# Checking the magento version for the actual environment
		if [[ ${mageversion##*-} == ${env##*-} ]]; then
			# Get all available patches uploaded on the remote server
			insideArray=`echo ls $env | $sftp $REMOTEUSER'@'$REMOTEHOST`
			for listed in $insideArray; do
				if [[ ${listed##*/} == "SUPEE"* ]]; then
					if [ -f $appliedpatch ]; then
						# Checking if the patch is already installed on the actual environment
						if ! grep -Fxq ${listed##*/} $appliedpatch; then
							# Commit changes
							if [[ $gitFlag == 1 ]]; then
							
								gitCommitMsg="CommitBeforeApplyingPatch"
								gitstcheck $gitCommitMsg
						
								# Getting the patch name
								patchPath=`echo ls "$env/${listed##*/}" | $sftp $REMOTEUSER'@'$REMOTEHOST | grep ".sh"`
								patchName=${patchPath##*/}

								echo get -P $patchPath . | $sftp $REMOTEUSER'@'$REMOTEHOST

								patchapply $patchName ${listed##*/}

								rm -f $patchName

								gitCommitMsg="${listed##*/}"
								gitstcheck $gitCommitMsg
						
							else
								# Getting the patch name	
								patchPath=`echo ls "$env/${listed##*/}" | $sftp $REMOTEUSER'@'$REMOTEHOST | grep ".sh"`
								patchName=${patchPath##*/}
					
								echo get -P $patchPath . | $sftp $REMOTEUSER'@'$REMOTEHOST
								
								patchapply $patchName ${listed##*/}

								rm -f $patchName
							fi

						else
							echo "Patch ${listed##*/} is already installed on this environment"
						fi
					else
						echo "Please check the file for already applied patches"
					fi
				fi
			done
		else
			echo "Unknown version"
		fi
	done
else	
	echo "Connection to the remote server cannot be established"
	exit 1
fi
