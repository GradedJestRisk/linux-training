#!/home/topi/.nvm/versions/node/v10.15.3/bin/npx bats

@test "numeric equality" {
  [[ 1 -eq 1 ]]
}

@test "not equal" {
  [[ 0 -ne 1 ]]
}

@test "lower than" {
  [[ 0 -lt 1 ]]
}

@test "lower than or equal" {
  [[ 0 -le 0 ]]
}

@test "greater than" {
  [[ 1 -gt 0 ]]
}

@test "greater than or equal" {
  [[ 1 -ge 1 ]]
}
