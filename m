From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v3 5/5] btrfs-progs: scrub added to manpage
Date: Mon, 18 Jul 2011 14:37:25 +0200
Message-ID: <f65da9ed89733c87a61af063fa798c9c6e525450.1310990184.git.list.btrfs@jan-o-sch.net>
References: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1310990184.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 man/btrfs.8.in |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index e1a6ad9..84a60cd 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -41,7 +41,15 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
-\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP]
+\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
+.PP
+\fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
 .PP
@@ -225,6 +233,60 @@ Finally, if \fB--all-devices\fP is passed, all the devices under /dev are
 scanned.
 .TP
 
+\fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
+a single \fI<device>\fR. Without options, scrub is started as a background
+process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
+involves reading all data from all disks and verifying checksums. Errors are
+corrected along the way if possible.
+.RS
+
+\fIOptions\fR
+.IP -B 5
+Do not background and print scrub statistics when finished.
+.IP -d 5
+Print separate statistics for each device of the filesystem (-B only).
+.IP -q 5
+Quiet. Omit error messages and statistics.
+.IP -r 5
+Read only mode. Do not attempt to correct anything.
+.IP -u 5
+Scrub unused space as well. (NOT IMPLEMENTED)
+.RE
+.TP
+
+\fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
+If a scrub is running on the filesystem identified by \fI<path>\fR, cancel it.
+Progress is saved in the scrub progress file and scrubbing can be resumed later
+using the \fBscrub resume\fR command.
+If a \fI<device>\fR is given, the corresponding filesystem is found and
+\fBscrub cancel\fP behaves as if it was called on that filesystem.
+.TP
+
+\fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+Resume a canceled or interrupted scrub cycle on the filesystem identified by
+\fI<path>\fR or on a given \fI<device>\fR. Does not start a new scrub if the
+last scrub finished successfully.
+.RS
+
+\fIOptions\fR
+.TP
+see \fBscrub start\fP.
+.RE
+.TP
+
+\fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
+Show status of a running scrub for the filesystem identified by \fI<path>\fR or
+for the specified \fI<device>\fR.
+If no scrub is running, show statistics of the last finished or canceled scrub
+for that filesystem or device.
+.RS
+
+\fIOptions\fR
+.IP -d 5
+Print separate statistics for each device of the filesystem.
+.RE
+
 .PP
 
 \fBbalance progress\fP [\fB-m\fP|\fB--monitor\fP] \fI<path>\fP
-- 
1.7.3.4

