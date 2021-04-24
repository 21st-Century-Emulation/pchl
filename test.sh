docker build -q -t pchl .
docker run --rm --name pchl -d -p 8080:8080 pchl

sleep 5
RESULT=`curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"id":"abcd", "opcode":0,"state":{"a":181,"b":0,"c":0,"d":0,"e":0,"h":25,"l":10,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":0,"stackPointer":0,"cycles":0}}' \
  http://localhost:8080/api/v1/execute`
EXPECTED='{"id":"abcd", "opcode":0,"state":{"a":181,"b":0,"c":0,"d":0,"e":0,"h":25,"l":10,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":false},"programCounter":6410,"stackPointer":0,"cycles":5}}'

docker kill pchl

DIFF=`diff <(jq -S . <<< "$RESULT") <(jq -S . <<< "$EXPECTED")`

if [ $? -eq 0 ]; then
    echo -e "\e[32mPCHL Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mPCHL Test Fail  \e[0m"
    echo "$RESULT"
    echo "$DIFF"
    exit -1
fi