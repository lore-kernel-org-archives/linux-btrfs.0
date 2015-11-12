Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36235 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbbKLJKx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 04:10:53 -0500
Received: by wmww144 with SMTP id w144so191417049wmw.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 01:10:52 -0800 (PST)
Subject: Re: [PATCH] btrfs-progs: Fix partitioned loop devices resolve.
To: Karel Zak <kzak@redhat.com>
References: <56409A52.2000708@commerceguys.com>
 <20151109141256.GW19508@ws.net.home> <5641AC4A.2090703@commerceguys.com>
 <20151110115018.GY19508@ws.net.home>
Cc: linux-btrfs@vger.kernel.org
From: Florian Margaine <florian.margaine@commerceguys.com>
Message-ID: <5644579B.3000102@commerceguys.com>
Date: Thu, 12 Nov 2015 10:10:51 +0100
MIME-Version: 1.0
In-Reply-To: <20151110115018.GY19508@ws.net.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dac9PmgjOANcjNH6LC0c9Mr3OPxc6Si2h"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dac9PmgjOANcjNH6LC0c9Mr3OPxc6Si2h
Content-Type: multipart/mixed;
 boundary="------------040202020704060508060104"

This is a multi-part message in MIME format.
--------------040202020704060508060104
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

New patch is attached.

On 11/10/2015 12:50 PM, Karel Zak wrote:
>=20
> Yep, first try /sys/... and when unsuccessful then try ioctl.
>=20
> losetup example:
> https://github.com/karelzak/util-linux/blob/master/lib/loopdev.c#L686
>=20
> (it's probably too complex, but the basic idea is obvious)
>=20
> Maybe we need libloop.so to share all these things between various
> project :-)

That would be lovely indeed.

>=20
>     Karel
>=20

Regards,

--=20
Florian Margaine

Product Engineer @ Platform.sh
https://platform.sh

https://keybase.io/fmargaine

--------------040202020704060508060104
Content-Type: text/x-patch;
 name="fix-partitioned-loop-devices-resolve.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="fix-partitioned-loop-devices-resolve.patch"

When using partitions on a loop device, the device's name can be
/dev/loop0p1 or similar, and no relevant entry exists in the /sys
filesystem, so the current resolve_loop_device function fails.

This patch adds a fallback to using loopdev API which will get the
correct backing file even for partitioned loop devices, at the expense
of using more memory, hence using it as a fallback only.
---
 utils.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index d546bea..5e4813d 100644
--- a/utils.c
+++ b/utils.c
@@ -1170,2 +1170,2 @@ static int is_loop_device (const char* device) {
 		MAJOR(statbuf.st_rdev) =3D=3D LOOP_MAJOR);
 }

+/*
+ * Takes a loop device path (e.g. /dev/loop0) and returns
+ * the associated file (e.g. /images/my_btrfs.img) using
+ * loopdev API
+ */
+static int resolve_loop_device_with_loopdev(const char* loop_dev, char* =
loop_file)
+{
+	int fd;
+	struct loop_info64 lo64;
+
+	if (!(fd =3D open(loop_dev, O_RDONLY | O_NONBLOCK)))
+		return -errno;
+	if (ioctl(fd, LOOP_GET_STATUS64, &lo64) !=3D 0)
+		return -errno;
+
+	memcpy(loop_file, lo64.lo_file_name, strlen(lo64.lo_file_name) + 1);
+	if (close(fd) !=3D 0)
+		return -errno;
+
+	return 0;
+}

 /* Takes a loop device path (e.g. /dev/loop0) and returns
  * the associated file (e.g. /images/my_btrfs.img) */
@@ -1185,5 +1206,10 @@ static int resolve_loop_device(const char* loop_de=
v, char* loop_file,
 	if (!realpath(loop_dev, real_loop_dev))
 		return -errno;
 	snprintf(p, PATH_MAX, "/sys/block/%s/loop/backing_file", strrchr(real_l=
oop_dev, '/'));
-	if (!(f =3D fopen(p, "r")))
+	if (!(f =3D fopen(p, "r"))) {
+		if (errno =3D=3D ENOENT)
+			/* It's possibly a partitioned loop device, which
+			   is resolvable with loopdev API. */
+			return resolve_loop_device_with_loopdev(loop_dev, loop_file);
 		return -errno;
+	}

 	snprintf(fmt, 20, "%%%i[^\n]", max_len-1);
 	ret =3D fscanf(f, fmt, loop_file);
--
2.6.1

--------------040202020704060508060104--

--dac9PmgjOANcjNH6LC0c9Mr3OPxc6Si2h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWRFebAAoJEIQ/bXU9lJcq6EsH/02mG2Ek4o0+vUn9SxrqexXV
q8xE0nAXo7bb3bLTZiuw4oGNZZYUMgVAulNjxfGjlJzqwwfcbcHDd9FbJGc5ZBf5
A/7Y2OfK7ooRCjt4i/KgDNJn3M/1fOyxDA7QjGvcutiXIE8pN3q9IJv18PtKynjd
JRUgTngVuCQeObTtwgDBMkGR8eJoCmA9R4iNHNa1BMNVLGJ7k4LgtbhkE4iLHSbd
uEM2saIbMy3h/0GAaF+TB6tFCne5MY8JXIYHYCkO1F3uKm57AUm3JZkGzaQgnfKu
UpKZn3lKFcvxbJOZXxCKocpTY6vkLxQmH1PS2vU32RsoGirSbacXBF4151b1QiY=
=7Fuy
-----END PGP SIGNATURE-----

--dac9PmgjOANcjNH6LC0c9Mr3OPxc6Si2h--
