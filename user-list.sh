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
echo "<br>"
echo "<br>"
source /usr/lib/cgi-bin/keystonerc 
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/users -k  | json_pp| jshon -e users -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/users

echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">User-name</font></th>
    <th><font color="#FFC300">User-id</font></th>
  </tr>"
cat /usr/lib/cgi-bin/tmp/users  | awk {'print $NF'}  >  /usr/lib/cgi-bin/tmp/users-id
    for i in `cat /usr/lib/cgi-bin/tmp/users-id`
       do
           grep $i$ /usr/lib/cgi-bin/tmp/users | awk {'print $1'} > /usr/lib/cgi-bin/tmp/users-f1
           grep $i$ /usr/lib/cgi-bin/tmp/users | awk {'print $2'} > /usr/lib/cgi-bin/tmp/users-f2
           echo "<tr><td><font color="#FFFFFF">`cat /usr/lib/cgi-bin/tmp/users-f1`</font></td>"
           echo "<td><font color="#FFFFFF">`cat /usr/lib/cgi-bin/tmp/users-f2`</font></td></tr>"
       done 
                  
echo "</table>" 


echo "</center>"
echo "</body>"
echo "</html>"
