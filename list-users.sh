#!/bin/bash

###########
#About : This script will check the editor of script
#Input : In form with Repo Owner & Repo Name
#Owner : Kaustubh Mowade
###########

function helper {
        expect_cmd_args=2
        if [ $# -ne $expect_cmd_args]; then
                echo "please execute the script with required cmd args"
                echo "Args should be follows:"
                echo "file_name owner_name repo_name"
        fi
}

helper

#GitHub Api URL Form https://api.github.com/repos/{owner}/{repo}/pulls
API_URL="https://api.github.com"

#To access the git you should export username and access token
USERNAME=$username
TOKEN=$token

#Owner and repo information
REPO_OWNER=$1
REPO_NAME=$2

#Function to make a GET request to Github API
function github_api_get {
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	#Send a Get request to GitHub Api with authentication
	curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#Function to list users with read access to the repository
function List_users {
	local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

	#Fetch the List of collaborator on the repository
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permission.pull == true) | .login')"

	#Display the list of collaborators with read access
	if [[ -z "$collaborators" ]]; then
		echo "No user with read access found for ${REPO_OWNRE}/${REPO_NAME}."
	else 
		echo "User with read access to ${REPO_OWNER}/${REPO_NAME}:"
		echo "$collaborators"
	fi
}


#Main Scrpit
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
List_users

