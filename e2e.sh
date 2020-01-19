#!/usr/bin/env sh

./wiki &
WIKI_ID=$!

cleanup() {
        kill -9 $WIKI_ID
        rm -f test_*.out Test.txt final-test.go final-test.bin final-test-port.txt a.out get.bin
}
trap cleanup 0 INT

assert_diff() {
    diff -u $1 $2
    if [ $? -ne 0 ]
    then
        echo "failed"
        exit 1
    fi
}


go build -o get.bin e2e/get.go

./get.bin -post=body=some%20content http://127.0.0.1:8080/save/Test > test_save.out
assert_diff test_save.out e2e/test_view.good 
diff -u test_save.out e2e/test_view.good # should be the same as viewing

assert_diff Test.txt e2e/test_Test.txt.good

./get.bin http://127.0.0.1:8080/view/Test > test_view.out
assert_diff test_view.out e2e/test_view.good

echo PASS
