#!/bin/bash
function menu {

while true
do
clear	
echo "1) Create Database";
echo "2) Rename Database";
echo "3) Drop Database";
echo "4) Create New Table";
echo "5) Drop Table";
echo "6) Update Table";
echo "7) Delete From Table";
echo "8) Select From Table";
echo "9) Insert Into Table";


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
		# read -p "Choose Database : " dbName;
		# read -p "Please Enter The Name of Table : " tableName;
		# read -p "Enter Number Of Columns " noOfCols;
		# for (( i = 0; i < $noOfCols; i++ ))
		# do
		# 	read -p "Enter Name of column : " colName;

		# 	if [[	i -lt $noOfCols-1	]]; 
		# 	then
		# 		printf $colName":" >> $dbName/$tableName;
					
		# 	else
		# 		printf $colName >> $dbName/$tableName;
		# 	fi

			
		# done
	 #    printf "\n";
		# touch  $dbName/$tableName;
  #       echo "Your Table '$dbName.$tableName' is created";
        createTable;
        ;;
    5)
		read -p "Choose Database : " dbName;
		read -p "Please Enter The Name of Table : " tableName;
		rm  $dbName/$tableName;
        echo "Your Table '$dbName.$tableName' is Deleted ";
        ;;

    9)
        insertIntoTable;
        ;;
    
    *)
        echo "not found";
        ;;
esac
done

 }

 createDB(){
        read -p "Please Enter The Name of Database : " dbName;
         if [ -d $dbName ]
         then
             print "The Database Already Exists";
         else
             mkdir $dbName;
             print "Your Database '$dbName' is created";
        fi

 }
 renameDB(){
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
print(){
    clear
    echo $1;
    echo "Press any key to quit ";
    read confirm;
}

 function dropDatabase (){
 	clear
    
    read -p "Choose Database : " dbName;
	# rm -r $dbName;
    echo "You are going to drop $dbName Database ,Are you Sure? (y/n)"
    read confirm
    if [ $confirm = "y" ]
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
  insert="Y"
  while [ $insert = "Y" -o $insert = "y" ]; do
    clear;
    newRecord=""
    read -p "Choose Database : " dbName;
    read -p "Please Enter The Name of Table : " tableName;
    tableName="$PWD/$dbName/$tableName"
    print "Inserting new record in $tableName table"
    tableHeader=$(head -1 "$tableName");
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
          echo -en "Primary key value already existed!\n$col: "
          read input
          ChkPK=$(checkPrimaryKey);
        done
      fi
      newRecord="$newRecord$input;"
    done
    echo "${newRecord::-1}" >> "$tableName";
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
    read -p "Choose Database : " dbName;
    #read -p "Please Enter The Name of Table : " tableName;
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
