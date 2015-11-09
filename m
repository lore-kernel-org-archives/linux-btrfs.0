Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33951 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbKIJLl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 04:11:41 -0500
Received: by wmnn186 with SMTP id n186so93740694wmn.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 01:11:39 -0800 (PST)
Received: from [192.168.1.70] (238.32.12.93.rev.sfr.net. [93.12.32.238])
        by smtp.gmail.com with ESMTPSA id 20sm13151852wmh.8.2015.11.09.01.11.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2015 01:11:39 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Florian Margaine <florian.margaine@commerceguys.com>
Subject: [PATCH] Fix partitioned loop devices resolve.
Message-ID: <56406349.5020608@commerceguys.com>
Date: Mon, 9 Nov 2015 10:11:37 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uMEqGjts54uV8E8niDvrV898JL0dKqKue"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uMEqGjts54uV8E8niDvrV898JL0dKqKue
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




--uMEqGjts54uV8E8niDvrV898JL0dKqKue
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWQGNJAAoJEIQ/bXU9lJcqpJoIAKSZQlBkRYjNyFiDF+k8WPpC
MApEcwriU/g4KUX5IGnVfh0NsgCyzjqLSvsHiwdL4kBTtghnmgb7MSMGNefOIWX+
jcAP4MwDymlfiE+3Ek5CRozrluTbjLOJrIjWs7KXTmzf/MZWkkY6zseO4vph71Mj
3Wo3Mz44GMk3u4eCRNXrlZVdxp9Z3Uw0tqjq6+ZMKbdyZG2wp1oEFVzZqdLCND+j
w8CJVhPKp+f5uJKDVzo9JA+ek7f3qNezSnXL+iUKMgzQwyfMxiik9ktNDHrAOINy
T603GJFsGGuZdJSXQwL6bJvST1BGuKLZfHAVTNf+cGgUuwbWfrSCh1dq+4Tp55Q=
=zMDU
-----END PGP SIGNATURE-----

--uMEqGjts54uV8E8niDvrV898JL0dKqKue--
