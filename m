From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH] Btrfs-progs: Fix manual of btrfs command
Date: Fri, 16 Dec 2011 17:46:48 +0900
Message-ID: <4EEB0578.6000709@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Usage of balancing btrfs is "btrfs filesystem balance",
not "btrfs device balance". And remove unneeded
usage of "btrfs filesystem defrag".
Also fix some typos and over 80 columns.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 man/btrfs.8.in |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)
diff --git a/man/btrfs.8.in b/man/btrfs.8.in

index be478e0..2f36f2a 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,20 +17,20 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
+[-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
+[<\fIfile\fR>|<\fIdir\fR>...]
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
-.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fP
-.PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
@@ -78,7 +78,7 @@ and as
 .I filesystem sync.
 In this case
 .I btrfs
-returnsfilesystem sync
+returns filesystem sync
 If a command is terminated by
 .I --help
 , the detailed help is showed. If the passed command matches more commands,
@@ -132,12 +132,17 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
+\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
+[-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
 
-The start position and the number of bytes to deframention can be specified by \fIstart\fR and \fIlen\fR. Any extent bigger than \fIthresh\fR will be considered already defragged. Use 0 to take the kernel default, and use 1 to say eveery single extent must be rewritten. You can also turn on compression in defragment operations.
+The start position and the number of bytes to defragment can be specified by 
+\fIstart\fR and \fIlen\fR. Any extent bigger than threshold will be 
+considered already defragged. Use 0 to take the kernel default, and use 1 to 
+say every single extent must be rewritten. You can also turn on compression in 
+defragment operations.
 
 \fB-v\fP be verbose
 
@@ -151,9 +156,11 @@ The start position and the number of bytes to deframention can be specified by \
 
 \fB-t size\fP defragment only files at least \fIsize\fR bytes big
 
-NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
-use it if you use snapshots, have de-duplicated your data or made copies with 
-\fBcp --reflink\fP.
+NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
+don't use it if you use snapshots, have de-duplicated your data or made 
+copies with \fBcp --reflink\fP.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
@@ -185,13 +192,13 @@ can expand the partition before enlarging the filesystem and shrink the
 partition after reducing the size of the filesystem.
 .TP
 
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBfilesystem label\fP\fI <dev> [newlabel]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
 filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
-following costraints exist for a label:
+following constraints exist for a label:
 .IP
-- the maximum allowable lenght shall be less or equal than 256 chars
+- the maximum allowable length shall be less or equal than 256 chars
 .IP
 - the label shall not  contain the '/' or '\\' characters.
 
@@ -209,7 +216,7 @@ If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
-\fBdevice balance\fR \fI<path>\fR
+\fBfilesystem balance\fR \fI<path>\fR
 Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
