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
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects

echo " <form action="user-creation.sh" method="get" accept-charset="ISO-8859-1">
    <h1><font color="#FFC300">  User name:</font></h1> <font color="#FFC300"> [don't use space and special characters in user name] </font>
    <input type="text" name="username" maxlength="120" size="30">"
echo "<font color="#FFC300">Password: <input type="password" name="password"></font>"
echo "<font color="#FFC300"> Poject Name: </font><select name="prjname">"
  for i in `cat /usr/lib/cgi-bin/tmp/projects | awk {'print $1'} | grep -v admin | grep -v service`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"

echo  "<input type="submit" value="Submit">"
echo "</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
