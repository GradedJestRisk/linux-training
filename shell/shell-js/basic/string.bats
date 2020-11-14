#!/home/topi/.nvm/versions/node/v10.15.3/bin/npx bats

# Use double brackets [[
# rationale => https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash

# operator cheatsheet => http://mywiki.wooledge.org/BashFAQ/031

@test "string equality" {
  [[ "hello" = "hello" ]]
}

@test "string equality (variable)" {
  string=hello
  [[ $string == "hello" ]]
}

@test "regex equality" {
  answer=yes
  [[ $answer =~ ^y(es)?$ ]]
}

@test "string non equality" {
  [[ "hello" != "goodbye" ]]
}