#!/bin/bash
#dbDir="$PWD"

function menu {

  while true
  do
    clear	
    startMenu;
    startMenu(){
      clear
       echo "##############################################################"
       echo "#         Welcome To Our Simple DBMS With Bash Script        #"
       echo "#              BY:Hager Elsayed & Amira Elkholy              #"
       echo "#             OPen Source Track Mansoura Branch              #"
       echo "##############################################################"

      echo "===================="
      echo "1) Manage Database";
      echo "2) Manage Tables";
   
      echo "3) Exit";
      echo "===================="
      read -p "please enter your Choice : ";
      case $REPLY in
      1)
        mangeDBMenu;
        ;;
      2)
        manageTable
        ;;
     
      3)
        break
        ;;
      
      *)
        echo "not found";
        ;;
      esac

    }
    mangeDBMenu(){
      clear
      echo "===================="
      echo "1) Create Database";
      echo "2) Rename Database";
      echo "3) Drop Database";
      echo "4) Back";
      echo "===================="
      read -p "please enter your Choice : ";
      case $REPLY in
      1)
      createDB;
      ;;

      2) 
      renameDB;
      ;;

      3)
      dropDatabase;
      ;;
      4)
      
      ;;
      *)
        echo "not found";
        ;;
      esac

    }
    manageTable(){
      clear
      echo "===================="
      echo "1) Create New Table";
      echo "2) Drop Table";
      echo "3) Update Table";
      echo "4) Delete From Table";
      echo "5) Select From Table";
      echo "6) Insert Into Table";
      echo "7) Back";
      echo "===================="
      read -p "please enter your Choice : ";
      case $REPLY in
        1)
        createTable;
        ;;

        2)
        dropTable;
        ;;

        3)
         updateTable;
        ;;

        4)
        deleteFromTable;
        ;;

        5)
        selectMenu;
        ;;

        6)
        insertIntoTable;
        ;;
        7)
        
        ;;
        *)
        echo "not found";
        ;;
        esac

    }

    selectMenu(){
      clear
      echo "===================="
      echo "1) Select All From Table";
      echo "2) Select From Table Under Specific Condition";
      echo "3) Select Specific Columns From Table";
      echo "4) Apply Aggregate Function to Specific Column in Table";
      echo "5) Back"
      echo "===================="
      read -p "please enter your Choice : ";
      case $REPLY in
        1)
        selectAllFromTable;
        ;;

        2)
        selectFromTableUnderCondition;
        ;;

        3)
        selectSpecificColsFromTable;
        ;;

        4)
        chooseAggregateFunction;
        ;;
        5)
        
        ;;

        *)
        echo "not found";
        ;;


      esac
    }

done


}
showDatabases() {
    clear
    ls -d */ | awk 'BEGIN{FS=" "} { print "- "$1 }';
}
showTables() {
  clear
    ls -f */| awk 'BEGIN{FS=" "} { print "- "$1 }';
}
createDB(){
  clear
  echo "====== Creating New Database ============"
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
  then
   print "The Database Already Exists";
  else
   mkdir $dbName;
   mkdir $dbName/.config;
   touch $dbName/.config/$dbName;
   print "Your Database '$dbName' is created";
 fi

}
renameDB(){
  clear
  showDatabases
   echo "====== Renaming Database ============"
  read -p "Choose Database : " oldDbName;
  if [ -d $oldDbName ]
    then
    read -p "Please Enter The New Name of Database : " newDBName;
    mv $oldDbName $newDBName;
    print "Your Database is Changed from  $oldDbName to $newDBName";
  else
   print "No DB Exists";
 fi
}
selectAllFromTable(){
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    awk -F';' '{print $0}' $tablePath 
    read -p "Do you want to do another operation? (Y/N) "
  else
    print "this Database does not exist";
  fi
}
selectFromTableUnderCondition() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name : " colName;
    read -p "Please Enter The Condition : " condition;
    awk -F';'  'NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i}} NR>1 {if($ix[colName]==cond) print $0}' colName=$colName cond=$condition $tablePath 
    read -p "Do you want to select another row? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      selectFromTableUnderCondition;
    fi
  fi
}
selectSpecificColsFromTable() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Number of Columns you want to select : " colsNumber;
    cols=""
    for (( i = 0; i < $colsNumber; i++ )); do
      read -p "Please Enter The Column Name : " colName;
      if [[ i -eq $colsNumber-1 ]]; then
        cols+="$colName"
      else
        cols+="$colName"","
      fi
    done
    echo $cols;
    awk -F';' -v cols="$cols" 'BEGIN {split(cols,out,",")} NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i}} NR>1 {for (i=1; i<=numCols; i++) {if(i==numCols) {printf $ix[out[i]]"\n"} else {printf $ix[out[i]]","} } }' numCols=$colsNumber $tablePath 
    read -p "Do you want to select other columns? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      selectSpecificColsFromTable;
    fi
  fi
}
chooseAggregateFunction() {
  clear
  #showTables
  read -p "Please Enter The Aggregate Function you want to Apply (sum-avg-max-min-count): " funcName;
  if [[ "$funcName" == "sum" ]]; then
    sumSpecificColumn;
  elif [[ "$funcName" == "avg" ]]; then
    avgSpecificColumn;
  elif [[ "$funcName" == "max" ]]; then
    maxSpecificColumn;
  elif [[ "$funcName" == "min" ]]; then
    minSpecificColumn;
  elif [[ "$funcName" == "count" ]]; then
    read -p "Do you want to count under condition? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      countSpecificColumnUnderCondition;
    else
      countSpecificColumn;
    fi
  fi
  read -p "Do you want to apply another function? (Y/N) " input
  if [ $input = Y -o $input = y ]; then
    chooseAggregateFunction;
  fi
}
sumSpecificColumn() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to Sum : " colName;
    awk -F';'  'BEGIN {sum=0} NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i; if(t==colName) {type=a[2]} } } NR>1 { sum+=$ix[colName] } END { if(type!="int") { print colName" is Not an Integer!" } else { print "sum of "colName" = "sum} }' colName=$colName $tablePath 
    read -p "Do you want to sum another column? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      sumSpecificColumn;
    fi
  fi 
}
avgSpecificColumn() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to Get Average of : " colName;
    awk -F';'  'BEGIN {avg=0.00;OFMT = "%.0f";sum=0.00} NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i; if(t==colName) {type=a[2]} } } NR>1 { sum+=$ix[colName] } END {if(type!="int") { print colName" is Not an Integer!" } else { print "avg of "colName" = "sum/NR} }' colName=$colName $tablePath 
    read -p "Do you want to sum another column? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      avgSpecificColumn;
    fi
  fi 
}
maxSpecificColumn() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to get Max of : " colName;
    awk -F';'  ' NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i; if(t==colName) {type=a[2]} } } NR>1 { if(NR==2){max=$ix[colName]; row=$0} else{if($ix[colName]>max) { max=$ix[colName]; row=$0 }} } END { if(type!="int") { print colName" is Not an Integer!" } else { print "max of "colName" = "max; print row } }' colName=$colName $tablePath 
    read -p "Do you want to get max of another column? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      maxSpecificColumn;
    fi
  fi 
}
minSpecificColumn() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to get Min of : " colName;
    awk -F';'  ' NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i; if(t==colName) {type=a[2]} } } NR>1 { if(NR==2){min=$ix[colName]; row=$0 } else{if($ix[colName]<min) { min=$ix[colName]; row=$0 } }} END { if(type!="int") { print colName" is Not an Integer!" } else { print "min of "colName" = "min; print row } }' colName=$colName $tablePath 
    read -p "Do you want to get min of another column? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      minSpecificColumn;
    fi
  fi 
}
countSpecificColumn() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to count : " colName;
    awk -F';'  'NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i;} } END { print "count of "colName" = " NR-1 }' colName=$colName $tablePath 
    read -p "Do you want to count another column? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      countSpecificColumn;
    fi
  fi 
}
countSpecificColumnUnderCondition() {
  clear
  showDatabases
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    showTables
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name you want to count : " colName;
    read -p "Please Enter The Condition : " condition;
    awk -F';'  'BEGIN {count=0} NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i}} NR>1 {if($ix[colName]==cond) count+=1} END {print "count of "colName" where ("colName"="cond ") is "count}' colName=$colName cond=$condition $tablePath 
    read -p "Do you want to count another column under condition? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      countSpecificColumnUnderCondition;
    fi
  fi
}  


updateTable(){
     clear
      showDatabases
      read -p "Please Enter The Name of Database : " dbName;
      if [ -d $dbName ]
      then
          showTables
         read -p "Please Enter The Name of Table : " tableName;
         tablePath="$dbName/$tableName"
         read -p "Please Enter The Column Name : " colName;
         read -p "Please Enter The Condition : " condition;
         read -p "Please Enter Column Name you want to change : " updateColName;
         read -p "Please Enter The New Value for $updateColName : " newValue;

         awk -F';'  'BEGIN { ORS="" } NR==1 {for (i=1;i<=NF;i++) {split($i,a,".");t=a[1];ix[t] = i} print $0"\n"} NR>1 {if($ix[colName]==cond){$ix[updateColName]=newValue} for (i=1;i<=NF;i++){if(i==NF){print $i"\n"}else{print $i";"}}}' colName=$colName cond=$condition updateColName=$updateColName newValue=$newValue $tablePath > $dbName/try
         rm  $tablePath;
         mv $dbName/try $dbName/$tableName;
         echo "Your Column is updated Successfully"
        read -p "Do you want to update another record? (Y/N)" input
        if [ $input = Y -o $input = y ]; then
          updateTable;
        fi
      fi
     }
deleteFromTable(){
  read -p "Please Enter The Name of Database : " dbName;
  if [ -d $dbName ]
    then
    read -p "Please Enter The Name of Table : " tableName;
    tablePath="$dbName/$tableName"
    read -p "Please Enter The Column Name : " colName;
    read -p "Please Enter The Condition : " condition;
    awk -F';'  'NR==1 {for (i=1; i<=NF; i++) {split($i,a,".");t=a[1];ix[t] = i} print $0} NR>1 {if($ix[colName]!=cond) print $0}' colName=$colName cond=$condition $tablePath > $dbName/try
    rm  $tablePath;
    mv $dbName/try $dbName/$tableName;
    read -p "Do you want to delete another record? (Y/N) " input
    if [ $input = Y -o $input = y ]; then
      deleteFromTable;
    fi
  fi
}
dropTable(){
  showDatabases
  read -p "Choose Database : " dbName;
  showTables
  read -p "Please Enter The Name of Table : " tableName;
  rm  $dbName/$tableName;
  echo "Your Table '$dbName.$tableName' is Deleted ";
}
print(){
  clear
  echo $1;
  echo "Press any key to quit ";
  read confirm;
}

function dropDatabase (){
  clear
  showDatabases
  read -p "Choose Database : " dbName;
# rm -r $dbName;
echo "You are going to drop $dbName Database ,Are you Sure? (Y/N) "
read confirm
if [ $confirm = "y" -o $confirm="Y"]
  then
  if [ -d $db ] && rm -r $dbName
    then
    print "Dropped Successfully"
    break
  else
    print "Dropping Error"
  fi
fi
}

function insertIntoTable {
  clear
  showDatabases
  #showTables
  insert="Y"
  while [ $insert = "Y" -o $insert = "y" ]; do
    #clear;
    newRecord=""
    read -p "Choose Database : " dbName;
    showTables
    read -p "Please Enter The Name of Table : " tableName;

    tablePath="$PWD/$dbName/$tableName"
    print "Inserting new record in $tablePath table"
    tableHeader=$(head -1 "$tablePath");
    columnsList=$(echo  "$tableHeader" | awk 'BEGIN{RS=";"}; {print}')
    for col in $columnsList
    do
      colType=$(echo "$col" | awk 'BEGIN{FS="."}; NR==1{print $2}')
      echo -n "$col: "
      read input
      if [[ $colType == "int" ]]; then
        while ! [[ $input =~ ^[0-9] ]]; do
          echo "Invalid input datatype! enter $colType value";
          echo -n "$col: "
          read input
        done
      fi
      PKIndex=$(isPrimaryKey $col);
      if [[ $PKIndex != "0" ]]; then
        ChkPK=$(checkPrimaryKey);
        while [[ $ChkPK == "1" ]]; do
          echo -en "Primary key value already exists!\n$col: "
          read input
          ChkPK=$(checkPrimaryKey);
        done
      fi
      newRecord="$newRecord$input;"
    done
    echo "${newRecord::-1}" >> "$tablePath";
    echo -en "Record added successfully!\nInsert another record? [Y/N]: ";
    read insert;
  done
}
function createColumns {
  rowHeader=""
  for (( i = 0; i < $1; i++ )); do
    newColumn=""
    echo -n "Column $((i+1)) name: "
    read newColumn
    if [[ $rowHeader == *$newColumn* ]]; then
      echo "column name \"$newColumn\" alreadey existed!";
      ((i--));
      continue
    fi
    echo -n "[int OR string]: "
    read colType
    if [[ $colType != "int" && $colType != "string" ]]; then
      echo "Datatype \"$colType\" is not supported!";
      ((i--));
      continue
    fi
    newColumn="$newColumn.$colType"
    rowHeader="$rowHeader$newColumn"";"
  done
  rowHeader="${rowHeader::-1}";
  echo "$rowHeader" >> "$tablePath";
  echo -en "Table created successfully!\nWant to add Primary Key constraint? [Y/N] "
  read input
  if [[ $input == "Y" || $input == "y" ]]; then
    addPrimaryKey;
  fi
}

function createTable {
  clear;
  showDatabases
  read -p "Choose Database : " dbName;
  print "$dbName : Create New Table"
  echo -n "Enter table name: "
  read tableName;
  typeset -i colsNumber=-1;
  tablePath="$dbName"/"$tableName";
  if [ ! -f "$tablePath"  ]; then
    echo -n "Number of columns: "
    read colsNumber;
  else
    echo -n "Table already existed! Overwrite it? [Y/N]: "
    read input;
    if [ $input = Y -o $input = y ]; then
      sudo rm "$tablePath"
      echo -n "Number of columns: "
      read colsNumber;
    fi
  fi
  until [[ $colsNumber -gt 0 ]]; do
    if [[ $colsNumber -eq -1 ]]; then
      clear; break 2;
    else
      echo -en "Illegal number of columns! [-1 to Cancel]\n"
      echo -n "Number of columns: "
      read colsNumber
    fi
  done
  sudo touch "$tablePath"
  sudo chmod 666 "$tablePath"
  createColumns $colsNumber;
}

function isPrimaryKey {
  dbConfig=$dbName"/.config";
  PKName=$(echo $1 | awk 'BEGIN{FS="."}; NR==1{print $1}')
  TableConfig=$(awk -v tbname="$tableName" 'BEGIN{FS=":";TF="0";}; $1==tbname{print $0; TF="1";}; END{if(TF=="0") print "0";}' $dbConfig/$dbName)
  if [[ $TableConfig != "0" ]]; then
    PKConfig=$(echo "$TableConfig" | awk -v col="$PKName" 'BEGIN{FS=":";PF="0";}; $2==col{PF="1"; print $3}; END{if(PF=="0") print "0"};')
    echo $PKConfig;
  else
    echo "0"
  fi
}
function addPrimaryKey {
  clear;
  dbConfig=$dbName"/.config";
  pkinput="Y"
  print "Adding primary key to $dbName.$tableName";
  echo $rowHeader | awk 'BEGIN{ RS=";" ; FS="." }{ print "- " $1 }'
  while [[ $pkinput == "Y" || $pkinput == "y" ]]; do
    echo -n "Enter column name: ";
    read PKName;
    typeset -i colIndex=$(echo $rowHeader | awk -v col="$PKName" 'BEGIN{RS=";";FS=".";i=0} $1==col{ i=NR }; END{print i}')
    if [  $colIndex -ne 0 ]; then
      echo $tableName:$PKName:$colIndex >> $dbConfig/$dbName;
      echo -e "$PKName Primary Key constraint addedd successfully!\nPress any key to continue.."
      read;
      break;
    else
      echo -en "$1 column is not existed!\nTry again? [Y/N]: "
      read pkinput;
    fi
  done
}
function checkPrimaryKey {
  dbConfig=$dbName"/.config";
  tableName=$tablePath;
  PKFound="0";
  PKColumn=($(awk -v pkindex="$PKIndex" 'BEGIN{FS=";"}; {print $pkindex};' $tableName))
  for PK in "${PKColumn[@]}"; do
    if [[ $PK == $input ]]; then
      PKFound="1";
      break;
    fi
  done
  echo $PKFound;
}


menu;
