/^commit/ {
	commit[++c] = $2
	next
}
/^Date:/ {
	$1 = ""
	$0 = $0
	date[++d] = $0
	getline
	getline msg
	message[d] = msg
	getline
	if (NF > 1)
		message[d] = message[d] RS $0
}

END {
	for (i = 1; i < d; i++) {
		print "echo ===============", date[i]
		printf ("echo '%s'\necho ===============\n", message[i])
		printf "git diff %s %s\n", commit[i+1], commit[i]
	}
}
