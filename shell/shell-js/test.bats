#!/home/topi/.nvm/versions/node/v10.15.3/bin/npx bats

@test "assert numeric equality" {
  [[ 1 = 1 ]]
}

@test "assert equality (alternative) " {
  [ 1 -eq 1 ]
}

@test "multiple assertions " {
  [ 1 = 1 ]
  [ "true" = "true" ]
}


@test "call code - assert return value" {
  add(){
    first=$1
    second=$1
    result=$((first+second))
    return $result
}
    #skip
    run add 2 2
  [ "$status" -eq 4 ]
}

@test "call code - assert output" {

  add(){
    first=$1
    second=$1
    result=$((first+second))
    echo $result
  }
    #skip
    run add 2 2
  [ "$output" = "4" ]

}

@test "skip test" {
  skip
  [ 1 = 0 ]
}