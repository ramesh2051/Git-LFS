  
  #PAT Token which should be authorised to access the GitHub Organization, must have scope admin:org 
  $GitHubUserToken=""
  
  $GitHubAdminHeader=@{
 
  Authorization = 'Bearer ' + $GitHubUserToken
  Accept = "application/vnd.github.v3+json"

  }       
  

  #Pass the GitHub Organization Name for which you want to pull the reports
  $GitHubOrg="Canarys-Migration-test"

  $page_no=1


  #Name and Location of the file where the report should be generated
  $repositoryreportpath = "C:\Users\rameshk\Desktop\Test\repositoryaccess.csv"
  $teamsreportpath = "C:\Users\rameshk\Desktop\Test\teamrepositoryaccess.csv"
  
function get-allrepos {

        param([int]$page)    

        $getghreposrequest = @{
			 
					    Uri = "https://api.github.com/orgs/$GitHubOrg/repos?page=$page&per_page=100&type=all"
					    Method = "Get"
				    	ContentType = "application/json"
			    		Headers = $GitHubAdminHeader
			
		    		 }

        $repositoryobject = Invoke-RestMethod @getghreposrequest

        $page_no = $page_no + 1

        foreach ($repoobject in $repositoryobject)
        {
            $repositoryname = $repoobject.name

            get-repocollaborators -repo $repositoryname
        }

        if ($repositoryobject -ne $null)
        {
            get-allrepos -page $page_no
        }

  }
  
function get-repocollaborators {  

  param([string]$repo)
    
        $getreposcollaboratorsrequest = @{
			 
				Uri = "https://api.github.com/repos/$GitHubOrg/$repo/collaborators?page=1&per_page=100"
				Method = "Get"
				ContentType = "application/json"
			    Headers = $GitHubAdminHeader
			}

        $repocollaboratorsobject = Invoke-RestMethod @getreposcollaboratorsrequest

        foreach ($repocollaborator in $repocollaboratorsobject)
        {

         $permissions=$repocollaborator.role_name
              $RepoCollaboratorObjects = @(
              [pscustomobject]@{
                 Repository  = $repo
                 Collaborator = $repocollaborator.login
                 Permissions = $permissions                           
                        }
               )



      $RepoCollaboratorObjects | Export-CSV $repositoryreportpath  -Append -NoTypeInformation -Force

  }
}

function team_details {
    
      param([int]$page)  

     
      $teamnames = getallteams -page $page_no
      foreach ($teamname in $teamnames)
      {

        $teammembers = getteammembers -teamname $teamname -page $page_no

        $teammembersnew = $teammembers -join ","

        $getteamsrepositories = @{
			 
				Uri = "https://api.github.com/orgs/$GitHubOrg/teams/$teamname/repos?page=$page&per_page=100"
				Method = "Get"
				ContentType = "application/json"
			    Headers = $GitHubAdminHeader
			}

        $teamrepoobject = Invoke-RestMethod @getteamsrepositories
        
        foreach ($teamrepo in $teamrepoobject)

        {
          $teamreponame = $teamrepo.name

          if($teamrepo.permissions.admin -eq "True"){

                 $teamrepopermissions="admin"
    
            }elseif($teamrepo.permissions.push -eq "True"){ 

                $teamrepopermissions="write"

            }else{

               $teamrepopermissions="read"
            }

             $TeamObjects = @(
              [pscustomobject]@{
                 TeamName  = $teamname
                 Members = $teammembersnew
                 RepositoryAccess = $teamreponame
                 RepositoryPermission = $teamrepopermissions                          
                        }
               )
               $TeamObjects | Export-CSV $teamsreportpath   -Append -NoTypeInformation -Force
        }
     }
}

function getteammembers {

    param([string]$teamname,[int]$page)  


        $getteammembersrequest = @{
			 
				Uri = "https://api.github.com/orgs/$GitHubOrg/teams/$teamname/members?page=$page&per_page=100"
				Method = "Get"
				ContentType = "application/json"
			    Headers = $GitHubAdminHeader
			}
        
        $teammembersobject = Invoke-RestMethod @getteammembersrequest

        $members=@()

        foreach ( $teammember in $teammembersobject)
        { 
           $members+=$teammember.login
        }

        return $members
}

function getallteams {

      param([int]$page)  

      $getteamsrequest = @{
			 
				Uri = "https://api.github.com/orgs/$GitHubOrg/teams?page=$page&per_page=100"
				Method = "Get"
				ContentType = "application/json"
			    Headers = $GitHubAdminHeader
			}
        
        $teamsobject = Invoke-RestMethod @getteamsrequest

        $teams=@()

        foreach ( $githubteam in $teamsobject)
        { 
           $teams+=$githubteam.slug
        }

        $page_no = $page_no + 1

        if ($teamsobject -ne $null)
        {
            getallteams -page $page_no
        }


        return $teams
}

get-allrepos -page $page_no
team_details -page $page_no
