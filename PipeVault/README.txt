		How to run the project?

Give execution permission:

	chmod +x pipevault install.sh

To install the program, run: 

	./install.sh


Run commands as:  pipevault [command] [option1] [option2] [option3..]

		Commands:

pipevault send [name_or_address] [compression_option] [file or files1] [file_or_files2] …

	Compression options:

	0 = no compression
	1 = gzip
	2 = bzip2
	3 = xz

	This command creates an archive from the selected files, compresses it, generates a checksum and transfers it to the remote host

pipevault ping [name_or_address]

	This script accepts the name or the direct address, attempts SSH connection with a timeout


pipevault contacts [add|delete|list|edit]: - contacts.sh  Manages the contact file; supports adding, deleting, editing and listing contacts.

	pipevault contacts add [name] [address] - add contact
	pipevault contacts delete [name_or_ID] - delete a contact
	pipevault contacts contacts list - list all contacts
	pipevault contacts edit [old_name] [new_name] [new address] - edit a contact 
	
pipevault log [number of last records to show] - history.sh

	If no number is given, the whole log is shown; If a number is given, the script shows the header and the last N records;


To remove the command from the system: uninstall.sh
