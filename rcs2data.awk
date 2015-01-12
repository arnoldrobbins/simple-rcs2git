#! /usr/local/bin/gawk -f

/^Working file:/ {
	finish()
	reset()
	File = $NF
	next
}

/^revision/ {
	finish()
	Message = ""
	Revision = $2
	next
}

/^date:/ {
	date = $2
	gsub("/", "-", date)
	time = $3
	sub(";", "", time)
	Date = date "T" time
	getmessage()
}

function finish()
{
	if (File == "" || Date == "" || Revision == "" || Message == "")
		return

	printf("%s %s %s %s\n", Date, Revision, File, Message)
}

function reset()
{
	Date = Revision = File = Message = ""
}

function getmessage(	text, start)
{
	while (getline text > 0) {
		start = substr(text, 1, 3)
		if (start == "---" || start == "===")
			break
		if (Message == "")
			Message = text
		else
			Message = Message "\\n" text
	}
}

END {
	finish()
}
