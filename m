From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: btrfs: could not do orphan cleanup -116
Date: Mon, 07 Nov 2011 13:17:04 +0000
Message-ID: <1320671824.2445.8.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-osoUawfOTqh0p7wy4+Vq"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-osoUawfOTqh0p7wy4+Vq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

When I booted my machine (after clean powerdown) the following message
appeared:
[   32.757913] device fsid XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX devid 1
transid 40864 /dev/mapper/XXXXX-XXXXX
[   32.758466] btrfs: use lzo compression
[   32.758475] btrfs: enabling disk space caching
[   32.758483] btrfs: enabling inode map caching
[   32.758490] btrfs: enabling auto defrag
[   32.758497] btrfs: thread pool 2
[   34.024359] btrfs: could not do orphan cleanup -116
[   63.173382] btrfs: open_ctree failed

btrfsck has shown no errors.

Afterwards when I tried to mount filesystem it have shown:

[  116.012528] btrfs: enabling inode map caching
[  116.012534] btrfs: enabling auto defrag
[  116.012542] btrfs: thread pool 2

It looked like everything is working but to be sure I've run scrub:

scrub status for fsid XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
        scrub started at Mon Nov  7 13:05:50 2011 and finished after 606
seconds
        total bytes scrubbed: 32.37GB with 0 errors

PS.=20
# find include | xargs grep 116
(...)
include/asm-generic/errno.h:#define     ESTALE          116     /* Stale
NFS file handle */
(...)

I don't use NFS - I use LVM on LUKS. In any case - it have been done
concurrently with mounting of other fs which had no such problems.

--=-osoUawfOTqh0p7wy4+Vq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOt9pUAAoJEJIdee2Vr4aPCBgQAM59sfqDDW/TcyKcPJGzwgv5
/dZOXGrnODt6A0RHfCpima1CmRFovZKNgLbFIRyZiC8aH+t31GCE2AL1Gt1pVBnF
KNHxT5g9izzP08lE33jhzViVQCLbamfDrwsul/RuUZzZ5xJfD59R3TUaBY2dgb07
9ngGrrqRy4G8k+1yUplByNQJKBfFYODzbe8rJlFMdwOl90lo9MN8dj5wn6jF8RUC
kZap7a3y5doBwZ8dG1PHV/DJohOrpNOXrOVtNWPA04guIRe1dw0FKl9Gs50Be6mG
t3Y8EINQJflSzLDzchO9fk8rYDF4z0x/K2VFWVvPb6XAUgGxJP+YiFCdbtMSAS1o
/iq9xVbZhSYdnN97Us3B16v2HH6Me4OFLEZGImqgt0cAQGC54fC5nRajkyakosa8
hgz57nrJxzdrIvW/OPHxNE+jq6PRXKveEMwLqhM62qFqRQtc8twpaj6gERJ4N5G9
YF5s21GUD5h/g6GJiEED5ZovJ8qnDXlb8YsBaFX++pWIF9GdWxWRPNsYC+zdnFa6
ADbGtpVS52yGsquoiFcqlfxhdB+9sAtiMS7FJzddVx3c5uXeW5dj+fjO2KGRpCYr
3TYXu0gj7U/gRqjlc+XANpFwYCbG+CnE2NSRYGZHlYxc5nSr/YpHJx8djFA7UG7v
iYIxhbBKCWtzJXMYR/CV
=LK2X
-----END PGP SIGNATURE-----

--=-osoUawfOTqh0p7wy4+Vq--


