PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
SYMBOL=$1
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
  then
    LENGTH=$(echo -n "$SYMBOL" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$SYMBOL'")
      if [[ -z $DATA ]]
      then
        echo "I could not find that element in the database."
      else
        echo $DATA | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    else
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$SYMBOL'")
      if [[ -z $DATA ]]
      then
        echo "I could not find that element in the database."
      else
        echo $DATA | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    fi
  else
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number='$SYMBOL'")
    if [[ -z $DATA ]]
    then
        echo "I could not find that element in the database."
    else
      echo $DATA | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELTING BAR BOILING BAR TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
fi
