From: Phillip Susi <psusi@cfl.rr.com>
Subject: [btrfs-progs PATCH 1/2] Removed extraneous whitespace from mkfs man
 page
Date: Fri, 25 Nov 2011 12:36:26 -0500
Message-ID: <4ECFD21A.4050203@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

There were extra spaces around some of the arguments in the man
page for mkfs.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
- ---
 man/mkfs.btrfs.8.in |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 432db1b..542e6cf 100644
- --- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -5,15 +5,16 @@ mkfs.btrfs \- create an btrfs filesystem
 .B mkfs.btrfs
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
- -[ \fB \-d\fP\fI data-profile\fP ]
- -[ \fB \-l\fP\fI leafsize\fP ]
- -[ \fB \-L\fP\fI label\fP ]
- -[ \fB \-m\fP\fI metadata profile\fP ]
- -[ \fB \-M\fP\fI mixed data+metadata\fP ]
- -[ \fB \-n\fP\fI nodesize\fP ]
- -[ \fB \-s\fP\fI sectorsize\fP ]
- -[ \fB \-h\fP ]
- -[ \fB \-V\fP ] \fI device\fP [ \fI device ...\fP ]
+[ \fB\-d\fP\fI data-profile\fP ]
+[ \fB\-l\fP\fI leafsize\fP ]
+[ \fB\-L\fP\fI label\fP ]
+[ \fB\-m\fP\fI metadata profile\fP ]
+[ \fB\-M\fP\fI mixed data+metadata\fP ]
+[ \fB\-n\fP\fI nodesize\fP ]
+[ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-h\fP ]
+[ \fB\-V\fP ]
+\fI device\fP [ \fIdevice ...\fP ]
 .SH DESCRIPTION
 .B mkfs.btrfs
 is used to create an btrfs filesystem (usually in a disk partition, or an array
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7P0hUACgkQJ4UciIs+XuK6lgCcDVJyqpPS1tkZrFHO7gSwanZY
P+4An231BTNvoFgIIf52NOs1t/SjFTt5
=tSkT
-----END PGP SIGNATURE-----
