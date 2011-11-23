From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 2/2] Document --rootdir mkfs switch
Date: Wed, 23 Nov 2011 16:26:36 -0500
Message-ID: <4ECD650C.1030207@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

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

