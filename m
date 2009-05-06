From: Michael Raskin <7c6f434c@mail.ru>
Subject: [MISFEATURE] Size reporting on small devices
Date: Wed, 06 May 2009 20:53:29 +0400
Message-ID: <4A01C089.2080201@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

		Hello
	During testing, I tried to create small BtrFS images (256M, 1G) and
just fill them up with large (100M) files. During these tests df -h
showed 130M at the time BtrFS reported "disk is full".

/dev/loop2            1.0G  895M  130M  88% /root/mnt/loop

One-byte files (80K+) allow to reproduce

/dev/loop2            1.0G   49M  976M   5% /root/mnt/loop

(and disk-full behavior) with Kernel BUG in
__btrfs_reserve_extent+0x351/0x35f , but that seems to be well-known.
Maybe df -i could be useful until metadata/data split is flexible? Is
there any way to inspect the metadata filling up and change the split?

Michael Raskin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJKAcCIAAoJEE6tnN0aWvw3VooH/RLHZrjk4DAsAWOt/H/3OvUb
+HPPpkbCjTwPwpBd+ckRe0abKpwhcisJJg9BSpF/Co3kRlwSKkwj+K0gIUJtOwj8
R1AejEP++cW90l6GgeJGdA8sdGVSY4QBIjqdPYeDNn/GitrTOe/E8H2d+54JmDwm
v3664219SXmJas/jbKPBXi3DXNVc5Y9ZIWwp4RruOGJvS+NHUXRMVIjMMrsaqUZQ
g4qnXYFJeIePGErHlUcVYYwHWee9Xlv1EqV6u4M5UaLXcyZqW8+VIm+02amypcsp
otLsrLMCxedX90M/FlgbkECgWe6ttBYhTwRuAaSszuO+ip4/NfFOayGU4kJWzfc=
=UFlT
-----END PGP SIGNATURE-----
