From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/2][BTRFS-PROGS] add the "--force" switch to the mkfs.btrfs command
Date: Tue, 18 Oct 2011 18:45:22 +0200
Message-ID: <12563918.0zZUdZd8Dg@venice>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4189592.Vv4KKB2IH3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4189592.Vv4KKB2IH3
Content-Type: multipart/mixed; boundary="nextPart1373486.OA7rgBfZJP"
Content-Transfer-Encoding: 7Bit


--nextPart1373486.OA7rgBfZJP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This patch update the man page

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1373486.OA7rgBfZJP
Content-Disposition: inline; filename="0002-mkfs.btrfs-man-page-document-the-force-option.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-mkfs.btrfs-man-page-document-the-force-option.patch"

>From 82c11672909e5cc784d08d9361c69f0efb122ef1 Mon Sep 17 00:00:00 2001
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Mon, 3 Jan 2011 19:53:05 +0100
Subject: [PATCH 2/2] mkfs.btrfs man page: document the --force option.

Add the --force option to not check if a device is already mounted.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/mkfs.btrfs.8.in |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 432db1b..2610e9d 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -6,6 +6,7 @@ mkfs.btrfs \- create an btrfs filesystem
 [ \fB\-A\fP\fI alloc-start\fP ]
 [ \fB\-b\fP\fI byte-count\fP ]
 [ \fB \-d\fP\fI data-profile\fP ]
+[ \fB \-f\fP ]
 [ \fB \-l\fP\fI leafsize\fP ]
 [ \fB \-L\fP\fI label\fP ]
 [ \fB \-m\fP\fI metadata profile\fP ]
@@ -35,6 +36,9 @@ mkfs.btrfs uses all the available storage for the filesystem.
 Specify how the data must be spanned across the devices specified. Valid
 values are raid0, raid1, raid10 or single.
 .TP
+\fB\-f\fR, \fB\-\-force \fR
+Don't check if the device is already mounted.
+.TP
 \fB\-l\fR, \fB\-\-leafsize \fIsize\fR
 Specify the leaf size, the least data item in which btrfs stores data. The
 default value is the page size.
-- 
1.7.7


--nextPart1373486.OA7rgBfZJP--

--nextPart4189592.Vv4KKB2IH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOna0ivwTxYT3FBRIRAhr9AJ9CDgMz1/HE8EF7MGEfYSRO/gIqGwCcCeNJ
rm1nzqeaeEd8ix1b9/5EWgU=
=zcil
-----END PGP SIGNATURE-----

--nextPart4189592.Vv4KKB2IH3--

