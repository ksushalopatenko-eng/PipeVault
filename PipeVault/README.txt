

TO RUN SCRIPTS START WITH 

chmod +x pipevault

run commands as ./pipevault [command] [option1] [option2] [option3..]



                                 COMMANDS

./pipevault send [name_or_address] [compression_option] [file or files1] [file_or_files2] ...

	[compression_option] - "0" - no compression; "1" - gzip; "2" - bzip2; "3" - xz;

./pipevault ping [name_or_address]

./pipevault contacts [add|delete|list|edit]

	[edit] - ./pipevault edit [old_name] [new_name] [new address]

	[delete] - ./pipevault delete [name_or_ID(NEEDSFIX)]

	[add] - ./pipevault add [name] [address]

./pipevault log [number of last records to show] <-- here the argument(number is OPTIONAL)



To empty/rewrite contact list:]
printf "%-5s\t%-15s\t%-40s\n" "ID" "NAME" "ADDRESS" > datafiles/contacts.tsv

To empty/rewrite history log:
printf "%-10s\t%-10s\t%-20s\t%-15s\t%-40s\t%s\n" "ID" "STATUS" "TIMESTAMP" "NAME" "ADDRESS" "FILES" > datafiles/history.log



СПИСОК БАГІВ ЯКІ  Я ЇБАВ ФІКСИТИ ^^

1)ЯКШО ВИДАЛИТИ НЕ  ОСТАННІЙ ЗРОБЛЕНИЙ КОНТАКТ ТО З'ЇДЕ ID (було 5 контактів, видалили 3й але у файлі все ще 5 lines тому ID наступного буде 5 -> дублікат)
2)ТАМ ДЕ GREP ВИКОРИСТОВУЄТЬСЯ ДЛЯ ПАРСИНГУ КОНТАКТІВ, МОЖЛИВЕ ВИДАЛЕННЯ СПІЛЬНОКОРЕНЕВИХ ІМЕН(наприклад якшо у контактах є anna та hannah усі скрипти на 
grep поламаються, основний send так точно, у мене десь була структура пошуку через awk, замініть пжпжпжжп)
3)./pipevault contacts delete видалило у мене всь список чогось. ВОНО НАРАЗІ ШУКАЄ ТІЛЬКИ ПО ІМЕНІ, ТРЕБА ОРГАНІУВАТИ ВИДАЛЕННЯ ПО ID ТЕЖ! проста логіка, аналузівати якщо ввели тільки цифри


Удокументації вказати шо скрипт запускати ТІЛЬКИ З ПАПКИ ПРОЕКТУ!!!!. можете написати хедер до pipevault головного файлу шоб автоматично шукав папку проекту та до неґ переходив^^

Усіх цьомаю^^
