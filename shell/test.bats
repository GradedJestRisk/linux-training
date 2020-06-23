#!/home/topi/.nvm/versions/node/v10.15.3/bin/npx bats

@test "test return value" {
  add(){
    first=$1
    second=$1
    result=$((first+second))
    echo 'hello'
    return $result
}
    #skip
    run add 2 2
  [ "$status" -eq 4 ]
}

@test "test output" {
  add(){
    first=$1
    second=$1
    result=$((first+second))
    echo 'hello'
    return $result
}
    #skip
    run add 2 2
  [ "$output" = "hello" ]
}
