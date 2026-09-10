#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USERNAME
INFO=$($PSQL "SELECT COALESCE(games_played, 1), best_game FROM users WHERE username = '$USERNAME'")

if [[ -z $INFO ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
   echo "$INFO" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi
SECRET=$((RANDOM % 1000 + 1))
echo "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=0
while true
do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    ((NUMBER_OF_GUESSES++))
    if [[ $GUESS -eq $SECRET ]]
    then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET. Nice job!"
      break
    elif [[ $GUESS -gt $SECRET ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  fi
done
NEW_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
FORMER_BEST=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")

if [[ -z $FORMER_BEST || $NUMBER_OF_GUESSES -lt $FORMER_BEST ]]
then
  NEW_BEST=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username='$USERNAME'")
fi