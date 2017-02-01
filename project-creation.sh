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

query_string=$QUERY_STRING;
PRJNAME=`echo $query_string | sed -e 's/prjname=//g'`
#echo "$PRJNAME"
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
echo 'curl -H "Content-Type: application/json" -s -X POST -H "X-Auth-Token: '$TOKEN'" -d '"'"'{''"project"'': {''"enabled"'': true,''"description"'': ''"'$PRJNAME'"'',''"domain_id"'': ''"default"'',''"name"'': ''"'$PRJNAME'"''}}'"'"' https://'$IP':5000/v3/projects -k ' > /usr/lib/cgi-bin/tmp/test1
bash /usr/lib/cgi-bin/tmp/test1 | json_pp > /usr/lib/cgi-bin/tmp/prj-create-out
echo "<br>"
echo "<br>"
echo "<font color="#229954"> <h2>Project has created </h2> </font> "
echo "<br>"
echo "<br>"
a=`cat /usr/lib/cgi-bin/tmp/prj-create-out  | egrep  '"id"|"name"' |paste - - | sed -e 's/"//g' -e 's/,//g'`
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Project-name</font></th>
    <th><font color="#FFC300">Project-id</font></th>
  </tr>"
  echo "<tr><td><font color="#FFFFFF">` echo $a | awk {'print $3'}`</font></td>"
  echo "<td><font color="#FFFFFF">` echo $a | awk {'print $6'}`</font></td></tr>"
echo "</table>"
echo "</center>"
echo "</body>"
echo "</html>"
