CATS - A Multi-Disk Cataloging Utility

Version 2.

by William C. Parke (c) Copyright 1986- 1989

## ACKNOWLEDGEMENTS:

Jerry Horwitz, CHUG MS-DOS, SIG Coordinator Emeritus, made many
corrections and additions to this document, and many useful
suggestions for enhancing the program. (CHUG is the Capitol
Heath/Zenith Users' Group, Fairfax, Virginia.)

Douglas Clark, another CHUG MS-DOS SIG Coordinator, spent many hours
testing the program and thinking of ways to improve it. His incisive
mind led to the correction of a very difficult to find program bug.

The author consulted with the CHUG SYSOP Emeritus, Larry Sites, during
program development to gain from his wisdom.

## INTRODUCTION:

CATS is a directory-cataloging program for MS-DOS computer systems.
CATS will generate a catalog file which lists the volume label and all
directories and files on each disk selected by the user for cataloging
(including floppy diskettes, hard-disk partitions, and RAM disks). If
the catalog file exists, CATS will append the new data to it. If the
catalog file does not exist, CATS will create it.

The listing for each file on the disks cataloged is in the form of a
record consisting of one line in the catalog file. This record
includes fields for the filename and extension, an abbreviated listing
of attributes, size, date and time of last write, disk volume label,


path, and space for special comments (which can be added with an
editor) about each file to identify its purpose. The catalog file can
be sorted according to any or all of these fields by means of the
sorting utility SORTS supplied with CATS. Cataloging your removable
disks will give you the ability to find any file in your library of
disks by simply using an editor or file listing utility to search the
catalog for the desired file. As disks are modified, their directories
can be added to the catalog and, by sorting on the volume label, the
catalog can be edited to remove obsolete entries. This obviates the
need for rebuilding a large catalog from scratch.

The advantages of CATS over other cataloging programs include:

1. Speed: CATS was written in assembly language, and operates very
quickly.
2. Multiple drives: CATS lets you use any number of drives. While one
is being used, another can be loaded with a new disk. CATS works with
any drives supported by the operating system.
3. Ease of use: CATS provides explicit instructions and detailed
information on what operation it is performing. A minimal number of
keystrokes is used for each command.
4. Flexibility: You can use a different catalog file each time CATS is
run. The default catalog file name and its format can be changed.
CATS and the catalog file can be in different directories or even on
different disks.
5. Universality: CATS should run on any generic MS-DOS computer.
6. Useful formats: The catalog file may have a fixed record format
with fields for all useful directory data suitable for a sorting
program, or variable record lengths depending on the path names of the
files.
7. Handles many disks: The catalog file is limited only by the
capability of the selected sorting program and by available disk space
to store the catalog (nominally 80 bytes per record, including the
carriage return and line feed). CATS puts no limit on the catalog file
size.

INVOKING CATS

Before running CATS, .change its name from CATS??.COM on your disk to
CATS.COM.

The command syntax for CATS is:

CATS x: [catname][/s]

where x: is a valid drive name for the disk you wish cataloged,
and


[catname] is the optional drive:\path\filename for your catalog
file.
If no catname is given, the default: \CAT\CATS.DIR is used.
[/s] represents optional switches. s=
A to Add compressed file internal directories,
C to Change the default catname
within CATS.COM stored on your disk drive,
(No drive name x: is needed for this option)
D to Display disk files onto the console
F to Force a comma Field separator
M to Make sequential numerical volume labels
N to Not write your new volume label onto current disk
Q to Quit after single disk is finished in Quiet mode
R to Record fixed length Records
V to Verify current disk volume label and be given option
to change volume label.
All switches can be combined (e.g. /NVDC ).

Note that the entry for the drive name of the drive containing the
disk to be cataloged must be provided, unless the switch 'C' is used.
However, the entry associated with the catalog file (catname) is
optional. If no catalog file is given, the default catalog file
\CAT\CATS.DIR will be used. This default name can be changed with the
'C' switch. All of the switches are optional.

CATS.COM must reside in the current directory or in a directory
defined in the search PATH. The directory containing the catalog file
must exist and must be reachable from the current drive\directory. If
CATS.COM resides in a directory defined in the search PATH and
"catpath" reaches the directory containing the catalog file from the
root directory, you can run CATS from any subdirectory.

EXAMPLES OF USE

To catalog the disk in drive B: into the default catalog file, use the
command

CATS B:

(This form assumes that the directory containing the default catalog
file is reachable from the current drive and directory.) The catalog
list of all files on B: will be placed in the default catalog file
(\CAT\CATS.DIR on the default drive, unless the user has changed the
default). If the catalog file is not found, you will be asked if you
wish it to be created. In order for CATS to create the catalog file,
the given directory path must exist.

To catalog the disk in drive B: into a catalog file other than the
default file, such as SPECIAL.DIR on the disk in drive A:, use the
command:

CATS B: A:SPECIAL.DIR

This will add the information for the files on the disk in drive B: to


the catalog file SPECIAL.DIR on the disk in drive A:.

To catalog a series of disks using drive A:, verifying each volume
label, electing to display the disk files on the console, making
volume serial numbers, and not writing the new volume labels on the
disk, use:

CATS A: /VDMN

The catalog for this series of disks will be appended to the default
catalog.

More on Command-Line Switches

CATS can be invoked using one or more of the available command-line
switches. Example valid forms for invoking these switches include

/V for the single switch V
/VNM for three switches
/V /N /M for the same three switches as the previous case

Volume-Label-Verify Switch /V

The V switch allows you change the volume label on the disks you are
cataloging, even if these disks already have a volume label. For
example, the command

CATS A: /V

causes CATS to first read the volume label on the disk in drive A:. If
one is not found, you will be asked to supply one. If one is present,
you will be shown it and asked if you wish to change it. If you answer
Y for yes, you will be asked to supply a new name. A volume label can
contain all valid file name characters:

A-Z 0-9 $ & # % ' ( ) - @ ^ { } ~ `! and _.

In addition, spaces can be used. Lower case letters are mapped to
upper case. The /V switch allows you to relabel your disks in a
logical fashion according to the order you have arranged them. After
the volume label is changed (if you answered Y for yes), CATS catalogs
the files on the disk.

No-Write Volume-Label Switch /N

The N switch prevents CATS from writing any new volume label onto the
disk itself. This is useful for cataloging write-protected disks which
have no labels, to catalog low density disks in high density drives
(which should not write to those disks, but can read them), to make a
catalog with disk labels which do not correspond to volume labels, or
to catalog duplicate disks which you wish to catalog separately. The
labels you choose to display in the catalog file should be noted on
the disk paper labels, so that you can identify the physical disk
which corresponds to a given catalog entry. They do not have to match


the volume label on the disk.

Make Sequential Numerical Volume Labels Switch /M

The M switch is used to automatically label disks with a sequence of
numbers. The first eight characters of the volume label can be any
name which applies to a set of disks. The last three characters are
reserved for a three digit number. CATS will prompt you for the
volume set name and the beginning serial number. Each succeeding disk
cataloged will be given the same eight character name but with a new
serial number, incremented by one from the previous disk. By using
both the V and M switches, several sets of disks with different set
names can be catalogued in one CATS session, with arbitrary starting
serial numbers.

If you have over 999 disks in one set, CATS will use one more of the
eleven characters to establish a proper serial number, letting you
catalog up to 10,000 disks in one series. With both the V and M
switches on, CATS will prompt you to verify the new disk volume label
while maintaining a volume serial number. If the new label given is
satisfactory, you need not change it. However, you may elect to change
the volume set name or the serial number. CATS will use your name to
begin a new series of numbered labels.

Force a Comma Field Separator /F

The fields in a CATS catalog are the divisions of each catalog line
which show a particular aspect of a file. The filename, attribute,
size, creation date, etc. are all considered separate fields. The
default field separator in CATS is an single space. Other field
separation characters would make the catalog less readable to the
human eye, but possibly more useful if the catalog file is to be used
as input to a data base or spreadsheet program. A popular field
separator for these type of programs is a comma. By applying the /F
switch on the command line of CATS, a comma will be used instead of a
space to separate fields on each new catalog line. An alternative to
the /F switch is a patch to CATS which will change the field separator
to any character you choose. Such patches are described later in this
document.

Display the Current Disk Files onto the Console /D

If the D switch is selected, CATS will let you display the files on
the current disk onto your console screen. If the V switch is also
active, this file list will be given to you before you are asked for a
new volume label. In this way, you can review the files on the disk
before deciding on a new volume label. In addition, you will be asked
if you wish to catalog the current disk after the display of files.

Change the Default Catalog File Name /C

The C switch lets you change the default catalog file name within the
CATS.COM program. The catalog file is used by CATS to store the disk
file catalogs. If you have several distinct group of disks, you may


wish to have a separate catalog file for each group. Setting the
default catalog file name to match one group of disks will mean you do
not have to give that name on the command line while cataloging disks
in that group.

If the C switch is used without a drive letter, CATS will prompt you
for a new catalog name. CATS will accept only valid subdirectory
names in the catalog path name. Under DOS 2.x, the file name CATS.COM
is assumed to be the invoking program name. Under DOS 3.x, the program
name need not be CATS.COM, nor does it have to be in the current
directory. CATS will clone itself to record the new catalog name.

All of the switches described above can be used in combination. For
example the command:

CATS /VNMC

is valid, and will let you establish a new default catalog file, then
start cataloging a set of disks, with CATS asking to change the volume
label, but without writing any new label to the disk.

Adding Internal Directories of Compressed Files /A

By using the /A switch, CATS will monitor the file extensions while it
is cataloging a disk. If the extension is .ARC or .ZIP, then CATS will
open that file, verify that it is a true compressed file, and if so,
add the names of all the files contained in that compressed file to
the current catalog. The internal files of a compressed file will be
marked in the catalog by using an 'a' or 'z' symbol in the attribute
field. (The characters used may be changed. See the patch instructions
in the section on changing defaults.) Moreover, the path name for the
internal files will have the parent compressed-file name appended,
terminated with a period rather than a backslash.

Quiet Cataloging for Single Disk /Q

The /Q switch will make CATS quit after finishing cataloging a single
disk. Moreover, if no user information is required for CATS to
proceed, then CATS will only display its invocation line. This option
make it easier to use CATS within BAT files and other programs. If an
error is detected, CATS will set the ERRORLEVEL as follows:

ERRORLEVEL Cause
1 DOS must be 2.xx or above
2 Command line syntax, or no command given
3 Disk drive error
4 CATS.COM not found
5 CATS.DIR creation error
6 CATS.DIR write error
7 Volume label error

## CATALOGING CONSIDERATIONS


CATS has no limit as to how many disks or directory entries can be
cataloged. However, the catalog file can grow to substantial size. If
you intend to store the catalog file on a floppy disk with 360K bytes
storage, you will be able to catalog about 4,530 files, using the
fixed record column length of 78 columns (two additional bytes per
record are required for the terminator--a carriage return and line
feed). The default record length may be shortened or lengthened (see
CHANGING DEFAULT SETTINGS), which changes the maximum number of files
that can be stored in a given disk space.

To make a sensible catalog of many disks, each disk must be
identifiable in the catalog list. Disk volume labels serve this
purpose, and therefore each disk cataloged must have a volume label.
If CATS finds that a disk volume label is missing, the program will
ask you to furnish one or to exit the program. To help find that disk
later, some thought should go into the volume label choice. Sequential
numbers are often found the most useful, provided these numbers are
then written on the disk paper labels. As described above, CATS also
allows you to use volume labels which are different than those stored
magnetically on the disks.

CATS is streamlined to act efficiently cataloging a complete library
of disks. When one disk has been cataloged, CATS asks if you wish to
continue, and gives you the choice of either operating with the same
drive to catalog another disk, or to change to another drive. By
switching between drives A: and B:, for example, you can be loading
one drive while CATS is working on the disk in the other. When
finished, a carriage return closes the completed catalog file and
exits back to MS-DOS.

CATALOG FILE STRUCTURE

CATS creates a catalog file, listing each file found on each disk,
together with its size, date and time of creation, disk volume label,
and a possible path. Space is reserved to the right in each line to
add any comments you wish to help identify the file. The sample
records shown below will help illustrate the structure of the catalog
files produced by CATS.

FOOBAR EXE 89984 83/11-30 01:23 DISK 000001\
FOOBAR DOC 85/08-02 02:06 DISK 000001\
MSDOS SYS s 17071 84/09-10 13:25 DISK 0000 01 \
DISK000 001 V 85/08-02 00:25 DISK 000001\
104448 86/08-30 10:21 DISK 000001\ <- Free Space

The format of each record for the default settings is shown below:

Field description Default Appearance
================== ======= ==========
Filename 1- 8 FILENAME
Space1 9
Extension 10-12 EXT
Space2 13
Attribute symbol 14 V D S v d s h @


File size 15-22 12345678
Space3 23
Date 24-31 86/08- 20
Space4 32
Time 33-37 18:
Space5 38
Volume label 39-49 VOLABEL
Path from root 50- \PATH1\PATH2\ARCHIVE.
Fill to end - ....

The column positions provided above are the first and last columns of
each field. These data are useful for specifying the key field
positions needed by sorting utilities. These set of positions listed
are those created by CATS when none of the defaults have been changed.
See Appendix A for non- default column positions (see also CHANGING
DEFAULT SETTINGS).

The files are listed in directory order, that is, just as they are
found in the directory on the disk. Directories are listed to identify
their creation date, but their display can be suppressed by changing
defaults. The disk volume label is also given a separate line, so that
the volume label creation date can be noted. (This has the added
benefit of showing, in the catalog file, the actual volume label, if
you have chosen to use a different one in the catalog.) In addition, a
line will appear which has all spaces in the file name field. This
line is reserved for indicating the remaining disk space and the
current date. When a sort (in ascending order) is performed on the
file name field, all of the disk space information will appear on the
top of the sorted file.

The attribute field takes one column in the default mode of CATS, with
one preceding space. The symbols V (volume), D (directory), S
(system), h (hidden), a (arc), and z (zip) flag symbols are used. If D
or S show in lower case, then the directory or system file was hidden.
If V is shown in lower case, then the disk had no physical label, and
the CATS /N switch was used to prevent one from being created on the
disk. In that case, the label used in the catalog file name field is
the one supplied by the user during the CATS cataloging session. The
backup flag (also sometimes called archive flag) is not shown in the
default configuration. (See CHANGING DEFAULT SETTINGS to see how to
change the flag characters.)

Eight columns are reserved for the file size in bytes, with no
preceding space (unless a comma is used as the field separator, in
which case only seven columns are used for the file size). As files of
10 Megabytes or more are rare, some clear space will nearly always
appear between the attribute and size fields. If a file size or total
disk space exceeds the allocated space, question marks will appear in
the size field.

The date and time indication is non-standard but very logical: The
order from left to right starts with the largest unit and proceeds to
the smallest. This format was taken to allow chronological sorting of
the catalog file based on a single sort over the whole date and time


field. The format is: Year/Month-Day Hour:Minute. Seconds are omitted
(unless you change the defaults--see CHANGING DEFAULT SETTINGS to see
how to change the flag characters) to preserve more comment space on
the right of the line. If no date or time is recorded in the
directory, asterisks will appear in the date or time field. Since an
asterisk is below numbers in an ASCII sort, files without a date or
time will appear at the beginning of an ascending sort on these
fields. Files without a date or time are unusual and unorthodox, but
can be created by some utilities, such as CHKDSK from Microsoft
Corporation. (Rescued orphan-cluster files with the name FILE0xxx.CHK
are created without a date or time.)

The volume label is an important sorting and searching field. Thus
CATS requires a disk volume label or a label which you supply
interactively. By searching the catalog produced by CATS for a given
file and reading the volume label which follows, the disk on which the
file resides can be quickly identified. Unless the 'N' switch is used
with CATS, the volume label will correspond to the label written in
that disk directory. Otherwise, it will be the name you gave for the
volume label when cataloging the disk and should correspond to the
disk paper label. The label field has eleven characters, with no space
before the following path name.

The path name field has a variable length (limited by the maximum
record length, which has a default value of 78). If the path name will
not fit in the record length of one line, it will be truncated. A
switch in CATS can be used to turn off the path name field, making it
easier to add longer comments to a file line (see CHANGING DEFAULT
SETTINGS). The path name field is of somewhat lesser utility on 360
kilobyte diskettes than hard disks, as these usually do not have an
extensive directory tree structure. However, this field can be quite
useful for hard-disk partitions and for 96 tpi/720 KB and high-
density/1.25 MB floppies. The catalog line showing the remaining disk
space and current date will have the comment:

' <- Free Space '

replacing the path name field.

USING THE CATALOG FILE

A good sorting program should be able to sort any of the defined
fields of your catalog, giving you alphabetical file name listings,
chronological listings, disk contents listings, file size orderings,
etc. Sorting on the volume label field will concatenate the files for
each disk in the catalog. Once a number of disks have been cataloged
with CATS, the catalog can be sorted sequentially to produce almost
any desired ordering of the listings. Further processing by a utility
such as UNIQ can eliminate duplicate listings, should these eventually
creep into the catalog.

A companion sorting program called SORTS is available with CATS for
ordering your catalog file. Both CATS and SORTS were written in
assembly language, making them quite fast. In addition, SORTS uses


all available memory to perform its sorting function. Catalog files
with up to 30,000 lines can be sorted, with the sorting order
determined by a selection of multiple key columns, sorting in normal
or reverse order in any of these selected columns. This makes SORTS
one of the most versatile sorting programs available.

SORTS contains a set of default sorting columns which match the
default fields used in a CATS catalog. This means you do not have to
determine or enter the column positions each time SORTS is run. The
default column order settings in SORTS are:

Column order setting Purpose for CATS Catalog file
-----
n=1-8,10-12,14 Sort by name, extension, attribute

s=r15-22,14,1-3 Reverse sort by file size, then attr.,
then file extension
t=r24-25,r27-28,r30-31, Reverse sort by date, then name
r33-34,r36-37,1- 2
l=39-49,1 Sort by volume label, then name

p=51-67,39-49 Sort by path name, then vol. label

a=14,1-8,10-12 Sort by attribute, then file name

y=r24-25,1-8,10-12 Reverse sort by year, then file name
----

As an example, suppose you wished to find all files in your catalog
CATS.DIR which were created in 1985 with a given name. You could
first perform the sort:

SORTS CATS.DIR CATY.DIR/Uy

Then, use a file listing utility to search within and display the new
sorted catalog. All files with a given name within 1985 will be
arranged together in the new catalog (refer to the documentation for
SORTS for a detailed description of its the command syntax).

CAUTION: If you edit a catalog and then wish to use CATS to add new
disk volumes, be sure the catalog file has not been terminated with a
control-Z by your editor. If it has, that same editor may not be able
to view the appended new volume information. The editor BSE.EXE
supplied with the Zenith Programmer's Utility Pack is a fine editor
for quickly searching a catalog and adding comments. Moreover, it will
not automatically add end-of-file characters when you finish editing.
Another extremely well designed and powerful ASCII editor is QEDIT by
Sammy Mitchell of SemWare. For a quick search for a particular file,
Vernon Buerg's LIST.COM (or ZLIST.COM on the Z100) is probably the
fastest available and most flexible file-to-screen displayer and
text-string searcher.

CHANGING DEFAULT SETTINGS


The default settings are stored in CATS.COM near the beginning of the
program. Ordinarily, these settings need not be changed. However, some
users may prefer a different configuration of CATS. To change the
default catalog name so that it does not have to be supplied on the
command line, use the command:

CATS /C

CATS will give the present default catalog name and request a new one.
You may give a complete drive and path name or simply the file name,
if the catalog is to be on the drive and in the directory from which
CATS is invoked. For the /C to work, CATS must be able to find itself
on the disk. If you must change the name of the program, change the
file name CATS.COM within the program near its beginning using the
DEBUG utility.

Other configuration parameters may also be changed. However, these may
affect the format of the catalog file, and therefore should not be
changed unless you plan to create a completely new catalog (see
CATALOG FILE STRUCTURE).

Listed below are the configuration parameters which can be changed
with the MS-DOS utility DEBUG. Make these changes with care, and keep
a backup copy of CATS, just in case an error occurs.

Load CATS into DEBUG with the command:

DEBUG CATS.COM <cr>

(The <cr> means "RETURN" or "ENTER".) Use the E(xamine) command of
DEBUG to look at and make changes to a particular byte at a given
address. For example,

E10A <cr>

will show the current byte at address 10A (in hexadecimal). You can
put your own value following the current one, then a <cr>. An ASCII
character can also be inserted directly with the E(xamine) command.
For example, to change the backup flag character to an 'B', you could
use the command:

E104'A' <cr>

To see the new set of values in one display, use the D(isplay)
command:

D100 <cr>

When you have finished reconfiguring CATS with DEBUG, you can write
CATS back to the disk using the W(rite) command. Exit DEBUG with the
Q(uit) command.

Address Default


(hex) Value Purpose
======= ======= ========================
0103 '.' comment-field fill-char.
0104 ' ' (space) backup flag character
010 5 'h' hidden flag character
0106 'S' system flag character
0107 'V' volume flag character
0108 0FFH show paths if 1
0109 0 show seconds if 1
010A 04FH columns in record (78)
010B 0FFH reserved
010C 0 reserved
010D 1 suppress dirs. if 0
010E 'D' directory flag character
010F 1 add space before file ext.
0110 2 col. space for attr. field
0111 1 fix rec.length if 0
0112 ' ' (space) field separation character
0113 '?' numeric overflow character
0114 '*' no date fill character
0115 '*' no time fill character
0116 'a' ARC-file flag char.
0117 4 process compressed file if 5
0118 0 ask for volume label if 1
0119 0 change default cat name if 1
011A 0 display files if 1
011B 0 make serial numbers if 1
011C 0 do not write label if 1
011D 0 use quiet mode if 1
011E 'z' ZIP-file flag char.

For fixed record output, the comment-field fill-line character is a
period (.) so that the length of each record (one line) is visible.
Some sorting utilities must have fixed record lengths. As you add
comments to each file line, the periods help to keep track of the
length of each line. However, because of the saving in space, the
default setting in CATS is for a variable record length. SORTS can
still be used with this format, as well as many data base programs
which can import ASCII data.

The default backup flag character is a space to make the catalog file
more readable. There are usually many files on a floppy disk with the
backup flag set, since this flag is set whenever the file is written,
and not reset until a BACKUP utility is run. If any other attribute is
present for display, the backup flag will not be shown, even if you
change the character to a visible one.

If a file has only the hidden flag set or the backup and hidden flag
set, the hidden flag (h) will be displayed in the catalog. A hidden
system file or directory will have a lower case (S) or (D) character
following the file name. The case of the flag is lowered in CATS by
forcing bit 5 in the flag character's binary code to be high (bits are
numbered from LSB=0 to MSB=7). If you change a flag character from the
initial default to any of the ASCII characters between the space (20H)


and '?' (3FH), this bit will already be high, so the case of the flag
character will not change when the file hidden flag is detected.

If the byte at address 108 is changed to 0, the file directory path
names will not be shown. This will leave more space for comments to
identify files.

The byte at address 109 controls whether seconds are displayed in the
time field. If so, it will take three extra columns.

You can change the record length for fixed record length output with
the byte at address 10A. Records longer than the standard screen width
of 80 columns up to 255 columns are allowed by CATS. Of course, only
80 columns can be seen on a normal screen, so an editor or listing
utility capable of horizontal scrolling would be needed to read the
remainder of any records wider than 80 columns. A default of 78
columns per record rather than 80 is taken so that if your console has
an automatic line wrapping set on, you will not see the catalog file
apparently double spaced when the catalog file is sent to the screen.
In addition, having 78 visible characters in a record plus a carriage
return and linefeed gives a full record length divisible by 16,
helping some sorting utilities.

The listing of directories can be suppressed if the byte at address
10D is 0.

One additional space for comments can be gained by deleting the space
between file names and their extensions. This space is controlled by
the byte at address 10F.

Additional comment space can be gained by reducing or removing the
field reserved for the attribute flag. The byte at address 110 can be
0, 1, or 2, representing the number of columns reserved for the
attribute character and preceding field separator.

For those who wish to use the CATS catalog as input to a data base
program, the field separation character at address 112 can be changed
to a comma, or any other character.

CATS ERROR MESSAGES

If you type CATS without any command string following, you will be
shown a help screen with the proper command syntax.

The error messages generated by CATS are explained below.

MS-DOS version above 2.0 required.

Version 1.x of MS-DOS will not run CATS.

X: is an invalid drive. Currently drives are: A: to ...

The drive name you specified was outside the range recognized by your
system.


Bad catalog disk, path, or file name.

The directories in the path must exist. As a precaution against
typographical errors creating new but unwanted directories, CATS
requires that the directory path to your catalog file exists.

Volume name matches a file name.

The volume label you specified has been rejected because it is the
same as a file name on the root directory of the disk.

Error creating volume label.

The following may cause this error: Invalid volume label character;
disk is flagged write only; the directory space on the disk is full;
the disk format was unrecognized; the given volume label matches a
current file name.

Error writing to catalog file: ...

The disk containing the catalog file is write protected or may not
have any space left. Invalid switch. A switch character following the
'/' on the command line was found not to match the defined ones.

The catalog program was not found.

An attempt to change the configuration of CATS failed, because
CATS.COM could not be found. If you wish to rename CATS.COM to any
other name, the /C option will not work unless you also change the
CATS.COM path name within CATS itself. This can be done using DEBUG.
The path name CATS.COM appears near the front of the program. There
are 64 bytes reserved for the path name.

Catalog name was not changed.

An invalid new catalog name was supplied, or a carriage return was
given in response to the request for a new name.

Volume label error. Sample format: VOLUME 000

The /M make volume serial label was used. The volume set label must
end in three numerical digits.

## MS-DOS ERROR MESSAGES WHILE IN CATS

The MS-DOS operating system can generate an error message when you
attempt to access a disk drive containing no disk or with the drive
door open. You will see the messages:

Drive ready error reading drive x:
Abort, Retry, or Ignore? _


If the disk is unformated or has a bad sector, you may see the
message:

Disk error reading drive x:
Abort, Retry, or Ignore? _

If you have left a write protect tab on the disk, and you attempt to
create a new volume label on the disk, MS-DOS gives:

Write protect error writing drive x:
Abort, Retry, or Ignore? _

You should put a valid disk in the drive, close the door, and press
'R' for Retry. CATS can then continue. If you press 'A' for abort, the
system will return to the operating system prompt on the drive from
which CATS was invoked.

APPENDIX A: Alternative CATS File Formats

When some of the default settings are changed in CATS.COM using DEBUG,
the format of the catalog file records will also change. This affects
the beginning of the sorting field columns. Below is a list of the new
column positions for a sample of changed switches within CATS:

Field ------------ Column positions ----------
description Default Alternate record format Appearance
============== ====== ================================= ==========
Filename 1- 8 1- 8 1- 8 1- 8 1- 8 1- 8 FILENAME
Space 9 ** 9 ** 9 **
Extension 10-12 9-11 10-12 9-11 10-12 9-11 EXT
Space 13 12 ** ** ** **
Attribute 14 13 13 12 ** ** V D S d s h
File size 15-22 14-21 14-21 13-20 13-20 12-19 mmttthhh
Date 24-31 23-30 23-30 22-29 22-29 21-28 86/08- 20
Time 33-37+ 32-36+ 32-36+ 31-35+ 31 - 35+ 30-34+ 18:45
Volume label 39-49 38-48 38-48 37-47 37-47 36-46 volumelabel
Path from root 50- 49 - 49 - 48 - 48 - 47 - \path\path
Fill to end (if fixed record length output) ....
_____________________________________________________________________
** Position deleted by changing defaults.
+ An additional three positions are used for optional display of
seconds.

If the defaults are changed to display seconds, add three to the width
of the key field length for sorting time, and add three each to the
start and end positions for volume label and to the start position for
path.

CHANGES:

Version 2.4 (March, 1989) Added ZIP file support; expanded ERRORLEVEL
values; added search for invoking program name under DOS 3.x when
clone of program is attempted with /c switch.


Version 2.3 (January, 1988) Added archive directories; variable record
lengths; quiet switch; ask to catalog with /D switch.

## DISTRIBUTION:

CATS is released for use by members of the Capital Heath Users' Group
by its initial distribution. With Version 1.8, CATS is released for
distribution into the public domain by its author, W. C. Parke. CATS
is copyrighted 1986 by W. C. Parke, 1820 S Street NW, Washington, D.C.
20009, telephone (202) 667-4094.

CATS may be freely copied and used, but may not be sold for profit or
bundled with products offered for sale without expressed permission of
the author.

-------