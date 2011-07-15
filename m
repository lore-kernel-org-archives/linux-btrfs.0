From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RFC][GIT] Move the the text of the man page in the code
Date: Fri, 15 Jul 2011 15:28:19 +0200
Message-ID: <4E204073.2060103@inwind.it>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020203000604020109090104"
Cc: Hugo Mills <hugo@carfax.org.uk>, Hubert Kario <kario@wit.edu.pl>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020203000604020109090104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

after the discussion of the thread " [PATCH 2/2] add detailed help
messages to btrfs command", I coded a solution for moving the help
information of the btrfs sub-commands in the code.

Actually we have three source of information about the btrfs sub-commands:
1) btrfs help
   this show the command syntax, and a brief help (often 1 line) about
   the command purpose
2) btrfs <sub-command> --help
   this show the command syntax, and a detailed (if available )
   explanation of the command
3) the man page

This cause a lot of information duplicated. Very often these information
are incoherent or outdated.

My idea is to code these information in the comment before the relevant
function. Then a tool will parse these files and generate both a man
page and the text showed in the "btrfs *help" commands.

The information are store in a comment like this:

/**** man: btrfs subvolume delete
 *
 * \Bbtrfs\b \Bsubvolume delete\b\I <subvolume>\i
 *
 * Delete the subvolume <subvolume>.
 *
 * Delete the subvolume \I<subvolume>\i. If \I<subvolume>\i is not a
 * subvolume, \Bbtrfs\b returns an error.
 ****/

The first part ("/**** man: ") is a marker line is a marker. So the tool
knows that it should extract the information from the comment.

* After the marker (first line) there is the name of the btrfs sub command.
* Then there is a empty line.
* Then there is the command line syntax (1 line only)
* Then there is a empty line.
* Then there is the short description (the one used in the command
"btrfs help"). Multiple line allowed.
* Then there is a empty line.
* Then there is the detailed description (the one used in the command
"btrfs <btrfs sub command> --help", and in the man page). Multiple line
allowed.

Note: the \B are marker to highlight that it should start the bold font.
(\b->end bold font, \I->start italic font, \i->end italic font....)

For the help command these information are sufficient. For the man page,
there is two more section (which I named "btrfs introduction" and "btrfs
notes") which detail in a more general way the btrfs commands. Think
about these section as a header and a footer.

  Technical details:

The tool which extract the information is called "helpextract". It is a
C program which analyzes the files passed on the command line, and
generate the C array and the man page.


   C-Array

The Makefile generates the file helpmsg.c, which contains an array with
all the information extracted from the comment. The code which process
the help uses these information to show the normal and the detailed help.

   Man page

The man page generation is a bit more complicated. There is a footer,
there is header, there is an introduction, there is a section which
contains the notes (I hope to permit the access about these two section
from the command line; something like "btrfs help introduction") and
some template.
You can generate the man page via
$ make man/btrfs.8.2.in
$ man man/btrfs.8.2.in

The man page is quite good. You can download at

	http://cassiopea.homelinux.net/tmp/btrfs.8.2.in


   Where are the information.

For simplicity I put the comment with the information in two files:
"btrfs.8+1.in.c" and "btrfs.8.in.c". These two files are temporary. I
hope to integrate the text in the source.

   Repository

You can download the source from
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
and/or browse the code at
	http://cassiopea.homelinux.net/git/?p=btrfs-progs-unstable.git


$ git diff --stat integration-20110705

 Makefile                 |   22 +++-
 btrfs.8+1.in.c           |  331 ++++++++++++++++++++++++++++++++
 btrfs.8.in.c             |  116 +++++++++++++
 btrfs.c                  |   34 ++++-
 extract_from_man_page.py |  249 ++++++++++++++++++++++++++++
 helpextract.c            |  403 ++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in           |   27 ++--
 7 files changed, 1163 insertions(+), 19 deletions(-)

    Escape sequence

As stated before, in the comment it is possible to use some escape
sequence to format the text. When the man page is generate, the tools
replace the escape sequence (the left one) with a "troff" macro on the
basis of the following table:

                \B \fB       /* bold */
                \b \fP       /* end bold */
                \I \fI       /* italic */
                \i \fP       /* end italic */
                \c .\"      /* comment */
                \P .PP        /* start paragraph */
                \p .TP        /* indented paragraph */
                \h .SH        /* header */
                \d .BR        /* bold regular */
                \e .B         /* bold */
                \t .IP        /* indented paragraph */
                \w .RS        /* move the left margin */
                \q .RE        /* move the left margin back */

For example the \P sequence is used to start a paragraph.

    Next step

If there no is major complaints and/or issues I will move the comments
with the information near the functions which perform the command, and I
will add some documentation.

Comments are welcome
BR
G.Baroncelli

Enclosed the code for the comment

diff --git a/Makefile b/Makefile
index edee1a0..f089ca7 100644
--- a/Makefile
+++ b/Makefile
@@ -35,8 +35,9 @@ all: version $(progs) manpages
 version:
        bash version.sh

-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o helpmsg.o
        $(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+               helpmsg.o \
                $(objects) $(LDFLAGS) $(LIBS)

 btrfsctl: $(objects) btrfsctl.o
@@ -84,6 +85,25 @@ convert: $(objects) convert.o
 ioctl-test: $(objects) ioctl-test.o
        $(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS)
$(LIBS)

+helpextract: helpextract.o
+       $(CC) $(CFLAGS) -o $@ helpextract.o
+
+man/btrfs.8.2.in: helpextract
+       ./helpextract --man-page btrfs.8*.c >$@
+
+helpmsg.c: helpextract
+       echo  >$@ "/*"
+       echo >>$@ " * this file contains the help messages. It is "
+       echo >>$@ " * automatically generated. do not edit ! "
+       echo >>$@ " */"
+       echo >>$@
+       echo >>$@ "#define NULL 0"
+       echo >>$@
+
+       echo -n "char * help_messages[] = " >>$@
+       ./helpextract --c-array btrfs.8*.c >>$@
+        echo >>$@ ";"
+
 manpages:
        cd man; make

diff --git a/btrfs.8+1.in.c b/btrfs.8+1.in.c
new file mode 100644
index 0000000..49855d4
--- /dev/null
+++ b/btrfs.8+1.in.c
@@ -0,0 +1,331 @@
+/**** man: btrfs subvolume delete
+ *
+ * \Bbtrfs\b \Bsubvolume delete\b\I <subvolume>\i
+ *
+ * Delete the subvolume <subvolume>.
+ *
+ * Delete the subvolume \I<subvolume>\i. If \I<subvolume>\i is not a
+ * subvolume, \Bbtrfs\b returns an error.
+ ****/
+
+/**** man: btrfs scrub start
+ *
+ * \Bbtrfs\b \Bscrub start\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ *
+ * Start a new scrub.
+ *
+ * Start a scrub on all devices of the filesystem identified by
\I<path>\i or on
+ * a single \I<device>\i. Without options, scrub is started as a background
+ * process. Progress can be obtained with the \Bscrub status\b command.
Scrubbing
+ * involves reading all data from all disks and verifying checksums.
Errors are
+ * corrected along the way if possible.
+ * \w
+ *
+ * \IOptions\i
+ * \t -B 5
+ * Do not background and print scrub statistics when finished.
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem (-B only).
+ * \t -q 5
+ * Quiet. Omit error messages and statistics.
+ * \t -r 5
+ * Read only mode. Do not attempt to correct anything.
+ * \t -u 5
+ * Scrub unused space as well. (NOT IMPLEMENTED)
+ * \q
+ ****/
+
+/**** man: btrfs filesystem show
+ *
+ * \Bbtrfs\b \Bfilesystem show\b [--all-devices|<uuid>|<label>]\b
+ *
+ * Show the info of a btrfs filesystem. If no argument
+ * is passed, info of all the btrfs filesystem are shown.
+ *
+ * Show the btrfs filesystem with some additional info. If no \IUUID\i or
+ * \Ilabel\i is passed, \Bbtrfs\b show info of all the btrfs filesystem.
+ * If \B--all-devices\b is passed, all the devices under /dev are scanned;
+ * otherwise the devices list is extracted from the /proc/partitions file.
+ ****/
+
+/**** man: btrfs balance progress
+ *
+ * \Bbtrfs\b \Bbalance progress\b [\B-m\b|\B--monitor\b] \I<path>\i
+ *
+ * Show progress of the balance operation running on <path>.
+ *
+ * Report progress on the currently-running balance operation on the
+ * filesystem mounted at \I<path>\i. Use --monitor to report progress
+ * continually, including an estimate of completion time.
+ ****/
+
+/**** man: btrfs filesystem sync
+ *
+ * \Bbtrfs\b \Bfilesystem sync\b\I <path> \i
+ *
+ * Force a sync on the filesystem <path>.
+ *
+ * Force a sync for the filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs subvolume set-default
+ *
+ * \Bbtrfs\b \Bsubvolume set-default\b\I <id> <path>\i
+ *
+ * Set the subvolume of the filesystem <path> which will be mounted
+ * as default.
+ *
+ * Set the subvolume of the filesystem \I<path>\i which is mounted as
+ * \Idefault\i. The subvolume is identified by \I<id>\i, which
+ * is returned by the \Bsubvolume list\b command.
+ ****/
+
+/**** man: btrfs device delete
+ *
+ * \Bbtrfs\b \Bdevice delete\b\I <dev> [<dev>..] <path>\i
+ *
+ * Remove a device from a filesystem.
+ *
+ * Remove device(s) from a filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs balance cancel
+ *
+ * \Bbtrfs\b \Bbalance cancel\b \I<path>\i
+ *
+ * Cancel the balance operation running on <path>.
+ *
+ * Cancel the balance currently running on the filesystem mounted at
+ * \I<path>\i.
+ ****/
+
+/**** man: btrfs scrub resume
+ *
+ * \Bbtrfs\b \Bscrub resume\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ *
+ * Resume previously canceled or interrupted scrub.
+ *
+ * Resume a canceled or interrupted scrub cycle on the filesystem
identified by
+ * \I<path>\i or on a given \I<device>\i. Does not start a new scrub if the
+ * last scrub finished successfully.
+ * \w
+ *
+ * \IOptions\i
+ *  \p
+ * see \Bscrub start\b.
+ * \q
+ ****/
+
+/**** man: btrfs scrub status
+ *
+ * \Bbtrfs\b \Bscrub status\b [-d] {\I<path>\i|\I<device>\i}
+ *
+ * Show status of running or finished scrub.
+ *
+ * Show status of a running scrub for the filesystem identified by
\I<path>\i or
+ * for the specified \I<device>\i.
+ * If no scrub is running, show statistics of the last finished or
canceled scrub
+ * for that filesystem or device.
+ * \w
+ *
+ * \IOptions\i
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem.
+ * \q
+ ****/
+
+/**** man: btrfs subvolume list
+ *
+ * \Bbtrfs\b \Bsubvolume list\b\I [-p] <path>\i
+ *
+ * List the snapshot/subvolume of a filesystem.
+ *
+ * List the subvolumes present in the filesystem \I<path>\i. For every
+ * subvolume the following information is shown by default.
+ * ID <ID> top level <ID> path <path>
+ * where path is the relative path of the subvolume to the \Itop level\i
+ * subvolume.
+ * The subvolume's ID may be used by the \Bsubvolume set-default\b
command, or
+ * at mount time via the \Isubvol=\i option.
+ * If \I-p\i is given, then \Iparent <ID>\i is added to the output
between ID
+ * and top level. The parent's ID may be used at mount time via the
+ * \Isubvolrootid=\i option.
+ ****/
+
+**** key= btrfs help|\-\-help|\-h  ; v= \fBbtrfs\fP
\fBhelp|\-\-help|\-h \fP\fI\fP
+
+/**** man: btrfs filesystem balance
+ *
+ * \Bbtrfs\b \Bfilesystem balance\b [\B-wcv\b] [\B--wait\b]
[\B--count\b] [\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ *
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ *
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ ****/
+
+/**** man: btrfs subvolume snapshot
+ *
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ *
+ * Create a writable/readonly snapshot of the subvolume <source> with
+ * the name <name> in the <dest> directory.
+ *
+ * Create a writable/readonly snapshot of the subvolume \I<source>\i
with the
+ * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
+ * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
+ * will be readonly.
+ ****/
+
+/**** man: btrfs filesystem defragment
+ *
+ * \Bbtrfs\b \Bfilesystem defragment\b -c[zlib|lzo] [-l \Ilen\i] [-s
\Istart\i] [-t \Isize\i] -[vf] <\Ifile\i>|<\Idir\i>
[<\Ifile\i>|<\Idir\i>...]
+ *
+ * Defragment a file or a directory.
+ *
+ * Defragment file data and/or directory metadata. To defragment all
files in a
+ * directory you have to specify each one on its own or use your shell
wildcards.
+ *
+ * The start position and the number of bytes to deframention can be
specified by \Istart\i and \Ilen\i. Any extent bigger than \Ithresh\i
will be considered already defragged. Use 0 to take the kernel default,
and use 1 to say eveery single extent must be rewritten. You can also
turn on compression in defragment operations.
+ *
+ * \B-v\b be verbose
+ *
+ * \B-c\b compress file contents while defragmenting
+ *
+ * \B-f\b flush filesystem after defragmenting
+ *
+ * \B-s start\b defragment only from byte \Istart\i onward
+ *
+ * \B-l len\b defragment only up to \Ilen\i bytes
+ *
+ * \B-t size\b defragment only files at least \Isize\i bytes big
+ *
+ * NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed
copies of data, don't
+ * use it if you use snapshots, have de-duplicated your data or made
copies with
+ * \Bcp --reflink\b.
+ ****/
+
+/**** man: btrfs subvolume find-new
+ *
+ * \Bbtrfs\b \Bsubvolume find-new\b\I <subvolume> <last_gen>\i
+ *
+ * List the recently modified files in a filesystem.
+ *
+ * List the recently modified files in a subvolume, after
\I<last_gen>\i ID.
+ ****/
+
+/**** man: btrfs device add
+ *
+ * \Bbtrfs\b \Bdevice add\b\I <dev> [<dev>..] <path>\i
+ *
+ * Add a device to a filesystem.
+ *
+ * Add device(s) to the filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs filesystem resize
+ *
+ * \Bbtrfs\b \Bfilesystem resize\b\I [+/\-]<size>[gkm]|max <path>\i
+ *
+ * Resize the file system. If 'max' is passed, the filesystem
+ * will occupe all available space on the device.
+ *
+ * Resize a filesystem identified by \I<path>\i.
+ * The \I<size>\i parameter specifies the new size of the filesystem.
+ * If the prefix \I+\i or \I\-\i is present the size is increased or
decreased
+ * by the quantity \I<size>\i.
+ * If no units are specified, the unit of the \I<size>\i parameter
defaults to
+ * bytes. Optionally, the size parameter may be suffixed by one of the
following
+ * the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or
gigabytes,
+ * respectively.
+ *
+ * If 'max' is passed, the filesystem will occupy all available space
on the
+ * volume(s).
+ *
+ * The \Bresize\b command \Bdoes not\b manipulate the size of underlying
+ * partition.  If you wish to enlarge/reduce a filesystem, you must
make sure you
+ * can expand the partition before enlarging the filesystem and shrink the
+ * partition after reducing the size of the filesystem.
+ ****/
+
+/**** man: btrfs filesystem label
+ *
+ * \Bbtrfs\b \Bfilesystem label\b\I <dev> [newlabel]\i
+ *
+ * With one argument, get the label of filesystem on <device>.
+ * If <newlabel> is passed, set the filesystem label to <newlabel>.
+ * The filesystem must be unmounted.
+ *
+ * Show or update the label of a filesystem. \I<dev>\i is used to
identify the
+ * filesystem.
+ * If a \Inewlabel\i optional argument is passed, the label is changed. The
+ * following costraints exist for a label:
+ * \t
+ * - the maximum allowable lenght shall be less or equal than 256 chars
+ * \t
+ * - the label shall not  contain the '/' or '\\' characters.
+ *
+ * NOTE: Currently there are the following limitations:
+ * \t
+ * - the filesystem has to be unmounted
+ * \t
+ * - the filesystem should not have more than one device.
+ ****/
+
+/**** man: btrfs device scan
+ *
+ * \Bbtrfs\b \Bdevice scan\b \I[--all-devices|<device> [<device>...]\i
+ *
+ * Scan all device for or the passed device for a btrfs
+ * filesystem.
+ *
+ * If one or more devices are passed, these are scanned for a btrfs
filesystem.
+ * If no devices are passed, \Bbtrfs\b scans all the block devices listed
+ * in the /proc/partitions file.
+ * Finally, if \B--all-devices\b is passed, all the devices under /dev are
+ * scanned.
+ ****/
+
+**** key= btrfs <command> \-\-help  ; v= \fBbtrfs\fP \fB<command>
\-\-help \fP\fI\fP
+
+/**** man: btrfs balance start
+ *
+ * \Bbtrfs\b \Bbalance start\b [\B-wcv\b] [\B--wait\b] [\B--count\b]
[\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ *
+ * Synonym for "btrfs filesystem balance".
+ *
+ * Balance the chunks of the filesystem identified by \I<path>\i across
+ * the devices. The command returns immediately, and the balance
+ * operation runs in the background. Use \B--wait\b to run
+ * synchronously instead. Use \B--count\b to scan the filesystem and
+ * report the number of chunks that would be processed. Use
+ * \B--verbose\b in synchronous mode to report the number of chunks
+ * examined and balanced. See \BBALANCE FILTERS\b, below, for details
+ * of the different filter types and syntax.
+ ****/
+
+/**** man: btrfs subvolume create
+ *
+ * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ *
+ * Create a subvolume in <dest> (or the current directory if
+ * not passed).
+ *
+ * Create a subvolume in \I<dest>\i (or in the current directory if
+ * \I<dest>\i is omitted).
+ ****/
+
+/**** man: btrfs scrub cancel
+ *
+ * \Bbtrfs\b \Bscrub cancel\b {\I<path>\i|\I<device>\i}
+ *
+ * Cancel a running scrub.
+ *
+ * If a scrub is running on the filesystem identified by \I<path>\i,
cancel it.
+ * Progress is saved in the scrub progress file and scrubbing can be
resumed later
+ * using the \Bscrub resume\b command.
+ * If a \I<device>\i is given, the corresponding filesystem is found and
+ * \Bscrub cancel\b behaves as if it was called on that filesystem.
+ ****/
+
diff --git a/btrfs.8.in.c b/btrfs.8.in.c
new file mode 100644
index 0000000..6957a1d
--- /dev/null
+++ b/btrfs.8.in.c
@@ -0,0 +1,116 @@
+/**** text: man btrfs header
+ * .TH BTRFS 8 "" "btrfs" "btrfs"
+ * .\"
+ * .\" Man page written by Goffredo Baroncelli <kreijack@inwind.it>
(Feb 2010)
+ * .\"
+ * .SH NAME
+ * btrfs \- control a btrfs filesystem
+ ****/
+
+/**** text: man btrfs synopsis
+ * .SH SYNOPSIS
+ ****/
+
+/**** text: man btrfs synopsis format
+ * \fB%s\fP
+ * .PP
+ ****/
+
+/**** text: man btrfs command format
+ *
+ * .TP
+ * %s%s
+ ****/
+
+/**** text: btrfs introduction
+ * .SH DESCRIPTION
+ * \Bbtrfs\b is used to control the filesystem and the files and
directories
+ * stored. It is the tool to create or destroy a snapshot or a
subvolume for
+ * the filesystem, to defrag a file or a directory, flush the data to
the disk,
+ * to resize the filesystem, to scan the device.
+ *
+ * It is possible to abbreviate the commands unless the commands  are
ambiguous.
+ * For example: it is possible to run
+ * \Ibtrfs sub snaps\i instead of \Ibtrfs subvolume snapshot\i. But
\Ibtrfs
+ * file s\i is not allowed, because \Ifile s\i may be interpreted both as
+ * \Ifilesystem show\i and as \Ifilesystem sync\i.
+ *
+ * If a command is terminated by \I--help\i, the detailed help is showed.
+ * If the passed command matches more commands, detailed help of all the
+ * matched commands is showed. For example \Ibtrfs dev --help\i shows the
+ * help of all \Idevice*\i commands.
+ ****/
+
+/**** text: man btrfs commands
+ * .SH COMMANDS
+ * .TP
+ */
+
+/**** text: btrfs notes
+ * \h BALANCE FILTERS
+ *
+ * With balance filters, it is possible to perform a balance operation on
+ * only a subset of the available chunks. Filters are specified with the
+ * \B--filter\b option of \Bbtrfs filesystem balance\b or \Bbtrfs
+ * balance start\b. Multiple filters may be given, either with multiple
+ * \B--filter\b options, or in a colon-separated list. When multiple
+ * filters are given, only the chunks meeting all of the selection
+ * critera are balanced. Help on the avaialble filters can be obtained
+ * with \B--filter=help\b.
+ *
+ *
+ * \Btype\b=[\B~\b]\I<flagname>\i[\B,\b...]
+ *
+ * Select only the chunks with the given type flag(s). Requiring a flag
+ * to be off can be specified with a \B~\b preceding the flag
+ * name. Flag names are:
+ *
+ * \Bmeta\b, \Bdata\b, \Bsys\b for metadata, file data and system
+ * chunk types.
+ *
+ * \Braid0\b, \Braid1\b, \Braid10\b, \Bdup\b for chunks of the
+ * given replication levels.
+ *
+ *
+ * \Bdevid\b=\I<n>\i
+ *
+ * Select chunks which have data on device ID \I<n>\i. This can be
+ * used, for example, to reduplicate data in a mirrored configuration
+ * where one drive has been lost due to hardware failure.
+ *
+ *
+ * \Bvrange\b=\I<start>\i,\I<end>\i
+ *
+ * Select chunks which have btrfs-internal virtual addresses within the
+ * range \I<start>\i (inclusive) to \I<end>\i (exclusive). Given the
+ * address of the last chunk moved, this filter can be used to restart a
+ * cancelled or interrupted balance operation, by supplying a range of
+ * \B0,\I<chunkaddr+1>\i.
+ *
+ * \Bdrange\b=\I<start>\i,\I<end>\i
+ *
+ * Select chunks which contain data in the address range \I<start>\i
+ * (inclusive) to \I<end>\i (exclusive) on \Iany\i block device in
+ * the filesystem. Can be mixed with the \Bdevid\b filter to select
+ * chunks in a given address range on a specific device.
+ *
+ * \h EXIT STATUS
+ * \Bbtrfs\b returns a zero exist status if it succeeds. Non zero is
returned in
+ * case of failure.
+ *
+ * \h AVAILABILITY
+ * \Bbtrfs\b is part of btrfs-progs. Btrfs filesystem is currently under
+ * heavy development, and not suitable for any uses other than
benchmarking and
+ * review.
+ *
+ * Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+ * further details.
+ *
+ * \h SEE ALSO
+ * \Bmkfs.btrfs (8)\b
+ ****/
+
+/**** text: man btrfs footer
+ ****/
+
+
diff --git a/btrfs.c b/btrfs.c
index 67d6f6f..fb94cf9 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -181,6 +181,8 @@ static struct Command commands[] = {
        { 0, 0, 0, 0 }
 };

+extern char * help_messages[];
+
 static char *get_prgname(char *programname)
 {
        char    *np;
@@ -196,21 +198,43 @@ static char *get_prgname(char *programname)
 static void print_help(char *programname, struct Command *cmd, int
helptype)
 {
        char    *pc;
+       int     i;
+       char    *adv_help;
+       char    *std_help;
+
+       /* printf("\t%s %s ", programname, cmd->verb ); */
+
+       adv_help = cmd->adv_help;
+       std_help = cmd->help;
+
+       for(i = 0; help_messages[i]; i+= 4 ){
+               if(!strncmp(help_messages[i],"btrfs ",6) &&
+                  !strcmp(help_messages[i]+6,cmd->verb) ){
+                       if(help_messages[i+2])
+                               std_help = help_messages[i+2];
+                       if(help_messages[i+3])
+                               adv_help = help_messages[i+3];
+                       printf("\t%s\t\t",help_messages[i+1]);
+                       break;
+               }
+       }

-       printf("\t%s %s ", programname, cmd->verb );
+       if( !help_messages[i])
+               printf("\t%s %s ", programname, cmd->verb );

-       if (helptype == ADVANCED_HELP && cmd->adv_help)
-               for(pc = cmd->adv_help; *pc; pc++){
+       if (helptype == ADVANCED_HELP && adv_help){
+               for(pc = adv_help; *pc; pc++){
                        putchar(*pc);
                        if(*pc == '\n')
                                printf("\t\t");
                }
-       else
-               for(pc = cmd->help; *pc; pc++){
+       }else{
+               for(pc = std_help; *pc; pc++){
                        putchar(*pc);
                        if(*pc == '\n')
                                printf("\t\t");
                }
+       }

        putchar('\n');
 }
diff --git a/extract_from_man_page.py b/extract_from_man_page.py
new file mode 100644
index 0000000..033da00
--- /dev/null
+++ b/extract_from_man_page.py
@@ -0,0 +1,249 @@
+import os
+
+f = open("man/btrfs.8.in")
+while True:
+       line = f.readline()
+       if line.startswith(".SH SYNOPSIS"): break
+
+
+cmds = []
+while True:
+       line = f.readline()
+       pp = f.readline()
+       if not pp.startswith(".PP"):
+               break
+
+       cmds.append(line)
+
+
+while True:
+       line = f.readline()
+       if line.startswith(".SH COMMANDS"): break
+
+
+       line = f.readline()
+
+xcmds = []
+cmd = ""
+while True:
+       line = f.readline()
+
+       if line.startswith(".\\\""):
+               continue
+
+       if line.startswith(".TP") or line.startswith(".SH"):
+               xcmds.append(cmd)
+               cmd=""
+               if line.startswith(".SH"): break
+               continue
+
+       cmd += line
+
+
+#print cmds
+#print xcmds
+
+mcmds = dict()
+for c in cmds:
+       i1 = c.find("\\fP")
+       i2 = c.find("\\fP", i1+1)
+
+       key = c[:i2]
+       key = key.replace("\\fB","").replace("\\fP","")
+
+       mcmds[key] = c
+
+
+#for k,v in mcmds.iteritems():
+#      print "%s: %s"%(k,v)
+
+
+for c in xcmds:
+       c = c.strip()
+       if len(c) == 0: continue
+
+       firstline = c.split("\n")[0]
+       i = firstline.find("\\fR")
+       if(i<0):
+               i = firstline.find("\\fP")
+       if(i<0):
+               print
+               print "*****Formato linea",c
+               continue
+       key = firstline[:i]
+       key = "btrfs
"+key.replace("\\fB","").replace("\\fP","").replace("\\fR","")
+
+       if mcmds.has_key(key):
+               mcmds[key] = (mcmds[key], c)
+       else:
+               print
+               print "******Non riesco a trovare ",key
+
+
+
+
+f2 = open("btrfs.c")
+
+def merge_strings(s):
+       i=0
+       q=False
+       xesc=False
+       r=""
+       escape_seq={ '"': '"',
+                                'n': '\n',
+                                't': '\t' }
+
+       while(i<len(s)):
+               if xesc:
+                       xesc=False
+                       r += escape_seq[s[i]]
+                       i+=1
+                       continue
+               elif s[i] == '"':
+                       q = not q
+                       i+=1
+                       continue
+               elif s[i] == '\\':
+                       xesc = True
+                       assert(q)
+                       i+=1
+                       continue
+
+               if q:
+                       r += s[i]
+
+               i+=1
+
+       return r
+
+
+m_short_help=dict()
+r=False
+block=False
+n=0
+head = ""
+short_help=""
+for l in f2.readlines():
+       if l.startswith("static struct Command co"):
+               r=True
+               continue
+       if r and l.startswith("}"):
+               break
+       if "{" in l:
+               block=True
+               n=0
+               continue
+       if not block:
+               continue
+
+       if(n==0):
+               head=l
+               k=head.find(",")
+               if(k>=0):
+                       head = head[:k]
+               head="btrfs "+merge_strings(head)
+               n+=1
+               continue
+       if(n==1):
+               short_help+=l
+               if l.strip().endswith(","):
+                       m_short_help[head]=merge_strings(short_help)
+                       block=False
+                       short_help=""
+                       head=""
+                       n=0
+
+
+
+#for k,v in m_short_help.iteritems():
+#      print "\n%s:\n%s"%(k,v)
+
+def cleanup(s):
+
+       r=""
+       i=0
+       bold=False
+       italic=False
+       while(i<len(s)):
+
+               if s[i:].startswith("\\fB"):
+                       bold=True
+                       i+=3
+                       r += "\\B"
+               elif s[i:].startswith("\\fI"):
+                       italic=True
+                       i+=3
+                       r += "\\I"
+               elif s[i:].startswith("\\fP") or s[i:].startswith("\\fR"):
+                       i+=3
+                       if italic:
+                               r += "\\i"
+                       else:
+                               r += "\\b"
+                       italic = False
+                       bold = False
+
+               else:
+                       skip = False
+
+                       ll=[
+                                       "P .PP",
+                                       "p .TP",
+                                       "h .SH",
+                                       "d .BR",
+                                       "e .B",
+                                       "t .IP",
+                                       "w .RS",
+                                       "q .RE",
+                       ]
+                       for f in ll:
+                               new=f[0]
+                               old=f[2:]
+
+                               if s[i:].startswith(old):
+                                       i+=len(old)
+                                       r += "\\"+new
+                                       skip = True
+                                       break
+
+                       if not skip:
+
+                               r += s[i]
+                               i += 1
+
+       return r
+
+
+
+for k,v in mcmds.iteritems():
+    try:
+        (s,l)=v
+    except:
+        print "**** key=",k,"; v=",v
+        continue
+
+    firstline = l.split("\n")[0]
+
+    if m_short_help.has_key(k):
+               short_help=m_short_help[k]
+               r=""
+               for sh in short_help.strip().split("\n"):
+                       r += " * "+sh+"\n"
+               short_help=r
+
+    else:
+               print "##############, missing key",k
+               short_help=" *\n"
+
+    print "/**** man: %s"%(k)
+    print " * "
+    print " * %s"%("\\Bbtrfs\\b "+cleanup(firstline))
+    print " * "
+    print short_help,
+    print " * "
+    for line in l.split("\n"):
+        print " * %s"%(cleanup(line))
+    print " ****/"
+    print
+
+
diff --git a/helpextract.c b/helpextract.c
new file mode 100644
index 0000000..bda05c7
--- /dev/null
+++ b/helpextract.c
@@ -0,0 +1,403 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+
+#define PREFIX_MAN     "/**** man: "
+#define PREFIX_TEXT    "/**** text: "
+#define PREFIX_END     " ****"
+#define PREFIX_SKIP    " * "
+
+#define LINEBUF                1024
+
+char **msgs=0;
+int nmsg=0;
+
+static char *xstrdup(char *str){
+       char    *new = strdup(str);
+       if(!new){
+               fprintf(stderr,"*** Memory allocation fail ! (xstrdup)\n");
+               exit(101);
+       }
+       return new;
+}
+
+static void *xrealloc(void *ptr, int newsize){
+       void *new = realloc(ptr, newsize);
+       if(!new){
+               fprintf(stderr,"*** Memory allocation fail ! (xrealloc)\n");
+               exit(101);
+       }
+       return new;
+
+
+}
+
+static char *xstrip(char *s){
+
+       char *last=NULL;
+       char *first;
+
+       while(*s && isspace(*s) ) s++;
+
+       first=s;
+
+       while(*s){
+               if(isspace(*s)) last=s;
+               s++;
+       }
+
+       if(last) *last=0;
+       return first;
+
+
+}
+
+static void addtuple(char *key, char *cmdline, char *short_help,
+               char *long_help){
+
+       msgs = (char**)xrealloc(msgs, sizeof(char *)*(nmsg+1)*4);
+
+       key = xstrip(key);
+
+       if( !long_help || !strcmp(long_help,"\n"))
+               long_help = short_help;
+       else if(!short_help || !strcmp(short_help, "\n"))
+               short_help = long_help;
+
+       msgs[nmsg*4] = key;
+       msgs[nmsg*4+1] = cmdline;
+       msgs[nmsg*4+2] = short_help;
+       msgs[nmsg*4+3] = long_help;
+       nmsg++;
+}
+
+
+static int search_in_file(char *nf){
+       char    buf[LINEBUF+1];
+       FILE    *fp;
+       int     status;
+       char    *key=NULL;
+       char    *cmdline=NULL;
+       char    *short_help=NULL;
+       char    *long_help=NULL;
+
+       fp = fopen(nf,"r");
+       if(!fp){
+               int     e=errno;
+               fprintf(stderr, "*** Cannot open '%s'; error = %d - '%s'\n",
+                       nf, e, strerror(e));
+               return -1;
+       }
+
+       status = 0;
+       while(fgets(buf,LINEBUF,fp)){
+       //      printf("status = %d, buf=%s",status, buf);
+
+               if(status == 0){
+                       if(!strncmp(buf,PREFIX_MAN, strlen(PREFIX_MAN)) ){
+                               key = xstrdup(buf+strlen(PREFIX_MAN));
+                               status++;
+                       }else if(!strncmp(buf,PREFIX_TEXT,
+                                       strlen(PREFIX_TEXT))){
+                               key = xstrdup(buf+strlen(PREFIX_TEXT));
+                               status=5;
+                       }
+                       continue;
+
+               }
+
+               if( !strncmp(buf,PREFIX_END, strlen(PREFIX_END)) ||
+                               strncmp(buf, PREFIX_SKIP,2)){
+
+                       addtuple(key, cmdline, short_help, long_help);
+                       key = cmdline = short_help = long_help = 0;
+                       status = 0;
+
+                       continue;
+               }
+               if( status == 2){
+                       if(strlen(buf)>strlen(PREFIX_SKIP))
+                               cmdline = xstrdup(buf+strlen(PREFIX_SKIP));
+                       status++;
+                       continue;
+               }
+               if( status == 4){
+                       int len;
+                       int len2;
+                       char *p;
+
+                       if(strlen(buf)<=strlen(PREFIX_SKIP)){
+                               status++;
+                               continue;
+                       }
+                       p=buf+3;
+                       while(isspace(*p) && *p ) p++;
+                       if(!*p){
+                               status++;
+                               continue;
+                       }
+
+                       len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+                       if(short_help)
+                               len = strlen(short_help);
+                       else
+                               len = 0;
+                       short_help = (char*)xrealloc(short_help,
len+len2+1);
+                       strcpy(short_help+len,buf+strlen(PREFIX_SKIP));
+                       continue;
+               }
+               if( status == 5){
+                       int len;
+                       int len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+                       if(long_help)
+                               len = strlen(long_help);
+                       else
+                               len = 0;
+                       long_help = (char*)xrealloc(long_help, len+len2+1);
+                       strcpy(long_help+len,buf+strlen(PREFIX_SKIP));
+                       continue;
+               }
+               if( status == 1 || status == 3 ){
+                       status++;
+                       continue;
+               }
+
+               fprintf(stderr,"*** Internal error: status = %d\n",status);
+               exit(100);
+
+       }
+
+       if( status != 0 ){
+               fprintf(stderr,"*** Parse error: file = '%s', "
+                               "status = %d at the end of file\n",
+                               nf, status);
+               exit(100);
+
+       }
+
+       fclose(fp);
+
+       return 0;
+}
+
+/* remove all the escape sequence excpet \\ */
+static char * my_escape(char *src, char *filters[] ){
+
+       static char buffer[LINEBUF*5];
+
+       int     i=0;
+       while(*src){
+               int     j;
+               int     next_char = *(src+1);
+               if(*src != '\\'){
+                       buffer[i++]=*src++;
+                       continue;
+               }
+               if(!next_char){
+                       buffer[i++]=*src++;
+                       continue;
+               }
+               if(next_char == '\\'){
+                       buffer[i++]='\\';
+                       src += 2;
+                       continue;
+               }
+               if( !filters ){
+                       src +=2;
+                       continue;
+               }
+
+               j=0;
+               while(filters[j]){
+                       if(filters[j][0] == next_char ){
+                               strcpy(buffer+i, filters[j]+2);
+                               i+=strlen(filters[j]+2);
+                               break;
+                       }
+                       j++;
+               }
+               if(!filters[j])
+                       fprintf(stderr, "Unknow escape sequence '\%c'\n",
+                               next_char);
+               src += 2;
+
+       }
+
+       buffer[i]=0;
+       return buffer;
+
+}
+
+static char * escape_c_array(char *src ){
+       return my_escape(src,NULL);
+}
+static char *escape_man_page(char *src){
+       /* from Gnu troff manual */
+       static char *filters[]={
+               "B \\fB",       /* bold */
+               "b \\fP",       /* end bold */
+               "I \\fI",       /* italic */
+               "i \\fP",       /* end italic */
+               "c .\\\"",      /* comment */
+               "P .PP",        /* start paragraph */
+               "p .TP",        /* indented paragraph */
+               "h .SH",        /* header */
+               "d .BR",        /* bold regular */
+               "e .B",         /* bold */
+               "t .IP",        /* indented paragraph */
+               "w .RS",        /* move the left margin */
+               "q .RE",        /* move the left margin back */
+
+
+               0
+       };
+
+       return my_escape(src, filters);
+}
+
+
+static void dump_c_array(){
+
+       int     i;
+
+       printf("{");
+       for(i=0; i < nmsg*4 ; i++){
+               char *c = msgs[i];
+               int begin;
+
+               if(i>0){
+                       putchar(',');
+                       if(!(i%4)) putchar('\n');
+               }
+
+               if(!c){
+                       printf("\n  NULL");
+                       continue;
+               }
+
+               c = escape_c_array(c);
+
+               begin = 1;
+               while( *c ){
+                       if(begin)
+                               printf("\n  \"");
+                       begin = 0;
+                       if( *c == '\n' ){
+                               printf("\\n\"");
+                               begin = 1;
+                       }else if( *c == '"' ){
+                               printf("\\\"");
+                       }else{
+                               putchar(*c);
+                       }
+
+                       c++;
+               }
+               if(!begin) putchar('"');
+       }
+       printf(",\n\n  ");
+       for(i=0; i < 4; i++){
+               if(i>0) putchar(',');
+               printf("NULL");
+       }
+       printf("\n}\n");
+
+}
+
+static int my_sort_cmp(const void *p1, const void *p2){
+       return strcmp(*(char**)p1, *(char **)p2);
+}
+
+static void my_sort(){
+       /* FIXME: check why the sort order is wrong */
+       qsort(msgs, nmsg, sizeof(char*)*4, my_sort_cmp);
+}
+
+static int find_section(char *key){
+       int     i;
+       for(i = 0 ; i < nmsg ; i++ )
+               if(!strcmp( msgs[i*4],key) )    return i;
+
+       return -1;
+}
+
+static void dump_man_page(){
+
+       int     i, fmt;
+
+       i = find_section("man btrfs header");
+       if( i>= 0 ) printf(msgs[i*4+3]);
+
+       i = find_section("man btrfs synopsis");
+       if( i>= 0 ) printf(msgs[i*4+3]);
+
+       fmt = find_section("man btrfs synopsis format");
+       for(i = 0; i < nmsg && fmt>=0; i++ ){
+               if( strncmp("btrfs ",msgs[i*4], 6) ||
+                   !strcmp("btrfs introduction", msgs[i*4] ) ||
+                   !strcmp("btrfs notes", msgs[i*4] ) )
+                               continue;
+
+               printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]));
+       }
+
+       i = find_section("btrfs introduction");
+       if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+
+       i = find_section("man btrfs commands");
+       if( i>= 0 ) printf(msgs[i*4+3]);
+
+       fmt = find_section("man btrfs command format");
+       for(i = 0; i < nmsg && fmt>=0; i++ ){
+
+               char big2[LINEBUF*5];
+               if( strncmp("btrfs ",msgs[i*4], 6) ||
+                   !strcmp("btrfs introduction", msgs[i*4] ) ||
+                   !strcmp("btrfs notes", msgs[i*4] ) )
+                               continue;
+
+               strcpy(big2, escape_man_page(msgs[i*4+3]));
+               printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]), big2);
+
+       }
+
+       i = find_section("man btrfs notes");
+       if( i>= 0 ) printf(msgs[i*4+3]);
+
+       i = find_section("btrfs notes");
+       if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+
+       i = find_section("man btrfs footer");
+       if( i>= 0 ) printf(msgs[i*4+3]);
+}
+
+static void usage(char *np){
+       printf("usage: %s --man-page|--c-array <file> [<file> [...]]\n",
np);
+}
+
+int main(int argc, char **argv ){
+
+       int     i;
+       if( argc < 3 || ( strcmp(argv[1],"--man-page") &&
+                         strcmp(argv[1],"--c-array") )){
+               usage(argv[0]);
+               return 0;
+       }
+
+       for(i=2; i < argc ; i++)
+               search_in_file(argv[i]);
+
+       my_sort();
+
+       if(!strcmp(argv[1], "--man-page"))
+               dump_man_page();
+       else if (!strcmp(argv[1], "--c-array"))
+               dump_c_array();
+
+       return 0;
+
+}
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 84a60cd..3a2dc34 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,8 +21,6 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir>
[<file>|<dir>...]\fP
-.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP]
[\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP]
\fI<path>\fP
@@ -37,7 +35,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
@@ -126,7 +124,7 @@ Set the subvolume of the filesystem \fI<path>\fR
which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP

-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s
\fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR>
[<\fIfile\fR>|<\fIdir\fR>...]
+\fBfilesystem defragment\fR -c[zlib|lzo] [-l \fIlen\fR] [-s
\fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR>
[<\fIfile\fR>|<\fIdir\fR>...]

 Defragment file data and/or directory metadata. To defragment all files
in a
 directory you have to specify each one on its own or use your shell
wildcards.
@@ -148,6 +146,8 @@ The start position and the number of bytes to
deframention can be specified by \
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies
of data, don't
 use it if you use snapshots, have de-duplicated your data or made
copies with
 \fBcp --reflink\fP.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
@@ -179,7 +179,7 @@ can expand the partition before enlarging the
filesystem and shrink the
 partition after reducing the size of the filesystem.
 .TP

-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBfilesystem label\fP\fI <dev> [newlabel]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to
identify the
 filesystem.
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
@@ -203,7 +203,7 @@ If \fB--all-devices\fP is passed, all the devices
under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP

-\fBdevice balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP]
[\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
+\fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP]
[\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 .TP
 \fBbalance start\fR [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP]
[\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP

@@ -270,7 +270,7 @@ last scrub finished successfully.
 .RS

 \fIOptions\fR
-.TP
+ .TP
 see \fBscrub start\fP.
 .RE
 .TP
@@ -287,28 +287,30 @@ for that filesystem or device.
 Print separate statistics for each device of the filesystem.
 .RE

-.PP
+.TP

 \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 Report progress on the currently-running balance operation on the
 filesystem mounted at \fI<path>\fP. Use --monitor to report progress
 continually, including an estimate of completion time.
+.TP

 \fBbalance cancel\fP \fI<path>\fP
 Cancel the balance currently running on the filesystem mounted at
 \fI<path>\fP.

 .SH BALANCE FILTERS
+
 With balance filters, it is possible to perform a balance operation on
 only a subset of the available chunks. Filters are specified with the
-\fB--filter\fR option of \fBbtrfs device balance\fR or \fBbtrfs
+\fB--filter\fR option of \fBbtrfs filesystem balance\fR or \fBbtrfs
 balance start\fR. Multiple filters may be given, either with multiple
 \fB--filter\fR options, or in a colon-separated list. When multiple
 filters are given, only the chunks meeting all of the selection
 critera are balanced. Help on the avaialble filters can be obtained
 with \fB--filter=help\fR.

-.TP
+
 \fBtype\fR=[\fB~\fR]\fI<flagname>\fR[\fB,\fR...]

 Select only the chunks with the given type flag(s). Requiring a flag
@@ -321,14 +323,14 @@ chunk types.
 \fBraid0\fR, \fBraid1\fR, \fBraid10\fR, \fBdup\fR for chunks of the
 given replication levels.

-.TP
+
 \fBdevid\fR=\fI<n>\fR

 Select chunks which have data on device ID \fI<n>\fR. This can be
 used, for example, to reduplicate data in a mirrored configuration
 where one drive has been lost due to hardware failure.

-.TP
+
 \fBvrange\fR=\fI<start>\fB,\fI<end>\fR

 Select chunks which have btrfs-internal virtual addresses within the
@@ -337,7 +339,6 @@ address of the last chunk moved, this filter can be
used to restart a
 cancelled or interrupted balance operation, by supplying a range of
 \fB0,\fI<chunkaddr+1>\fR.

-.TP
 \fBdrange\fR=\fI<start>\fB,\fI<end>\fR

 Select chunks which contain data in the address range \fI<start>\fR









--------------020203000604020109090104
Content-Type: text/x-patch;
 name="helpextract-vs-integration-20110705.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="helpextract-vs-integration-20110705.diff"

diff --git a/Makefile b/Makefile
index edee1a0..f089ca7 100644
--- a/Makefile
+++ b/Makefile
@@ -35,8 +35,9 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o helpmsg.o
 	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+		helpmsg.o \
 		$(objects) $(LDFLAGS) $(LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
@@ -84,6 +85,25 @@ convert: $(objects) convert.o
 ioctl-test: $(objects) ioctl-test.o
 	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
+helpextract: helpextract.o
+	$(CC) $(CFLAGS) -o $@ helpextract.o
+
+man/btrfs.8.2.in: helpextract 
+	./helpextract --man-page btrfs.8*.c >$@
+
+helpmsg.c: helpextract
+	echo  >$@ "/*"
+	echo >>$@ " * this file contains the help messages. It is "
+	echo >>$@ " * automatically generated. do not edit ! "
+	echo >>$@ " */"
+	echo >>$@
+	echo >>$@ "#define NULL 0"
+	echo >>$@
+
+	echo -n "char * help_messages[] = " >>$@
+	./helpextract --c-array btrfs.8*.c >>$@
+	 echo >>$@ ";"
+
 manpages:
 	cd man; make
 
diff --git a/btrfs.8+1.in.c b/btrfs.8+1.in.c
new file mode 100644
index 0000000..49855d4
--- /dev/null
+++ b/btrfs.8+1.in.c
@@ -0,0 +1,331 @@
+/**** man: btrfs subvolume delete
+ * 
+ * \Bbtrfs\b \Bsubvolume delete\b\I <subvolume>\i
+ * 
+ * Delete the subvolume <subvolume>.
+ * 
+ * Delete the subvolume \I<subvolume>\i. If \I<subvolume>\i is not a
+ * subvolume, \Bbtrfs\b returns an error.
+ ****/
+
+/**** man: btrfs scrub start
+ * 
+ * \Bbtrfs\b \Bscrub start\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Start a new scrub.
+ * 
+ * Start a scrub on all devices of the filesystem identified by \I<path>\i or on
+ * a single \I<device>\i. Without options, scrub is started as a background
+ * process. Progress can be obtained with the \Bscrub status\b command. Scrubbing
+ * involves reading all data from all disks and verifying checksums. Errors are
+ * corrected along the way if possible.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -B 5
+ * Do not background and print scrub statistics when finished.
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem (-B only).
+ * \t -q 5
+ * Quiet. Omit error messages and statistics.
+ * \t -r 5
+ * Read only mode. Do not attempt to correct anything.
+ * \t -u 5
+ * Scrub unused space as well. (NOT IMPLEMENTED)
+ * \q
+ ****/
+
+/**** man: btrfs filesystem show
+ * 
+ * \Bbtrfs\b \Bfilesystem show\b [--all-devices|<uuid>|<label>]\b
+ * 
+ * Show the info of a btrfs filesystem. If no argument
+ * is passed, info of all the btrfs filesystem are shown.
+ * 
+ * Show the btrfs filesystem with some additional info. If no \IUUID\i or 
+ * \Ilabel\i is passed, \Bbtrfs\b show info of all the btrfs filesystem.
+ * If \B--all-devices\b is passed, all the devices under /dev are scanned;
+ * otherwise the devices list is extracted from the /proc/partitions file.
+ ****/
+
+/**** man: btrfs balance progress
+ * 
+ * \Bbtrfs\b \Bbalance progress\b [\B-m\b|\B--monitor\b] \I<path>\i
+ * 
+ * Show progress of the balance operation running on <path>.
+ * 
+ * Report progress on the currently-running balance operation on the
+ * filesystem mounted at \I<path>\i. Use --monitor to report progress
+ * continually, including an estimate of completion time.
+ ****/
+
+/**** man: btrfs filesystem sync
+ * 
+ * \Bbtrfs\b \Bfilesystem sync\b\I <path> \i
+ * 
+ * Force a sync on the filesystem <path>.
+ * 
+ * Force a sync for the filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs subvolume set-default
+ * 
+ * \Bbtrfs\b \Bsubvolume set-default\b\I <id> <path>\i
+ * 
+ * Set the subvolume of the filesystem <path> which will be mounted
+ * as default.
+ * 
+ * Set the subvolume of the filesystem \I<path>\i which is mounted as 
+ * \Idefault\i. The subvolume is identified by \I<id>\i, which 
+ * is returned by the \Bsubvolume list\b command.
+ ****/
+
+/**** man: btrfs device delete
+ * 
+ * \Bbtrfs\b \Bdevice delete\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Remove a device from a filesystem.
+ * 
+ * Remove device(s) from a filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs balance cancel
+ * 
+ * \Bbtrfs\b \Bbalance cancel\b \I<path>\i
+ * 
+ * Cancel the balance operation running on <path>.
+ * 
+ * Cancel the balance currently running on the filesystem mounted at
+ * \I<path>\i.
+ ****/
+
+/**** man: btrfs scrub resume
+ * 
+ * \Bbtrfs\b \Bscrub resume\b [-Bdqru] {\I<path>\i|\I<device>\i}
+ * 
+ * Resume previously canceled or interrupted scrub.
+ * 
+ * Resume a canceled or interrupted scrub cycle on the filesystem identified by
+ * \I<path>\i or on a given \I<device>\i. Does not start a new scrub if the
+ * last scrub finished successfully.
+ * \w
+ * 
+ * \IOptions\i
+ *  \p
+ * see \Bscrub start\b.
+ * \q
+ ****/
+
+/**** man: btrfs scrub status
+ * 
+ * \Bbtrfs\b \Bscrub status\b [-d] {\I<path>\i|\I<device>\i}
+ * 
+ * Show status of running or finished scrub.
+ * 
+ * Show status of a running scrub for the filesystem identified by \I<path>\i or
+ * for the specified \I<device>\i.
+ * If no scrub is running, show statistics of the last finished or canceled scrub
+ * for that filesystem or device.
+ * \w
+ * 
+ * \IOptions\i
+ * \t -d 5
+ * Print separate statistics for each device of the filesystem.
+ * \q
+ ****/
+
+/**** man: btrfs subvolume list
+ * 
+ * \Bbtrfs\b \Bsubvolume list\b\I [-p] <path>\i
+ * 
+ * List the snapshot/subvolume of a filesystem.
+ * 
+ * List the subvolumes present in the filesystem \I<path>\i. For every
+ * subvolume the following information is shown by default.
+ * ID <ID> top level <ID> path <path>
+ * where path is the relative path of the subvolume to the \Itop level\i
+ * subvolume.
+ * The subvolume's ID may be used by the \Bsubvolume set-default\b command, or
+ * at mount time via the \Isubvol=\i option.
+ * If \I-p\i is given, then \Iparent <ID>\i is added to the output between ID
+ * and top level. The parent's ID may be used at mount time via the
+ * \Isubvolrootid=\i option.
+ ****/
+
+**** key= btrfs help|\-\-help|\-h  ; v= \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
+
+/**** man: btrfs filesystem balance
+ * 
+ * \Bbtrfs\b \Bfilesystem balance\b [\B-wcv\b] [\B--wait\b] [\B--count\b] [\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ * 
+ * Balance chunks across the devices. --filter=help for help on filters.
+ * --count to count chunks only (no balance performed).
+ ****/
+
+/**** man: btrfs subvolume snapshot
+ * 
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ * 
+ * Create a writable/readonly snapshot of the subvolume <source> with
+ * the name <name> in the <dest> directory.
+ * 
+ * Create a writable/readonly snapshot of the subvolume \I<source>\i with the
+ * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
+ * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
+ * will be readonly.
+ ****/
+
+/**** man: btrfs filesystem defragment
+ * 
+ * \Bbtrfs\b \Bfilesystem defragment\b -c[zlib|lzo] [-l \Ilen\i] [-s \Istart\i] [-t \Isize\i] -[vf] <\Ifile\i>|<\Idir\i> [<\Ifile\i>|<\Idir\i>...]
+ * 
+ * Defragment a file or a directory.
+ * 
+ * Defragment file data and/or directory metadata. To defragment all files in a
+ * directory you have to specify each one on its own or use your shell wildcards.
+ * 
+ * The start position and the number of bytes to deframention can be specified by \Istart\i and \Ilen\i. Any extent bigger than \Ithresh\i will be considered already defragged. Use 0 to take the kernel default, and use 1 to say eveery single extent must be rewritten. You can also turn on compression in defragment operations.
+ * 
+ * \B-v\b be verbose
+ * 
+ * \B-c\b compress file contents while defragmenting
+ * 
+ * \B-f\b flush filesystem after defragmenting
+ * 
+ * \B-s start\b defragment only from byte \Istart\i onward
+ * 
+ * \B-l len\b defragment only up to \Ilen\i bytes
+ * 
+ * \B-t size\b defragment only files at least \Isize\i bytes big
+ * 
+ * NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
+ * use it if you use snapshots, have de-duplicated your data or made copies with 
+ * \Bcp --reflink\b.
+ ****/
+
+/**** man: btrfs subvolume find-new
+ * 
+ * \Bbtrfs\b \Bsubvolume find-new\b\I <subvolume> <last_gen>\i
+ * 
+ * List the recently modified files in a filesystem.
+ * 
+ * List the recently modified files in a subvolume, after \I<last_gen>\i ID.
+ ****/
+
+/**** man: btrfs device add
+ * 
+ * \Bbtrfs\b \Bdevice add\b\I <dev> [<dev>..] <path>\i
+ * 
+ * Add a device to a filesystem.
+ * 
+ * Add device(s) to the filesystem identified by \I<path>\i.
+ ****/
+
+/**** man: btrfs filesystem resize
+ * 
+ * \Bbtrfs\b \Bfilesystem resize\b\I [+/\-]<size>[gkm]|max <path>\i
+ * 
+ * Resize the file system. If 'max' is passed, the filesystem
+ * will occupe all available space on the device.
+ * 
+ * Resize a filesystem identified by \I<path>\i.
+ * The \I<size>\i parameter specifies the new size of the filesystem.
+ * If the prefix \I+\i or \I\-\i is present the size is increased or decreased
+ * by the quantity \I<size>\i.
+ * If no units are specified, the unit of the \I<size>\i parameter defaults to
+ * bytes. Optionally, the size parameter may be suffixed by one of the following
+ * the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+ * respectively.
+ * 
+ * If 'max' is passed, the filesystem will occupy all available space on the
+ * volume(s).
+ * 
+ * The \Bresize\b command \Bdoes not\b manipulate the size of underlying
+ * partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
+ * can expand the partition before enlarging the filesystem and shrink the
+ * partition after reducing the size of the filesystem.
+ ****/
+
+/**** man: btrfs filesystem label
+ * 
+ * \Bbtrfs\b \Bfilesystem label\b\I <dev> [newlabel]\i
+ * 
+ * With one argument, get the label of filesystem on <device>.
+ * If <newlabel> is passed, set the filesystem label to <newlabel>.
+ * The filesystem must be unmounted.
+ * 
+ * Show or update the label of a filesystem. \I<dev>\i is used to identify the
+ * filesystem. 
+ * If a \Inewlabel\i optional argument is passed, the label is changed. The
+ * following costraints exist for a label:
+ * \t
+ * - the maximum allowable lenght shall be less or equal than 256 chars
+ * \t
+ * - the label shall not  contain the '/' or '\\' characters.
+ * 
+ * NOTE: Currently there are the following limitations:
+ * \t
+ * - the filesystem has to be unmounted
+ * \t
+ * - the filesystem should not have more than one device.
+ ****/
+
+/**** man: btrfs device scan
+ * 
+ * \Bbtrfs\b \Bdevice scan\b \I[--all-devices|<device> [<device>...]\i
+ * 
+ * Scan all device for or the passed device for a btrfs
+ * filesystem.
+ * 
+ * If one or more devices are passed, these are scanned for a btrfs filesystem. 
+ * If no devices are passed, \Bbtrfs\b scans all the block devices listed
+ * in the /proc/partitions file.
+ * Finally, if \B--all-devices\b is passed, all the devices under /dev are 
+ * scanned.
+ ****/
+
+**** key= btrfs <command> \-\-help  ; v= \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
+
+/**** man: btrfs balance start
+ * 
+ * \Bbtrfs\b \Bbalance start\b [\B-wcv\b] [\B--wait\b] [\B--count\b] [\B--verbose\b] [\B-f\b|\Bfilter=\b\I<filter>\i] \I<path>\i
+ * 
+ * Synonym for "btrfs filesystem balance".
+ * 
+ * Balance the chunks of the filesystem identified by \I<path>\i across
+ * the devices. The command returns immediately, and the balance
+ * operation runs in the background. Use \B--wait\b to run
+ * synchronously instead. Use \B--count\b to scan the filesystem and
+ * report the number of chunks that would be processed. Use
+ * \B--verbose\b in synchronous mode to report the number of chunks
+ * examined and balanced. See \BBALANCE FILTERS\b, below, for details
+ * of the different filter types and syntax.
+ ****/
+
+/**** man: btrfs subvolume create
+ * 
+ * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ * 
+ * Create a subvolume in <dest> (or the current directory if
+ * not passed).
+ * 
+ * Create a subvolume in \I<dest>\i (or in the current directory if
+ * \I<dest>\i is omitted).
+ ****/
+
+/**** man: btrfs scrub cancel
+ * 
+ * \Bbtrfs\b \Bscrub cancel\b {\I<path>\i|\I<device>\i}
+ * 
+ * Cancel a running scrub.
+ * 
+ * If a scrub is running on the filesystem identified by \I<path>\i, cancel it.
+ * Progress is saved in the scrub progress file and scrubbing can be resumed later
+ * using the \Bscrub resume\b command.
+ * If a \I<device>\i is given, the corresponding filesystem is found and
+ * \Bscrub cancel\b behaves as if it was called on that filesystem.
+ ****/
+
diff --git a/btrfs.8.in.c b/btrfs.8.in.c
new file mode 100644
index 0000000..6957a1d
--- /dev/null
+++ b/btrfs.8.in.c
@@ -0,0 +1,116 @@
+/**** text: man btrfs header
+ * .TH BTRFS 8 "" "btrfs" "btrfs"
+ * .\"
+ * .\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+ * .\"
+ * .SH NAME
+ * btrfs \- control a btrfs filesystem
+ ****/
+
+/**** text: man btrfs synopsis
+ * .SH SYNOPSIS
+ ****/
+
+/**** text: man btrfs synopsis format
+ * \fB%s\fP
+ * .PP
+ ****/
+
+/**** text: man btrfs command format
+ *
+ * .TP
+ * %s%s
+ ****/
+
+/**** text: btrfs introduction
+ * .SH DESCRIPTION
+ * \Bbtrfs\b is used to control the filesystem and the files and directories 
+ * stored. It is the tool to create or destroy a snapshot or a subvolume for 
+ * the filesystem, to defrag a file or a directory, flush the data to the disk,
+ * to resize the filesystem, to scan the device.
+ * 
+ * It is possible to abbreviate the commands unless the commands  are ambiguous.
+ * For example: it is possible to run
+ * \Ibtrfs sub snaps\i instead of \Ibtrfs subvolume snapshot\i. But \Ibtrfs 
+ * file s\i is not allowed, because \Ifile s\i may be interpreted both as
+ * \Ifilesystem show\i and as \Ifilesystem sync\i.  
+ * 
+ * If a command is terminated by \I--help\i, the detailed help is showed. 
+ * If the passed command matches more commands, detailed help of all the 
+ * matched commands is showed. For example \Ibtrfs dev --help\i shows the 
+ * help of all \Idevice*\i commands.
+ ****/
+
+/**** text: man btrfs commands
+ * .SH COMMANDS
+ * .TP
+ */
+
+/**** text: btrfs notes
+ * \h BALANCE FILTERS
+ * 
+ * With balance filters, it is possible to perform a balance operation on
+ * only a subset of the available chunks. Filters are specified with the
+ * \B--filter\b option of \Bbtrfs filesystem balance\b or \Bbtrfs
+ * balance start\b. Multiple filters may be given, either with multiple
+ * \B--filter\b options, or in a colon-separated list. When multiple
+ * filters are given, only the chunks meeting all of the selection
+ * critera are balanced. Help on the avaialble filters can be obtained
+ * with \B--filter=help\b.
+ * 
+ * 
+ * \Btype\b=[\B~\b]\I<flagname>\i[\B,\b...]
+ * 
+ * Select only the chunks with the given type flag(s). Requiring a flag
+ * to be off can be specified with a \B~\b preceding the flag
+ * name. Flag names are:
+ * 
+ * \Bmeta\b, \Bdata\b, \Bsys\b for metadata, file data and system
+ * chunk types.
+ * 
+ * \Braid0\b, \Braid1\b, \Braid10\b, \Bdup\b for chunks of the
+ * given replication levels.
+ * 
+ * 
+ * \Bdevid\b=\I<n>\i
+ * 
+ * Select chunks which have data on device ID \I<n>\i. This can be
+ * used, for example, to reduplicate data in a mirrored configuration
+ * where one drive has been lost due to hardware failure.
+ * 
+ * 
+ * \Bvrange\b=\I<start>\i,\I<end>\i
+ * 
+ * Select chunks which have btrfs-internal virtual addresses within the
+ * range \I<start>\i (inclusive) to \I<end>\i (exclusive). Given the
+ * address of the last chunk moved, this filter can be used to restart a
+ * cancelled or interrupted balance operation, by supplying a range of
+ * \B0,\I<chunkaddr+1>\i.
+ * 
+ * \Bdrange\b=\I<start>\i,\I<end>\i
+ * 
+ * Select chunks which contain data in the address range \I<start>\i
+ * (inclusive) to \I<end>\i (exclusive) on \Iany\i block device in
+ * the filesystem. Can be mixed with the \Bdevid\b filter to select
+ * chunks in a given address range on a specific device.
+ * 
+ * \h EXIT STATUS
+ * \Bbtrfs\b returns a zero exist status if it succeeds. Non zero is returned in
+ * case of failure.
+ * 
+ * \h AVAILABILITY
+ * \Bbtrfs\b is part of btrfs-progs. Btrfs filesystem is currently under 
+ * heavy development, and not suitable for any uses other than benchmarking and
+ * review.
+ *
+ * Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+ * further details.
+ *
+ * \h SEE ALSO
+ * \Bmkfs.btrfs (8)\b
+ ****/
+
+/**** text: man btrfs footer
+ ****/
+
+
diff --git a/btrfs.c b/btrfs.c
index 67d6f6f..fb94cf9 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -181,6 +181,8 @@ static struct Command commands[] = {
 	{ 0, 0, 0, 0 }
 };
 
+extern char * help_messages[];
+
 static char *get_prgname(char *programname)
 {
 	char	*np;
@@ -196,21 +198,43 @@ static char *get_prgname(char *programname)
 static void print_help(char *programname, struct Command *cmd, int helptype)
 {
 	char	*pc;
+	int	i;
+	char	*adv_help;
+	char	*std_help;
+
+	/* printf("\t%s %s ", programname, cmd->verb ); */
+
+	adv_help = cmd->adv_help;
+	std_help = cmd->help;
+
+	for(i = 0; help_messages[i]; i+= 4 ){
+		if(!strncmp(help_messages[i],"btrfs ",6) &&
+		   !strcmp(help_messages[i]+6,cmd->verb) ){
+			if(help_messages[i+2])
+				std_help = help_messages[i+2];
+			if(help_messages[i+3])
+				adv_help = help_messages[i+3];
+			printf("\t%s\t\t",help_messages[i+1]);
+			break;
+		}
+	}
 
-	printf("\t%s %s ", programname, cmd->verb );
+	if( !help_messages[i])
+		printf("\t%s %s ", programname, cmd->verb );
 
-	if (helptype == ADVANCED_HELP && cmd->adv_help)
-		for(pc = cmd->adv_help; *pc; pc++){
+	if (helptype == ADVANCED_HELP && adv_help){
+		for(pc = adv_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
-	else
-		for(pc = cmd->help; *pc; pc++){
+	}else{
+		for(pc = std_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
+	}
 
 	putchar('\n');
 }
diff --git a/extract_from_man_page.py b/extract_from_man_page.py
new file mode 100644
index 0000000..033da00
--- /dev/null
+++ b/extract_from_man_page.py
@@ -0,0 +1,249 @@
+import os
+
+f = open("man/btrfs.8.in")
+while True:
+	line = f.readline()
+	if line.startswith(".SH SYNOPSIS"): break
+
+
+cmds = []
+while True:
+	line = f.readline()
+	pp = f.readline()
+	if not pp.startswith(".PP"):
+		break
+
+	cmds.append(line)
+
+
+while True:
+	line = f.readline()
+	if line.startswith(".SH COMMANDS"): break
+
+
+	line = f.readline()
+
+xcmds = []
+cmd = ""
+while True:
+	line = f.readline()
+
+	if line.startswith(".\\\""):
+		continue
+
+	if line.startswith(".TP") or line.startswith(".SH"):
+		xcmds.append(cmd)
+		cmd=""
+		if line.startswith(".SH"): break
+		continue
+
+	cmd += line
+
+
+#print cmds
+#print xcmds
+
+mcmds = dict()
+for c in cmds:
+	i1 = c.find("\\fP")
+	i2 = c.find("\\fP", i1+1)
+
+	key = c[:i2]
+	key = key.replace("\\fB","").replace("\\fP","")
+
+	mcmds[key] = c
+
+
+#for k,v in mcmds.iteritems():
+#	print "%s: %s"%(k,v)
+
+
+for c in xcmds:
+	c = c.strip()
+	if len(c) == 0: continue
+
+	firstline = c.split("\n")[0]
+	i = firstline.find("\\fR")
+	if(i<0):
+		i = firstline.find("\\fP")
+	if(i<0):
+		print
+		print "*****Formato linea",c
+		continue
+	key = firstline[:i]
+	key = "btrfs "+key.replace("\\fB","").replace("\\fP","").replace("\\fR","")
+	
+	if mcmds.has_key(key):
+		mcmds[key] = (mcmds[key], c)
+	else:
+		print
+		print "******Non riesco a trovare ",key
+
+
+
+
+f2 = open("btrfs.c")
+
+def merge_strings(s):
+	i=0
+	q=False
+	xesc=False
+	r=""
+	escape_seq={ '"': '"',
+				 'n': '\n',
+				 't': '\t' }
+
+	while(i<len(s)):
+		if xesc:
+			xesc=False
+			r += escape_seq[s[i]]
+			i+=1
+			continue
+		elif s[i] == '"':
+			q = not q
+			i+=1
+			continue
+		elif s[i] == '\\':
+			xesc = True
+			assert(q)
+			i+=1
+			continue
+
+		if q:
+			r += s[i]
+
+		i+=1
+
+	return r
+			
+
+m_short_help=dict()
+r=False
+block=False
+n=0
+head = ""
+short_help=""
+for l in f2.readlines():
+	if l.startswith("static struct Command co"):
+		r=True
+		continue
+	if r and l.startswith("}"):
+		break
+	if "{" in l:
+		block=True
+		n=0
+		continue
+	if not block:
+		continue
+
+	if(n==0):
+		head=l
+		k=head.find(",")
+		if(k>=0):
+			head = head[:k]
+		head="btrfs "+merge_strings(head)
+		n+=1
+		continue
+	if(n==1):
+		short_help+=l
+		if l.strip().endswith(","):
+			m_short_help[head]=merge_strings(short_help)
+			block=False
+			short_help=""
+			head=""
+			n=0
+
+	
+	
+#for k,v in m_short_help.iteritems():
+#	print "\n%s:\n%s"%(k,v)
+
+def cleanup(s):
+
+	r=""
+	i=0
+	bold=False
+	italic=False
+	while(i<len(s)):
+
+		if s[i:].startswith("\\fB"):
+			bold=True
+			i+=3
+			r += "\\B"
+		elif s[i:].startswith("\\fI"):
+			italic=True
+			i+=3
+			r += "\\I"
+		elif s[i:].startswith("\\fP") or s[i:].startswith("\\fR"):
+			i+=3
+			if italic:
+				r += "\\i"
+			else:
+				r += "\\b"
+			italic = False
+			bold = False
+
+		else:
+			skip = False
+
+			ll=[
+					"P .PP",        
+					"p .TP",        
+					"h .SH",        
+					"d .BR",        
+					"e .B",
+					"t .IP",
+					"w .RS",
+					"q .RE",
+			]
+			for f in ll:
+				new=f[0]
+				old=f[2:]
+
+				if s[i:].startswith(old):
+					i+=len(old)
+					r += "\\"+new
+					skip = True
+					break
+
+			if not skip:
+
+				r += s[i]
+				i += 1
+
+	return r
+
+		
+
+for k,v in mcmds.iteritems():
+    try:
+        (s,l)=v
+    except:
+        print "**** key=",k,"; v=",v
+        continue
+
+    firstline = l.split("\n")[0]
+
+    if m_short_help.has_key(k):
+		short_help=m_short_help[k]
+		r=""
+		for sh in short_help.strip().split("\n"):
+			r += " * "+sh+"\n"
+		short_help=r
+
+    else:
+		print "##############, missing key",k
+		short_help=" *\n"
+
+    print "/**** man: %s"%(k)
+    print " * "
+    print " * %s"%("\\Bbtrfs\\b "+cleanup(firstline))
+    print " * "
+    print short_help,
+    print " * "
+    for line in l.split("\n"):
+        print " * %s"%(cleanup(line))
+    print " ****/"
+    print
+
+
diff --git a/helpextract.c b/helpextract.c
new file mode 100644
index 0000000..bda05c7
--- /dev/null
+++ b/helpextract.c
@@ -0,0 +1,403 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+
+#define PREFIX_MAN	"/**** man: "
+#define PREFIX_TEXT	"/**** text: "
+#define PREFIX_END 	" ****"
+#define PREFIX_SKIP	" * "
+
+#define LINEBUF		1024
+
+char **msgs=0;
+int nmsg=0;
+
+static char *xstrdup(char *str){
+	char	*new = strdup(str);
+	if(!new){
+		fprintf(stderr,"*** Memory allocation fail ! (xstrdup)\n");
+		exit(101);
+	}
+	return new;
+}
+
+static void *xrealloc(void *ptr, int newsize){
+	void *new = realloc(ptr, newsize);
+	if(!new){
+		fprintf(stderr,"*** Memory allocation fail ! (xrealloc)\n");
+		exit(101);
+	}
+	return new;
+
+
+}
+
+static char *xstrip(char *s){
+
+	char *last=NULL;
+	char *first;
+
+	while(*s && isspace(*s) ) s++;
+
+	first=s;
+
+	while(*s){
+		if(isspace(*s)) last=s;
+		s++;
+	}
+
+	if(last) *last=0;
+	return first;
+
+
+}
+
+static void addtuple(char *key, char *cmdline, char *short_help, 
+		char *long_help){
+
+	msgs = (char**)xrealloc(msgs, sizeof(char *)*(nmsg+1)*4);
+	
+	key = xstrip(key);
+
+	if( !long_help || !strcmp(long_help,"\n"))
+		long_help = short_help;
+	else if(!short_help || !strcmp(short_help, "\n"))
+		short_help = long_help;
+
+	msgs[nmsg*4] = key;
+	msgs[nmsg*4+1] = cmdline;
+	msgs[nmsg*4+2] = short_help;
+	msgs[nmsg*4+3] = long_help;
+	nmsg++;
+}
+
+
+static int search_in_file(char *nf){
+	char	buf[LINEBUF+1];
+	FILE	*fp;
+	int	status; 
+	char	*key=NULL;
+	char	*cmdline=NULL;
+	char	*short_help=NULL;
+	char	*long_help=NULL;
+
+	fp = fopen(nf,"r");
+	if(!fp){
+		int	e=errno;
+		fprintf(stderr, "*** Cannot open '%s'; error = %d - '%s'\n",
+			nf, e, strerror(e));
+		return -1;
+	}
+
+	status = 0;
+	while(fgets(buf,LINEBUF,fp)){
+	//	printf("status = %d, buf=%s",status, buf);
+	
+		if(status == 0){
+			if(!strncmp(buf,PREFIX_MAN, strlen(PREFIX_MAN)) ){
+				key = xstrdup(buf+strlen(PREFIX_MAN));
+				status++;
+			}else if(!strncmp(buf,PREFIX_TEXT, 
+					strlen(PREFIX_TEXT))){
+				key = xstrdup(buf+strlen(PREFIX_TEXT));
+				status=5;
+			}
+			continue;
+
+		}
+
+		if( !strncmp(buf,PREFIX_END, strlen(PREFIX_END)) || 
+				strncmp(buf, PREFIX_SKIP,2)){
+
+			addtuple(key, cmdline, short_help, long_help);
+			key = cmdline = short_help = long_help = 0;
+			status = 0;
+
+			continue;
+		} 
+		if( status == 2){
+			if(strlen(buf)>strlen(PREFIX_SKIP))
+				cmdline = xstrdup(buf+strlen(PREFIX_SKIP));
+			status++;
+			continue;
+		}
+		if( status == 4){
+			int len;
+			int len2;
+			char *p;
+
+			if(strlen(buf)<=strlen(PREFIX_SKIP)){
+				status++;
+				continue;
+			}
+			p=buf+3;
+			while(isspace(*p) && *p ) p++;
+			if(!*p){
+				status++;
+				continue;
+			}
+
+			len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+			if(short_help)
+				len = strlen(short_help);
+			else
+				len = 0;
+			short_help = (char*)xrealloc(short_help, len+len2+1);
+			strcpy(short_help+len,buf+strlen(PREFIX_SKIP));
+			continue;
+		}
+		if( status == 5){
+			int len;
+			int len2 = strlen(buf)-strlen(PREFIX_SKIP);
+
+			if(long_help)
+				len = strlen(long_help);
+			else
+				len = 0;
+			long_help = (char*)xrealloc(long_help, len+len2+1);
+			strcpy(long_help+len,buf+strlen(PREFIX_SKIP));
+			continue;
+		}
+		if( status == 1 || status == 3 ){
+			status++;
+			continue;
+		}
+
+		fprintf(stderr,"*** Internal error: status = %d\n",status);
+		exit(100);
+
+	}
+
+	if( status != 0 ){
+		fprintf(stderr,"*** Parse error: file = '%s', "
+				"status = %d at the end of file\n",
+				nf, status);
+		exit(100);
+
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
+/* remove all the escape sequence excpet \\ */
+static char * my_escape(char *src, char *filters[] ){
+
+	static char buffer[LINEBUF*5];
+
+	int	i=0;
+	while(*src){
+		int 	j;
+		int	next_char = *(src+1);
+		if(*src != '\\'){
+			buffer[i++]=*src++;
+			continue;
+		}
+		if(!next_char){
+			buffer[i++]=*src++;
+			continue;
+		}
+		if(next_char == '\\'){
+			buffer[i++]='\\';
+			src += 2;
+			continue;
+		}
+		if( !filters ){
+			src +=2;
+			continue;
+		}
+
+		j=0;
+		while(filters[j]){
+			if(filters[j][0] == next_char ){
+				strcpy(buffer+i, filters[j]+2);
+				i+=strlen(filters[j]+2);
+				break;
+			}
+			j++;
+		}
+		if(!filters[j])
+			fprintf(stderr, "Unknow escape sequence '\%c'\n",
+				next_char);
+		src += 2;
+
+	}
+
+	buffer[i]=0;
+	return buffer;
+
+}
+
+static char * escape_c_array(char *src ){
+	return my_escape(src,NULL);
+}
+static char *escape_man_page(char *src){
+	/* from Gnu troff manual */
+	static char *filters[]={
+		"B \\fB",	/* bold */
+		"b \\fP",	/* end bold */
+		"I \\fI",	/* italic */
+		"i \\fP",	/* end italic */
+		"c .\\\"",	/* comment */
+		"P .PP",	/* start paragraph */
+		"p .TP",	/* indented paragraph */
+		"h .SH",	/* header */
+		"d .BR",	/* bold regular */
+		"e .B",		/* bold */
+		"t .IP",	/* indented paragraph */
+		"w .RS",	/* move the left margin */
+		"q .RE",	/* move the left margin back */
+
+
+		0
+	};
+
+	return my_escape(src, filters);
+}
+	
+
+static void dump_c_array(){
+
+	int	i;
+
+	printf("{");
+	for(i=0; i < nmsg*4 ; i++){
+		char *c = msgs[i];
+		int begin;
+
+		if(i>0){
+			putchar(',');
+			if(!(i%4)) putchar('\n');
+		}
+
+		if(!c){
+			printf("\n  NULL");
+			continue;
+		}
+
+		c = escape_c_array(c);
+
+		begin = 1;
+		while( *c ){
+			if(begin)
+				printf("\n  \"");
+			begin = 0;
+			if( *c == '\n' ){
+				printf("\\n\"");
+				begin = 1;
+			}else if( *c == '"' ){
+				printf("\\\"");
+			}else{
+				putchar(*c);
+			}
+
+			c++;
+		}
+		if(!begin) putchar('"');
+	}
+	printf(",\n\n  ");
+	for(i=0; i < 4; i++){
+		if(i>0) putchar(',');
+		printf("NULL");
+	}
+	printf("\n}\n");
+
+}
+
+static int my_sort_cmp(const void *p1, const void *p2){
+	return strcmp(*(char**)p1, *(char **)p2);
+}
+
+static void my_sort(){
+	/* FIXME: check why the sort order is wrong */
+	qsort(msgs, nmsg, sizeof(char*)*4, my_sort_cmp);
+}
+
+static int find_section(char *key){
+	int 	i;
+	for(i = 0 ; i < nmsg ; i++ )
+		if(!strcmp( msgs[i*4],key) )	return i;
+	
+	return -1;
+}
+
+static void dump_man_page(){
+
+	int	i, fmt;
+
+	i = find_section("man btrfs header");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	i = find_section("man btrfs synopsis");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	fmt = find_section("man btrfs synopsis format");
+	for(i = 0; i < nmsg && fmt>=0; i++ ){
+		if( strncmp("btrfs ",msgs[i*4], 6) ||
+		    !strcmp("btrfs introduction", msgs[i*4] ) ||
+		    !strcmp("btrfs notes", msgs[i*4] ) )
+		    		continue;
+
+		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]));
+	}
+
+	i = find_section("btrfs introduction");
+	if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+	
+	i = find_section("man btrfs commands");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	fmt = find_section("man btrfs command format");
+	for(i = 0; i < nmsg && fmt>=0; i++ ){
+
+		char big2[LINEBUF*5];
+		if( strncmp("btrfs ",msgs[i*4], 6) ||
+		    !strcmp("btrfs introduction", msgs[i*4] ) ||
+		    !strcmp("btrfs notes", msgs[i*4] ) )
+		    		continue;
+		
+		strcpy(big2, escape_man_page(msgs[i*4+3]));
+		printf(msgs[fmt*4+3], escape_man_page(msgs[i*4+1]), big2);
+
+	}
+
+	i = find_section("man btrfs notes");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+
+	i = find_section("btrfs notes");
+	if( i>= 0 ) printf(escape_man_page(msgs[i*4+3]));
+
+	i = find_section("man btrfs footer");
+	if( i>= 0 ) printf(msgs[i*4+3]);
+}
+
+static void usage(char *np){
+	printf("usage: %s --man-page|--c-array <file> [<file> [...]]\n", np);
+}
+
+int main(int argc, char **argv ){
+
+	int	i;
+	if( argc < 3 || ( strcmp(argv[1],"--man-page") && 
+			  strcmp(argv[1],"--c-array") )){
+		usage(argv[0]);
+		return 0;
+	}
+
+	for(i=2; i < argc ; i++)
+		search_in_file(argv[i]);
+
+	my_sort();
+
+	if(!strcmp(argv[1], "--man-page"))
+		dump_man_page();
+	else if (!strcmp(argv[1], "--c-array"))
+		dump_c_array();
+
+	return 0;
+
+}
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 84a60cd..3a2dc34 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,8 +21,6 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
-.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
@@ -37,7 +35,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
@@ -126,7 +124,7 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
+\fBfilesystem defragment\fR -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
@@ -148,6 +146,8 @@ The start position and the number of bytes to deframention can be specified by \
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
 use it if you use snapshots, have de-duplicated your data or made copies with 
 \fBcp --reflink\fP.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
@@ -179,7 +179,7 @@ can expand the partition before enlarging the filesystem and shrink the
 partition after reducing the size of the filesystem.
 .TP
 
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBfilesystem label\fP\fI <dev> [newlabel]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
 filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
@@ -203,7 +203,7 @@ If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
-\fBdevice balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
+\fBfilesystem balance\fP [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 .TP
 \fBbalance start\fR [\fB-wcv\fP] [\fB--wait\fP] [\fB--count\fP] [\fB--verbose\fP] [\fB-f\fP|\fBfilter=\fP\fI<filter>\fP] \fI<path>\fP
 
@@ -270,7 +270,7 @@ last scrub finished successfully.
 .RS
 
 \fIOptions\fR
-.TP
+ .TP
 see \fBscrub start\fP.
 .RE
 .TP
@@ -287,28 +287,30 @@ for that filesystem or device.
 Print separate statistics for each device of the filesystem.
 .RE
 
-.PP
+.TP
 
 \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
 Report progress on the currently-running balance operation on the
 filesystem mounted at \fI<path>\fP. Use --monitor to report progress
 continually, including an estimate of completion time.
+.TP
 
 \fBbalance cancel\fP \fI<path>\fP
 Cancel the balance currently running on the filesystem mounted at
 \fI<path>\fP.
 
 .SH BALANCE FILTERS
+
 With balance filters, it is possible to perform a balance operation on
 only a subset of the available chunks. Filters are specified with the
-\fB--filter\fR option of \fBbtrfs device balance\fR or \fBbtrfs
+\fB--filter\fR option of \fBbtrfs filesystem balance\fR or \fBbtrfs
 balance start\fR. Multiple filters may be given, either with multiple
 \fB--filter\fR options, or in a colon-separated list. When multiple
 filters are given, only the chunks meeting all of the selection
 critera are balanced. Help on the avaialble filters can be obtained
 with \fB--filter=help\fR.
 
-.TP
+
 \fBtype\fR=[\fB~\fR]\fI<flagname>\fR[\fB,\fR...]
 
 Select only the chunks with the given type flag(s). Requiring a flag
@@ -321,14 +323,14 @@ chunk types.
 \fBraid0\fR, \fBraid1\fR, \fBraid10\fR, \fBdup\fR for chunks of the
 given replication levels.
 
-.TP
+
 \fBdevid\fR=\fI<n>\fR
 
 Select chunks which have data on device ID \fI<n>\fR. This can be
 used, for example, to reduplicate data in a mirrored configuration
 where one drive has been lost due to hardware failure.
 
-.TP
+
 \fBvrange\fR=\fI<start>\fB,\fI<end>\fR
 
 Select chunks which have btrfs-internal virtual addresses within the
@@ -337,7 +339,6 @@ address of the last chunk moved, this filter can be used to restart a
 cancelled or interrupted balance operation, by supplying a range of
 \fB0,\fI<chunkaddr+1>\fR.
 
-.TP
 \fBdrange\fR=\fI<start>\fB,\fI<end>\fR
 
 Select chunks which contain data in the address range \fI<start>\fR

--------------020203000604020109090104--
