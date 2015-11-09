Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34071 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbbKINGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 08:06:32 -0500
Received: by wmnn186 with SMTP id n186so102393501wmn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 05:06:31 -0800 (PST)
Received: from [192.168.1.70] (238.32.12.93.rev.sfr.net. [93.12.32.238])
        by smtp.gmail.com with ESMTPSA id d10sm15364219wje.14.2015.11.09.05.06.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2015 05:06:30 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Florian Margaine <florian.margaine@commerceguys.com>
Subject: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
Message-ID: <56409A52.2000708@commerceguys.com>
Date: Mon, 9 Nov 2015 14:06:26 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HK5amsnKhKURU1S5LO0SWBRWnflKfldsl"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HK5amsnKhKURU1S5LO0SWBRWnflKfldsl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

When using partitions on a loop device, the device's name can be
e.g. /dev/loop0p1 or similar, and no relevant entry exists in the /sys
filesystem, so the current resolve_loop_device function fails.

Instead of using string functions to extract the device name and reading
this file, this patch uses the loop device API through ioctl to get the
correct backing file.

Signed-off-by: Florian Margaine <florian@platform.sh>

---
 utils.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/utils.c b/utils.c
index d546bea..73a05e1 100644
--- a/utils.c
+++ b/utils.c
@@ -1176,22 +1176,16 @@ static int is_loop_device (const char* device) {
 static int resolve_loop_device(const char* loop_dev, char* loop_file,
 		int max_len)
 {
-	int ret;
-	FILE *f;
-	char fmt[20];
-	char p[PATH_MAX];
-	char real_loop_dev[PATH_MAX];
+	int fd;
+	struct loop_info64 lo64;

-	if (!realpath(loop_dev, real_loop_dev))
+	if (!(fd =3D open(loop_dev, O_RDONLY)))
 		return -errno;
-	snprintf(p, PATH_MAX, "/sys/block/%s/loop/backing_file",
strrchr(real_loop_dev, '/'));
-	if (!(f =3D fopen(p, "r")))
+	if (ioctl(fd, LOOP_GET_STATUS64, &lo64) !=3D 0)
 		return -errno;

-	snprintf(fmt, 20, "%%%i[^\n]", max_len-1);
-	ret =3D fscanf(f, fmt, loop_file);
-	fclose(f);
-	if (ret =3D=3D EOF)
+	memcpy(loop_file, lo64.lo_file_name, strlen(lo64.lo_file_name) + 1);
+	if (close(fd) !=3D 0)
 		return -errno;

 	return 0;
--=20
2.6.1


--HK5amsnKhKURU1S5LO0SWBRWnflKfldsl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWQJpSAAoJEIQ/bXU9lJcqzn4H/3+yI1IITnGIx/K+joPX1dit
O+b7fxGFPYutI/D5y7dfvrwgqgBv4NSEWA7cXwWtnMf/j9ANKPlCjUqnkR+cNQ46
Pupw8TbOsdQJrfp/pqVjzv5VtRU2firYrCnBkHR4KMfvr/QOa7uIk8+CdcV00GoN
Yqbjn1EA6fqp/Z0ZbVHVBI1Ooq+4BwFfPm/w6UpTDq62MCebalNU8b0PBwkC6FE2
IAM9aumJujOr4BnMo6glXq4Tuie2oXmxpsktOIIUhRoaMb+aUTRR+4MVJfBDzfDj
x08bPm8uJILjneaigf4hKvTC+YY4JCU0s49gnwqoHMLKiuvuI0ut6qecLfmSkgc=
=Bmp7
-----END PGP SIGNATURE-----

--HK5amsnKhKURU1S5LO0SWBRWnflKfldsl--
