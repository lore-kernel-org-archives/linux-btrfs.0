From: hugo@carfax.org.uk
Subject: (unknown)
Date: Fri, 12 Nov 2010 19:24:16 +0000
Message-ID: <E1PGzEO-000086-QS@vlad.carfax.org.uk>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>From 2de353ddda78ef5cbc84e1d3267606bc44e48faa Mon Sep 17 00:00:00 2001
Message-Id: <2de353ddda78ef5cbc84e1d3267606bc44e48faa.1289589812.git.hugo@carfax.org.uk>
From: Hugo Mills <hugo@carfax.org.uk>
Date: Sat, 6 Nov 2010 00:18:12 +0000
Subject: [PATCH] Clean up typography in the man pages.
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@libero.it>

The man pages are a bit vague about their use of bold and italic, and
don't lay out the meaning of options for each command very well. This
patch tightens up on the type-styles and layout for the main man pages
(btrfs, btrfsck, mkfs.btrfs).

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 man/btrfs.8.in      |  270 +++++++++++++++++++++++++++++++++-----------------
 man/btrfsck.8.in    |    4 +-
 man/mkfs.btrfs.8.in |   39 ++++----
 3 files changed, 200 insertions(+), 113 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..7569a9e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -1,39 +1,73 @@
+.so an
 .TH BTRFS 8 "" "btrfs" "btrfs"
 .\"
 .\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+.\" Typography fixed by Hugo Mills <hugo@carfax.org.uk> (Oct 2010)
 .\"
 .SH NAME
 btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI <source> [<dest>/]<name>\fP
+\fBsubvolume snapshot \fI<source> \fR[\fI<dest>\fR] \fI<name>\fR
 .PP
-\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
+
+.BI "btrfs subvolume delete " <subvolume>
+.PP
+
+.B btrfs subvolume create
+.RI [ <dest> ] " <name>"
 .PP
-\fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
+
+.BI "btrfs subvolume list " <path>
+.PP
+
+.BI "btrfs subvolume set-default " "<id> <path>"
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI <path>\fP
+
+.B "btrfs filesystem defragment "
+.RB [ -vcf "] [" -s
+.IR <start> ]
+.RB [ -l
+.IR <len> ]
+.RB [ -t
+.IR <size> "] " <file> | <dir> " ..."
 .PP
-\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+
+.BI "btrfs filesystem sync " <path>
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
+
+.BR "btrfs filesystem resize " [ + | \- ] \fI<size>\fP [ gmk ]| max
+.I <filesystem>
 .PP
-\fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
+
+.BR "btrfs filesystem df " [ -h | --human-readable | -H | --si ]
++.I <path>
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
+
+.BR "btrfs filesystem show " [ -h | --human-readable | -H | --si ]
+.RI [ <uuid> | <label> ]
 .PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
+.B btrfs device scan
+.RI [ <device> ] " ..."
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
+
+.B btrfs device show
+.IR <dev> | <label> " ..."
 .PP
-\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
+
+.BI "btrfs device balance " <path>
 .PP
-\fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
+
+.BI "btrfs device add " <dev>
+.RI [ <dev> " ... ]" <path>
 .PP
-\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
 
+.B "btrfs device delete"
+.IR <dev> [ <dev> " ... ]" <path>
 .PP
-\fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
+
+.BR "btrfs help" | \-\-help | \-h
 .PP
+
 .SH DESCRIPTION
 .B btrfs
 is used to control the filesystem and the files and directories stored. It is
@@ -42,123 +76,174 @@ filesystem, to defrag a file or a directory, flush the data to the disk,
 to resize the filesystem, to scan the device.
 
 It is possible to abbreviate the commands unless the commands  are ambiguous.
-For example: it is possible to run
-.I btrfs sub snaps
+For example, it is possible to run
+.B btrfs sub snaps
 instead of
-.I btrfs subvolume snapshot.
+.B btrfs subvolume snapshot.
 But
-.I btrfs dev s
+.B btrfs dev s
 is not allowed, because
-.I dev s
+.B dev s
 may be interpreted both as
-.I device show
+.B device show
 and as
-.I device scan.
+.B device scan.
 In this case
-.I btrfs
+.B btrfs
 returns an error.
 
 If a command is terminated by
-.I --help
-, the relevant help is showed. If the passed command matches more commands,
-the help of all the matched commands are showed. For example
-.I btrfs dev --help
+.B --help
+, the relevant help is shown. If the passed command matches more commands,
+the help of all the matched commands is shown. For example
+.B btrfs dev --help
 shows the help of all
-.I device*
-command.
+.B device*
+commands.
 
 .SH COMMANDS
-.TP
+.SS
+subvolume snapshot \fI<source> \fR[\fI<dest>\fR] \fI<name>\fR
 
-\fBsubvolume snapshot\fR\fI <source> [<dest>/]<name>\fR
-Create a writable snapshot of the subvolume \fI<source>\fR with the name
-\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
-.TP
+Create a writable snapshot of the subvolume \fI<source>\fP with the
+name \fI<name>\fP in the \fI<dest>\fP directory. If \fI<source>\fP is
+not a subvolume, \fBbtrfs\fP returns an error.
 
-\fBsubvolume delete\fR\fI <subvolume>\fR
-Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
-.TP
+.SS
+subvolume delete \fI<subvolume>\fP
 
-\fBsubvolume create\fR\fI [<dest>/]<name>\fR
-Create a subvolume in \fI<dest>\fR (or in the current directory if
-\fI<dest>\fR is omitted).
-.TP
+Delete the subvolume \fI<subvolume>\fP. If \fI<subvolume>\fP is not a
+subvolume, \fBbtrfs\fP returns an error.
 
-\fBsubvolume list\fR\fI <path>\fR
-List the subvolumes present in the filesystem \fI<path>\fR. For every
-subvolume is showed the subvolume ID (second column), 
-the ID of the \fItop level\fR 
-subvolume (fifth column), and the path (seventh column) relative to the
-\fItop level\fR subvolume.
-These <ID> may be used by the \fBsubvolume set-default\fR command, or at
-mount time via the \fIsubvol=\fR option.
-.TP
+.SS
+subvolume create \fR[\fI<dest>\fR] \fI<name>\fR
 
-\fBsubvolume set-default\fR\fI <id> <path>\fR
-Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
-\fIdefault\fR. The subvolume is identified by \fB<id>\fR, which 
-is returned by the \fBsubvolume list\fR command.
-.TP
+Create a subvolume in \fI<dest>\fP (or in the current directory if
+\fI<dest>\fP is omitted).
 
-\fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
-Defragment files and/or directories.
-.TP
+.SS
+subvolume list \fI<path>\fP
 
-\fBdevice scan\fR \fI[<device> [<device>..]]\fR
-Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR scans
-all the block devices.
-.TP
+List the subvolumes present in the filesystem \fI<path>\fP. For every
+subvolume, show the subvolume ID (second column), the ID of the \fItop
+level\fP subvolume (fifth column), and the path (seventh column)
+relative to the \fItop level\fP subvolume. These IDs may be used by
+the \fBsubvolume set-default\fP command, or at mount time via the
+\fIsubvolid=\fP option.
+
+.SS
+subvolume set-default \fI<id> <path>\fP
+
+Set the default subvolume of the filesystem \fI<path>\fP. The default
+subvolume is the one which is mounted as default if no \fBsubvol=\fP
+or \fBsubvolid=\fP parameter is passed to mount.
 
-\fBfilesystem sync\fR\fI <path> \fR
-Force a sync for the filesystem identified by \fI<path>\fR.
+.SS
+filesystem defragment \fR[\fB-vcf\fR] [\fB-s \fI<start>\fR] [\fB-l \fI<len>\fR] [\fB-t \fI<size>\fR] \fI<file>\fR|\fI<dir> \fR...
+
+Defragment files and/or directories. Defragmenting a directory will
+only defragment the directory metadata, not the contents.
+
+Options:
+.TP
+.B -v
+Verbose output.
 .TP
+.B -c
+Compress the file/directory.
+.TP
+.B -f
+Flush (what does this do? -HRM)
+.TP
+.BI -s " <start>"
+.TP
+.BI -l " <len>"
+Defragment a range of a file, starting at offset \fI<start>\fP into the file,
+and of length \fI<len>\fP.
+.TP
+.BI -t " <size>"
+Use extent threshold \fI<size>\fP (what does this do? -HRM).
+
+.SS
+device scan \fR[\fI<device> \fR...]
+
+Scan devices for a btrfs filesystem. If no devices are passed,
+\fBbtrfs\fP scans all the block devices.
 
+.SS
+filesystem sync \fI<path>\fP
+
+Force a sync for the filesystem identified by \fI<path>\fP.
+
+.SS
 .\"
-.\" Some wording are extracted by the resize2fs man page
+.\" Some wording has been extracted from the resize2fs man page
 .\"
+filesystem resize \fR[\fB+\fR|\fB\-\fR]\fI<size>\fR[\fBgmk\fR]|\fBmax \fI<path>\fR
 
-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
-Resize a filesystem identified by \fI<path>\fR.
-The \fI<size>\fR parameter specifies the new size of the filesystem.
-If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
-by the quantity \fI<size>\fR.
-If no units are specified, the unit of the \fI<size>\fR parameter defaults to
-bytes. Optionally, the size parameter may be suffixed by one of the following
-the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+Resize a filesystem identified by \fI<path>\fP. The \fI<size>\fP
+parameter specifies the new size of the filesystem. If the prefix
+\fI+\fP or \fI\-\fP is present, the size is increased or decreased by
+the quantity \fI<size>\fP. If no units are specified, the unit of the
+\fI<size>\fP parameter defaults to bytes. Optionally, the size
+parameter may be suffixed by one of the unit designators \fBk\fP,
+\fBm\fP, or \fBg\fP, representing, kibibytes, mebibytes, or gibibytes,
 respectively.
 
-If 'max' is passed, the filesystem will occupy all available space on the
-volume(s).
+If \fBmax\fP is passed, the filesystem will occupy all available space
+on the volume(s).
+
+The \fBresize\fP command \fBdoes not\fP manipulate the size of the
+underlying partition. If you wish to enlarge/reduce a filesystem, you
+must make sure you can expand the partition before enlarging the
+filesystem and shrink the partition after reducing the size of the
+filesystem.
+
+.SS
+filesystem df \fR[\fB\-h\fR|\fB\-H\fR|\fB\-\-human\-readable\fR|\fB\-\-si\fR] \fI<path>\fR
+Show the amount of space used on the filesystem mounted at
+\fI<path>\fP, in bytes.
 
-The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
-partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
-can expand the partition before enlarging the filesystem and shrink the
-partition after reducing the size of the filesystem.
 .TP
+.B \-h, \-\-human\-readable
+Use powers of 2^10 (1024) to report sizes.
 
-\fBfilesystem show\fR [<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no UUID or label is
-passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 .TP
+.B \-H, \-\-si
+Use powers of 10^3 (1000) to report sizes, in SI multiples.
+
+.SS
+filesystem show \fR[\fB\-h\fR|\fB\-H\fR|\fB\-\-human\-readable\fR|\fB\-\-si\fR] [\fI<uuid>\fR|\fI<label>\fR]
+
+Show the usage of each device in the filesystem with UUID \fI<uuid>\fP
+or label \fI<label>\fP, or all filesystems if no UUID or label is
+provided.
 
-\fBdevice balance\fR \fI<path>\fR
-Balance the chunks of the filesystem identified by \fI<path>\fR
-across the devices.
 .TP
+.B \-h, \-\-human\-readable
+Use powers of 2^10 (1024) to report sizes.
 
-\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
-Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
+.B \-H, \-\-si
+Use powers of 10^3 (1000) to report sizes, in SI multiples.
+
+.SS
+device balance \fI<path>\fP
+Balance the chunks of the filesystem identified by \fI<path>\fP
+across the devices.
 
-\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
-Remove device(s) from a filesystem identified by \fI<path>\fR.
+.SS
+device add \fI<dev> \fR[\fI<dev> \fR...] \fI<path>\fR
+Add device(s) to the filesystem identified by \fI<path>\fP.
+
+.SS
+device delete \fI<dev> \fR[\fI<dev> \fR...] \fI<path>\fR
+Remove device(s) from a filesystem identified by \fI<path>\fP.
 .PP
 
 .SH EXIT STATUS
-\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
-case of failure.
+\fBbtrfs\fP returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
 
 .SH AVAILABILITY
 .B btrfs
@@ -166,5 +251,6 @@ is part of btrfs-progs. Btrfs filesystem is currently under heavy development,
 and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
+
 .SH SEE ALSO
 .BR mkfs.btrfs (8)
diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
index 4bf1cff..b0201cd 100644
--- a/man/btrfsck.8.in
+++ b/man/btrfsck.8.in
@@ -1,8 +1,8 @@
-.TH BTRFSCK 8
+.TH BTRFSCK 8 "" "btrfs" "btrfs"
 .SH NAME
 btrfsck \- check a btrfs filesystem
 .SH SYNOPSIS
-.B btrfsck \fI device\fP
+.B btrfsck \fI<device>\fP
 .SH DESCRIPTION
 \fBbtrfsck\fP is used to check a btrfs filesystem.
 \fIdevice\fP is the device file where the filesystem is stored.
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 1e14c6c..cff147e 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -1,26 +1,26 @@
-.TH MKFS.BTRFS 8
+.TH MKFS.BTRFS 8 "" "btrfs" "btrfs"
 .SH NAME
-mkfs.btrfs \- create an btrfs filesystem
+mkfs.btrfs \- create a btrfs filesystem
 .SH SYNOPSIS
 .B mkfs.btrfs
-[ \fB\-A\fP\fI alloc-start\fP ]
-[ \fB\-b\fP\fI byte-count\fP ]
-[ \fB \-d\fP\fI data-profile\fP ]
-[ \fB \-l\fP\fI leafsize\fP ]
-[ \fB \-L\fP\fI label\fP ]
-[ \fB \-m\fP\fI metadata profile\fP ]
-[ \fB \-n\fP\fI nodesize\fP ]
-[ \fB \-s\fP\fI sectorsize\fP ]
-[ \fB \-h\fP ]
-[ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
+[\fB\-A\fP\fI alloc-start\fP]
+[\fB\-b\fP\fI byte-count\fP]
+[\fB\-d\fP\fI data-profile\fP]
+[\fB\-l\fP\fI leafsize\fP]
+[\fB\-L\fP\fI label\fP]
+[\fB\-m\fP\fI metadata profile\fP]
+[\fB\-n\fP\fI nodesize\fP]
+[\fB\-s\fP\fI sectorsize\fP]
+[\fB\-h\fP]
+[\fB\-V\fP] \fI device\fP [\fIdevice\fP ...]
 .SH DESCRIPTION
 .B mkfs.btrfs
-is used to create an btrfs filesystem (usually in a disk partition, or an array
-of disk partitions).
+is used to create a btrfs filesystem (usually in a disk partition, or
+an array of disk partitions).
 .I device
-is the special file corresponding to the device (e.g \fI/dev/sdXX\fP ).
-If multiple \fI devices \fP are specified, btrfs is created
-spanning across the specified \fI devices\fP.
+is the special file corresponding to the device (e.g \fB/dev/sd\fP\fIXX\fP).
+If multiple \fIdevice\fPs are specified, the filesystem is created
+across all the specified \fIdevice\fPs.
 .SH OPTIONS
 .TP
 \fB\-A\fR, \fB\-\-alloc\-start \fIoffset\fR
@@ -32,7 +32,7 @@ mkfs.btrfs uses all the available storage for the filesystem.
 .TP
 \fB\-d\fR, \fB\-\-data \fItype\fR
 Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are \fBraid0\fP, \fBraid1\fP, \fBraid10\fP or \fBsingle\fP.
 .TP
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
 Specify the leaf size, the least data item in which btrfs stores data. The
@@ -43,7 +43,7 @@ Specify a label for the filesystem.
 .TP
 \fB\-m\fR, \fB\-\-metadata \fIprofile\fR
 Specify how metadata must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are \fBraid0\fP, \fBraid1\fP, \fBraid10\fP or \fBsingle\fP.
 .TP
 \fB\-n\fR, \fB\-\-nodesize \fIsize\fR
 Specify the nodesize. By default the value is set to the pagesize.
@@ -61,3 +61,4 @@ Please refer to the btrfs wiki
 http://btrfs.wiki.kernel.org for further details.
 .SH SEE ALSO
 .BR btrfsck (8)
+.BR btrfs (8)
-- 
1.7.1

