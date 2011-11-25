From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 2/2] Document --rootdir mkfs switch
Date: Fri, 25 Nov 2011 12:37:27 -0500
Message-ID: <4ECFD257.6020000@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The --rootdir switch was not documented in the man page

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
- ---
 man/mkfs.btrfs.8.in |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 542e6cf..25e817b 100644
- --- a/man/mkfs.btrfs.8.in
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
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7P0lcACgkQJ4UciIs+XuKpMQCffecm37bfSbb8vqJe5hzmeuvU
n08AoJvHiTcO9k8M0g9k4TC7iGgaLZlN
=yE4p
-----END PGP SIGNATURE-----
