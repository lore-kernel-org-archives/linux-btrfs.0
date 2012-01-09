From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 2/2] btrfs-progs: document --rootdir mkfs switch
Date: Mon,  9 Jan 2012 10:18:56 -0500
Message-ID: <1326122336-23363-2-git-send-email-psusi@cfl.rr.com>
References: <1326122336-23363-1-git-send-email-psusi@cfl.rr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326122336-23363-1-git-send-email-psusi@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 man/mkfs.btrfs.8.in |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 542e6cf..25e817b 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -12,6 +12,7 @@ mkfs.btrfs \- create an btrfs filesystem
 [ \fB\-M\fP\fI mixed data+metadata\fP ]
 [ \fB\-n\fP\fI nodesize\fP ]
 [ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-r\fP\fI rootdir\fP ]
 [ \fB\-h\fP ]
 [ \fB\-V\fP ]
 \fI device\fP [ \fIdevice ...\fP ]
@@ -59,6 +60,9 @@ Specify the nodesize. By default the value is set to the pagesize.
 \fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
 Specify the sectorsize, the minimum block allocation.
 .TP
+\fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
+Specify a directory to copy into the newly created fs.
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
 .SH AVAILABILITY
-- 
1.7.5.4

