#!/bin/bash

###### CONFIG
ACCEPTED_HOSTS="/root/.hag_accepted.conf"
BE_VERBOSE=false

if [ "$UID" -ne 0 ]
then
 echo "Superuser rights required"
 exit 2
fi

genApacheConf(){
 echo -e "# Host ${HOME_DIR}$1/$2 :"
}

echo '"quoted"' | tr -d \" > text.txt

function incompatible_function() {
  :
}

compatible_function() {
  if ! [ "$1" == "yes" ]
  then
    return 3;:;
  fi
  (
    exec 3>&1
    echo "finished! $@? $*." >&3 \
      | cat | bat - | cat
    exit 4
  ) || exit $?
}

if command -v bat &> /dev/null; then
  var=1
  printf "%s...\n" "$(echo some text)"
  while true; do
    echo $var

    if { [[ "$var" -eq 1 && ( true || false ) ]] || false 2>&1 1> /dev/null; } &> /dev/null; then
      var="$(cat <<< "two")"
      continue 1
    fi

    case "$var" in
      "two") var="three" ;;
      three) var="four" ;;
      fo*r)
        var=five
        ;;

      "fi"ve)
        var="$(
          cat       << END
six > $var
END
        )"
        ;;

      $'six\n' | *six*)
        echo "?"
        seven=seven
        while read -r line
        do
          var="$line"
        done << "HEREDOC"
1
2
$seven
HEREDOC
        ;;

      *'sev'*)
        export var=eight
        unset var
        ;;

      '')
        { incompatible_function && false; } || compatible_function "yes"
        break
        ;;
    esac

    continue
  done
fi
