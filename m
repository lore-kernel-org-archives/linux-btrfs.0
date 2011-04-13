From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 5/5] Updated documentation for btrfs subvolume snapshot.
Date: Wed, 13 Apr 2011 11:12:14 +0200
Message-ID: <1302685934-15737-6-git-send-email-philipp.andreas@gmail.com>
References: <1302685934-15737-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>, lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302685934-15737-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 man/btrfs.8.in |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..b59bc6f 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -5,7 +5,7 @@
 .SH NAME
 btrfs \- control a btrfs filesystem
 .SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI <source> [<dest>/]<name>\fP
+\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume>\fP
 .PP
@@ -70,10 +70,11 @@ command.
 .SH COMMANDS
 .TP
 
-\fBsubvolume snapshot\fR\fI <source> [<dest>/]<name>\fR
-Create a writable snapshot of the subvolume \fI<source>\fR with the name
-\fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
+\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
+Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
+name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
+subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
+will be readonly.
 .TP
 
 \fBsubvolume delete\fR\fI <subvolume>\fR
-- 
1.7.4.1

