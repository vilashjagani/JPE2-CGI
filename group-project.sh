#!/bin/bash
echo "Content-type: text/html"
echo ""

echo "<html>"
echo "<title> JPE2 </title>"
echo "<head>
<link rel="stylesheet" href="/styles.css">
</head>
<body bgcolor="#3A332C">
<center>
<h1><font color="#FFC300"> JPE2 Projects Managment </font></h1>
<div class="menu5">
    <div class="dropdown">
     <a href="project.sh">Projects</a>
     <div class="dropdown-content">
     <a href="project-list.sh">Project-list</a>
     <a href="project-create.sh">Project-Create</a>
     </div>
     </div>

 <div class="dropdown">
     <a href="project.sh">Users</a>
    <div class="dropdown-content">
     <a href="user-list.sh">Users-list</a>
     <a href="user-create.sh">User-Create</a>
   </div>
 </div>

 <div class="dropdown">
     <a href="project.sh">Groups</a>
    <div class="dropdown-content">
     <a href="group-list.sh">Group-list</a>
     <a href="group-create.sh">Group-Create</a>
   </div>
     </div>
    <a href="group-project.sh">Group-Project-Mapping</a>
    <a href="user-group.sh">User-Group-Mapping</a>
</div>"

source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://10.144.164.80:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://10.144.164.80:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://10.144.164.80:5000/v3/roles -k  | json_pp| jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/roles

echo "<br>"
echo "<br>"
echo " <form action="group-project-mapping.sh" method="get">"
echo "<font color="#FFC300"> Poject Name: </font><select name="prjname">"
  for i in `cat /usr/lib/cgi-bin/tmp/projects | awk {'print $1'} | grep -v admin | grep -v service`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"
echo "<font color="#FFC300"> Group Name: </font><select name="grpname">"
  for i in `cat /usr/lib/cgi-bin/tmp/groups | awk {'print $1'}`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"

echo "<font color="#FFC300"> Role Name: </font><select name="rolname">"
  for i in `cat /usr/lib/cgi-bin/tmp/roles | awk {'print $1'} | grep -v admin | grep -v ResellerAdmin | grep -v IAAS_ADMIN | grep -v IAAS_MEMBER`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"



echo "<input type="submit" value="Submit">"

echo "</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
