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
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://10.144.164.80:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups


echo "<br>"
echo "<br>"
echo "<br>"
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Group-name</font></th>
    <th><font color="#FFC300">Group-id</font></th>
  </tr>"
cat /usr/lib/cgi-bin/tmp/groups  | awk {'print $NF'}  >  /usr/lib/cgi-bin/tmp/groups-id
    for i in `cat /usr/lib/cgi-bin/tmp/groups-id`
       do
           grep $i$ /usr/lib/cgi-bin/tmp/groups | awk {'print $1'} > /usr/lib/cgi-bin/tmp/groups-f1
           grep $i$ /usr/lib/cgi-bin/tmp/groups | awk {'print $2'} > /usr/lib/cgi-bin/tmp/groups-f2
           echo "<tr><td><font color="#FFFFFF">`cat /usr/lib/cgi-bin/tmp/groups-f1`</font></td>"
           echo "<td><font color="#FFFFFF">`cat /usr/lib/cgi-bin/tmp/groups-f2`</font></td></tr>"
       done 
                  
echo "</table>" 


echo "</center>"
echo "</body>"
echo "</html>"
