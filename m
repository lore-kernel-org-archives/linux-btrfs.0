From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v2 5/5] scrub added to manpage
Date: Wed, 30 Mar 2011 18:53:13 +0200
Message-ID: <e67447c14a200344d9e1d4785dfa28362b323bc9.1301503683.git.list.btrfs@jan-o-sch.net>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 man/btrfs.8.in |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..35aa44c 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -29,7 +29,15 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP
-\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
+\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP
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
@@ -154,6 +162,62 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 
 \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
+.TP
+
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
 
 .SH EXIT STATUS
-- 
1.7.3.4

