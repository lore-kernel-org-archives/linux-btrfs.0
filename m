From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/7][V2] btrfs-progs:  Add the header/footer/introduction of the man page.
Date: Tue, 08 Nov 2011 23:12:31 +0100
Message-ID: <30023568.Ekcgkf9aDJ@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1595004.pDBteokX8g"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1595004.pDBteokX8g
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"


Add the header/footer/introduction of the man page. There is also an
introduction to the syntax recognized by the tool helpextract to format
the information.

Signed off by: Goffredo Baroncelli <kreijack@inwind.it>
---
 btrfs.c |  173 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index cc2f7ca..26bd4f6 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -26,6 +26,179 @@
 #define BASIC_HELP 0
 #define ADVANCED_HELP 1
 
+/**
+ ** The comments below are used to make the man page
+ **
+ ** There are:
+ ** - Header, 
+ ** - The synopsis title section (the content are extracted from other 
+ **   comments)
+ ** - The synopsis format, which is a template: the '%s' is replaced by 
+ **   the command line "syntax"
+ ** - The btrfs introduction section
+ ** - The btfrs command title section (the content are extracted from other 
+ **   comments)
+ ** - The command format, which is a template: the first '%s' is replaced by 
+ **   the command line "syntax"; the ssecond '%s' is replaced by the
+ **   detailed descritpion
+ ** - The "notes" section 
+ ** - The footer (currentli empty)
+ **
+ ** The comments are the following sytax [replace '{slash}' with '/']
+ **
+ ** If the comment starts with '{slash}**** text: ', then all the text below
+ ** are used until ' ***'. The text after 'text: ' are the key used to
+ ** index teh content. 
+ **
+ ** If the comment starts with '{slash}**** man: ', then below the comment 
are
+ ** divided in three section:
+ ** 1) (one line) command line syntax
+ ** 2) (multiple line) short description (showed in the command "btrfs help")
+ ** 3) (multiple line) detailled description (showed in the man page and
+ **    command "btrfs <subcommand> --help")
+ ** The text after 'man: ' are the key used to index the content. This must
+ ** be equal to the subcommand which the info is referred.
+ ** 
+ ** Below the escape sequence which may be used in the text
+ **
+ **	     escape      troff
+ **          sequence    command
+ **
+ **                \B	 \fB         bold 
+ **                \b	 \fP         end bold 
+ **                \I	 \fI         italic 
+ **                \i	 \fP         end italic 
+ **                \c	 .\"         comment 
+ **                \P	 .PP         start paragraph 
+ **                \p	 .TP         indented paragraph 
+ **                \h	 .SH         header 
+ **                \d	 .BR         bold regular 
+ **                \e	 .B          bold 
+ **                \t	 .IP         indented paragraph 
+ **                \w	 .RS         move the left margin 
+ **                \q	 .RE         move the left margin back
+ **		   \-    \-          minus (it *must* escaped )
+ **
+ **
+ **/
+
+
+/**** text: man btrfs header
+ * .TH BTRFS 8 "" "btrfs" "btrfs"
+ * .\"
+ * .\" Man page for the "btrfs" tool 
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
+/**** text: btrfs introduction
+ * \h DESCRIPTION
+ * \Bbtrfs\b is used to control the filesystem and the files and directories 
+ * stored. It is the tool to create or destroy a snapshot or a subvolume for 
+ * the filesystem, to defrag a file or a directory, flush the data to the disk,
+ * to resize the filesystem, to scan the device.
+ * 
+ * It is possible to abbreviate the commands unless the commands  are 
ambiguous.
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
+/**** text: man btrfs command format
+ *
+ * .TP
+ * %s%s
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
+ * \I0,<chunkaddr+1>\i.
+ * 
+ * \Bdrange\b=\I<start>\i,\I<end>\i
+ * 
+ * Select chunks which contain data in the address range \I<start>\i
+ * (inclusive) to \I<end>\i (exclusive) on \Iany\i block device in
+ * the filesystem. Can be mixed with the \Bdevid\b filter to select
+ * chunks in a given address range on a specific device.
+ * 
+ * \h EXIT STATUS
+ * \Bbtrfs\b returns a zero exist status if it succeeds. Non zero is returned 
in
+ * case of failure.
+ * 
+ * \h AVAILABILITY
+ * \Bbtrfs\b is part of btrfs-progs. Btrfs filesystem is currently under 
+ * heavy development, and not suitable for any uses other than benchmarking 
and
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
 typedef int (*CommandFunction)(int argc, char **argv);
 
 struct Command {
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1595004.pDBteokX8g
Content-Disposition: inline; filename="send-via-kmail-attach-8089-1320789396-5201.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-8089-1320789396-5201.msg"

diff --git a/btrfs.c b/btrfs.c
index cc2f7ca..26bd4f6 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -26,6 +26,179 @@
 #define BASIC_HELP 0
 #define ADVANCED_HELP 1
 
+/**
+ ** The comments below are used to make the man page
+ **
+ ** There are:
+ ** - Header, 
+ ** - The synopsis title section (the content are extracted from other 
+ **   comments)
+ ** - The synopsis format, which is a template: the '%s' is replaced by 
+ **   the command line "syntax"
+ ** - The btrfs introduction section
+ ** - The btfrs command title section (the content are extracted from other 
+ **   comments)
+ ** - The command format, which is a template: the first '%s' is replaced by 
+ **   the command line "syntax"; the ssecond '%s' is replaced by the
+ **   detailed descritpion
+ ** - The "notes" section 
+ ** - The footer (currentli empty)
+ **
+ ** The comments are the following sytax [replace '{slash}' with '/']
+ **
+ ** If the comment starts with '{slash}**** text: ', then all the text below
+ ** are used until ' ***'. The text after 'text: ' are the key used to
+ ** index teh content. 
+ **
+ ** If the comment starts with '{slash}**** man: ', then below the comment are
+ ** divided in three section:
+ ** 1) (one line) command line syntax
+ ** 2) (multiple line) short description (showed in the command "btrfs help")
+ ** 3) (multiple line) detailled description (showed in the man page and
+ **    command "btrfs <subcommand> --help")
+ ** The text after 'man: ' are the key used to index the content. This must
+ ** be equal to the subcommand which the info is referred.
+ ** 
+ ** Below the escape sequence which may be used in the text
+ **
+ **	     escape      troff
+ **          sequence    command
+ **
+ **                \B	 \fB         bold 
+ **                \b	 \fP         end bold 
+ **                \I	 \fI         italic 
+ **                \i	 \fP         end italic 
+ **                \c	 .\"         comment 
+ **                \P	 .PP         start paragraph 
+ **                \p	 .TP         indented paragraph 
+ **                \h	 .SH         header 
+ **                \d	 .BR         bold regular 
+ **                \e	 .B          bold 
+ **                \t	 .IP         indented paragraph 
+ **                \w	 .RS         move the left margin 
+ **                \q	 .RE         move the left margin back
+ **		   \-    \-          minus (it *must* escaped )
+ **
+ **
+ **/
+
+
+/**** text: man btrfs header
+ * .TH BTRFS 8 "" "btrfs" "btrfs"
+ * .\"
+ * .\" Man page for the "btrfs" tool 
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
+/**** text: btrfs introduction
+ * \h DESCRIPTION
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
+/**** text: man btrfs command format
+ *
+ * .TP
+ * %s%s
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
+ * \I0,<chunkaddr+1>\i.
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
 typedef int (*CommandFunction)(int argc, char **argv);
 
 struct Command {
-- 
1.7.7.2

--nextPart1595004.pDBteokX8g--

