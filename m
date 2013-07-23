Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42063 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab3GWCmp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 22:42:45 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6N2gdvH026444
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 10:42:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 2/2] btrfs-progs: Update the man page of btrfs
Date: Tue, 23 Jul 2013 10:43:22 +0800
Message-Id: <1374547402-14890-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1374547402-14890-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1374547402-14890-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update the man page of "btrfs" command to keep up with new commands.

Now the updated btrfs man page should have all the commands,
and better description sequence, which is the same with "btrfs --help".
Also the paragraph and italic style is unified to improve the readability.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 man/btrfs.8.in | 568 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 396 insertions(+), 172 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..0d88340 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -1,67 +1,98 @@
 .TH BTRFS 8 "" "btrfs" "btrfs"
 .\"
 .\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+.\" Modified by Qu Wenruo <quwenruo@cn.fujitsu.com> (Jun 2013)
 .\"
 .SH NAME
 btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
+\fBbtrfs\fP \fBsubvolume create\fP [-i \fI<qgroupid>\fP] [\fI<dest>\fP/]\fI<name>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume> [<subvolume>...]\fP
+\fBbtrfs\fP \fBsubvolume delete\fP \fI<subvolume>\fP [\fI<subvolume>...\fP]
 .PP
-\fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
+\fBbtrfs\fP \fBsubvolume list\fP [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <lastgen>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
-[-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
-[<\fIfile\fR>|<\fIdir\fR>...]
+.PP
+\fBbtrfs\fP \fBfilesystem df\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem show\fP [--all-devices|\fI<uuid>\fP|\fI<label>\fP]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
+\fBbtrfs\fP \fBfilesystem defragment\fP [\fIoptions\fP] \fI<file>\fP|\fI<dir>\fP [\fI<file>\fP|\fI<dir>...\fP]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+\fBbtrfs\fP \fBfilesystem label\fP [\fI<device>\fP|\fI<mount_point>\fP] [\fI<newlabel>\fP]
 .PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
 .PP
-\fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fB[filesystem] balance start\fP [\fIoptions\fP] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
+\fBbtrfs\fP \fB[filesystem] balance pause\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
+\fBbtrfs\fP \fB[filesystem] balance cancel\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBreplace start\fP \fI[-Bfr] <srcdev>|<devid> <targetdev> <path>\fP
+\fBbtrfs\fP \fB[filesystem] balance resume\fP\fI <path>\fP
 .PP
-\fBbtrfs\fP \fBreplace status\fP \fI[-1] <path>\fP
+\fBbtrfs\fP \fB[filesystem] balance status\fP [-v] \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBreplace cancel\fP \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fBdevice add\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBdevice scan\fP [\fI<device>...\fP]
+.PP
+\fBbtrfs\fP \fBdevice ready\fP\fI <device>\fP
+.PP
+\fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
+.PP
+.PP
+\fBbtrfs\fP \fBscrub start\fP [-BdqrR] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
 .PP
-\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
+\fBbtrfs\fP \fBscrub resume\fP [-BdqrR] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
 .PP
+.PP
+\fBbtrfs\fP \fBcheck\fP [\fIoptions\fP] \fI<device>\fP
+.PP
+\fBbtrfs\fP \fBchunk-recover\fP [\fIoptions\fP] \fI<device>\fP
+.PP
+\fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP
+.PP
+.PP
 \fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBinspect-internal logical-resolve\fP
-[-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
+\fBbtrfs\fP \fBinspect-internal logical-resolve\fP [-Pv] [-s \fI<size>\fP] \fI<logical>\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBinspect-internal subvolid-resolve\fP \fI<subvolid>\fP \fI<path>\fP
 .PP
+.PP
+\fBbtrfs\fP \fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
+.PP
+\fBbtrfs\fP \fBreceive\fP [-ve] [-f \fI<infile>\fP] \fI<mount>\fP
+.PP
+.PP
+\fBbtrfs\fP \fBquota enable\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBquota disable\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBquota rescan\fP [-s] \fI<path>\fP
+.PP
+.PP
 \fBbtrfs\fP \fBqgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBqgroup remove\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
@@ -72,11 +103,18 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBqgroup show\fP \fI<path>\fP
 .PP
-\fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
+\fBbtrfs\fP \fBqgroup limit\fP [\fIoptions\fP] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
+.PP
+.PP
+\fBbtrfs\fP \fBreplace start\fP [-Bfr] \fI<srcdev>\fP|\fI<devid> <targetdev> <mount_point>\fP
 .PP
-\fBbtrfs\fP \fBhelp|\-\-help \fP\fI\fP
+\fBbtrfs\fP \fBreplace status\fP [-1] \fI<mount_point>\fP
 .PP
-\fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
+\fBbtrfs\fP \fBreplace cancel\fP \fI<mount_point>\fP
+.PP
+\fBbtrfs\fP \fBhelp|\-\-help \fP
+.PP
+\fBbtrfs\fP \fB<command> \-\-help \fP
 .PP
 .SH DESCRIPTION
 .B btrfs
@@ -85,7 +123,7 @@ the tool to create or destroy a snapshot or a subvolume for the
 filesystem, to defrag a file or a directory, flush the data to the disk,
 to resize the filesystem, to scan the device.
 
-It is possible to abbreviate the commands unless the commands  are ambiguous.
+It is possible to abbreviate the commands unless the commands are ambiguous.
 For example: it is possible to run
 .I btrfs sub snaps
 instead of
@@ -113,28 +151,29 @@ commands.
 .SH COMMANDS
 .TP
 
-\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
-Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
-name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
-will be readonly.
+\fBsubvolume create\fP [-i \fI<qgroupid>\fP] [\fI<dest>\fP/]\fI<name>\fP
+Create a subvolume \fI<name>\fR in \fI<dest>\fR.
+If \fI<dest>\fR is not given subvolume \fI<name>\fR will be created in the
+current directory.
+.RS
+
+\fIOptions\fP
+.IP "\fB-i\fP \fI<qgroupid>\fR" 5
+Add the newly created subvolume to a qgroup. This option can be given multiple
+times.
+.RE
 .TP
 
-\fBsubvolume delete\fR\fI <subvolume> [<subvolume>...]\fR
+\fBsubvolume delete\fR\fI <subvolume> \fP[\fI<subvolume>...\fP]\fR
 Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
 subvolume, \fBbtrfs\fR returns an error.
 .TP
 
-\fBsubvolume create\fR\fI [<dest>/]<name>\fR
-Create a subvolume in \fI<dest>\fR (or in the current directory if
-\fI<dest>\fR is omitted).
-.TP
+\fBsubvolume list\fR [\fIoptions\fP] [-G [+|-]\fIvalue\fP] [-C [+|-]\fIvalue\fP] [--sort=rootid,gen,ogen,path] \fI<path>\fR
 
-\fBsubvolume list\fR\fI [-acgoprts] [-G [+|-]value] [-C [+|-]value] [--sort=rootid,gen,ogen,path] <path>\fR
-.RS
 List the subvolumes present in the filesystem \fI<path>\fR. For every
 subvolume the following information is shown by default.
-ID <ID> top level <ID> path <path>
+ID \fI<ID>\fP top level \fI<ID>\fP path \fI<path>\fP
 where path is the relative path of the subvolume to the \fItop level\fR
 subvolume.
 
@@ -143,34 +182,38 @@ at mount time via the \fIsubvolid=\fR option.
 If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
 and top level. The parent's ID may be used at mount time via the
 \fIsubvolrootid=\fR option.
+.RS
 
-\fB-t\fP print the result as a table.
-
-\fB-a\fP print all the subvolumes in the filesystem and distinguish between
-absolute and relative path with respect to the given <path>.
-
-\fB-c\fP print the ogeneration of the subvolume, aliases: ogen or origin generation
-
-\fB-g\fP print the generation of the subvolume
-
-\fB-u\fP print the UUID of the subvolume
-
-\fB-o\fP print only subvolumes bellow specified <path>.
-
-\fB-r\fP only readonly subvolumes in the filesystem will be listed.
-
-\fB-s\fP only snapshot subvolumes in the filesystem will be listed.
-
-\fB-G [+|-]value\fP
+\fIOptions\fP
+.IP "\fB-p\fP" 5
+print parent ID.
+.IP "\fB-a\fP" 5
+print all the subvolumes in the filesystem and distinguish between
+absolute and relative path with respect to the given \fI<path>\fP.
+.IP "\fB-c\fP" 5
+print the ogeneration of the subvolume, aliases: ogen or origin generation.
+.IP "\fB-g\fP" 5
+print the generation of the subvolume.
+.IP "\fB-o\fP" 5
+print only subvolumes bellow specified <path>.
+.IP "\fB-u\fP" 5
+print the UUID of the subvolume.
+.IP "\fB-q\fP" 5
+print the parent uuid of subvolumes (and snapshots).
+.IP "\fB-t\fP" 5
+print the result as a table.
+.IP "\fB-s\fP" 5
+only snapshot subvolumes in the filesystem will be listed.
+.IP "\fB-r\fP" 5
+only readonly subvolumes in the filesystem will be listed.
+.IP "\fB-G [+|-]\fIvalue\fP\fP" 5
 list subvolumes in the filesystem that its generation is
->=, <= or = value. '+' means >= value, '-' means <= value, If there is
-neither '+' nor '-', it means = value.
-
-\fB-C [+|-]value\fP
+>=, <= or = \fIvalue\fP. '+' means >= \fIvalue\fP, '-' means <= \fIvalue\fP, If there is
+neither '+' nor '-', it means = \fIvalue\fP.
+.IP "\fB-C [+|-]\fIvalue\fP" 5
 list subvolumes in the filesystem that its ogeneration is
->=, <= or = value. The usage is the same to '-g' option.
-
-\fB--sort=rootid,gen,ogen,path\fP
+>=, <= or = \fIvalue\fP. The usage is the same to '-g' option.
+.IP "\fB--sort=rootid,gen,ogen,path\fP" 5
 list subvolumes in order by specified items.
 you can add '+' or '-' in front of each items, '+' means ascending, '-'
 means descending. The default is ascending.
@@ -180,10 +223,12 @@ for \fB--sort\fP you can combine some items together by ',', just like
 .RE
 .TP
 
-\fBsubvolume set-default\fR\fI <id> <path>\fR
-Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
-\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which 
-is returned by the \fBsubvolume list\fR command.
+\fBsubvolume snapshot\fP [-r] \fI<source>\fP \fI<dest>\fP|[\fI<dest>\fP/]\fI<name>\fP
+Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
+name \fI<name>\fR in the \fI<dest>\fR directory.
+If only \fI<dest>\fR is given, the subvolume will be named the basename of \fI<source>\fR.
+If \fI<source>\fR is not a subvolume, \fBbtrfs\fR returns an error.
+If \fI-r\fR is given, the snapshot will be readonly.
 .TP
 
 \fBsubvolume get-default\fR\fI <path>\fR
@@ -191,6 +236,12 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume set-default\fR\fI <id> <path>\fR
+Set the subvolume of the filesystem \fI<path>\fR which is mounted as
+\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which
+is returned by the \fBsubvolume list\fR command.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
@@ -199,9 +250,22 @@ List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 Show information of a given subvolume in the \fI<path>\fR.
 .TP
 
-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
-[-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
+\fBfilesystem df\fP\fI <path>\fR
+Show space usage information for a mount point.
+.TP
 
+\fBfilesystem show\fR [--all-devices|\fI<uuid>\fR|\fI<label>\fR]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP or
+\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+otherwise the devices list is extracted from the /proc/partitions file.
+.TP
+
+\fBfilesystem sync\fR\fI <path> \fR
+Force a sync for the filesystem identified by \fI<path>\fR.
+.TP
+
+\fBfilesystem defragment\fP [\fIoptions\fP] \fI<file>\fP|\fI<dir>\fP [\fI<file>\fP|\fI<dir>...\fP]\fP
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
 
@@ -210,18 +274,21 @@ The start position and the number of bytes to defragment can be specified by
 considered already defragged. Use 0 to take the kernel default, and use 1 to
 say every single extent must be rewritten. You can also turn on compression in
 defragment operations.
+.RS
 
-\fB-v\fP be verbose
-
-\fB-c\fP compress file contents while defragmenting
-
-\fB-f\fP flush filesystem after defragmenting
-
-\fB-s start\fP defragment only from byte \fIstart\fR onward
-
-\fB-l len\fP defragment only up to \fIlen\fR bytes
-
-\fB-t size\fP defragment only files at least \fIsize\fR bytes big
+\fIOptions\fR
+.IP "\fB-v\fP" 5
+be verbose
+.IP "\fB-c\fP" 5
+compress file contents while defragmenting
+.IP "\fB-f\fP" 5
+flush filesystem after defragmenting
+.IP "\fB-s \fIstart\fP\fP" 5
+defragment only from byte \fIstart\fR onward
+.IP "\fB-l \fIlen\fP\fP" 5
+defragment only up to \fIlen\fR bytes
+.IP "\fB-t \fIsize\fP\fP" 5
+defragment only files at least \fIsize\fR bytes big
 
 For \fBstart\fP, \fBlen\fP, \fBsize\fP it is possible to append a suffix
 like \fBk\fP for 1 KBytes, \fBm\fP for 1 MBytes...
@@ -229,17 +296,13 @@ like \fBk\fP for 1 KBytes, \fBm\fP for 1 MBytes...
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
 don't use it if you use snapshots, have de-duplicated your data or made
 copies with \fBcp --reflink\fP.
-.TP
-
-\fBfilesystem sync\fR\fI <path> \fR
-Force a sync for the filesystem identified by \fI<path>\fR.
+.RE
 .TP
 
 .\"
 .\" Some wording are extracted by the resize2fs man page
 .\"
-
-\fBfilesystem resize\fR\fI [devid:][+/\-]<size>[gkm]|[devid:]max <path>\fR
+\fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fR
 Resize a filesystem identified by \fI<path>\fR for the underlying device
 \fIdevid\fR.  The \fIdevid\fR can be found with \fBbtrfs filesystem show\fR and
 defaults to 1 if not specified.
@@ -263,7 +326,7 @@ it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 .TP
 
-\fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBfilesystem label\fP [\fI<dev>\fP|\fI<mount_point>\fP] [\fInewlabel\fP]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
 filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
@@ -271,7 +334,7 @@ following constraints exist for a label:
 .IP
 - the maximum allowable length shall be less or equal than 256 chars
 .IP
-- the label shall not  contain the '/' or '\\' characters.
+- the label shall not contain the '/' or '\\' characters.
 
 NOTE: Currently there are the following limitations:
 .IP
@@ -280,39 +343,61 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
+\fB[filesystem] balance start\fR [\fIoptions\fP] \fI<path>\fR
+Balance chunks across the devices
+Balance and/or convert (change allocation profile of) chunks that
+passed all \fIfilters\fR in a comma-separated list of filters for a
+particular chunk type.
+If filter list is not given balance all chunks of that type.
+In case none of the \fI-d\fR, \fI-m\fR or \fI-s\fR options is
+given balance all chunks in a filesystem.
+.RS
+
+\fIOptions\fR
+.IP "\fB-d[\fIfilters\fP]\fR" 5
+act on data chunks
+.IP "\fB-m[\fIfilters\fP]\fR" 5
+act on metadata chunks
+.IP "\fB-s[\fIfilters\fP]\fR" 5
+act on system chunks (only under -f)
+.IP "\fB-v\fP" 5
+be verbose
+.IP "\fB-f\fP" 5
+force reducing of metadata integrity
+.RE
 .TP
 
-\fBfilesystem balance\fR \fI<path>\fR
-Balance the chunks of the filesystem identified by \fI<path>\fR
-across the devices.
+\fB[filesystem] balance pause\fR\fI <path>\fR
+Pause running balance.
 .TP
 
-\fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
-Read and print the device IO stats for all devices of the filesystem
-identified by \fI<path>\fR or for a single \fI<device>\fR.
+\fB[filesystem] balance cancel\fR\fI <path>\fR
+Cancel running or paused balance.
+.TP
+
+\fB[filesystem] balance resume\fR\fI <path>\fR
+Resume interrupted balance.
+.TP
 
+\fB[filesystem] balance status\fR [-v] \fI<path>\fR
+Show status of running or paused balance.
 .RS
+
 \fIOptions\fR
-.TP
-.B -z
-Reset stats to zero after reading them.
+.IP "\fB-v\fP" 5
+be verbose
 .RE
 .TP
 
-\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice add\fR\fI <dev> \fP[\fI<dev>..\fP] \fI<path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice delete\fR\fI <dev> \fP[\fI<dev>..\fP] \fI<path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
-\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
+\fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
 If no devices are passed, \fBbtrfs\fR scans all the block devices listed
 in the /proc/partitions file.
@@ -320,56 +405,22 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
 scanned.
 .TP
 
-\fBreplace start\fR \fI[-Bfr] <srcdev>|<devid> <targetdev> <path>\fR
-Replace device of a btrfs filesystem.
-On a live filesystem, duplicate the data to the target device which
-is currently stored on the source device. If the source device is not
-available anymore, or if the \fB-r\fR option is set, the data is built
-only using the RAID redundancy mechanisms. After completion of the
-operation, the source device is removed from the filesystem.
-If the \fIsrcdev\fR is a numerical value, it is assumed to be the device id
-of the filesystem which is mounted at mount_point, otherwise is is
-the path to the source device. If the source device is disconnected,
-from the system, you have to use the \fIdevid\fR parameter format.
-The targetdev needs to be same size or larger than the \fIsrcdev\fR.
-
-.RS
-\fIOptions\fR
-.TP
-.B -r
-only read from \fIsrcdev\fR if no other zero-defect mirror exists (enable
-this if your drive has lots of read errors, the access would be very slow)
-.TP
-.B -f
-force using and overwriting \fItargetdev\fR even if it looks like
-containing a valid btrfs filesystem. A valid filesystem is
-assumed if a btrfs superblock is found which contains a
-correct checksum. Devices which are currently mounted are
-never allowed to be used as the \fItargetdev\fR
-.TP
-.B -B
-do not background
-.RE
+\fBdevice ready\fR \fI<device>\fR
+Check device to see if it has all of it's devices in cache for mounting.
 .TP
 
-\fBreplace status\fR \fI[-1] <path>\fR
-Print status and progress information of a running device replace operation.
-
+\fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
+Read and print the device IO stats for all devices of the filesystem
+identified by \fI<path>\fR or for a single \fI<device>\fR.
 .RS
+
 \fIOptions\fR
-.TP
-.B -1
-print once instead of print continously until the replace
-operation finishes (or is canceled)
+.IP "\fB-z\fP" 5
+Reset stats to zero after reading them.
 .RE
 .TP
 
-\fBreplace cancel\fR \fI<path>\fR
-Cancel a running device replace operation.
-.TP
-
-\fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
-\fBscrub start\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
+\fBscrub start\fP [-BdqrR] [-c \fIioprio_class\fP -n \fIioprio_classdata\fP] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
 a single \fI<device>\fR. Without options, scrub is started as a background
 process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
@@ -382,21 +433,21 @@ syntax.
 .RS
 
 \fIOptions\fR
-.IP -B 5
+.IP "\fB-B\fP" 5
 Do not background and print scrub statistics when finished.
-.IP -d 5
+.IP "\fB-d\fP" 5
 Print separate statistics for each device of the filesystem (-B only).
-.IP -q 5
+.IP "\fB-q\fP" 5
 Quiet. Omit error messages and statistics.
-.IP -r 5
+.IP "\fB-r\fP" 5
 Read only mode. Do not attempt to correct anything.
-.IP -u 5
-Scrub unused space as well. (NOT IMPLEMENTED)
-.IP -c 5
+.IP "\fB-R\fP" 5
+Raw print mode. Print full data instead of summary.
+.IP "\fB-c \fIioprio_class\fP" 5
 Set IO priority class (see
 .BR ionice (1)
 manpage).
-.IP -n 5
+.IP "\fB-n \fIioprio_classdata\fP" 5
 Set IO priority classdata (see
 .BR ionice (1)
 manpage).
@@ -411,7 +462,7 @@ If a \fI<device>\fR is given, the corresponding filesystem is found and
 \fBscrub cancel\fP behaves as if it was called on that filesystem.
 .TP
 
-\fBscrub resume\fP [-Bdqru] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
+\fBscrub resume\fP [-BdqrR] [-c ioprio_class -n ioprio_classdata] {\fI<path>\fP|\fI<device>\fP}
 Resume a canceled or interrupted scrub cycle on the filesystem identified by
 \fI<path>\fR or on a given \fI<device>\fR. Does not start a new scrub if the
 last scrub finished successfully.
@@ -431,17 +482,75 @@ for that filesystem or device.
 .RS
 
 \fIOptions\fR
-.IP -d 5
+.IP "\fB-d\fP" 5
 Print separate statistics for each device of the filesystem.
 .RE
 .TP
 
+\fBcheck\fR [\fIoptions\fP] <device>\fR
+Check an unmounted btrfs filesystem.
+.RS
+
+\fIOptions\fR
+.IP "\fB-s|--support \fI<superblock>\fP\fR" 5
+use this superblock copy.
+.IP "\fB--repair\fP" 5
+try to repair the filesystem.
+.IP "\fB--init-csum-tree\fP" 5
+create a new CRC tree.
+.IP "\fB--init-extent-tree\fP" 5
+create a new extent tree.
+.RE
+.TP
+
+\fBchunk-recover\fR [\fIoptions\fP] <device>\fR
+Recover the chunk tree by scanning the devices one by one.
+.RS
+
+\fIOptions\fR
+.IP "\fB-y\fP" 5
+assume an answer of 'yes' to all questions.
+.IP "\fB-v\fP" 5
+verbose mode.
+.IP "\fB-h\fP" 5
+help.
+.RE
+.TP
+
+\fBrestore\fR [\fIoptions\fP] <device>\fR
+Try to restore files from a damaged filesystem(unmounted).
+.RS
+
+\fIOptions\fR
+.IP "\fB-s\fP" 5
+get snapshots.
+.IP "\fB-v\fP" 5
+verbose.
+.IP "\fB-i\fP" 5
+ignore errors.
+.IP "\fB-o\fP" 5
+overwrite.
+.IP "\fB-t \fI<location>\fP\fP" 5
+tree location.
+.IP "\fB-f \fI<offset>\fP\fP" 5
+filesystem location.
+.IP "\fB-u \fI<block>\fP\fP" 5
+super mirror.
+.IP "\fB-r \fI<rootid>\fP\fP" 5
+root objectid.
+.IP "\fB-d\fP" 5
+find dir.
+.IP "\fB-l\fP" 5
+list tree roots.
+.RE
+.TP
+
 \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
 Resolves an <inode> in subvolume <path> to all filesystem paths.
 .RS
 
 \fIOptions\fR
-.IP -v 5
+.IP "\fB-v\fP" 5
 verbose mode. print count of returned paths and ioctl() return value
 .RE
 .TP
@@ -453,42 +562,157 @@ By default, each inode is then resolved to a file system path (similar to the
 .RS
 
 \fIOptions\fR
-.IP -P 5
+.IP "\fB-P\fP" 5
 skip the path resolving and print the inodes instead
-.IP -v 5
+.IP "\fB-v\fP" 5
 verbose mode. print count of returned paths and all ioctl() return values
-.IP -s bufsize 5
+.IP "\fB-s \fI<bufsize>\fP" 5
 set inode container's size. This is used to increase inode container's size in case it is
 not enough to read all the resolved results. The max value one can set is 64k.
 .RE
 .TP
 
-\fBinspect-internal subvolid-resolve\fP \fI<subvolid>\fP \fI<path>\fP
+\fBinspect-internal subvolid-resolve\fP \fI<subvolid> <path>\fP
 Get file system paths for the given subvolume ID.
 .TP
 
-\fBbtrfs qgroup assign\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+\fBsend\fP [-v] [-p \fI<parent>\fP] [-c \fI<clone-src>\fP] [-f \fI<outfile>\fP] \fI<subvol>\fP
+Send the subvolume to stdout.
+Sends the subvolume specified by \fI<subvol>\fR to stdout.
+By default, this will send the whole subvolume. To do an incremental
+send, use '\fI-p <parent>\fR'. If you want to allow btrfs to clone from
+any additional local snapshots, use '\fI-c <clone-src>\fR' (multiple times
+where applicable). You must not specify clone sources unless you
+guarantee that these snapshots are exactly in the same state on both
+sides, the sender and the receiver. It is allowed to omit the
+'\fI-p <parent>\fR' option when '\fI-c <clone-src>\fR' options are given, in
+which case '\fBbtrfs send\fP' will determine a suitable parent among the
+clone sources itself.
+.RS
+
+\fIOptions\fR
+.IP "\fB-v\fP" 5
+Enable verbose debug output. Each occurrence of this option increases the
+verbose level more.
+.IP "\fB-p \fI<parent>\fP" 5
+Send an incremental stream from \fI<parent>\fR to \fI<subvol>\fR.
+.IP "\fB-c \fI<clone-src>\fP" 5
+Use this snapshot as a clone source for an incremental send (multiple allowed).
+.IP "\fB-f \fI<outfile>\fP" 5
+Output is normally written to stdout. To write to a file, use this option.
+An alternative would be to use pipes.
+.RE
+.TP
+
+\fBreceive\fP [-ve] [-f \fI<infile>\fR] \fI<mount>\fR
+Receive subvolumes from stdin.
+Receives one or more subvolumes that were previously
+sent with btrfs send. The received subvolumes are stored
+into \fI<mount>\fP.
+btrfs receive will fail in case a receiving subvolume
+already exists. It will also fail in case a previously
+received subvolume was changed after it was received.
+After receiving a subvolume, it is immediately set to
+read only.
+.RS
+
+\fIOptions\fR
+.IP "\fB-v\fP" 5
+Enable verbose debug output. Each occurrence of this option increases the
+verbose level more.
+.IP "\fB-f \fI<infile>\fR" 5
+By default, btrfs receive uses stdin to receive the subvolumes.
+Use this option to specify a file to use instead.
+.IP "\fB-e\fP" 5
+Terminate after receiving an <end cmd> in the data stream.
+Without this option, the receiver terminates only if an error is recognized or on EOF.
+.RE
+.TP
+
+\fBquota enable\fR \fI<path>\fR
+Enable subvolume quota support for a filesystem.
+.TP
+
+\fBquota disable\fR \fI<path>\fR
+Disable subvolume quota support for a filesystem.
+.TP
+
+\fBquota rescan\fR [-s] \fI<path>\fR
+Trash all qgroup numbers and scan the metadata again with the current config.
+.RS
+
+\fIOptions\fR
+.IP "\fB-s\fP" 5
+show status of a running rescan operation.
+.RE
+.TP
+
+\fBqgroup assign\fP \fI<src> <dst> <path>\fP
 Enable subvolume qgroup support for a filesystem.
 .TP
 
-\fBbtrfs qgroup remove\fP \fI<src>\fP \fI<dst>\fP \fI<path>\fP
+\fBqgroup remove\fP \fI<src> <dst> <path>\fP
 Remove a subvol from a quota group.
 .TP
 
-\fBbtrfs qgroup create\fP \fI<qgroupid>\fP \fI<path>\fP
+\fBqgroup create\fP \fI<qgroupid> <path>\fP
 Create a subvolume quota group.
 .TP
 
-\fBbtrfs qgroup destroy\fP \fI<qgroupid>\fP \fI<path>\fP
+\fBqgroup destroy\fP \fI<qgroupid> <path>\fP
 Destroy a subvolume quota group.
 .TP
 
-\fBbtrfs qgroup show\fP \fI<path>\fP
+\fBqgroup show\fP \fI<path>\fP
 Show all subvolume quota groups.
 .TP
 
-\fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
+\fBqgroup limit\fP [\fIoptions\fP] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
 Limit the size of a subvolume quota group.
+.TP
+
+\fBreplace start\fR [-Bfr] \fI<srcdev>\fP|\fI<devid> <targetdev> <path>\fR
+Replace device of a btrfs filesystem.
+On a live filesystem, duplicate the data to the target device which
+is currently stored on the source device. If the source device is not
+available anymore, or if the \fB-r\fR option is set, the data is built
+only using the RAID redundancy mechanisms. After completion of the
+operation, the source device is removed from the filesystem.
+If the \fI<srcdev>\fR is a numerical value, it is assumed to be the device id
+of the filesystem which is mounted at mount_point, otherwise is is
+the path to the source device. If the source device is disconnected,
+from the system, you have to use the \fIdevid\fR parameter format.
+The \fI<targetdev>\fP needs to be same size or larger than the \fI<srcdev>\fR.
+.RS
+
+\fIOptions\fR
+.IP "\fB-r\fP" 5
+only read from \fI<srcdev>\fR if no other zero-defect mirror exists (enable
+this if your drive has lots of read errors, the access would be very slow)
+.IP "\fB-f\fP" 5
+force using and overwriting \fI<targetdev>\fR even if it looks like
+containing a valid btrfs filesystem. A valid filesystem is
+assumed if a btrfs superblock is found which contains a
+correct checksum. Devices which are currently mounted are
+never allowed to be used as the \fI<targetdev>\fR
+.IP "\fB-B\fP" 5
+do not background
+.RE
+.TP
+
+\fBreplace status\fR [-1] \fI<mount_point>\fR
+Print status and progress information of a running device replace operation.
+.RS
+
+\fIOptions\fR
+.IP "\fB-1\fP" 5
+print once instead of print continuously until the replace
+operation finishes (or is canceled)
+.RE
+.TP
+
+\fBreplace cancel\fR \fI<mount_point>\fR
+Cancel a running device replace operation.
 .RE
 
 .SH EXIT STATUS
-- 
1.8.3.3

