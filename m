Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56279 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2LKLRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 06:17:04 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2810129pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 03:17:04 -0800 (PST)
Message-ID: <50C71625.1010003@codesrc.com>
Date: Tue, 11 Dec 2012 21:16:53 +1000
From: Michael McMaster <michael@codesrc.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Patch for resolving loop devices
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig9AD61485B42339BD31588560"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9AD61485B42339BD31588560
Content-Type: multipart/mixed;
 boundary="------------040002000606040303010508"

This is a multi-part message in MIME format.
--------------040002000606040303010508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I experienced an error where mkfs.btrfs failed when an unrelated
cryptoloop device was mounted.

$ sudo /tmp/btrfs-progs/mkfs.btrfs  /dev/mapper/mydisk

WARNING! - Btrfs v0.20-rc1-37-g91d9eec-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

error checking /dev/mapper/mydisk mount status

$ sudo losetup -a
/dev/loop0: [0014]:71314 (/home/michael/loopfile), encryption aes (type 1=
8)

I found that resolve_loop_device() method in utils.c was returning "aes"
as the associated file, instead of /home/michael/loopfile.  This
eventually causes the realpath() call in is_same_blk_file() to fail. The
attached patch fixes this problem.

Regards,
Michael McMaster



--------------040002000606040303010508
Content-Type: text/x-patch;
 name="utils.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="utils.c.patch"

--- utils.c.orig	2012-12-11 21:00:07.000000000 +1000
+++ utils.c	2012-12-11 21:00:26.000000000 +1000
@@ -653,16 +653,16 @@
 {
 	int loop_fd;
 	int ret_ioctl;
-	struct loop_info loopinfo;
+	struct loop_info64 loopinfo;
=20
 	if ((loop_fd =3D open(loop_dev, O_RDONLY)) < 0)
 		return -errno;
=20
-	ret_ioctl =3D ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
+	ret_ioctl =3D ioctl(loop_fd, LOOP_GET_STATUS64, &loopinfo);
 	close(loop_fd);
=20
 	if (ret_ioctl =3D=3D 0) {
-		strncpy(loop_file, loopinfo.lo_name, max_len);
+		strncpy(loop_file, loopinfo.lo_file_name, max_len);
 		if (max_len > 0)
 			loop_file[max_len-1] =3D 0;
 	} else

--------------040002000606040303010508--

--------------enig9AD61485B42339BD31588560
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCAAGBQJQxxYqAAoJEGR9aq/UZ4isbocP/2JmWxvRWB8hRyoh0OqD93Yo
Fzlx6YhgyMhS1XRlzdnsDvhtr8RX3DgBxk6g0E6sGEwGWVyFzpli1UYsAugA1AuQ
PNYRFHhX8LZmk12VwqE/Z/q1T8r4lTDcHSpJkOgVd8bd4B0UtQAqAAv9+Ub1P17t
Xepr1QNiH2f+KolTfU/b7qLLRSfJ50tFC7gBiN2ndDcNhCzCUf5bi163QUFmNybz
H+R4H7WHt4j7O/TMEO0H17i8P+axRUPi9QhoKtVD+71mpBbTAK5Xn0EPoYRi6QLM
5b9qaFzGJVOUozwUVgrpkzEP7E7WICV1AMuOQEDhrvj1eCECg/0prBvdjVbwxMFP
qGZ+hqyAKinFKVcU3VtDY+BXIrEEEDZELAPG5t9UccZu5aho3iJBsqqfgIc/E2VI
S6fJxKy9nry0iCMInTgvsFWEJuUMomuaakxLr4tlqYzVJfwOp23hNnqLmZ1uQjzH
q7DkCecA7tKoyenGblumJwoilkZSklpYIIQvlbJZCuesee1qc9cH++7+xeIJ2M8d
f73zyzlKqzGts1g35A3ipLeiLYFqwGIVfNuoRKml/w0cmkkYbbtdHk3b56IsJASh
FBf/svWrMTwnJ7GF/CTMIds7s5yhH2Gvk5o/BTUlznCuoDDOTl3NLWNxN+M6N6aN
daLvntghYC07bhkwNEJa
=Gkcn
-----END PGP SIGNATURE-----

--------------enig9AD61485B42339BD31588560--
