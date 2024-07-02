output=$(./PerfPowerTracker.sh -header)
output="$output;Input"
output=${output//$'\n'/,}
echo $output >> myo_clang${ver}.csv

echo "Run MYO"
for i in {2..1024..2}
do
	output=$(./PerfPowerTracker.sh ./myocyteClang $i 1024 0 4 )
	output="$output;$i"
	output=${output//$'\n'/,}
	echo $output >> myo_clang${ver}.csv
	echo $output
done