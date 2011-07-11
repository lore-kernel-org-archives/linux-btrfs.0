From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 3/3] Btrfs-progs: added resolve commands to man page
Date: Mon, 11 Jul 2011 19:47:59 +0200
Message-ID: <22b0bf83ce98afebee9aa9b12eeac0ff3eb5e4f2.1310405883.git.list.btrfs@jan-o-sch.net>
References: <cover.1310405883.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310405883.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310405883.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Added "inspect-internal inode-resolve" and "inspect-internal
logical-resolve" to the btrfs(8) man page.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 man/btrfs.8.in |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 84a60cd..6e0568b 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -51,6 +51,11 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
 .PP
+\fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBinspect-internal logical-resolve\fP
+[-Pv] \fI<logical>\fP \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
 .PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
@@ -286,6 +291,30 @@ for that filesystem or device.
 .IP -d 5
 Print separate statistics for each device of the filesystem.
 .RE
+.TP
+
+\fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
+Resolves an <inode> in subvolume <path> to all filesystem paths.
+.RS
+
+\fIOptions\fR
+.IP -v 5
+verbose mode. print count of returned paths and ioctl() return value
+.RE
+.TP
+
+\fBinspect-internal logical-resolve\fP [-Pv] \fI<logical>\fP \fI<path>\fP
+Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
+By default, each inode is then resolved to a file system path (similar to the
+\fBinode-resolve\fP subcommand).
+.RS
+
+\fIOptions\fR
+.IP -P 5
+skip the path resolving and print the inodes instead
+.IP -v 5
+verbose mode. print count of returned paths and all ioctl() return values
+.RE
 
 .PP
 
-- 
1.7.3.4

