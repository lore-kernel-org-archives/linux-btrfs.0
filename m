Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33862 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935174AbeBMNZ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 08:25:56 -0500
Received: by mail-pg0-f53.google.com with SMTP id m19so4855400pgn.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 05:25:56 -0800 (PST)
Received: from drobertson-crashbox.lab.tripwire.com ([209.194.39.10])
        by smtp.gmail.com with ESMTPSA id f12sm29291871pga.67.2018.02.13.05.25.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Feb 2018 05:25:54 -0800 (PST)
Date: Tue, 13 Feb 2018 13:25:10 +0000
From: Dan Robertson <danlrobertson89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-progs: compile with musl libc
Message-ID: <20180213132509.GA16525@drobertson-crashbox.lab.tripwire.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kXdP64Ggrk/fb43R
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Ensure that limits.h is included in mkfs/main.c as PATH_MAX is used. The lack
of this currently causes btrfs-progs to fail to compile when the systems libc
is musl.

--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-progs-compile-with-musl-libc.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 7859e0d01778e844ae0fcbefe55581277ce7cab3 Mon Sep 17 00:00:00 2001
=46rom: Dan Robertson <danlrobertson89@gmail.com>
Date: Tue, 13 Feb 2018 13:04:29 +0000
Subject: [PATCH] btrfs-progs: compile with musl libc

Ensure that limits.h is included in mkfs/main.c as PATH_MAX is used.

Signed-off-by: Dan Robertson <danlrobertson89@gmail.com>
---
 mkfs/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index ea65c6d8..f44520aa 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -27,6 +27,7 @@
 /* #include <sys/dir.h> included via androidcompat.h */
 #include <fcntl.h>
 #include <unistd.h>
+#include <limits.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
 #include <ctype.h>
--=20
2.16.1


--u3/rZRmxL6MmkK24--

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE/rsbXA6uV265z+m9Btkjh+bF0AgFAlqC5zUACgkQBtkjh+bF
0Ajvlg//exbNRljHokqG0ewYaosvKYuqmSQbPckEvIShAK9JcBwVgbM61ofgLO5W
yVeU4TckiW/HLktNj6iPR1igYbopc67d0yBHY6vbiT9OAFfVDwKLuPRdBmTvMgMT
JEyg0Svo9kH6oKdiZnGVwdtvFtRYKw0WZRvqU/uGwKkLaBU7LyyjOeTfrowcfLdw
KfMG8D4GPKNj9yjeL4fch/6dWXFoso/OgBz1hXQoiK/PoPi7LJVSno73MwMH5kmA
Myb7/rBtId8O+hSE/yuZ9JFSqOMwc+z6FTTR1kIa6heDFn4ie3/Sq2j0SROByzGw
uNDKLlpgi/97uD9FijqXX701StxkWvnmbdUDYqpsfnXJeByQm6Z4aNDIjAmKLYI1
QVmoXG88rX4HNZ2bCzDYrjQRq09Hw0qd5uFHCB9HfGidtquZsW5h4ZF4lDtpwAbo
dqOxaO84HWtqpUJ/rzVKdtyPxin2gkdvSj++fOBJpL/60uoIMUV79jc+t5SzOmdp
KiC12mB9Xgl16sulmPwiMN6z5ID+bYspXU7aivJbhruPg2t3W/FyGy92Xwe60DI2
kct3WUSdQkGa5Sdno9wKyGjaJlTifrKk8Nw8HvSeEjzsZnKuDJAESVsXPR43C+dV
dlPL78TgAWgih1WEJil/UeviGJjbLGYaNLeXfMq6M5C0uffI/Tk=
=GbcP
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
