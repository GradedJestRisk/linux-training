#!/home/topi/.nvm/versions/node/v10.15.3/bin/npx bats

@test "loop with until" {
  i=0
  result=0
  until [ $i -gt 3 ]
  do
    ((result=result+1))
    ((i=i+1))
  done
  [[ $result -eq 4 ]]
}

