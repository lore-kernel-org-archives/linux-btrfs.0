From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: Misc fix for btrfs man page
Date: Thu, 27 Oct 2011 13:40:51 +0900
Message-ID: <4EA8E0D3.1040502@jp.fujitsu.com>
References: <4EA8DFF5.1060400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA8DFF5.1060400@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Remove duplicated entry for filesystem defrag, finish renaming
device show to filesystem show, fix some minor misdescriptions
and fix some format tokens.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 man/btrfs.8.in |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 24bd933..e40de6f 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -21,17 +21,15 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
+\fBbtrfs\fP \fBfilesystem defragment\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fP
-.PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device>...]\fP
 .PP
-\fBbtrfs\fP \fBdevice show\fP\fI [<device>|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [<device>|<uuid>|<label>]\fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
@@ -71,7 +69,7 @@ and as
 .I filesystem sync.
 In this case
 .I btrfs
-returnsfilesystem sync
+returns an error.
 If a command is terminated by
 .I --help
 , the detailed help is showed. If the passed command matches more commands,
@@ -120,7 +118,7 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
+\fBfilesystem defragment\fP [-vf] [-c[zlib|lzo]] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
 Defragment file data and/or directory metadata. To defragment all files in a
 directory you have to specify each one on its own or use your shell wildcards.
@@ -141,9 +139,11 @@ The start position and the number of bytes to deframention can be specified by \
 
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
 use it if you use snapshots, have de-duplicated your data or made copies with 
-\fBcp --reflink\fP.
+\fBcp --reflink\fR.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
-List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
+List the recently modified files in a \fI<subvolume>\fR, after \fI<last_gen>\fR ID.
 .TP
 
 \fBdevice scan\fR \fI[<device>...]\fR
@@ -178,7 +178,7 @@ can expand the partition before enlarging the filesystem and shrink the
 partition after reducing the size of the filesystem.
 .TP
 
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBfilesystem label\fP\fI <dev> [newlabel]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
 filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
@@ -195,7 +195,7 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [<device>|<uuid>|<label>]\fR
+\fBfilesystem show\fR\fI [<device>|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no argument is
 passed, \fBbtrfs\fR shows info of all the btrfs filesystems.
 .TP
@@ -211,7 +211,7 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 
 \fBdevice delete\fR\fI <device> [<device>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
-.PP
+.TP
 
 \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
 Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
-- 
1.7.6.4


