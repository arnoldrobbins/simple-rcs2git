#! /usr/local/bin/gawk -f

BEGIN {
	print "export TZ=UTC"
}

$1 != Prev_date {
	if (Prev_date != "")
		commit()
	Prev_date = $1
}

{
	Date = $1
	Revision = $2
	Filename = $3
	$1 = $2 = $3 = ""
	Message = $0
	gsub(/\\n/, "\n", Message)
	gsub(/"/, "\\\"", Message)
	sub(/^[[:space:]]*/, "", Message)
	printf("co -f -r%s %s\n", Revision, Filename)
	printf("chmod 644 %s\n", Filename)
	printf("git add %s\n", Filename)
}

function commit()
{
	printf("export GIT_AUTHOR_DATE=\"%s\" GIT_COMMITTER_DATE=\"%s\"\n",
		Date, Date)
	printf("git commit -m\"%s\"\n", Message)
	print ""
}

END {
	commit()
}
