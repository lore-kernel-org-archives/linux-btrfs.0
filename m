From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: Sort commands/descriptions in btrfs man
 page
Date: Thu, 27 Oct 2011 13:41:54 +0900
Message-ID: <4EA8E112.8070903@jp.fujitsu.com>
References: <4EA8DFF5.1060400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA8DFF5.1060400@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sort items in man page, to put together items in the same group,
and to put sequences of SYSNOPSIS and COMMANDS in same order.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 man/btrfs.8.in |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index e40de6f..0cb51ca 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,22 +15,22 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem defragment\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem defragment\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
-.PP
-\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [<device>|<uuid>|<label>]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [<device>...]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [<device>|<uuid>|<label>]\fP
-.PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
@@ -118,6 +118,10 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
+List the recently modified files in a \fI<subvolume>\fR, after \fI<last_gen>\fR ID.
+.TP
+
 \fBfilesystem defragment\fP [-vf] [-c[zlib|lzo]] [-l \fIlen\fR] [-s \fIstart\fR] [-t \fIsize\fR] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
 Defragment file data and/or directory metadata. To defragment all files in a
@@ -142,15 +146,6 @@ use it if you use snapshots, have de-duplicated your data or made copies with
 \fBcp --reflink\fR.
 .TP
 
-\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
-List the recently modified files in a \fI<subvolume>\fR, after \fI<last_gen>\fR ID.
-.TP
-
-\fBdevice scan\fR \fI[<device>...]\fR
-Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR scans
-all the block devices.
-.TP
-
 \fBfilesystem sync\fR\fI <path> \fR
 Force a sync for the filesystem identified by \fI<path>\fR.
 .TP
@@ -205,6 +200,11 @@ Balance the chunks of the filesystem identified by \fI<path>\fR
 across the devices.
 .TP
 
+\fBdevice scan\fR \fI[<device>...]\fR
+Scan devices for a btrfs filesystem. If no devices are passed, \fBbtrfs\fR scans
+all the block devices.
+.TP
+
 \fBdevice add\fR\fI <device> [<device>..] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
-- 
1.7.6.4


