#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# *********************************************************

MAIN_MENU() {
  echo -e "\n$1\n"

  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU $SERVICE_ID_SELECTED ;;
    2) SERVICE_MENU $SERVICE_ID_SELECTED ;;
    3) SERVICE_MENU $SERVICE_ID_SELECTED ;;
    4) SERVICE_MENU $SERVICE_ID_SELECTED ;;
    5) SERVICE_MENU $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE_MENU() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE_NUMBER_RESULT=$($PSQL "SELECT customer_id, name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE_RESULT=$($PSQL "SELECT name FROM services WHERE service_id = $1")
  SERVICE_NAME=$(echo "$SERVICE_RESULT" | sed -E 's/^ +//g')
  if [[ -z $PHONE_NUMBER_RESULT ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

echo -e "\n~~~~~ MY SALON ~~~~~"
MAIN_MENU "Welcome to My Salon, how can I help you?"