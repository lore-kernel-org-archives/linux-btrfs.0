Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ble59-2-81-56-123-40.fbx.proxad.net ([81.56.123.40]:36939 "EHLO
	jmuchemb.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaKKUSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 15:18:53 -0500
Received: from [10.236.3.1] (tecra [10.236.3.1])
	by jmuchemb.eu (Postfix) with ESMTP id 79A0C46A6D
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Nov 2014 21:10:14 +0100 (CET)
Message-ID: <54626D23.20701@jmuchemb.eu>
Date: Tue, 11 Nov 2014 21:10:11 +0100
From: Julien Muchembled <jm@jmuchemb.eu>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: kernel >= 3.16 saturates I/O endlessly and without reason
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NH1Gb8WkGNRicIRB4onElRwIKof80fjD0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NH1Gb8WkGNRicIRB4onElRwIKof80fjD0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I upgraded my kernel from 3.15.10 to 3.17.2 and after a while, btrfs kwor=
kers started to read/write data at maximum speed for hours whereas I was =
doing nothing. So I rebooted with kernel 3.15.10 and hopefully everything=
 went back to normal. Later attempts to upgrade to 3.16.7 or 3.17.2 showe=
d the same issue, immediately at boot or after a while.

In order to investigate a little, I copied the partition and mounted it i=
n qemu (snapshot mode, with cow file in tmpfs, debian kernel 3.16.7-2). I=
 could see that btrfs always wrote the same ~8MB in loop. qemu used all c=
pu and when I stopped it, it wrote 190G and the generation number raised =
from 625955 to 853922.

I dumped the FS with btrfs-image. The restored FS has the same issue so I=
 can send the image (78M) to anyone who would like to debug.

$ btrfs fi df /
Data, single: total=3D13.62GiB, used=3D12.60GiB
System, single: total=3D4.00MiB, used=3D16.00KiB
Metadata, single: total=3D1.00GiB, used=3D747.48MiB
GlobalReserve, single: total=3D256.00MiB, used=3D0.00B

$ btrfs fi show --mounted
Label: none  uuid: f5a13768-b968-49c7-8a09-fdad88b83ea8
        Total devices 1 FS bytes used 13.33GiB
        devid    1 size 14.62GiB used 14.62GiB path /dev/sdb2

$ btrfs sub list -a /
ID 257 gen 626025 top level 5 path <FS_TREE>/@
ID 269 gen 28 top level 257 path @/usr/src/linux-sysrcd
ID 278 gen 599690 top level 257 path @/usr/src/linux-3.15-1
ID 279 gen 13003 top level 257 path @/usr/src/python3.3
ID 281 gen 13036 top level 257 path @/usr/src/python3.4
ID 282 gen 614068 top level 257 path @/usr/src/linux-3.16-1
ID 283 gen 599642 top level 257 path @/usr/src/linux-3.17-1


--NH1Gb8WkGNRicIRB4onElRwIKof80fjD0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJUYm0mAAoJEEwjvlkacWMk4q8QAIISldEDF8lbVh2td7MG9V9I
tx38s6RKq/ioRzePJullc/6WL9HKQRXn8X1U53Rr6NUkbvDY8OHGA/EVooXdN+5A
8QIVfV5FF11LnJ0opBkH9xLuh1VXe6RhsKTVebQdOtNyIE03+eUkaIEGU4sQvVXy
x8eC/MUqlWk35XorkeooYzgSeCJ3klCrg6J+RC4CjbzVLHimTdO4QbXzWCI0NHw0
bY8a8D+iD/I1DVxpkDnx7PyrRmq4h0Y0p6WRkAxj/GcFce1ytnCgEY2wYCsCCl3D
vhtwjRHsCaeyS1ipPHVmjTF+KxxTukNK/xQvoIvtpE2qbAeSP3Ar4mE585u/+zkr
Wa/VYgeDGooZfMgEvCRF8L3NTaAzP9tyGJ4LziB4/iEXWpa8DTGaVWQjBoSqg9Wz
aE/GglDtmzmmEGD2LNR/zz6EffjM6Xxafe+UkIWk91/QEH8Vr+II4y2qx3fRL+Dh
AhixK3L9GvbLKPBTsqOQN3B70D/eMRbAAp3HqNcARdiZ8RHqzEJGfRFvsAy9+99Y
ZJbG/nqTWdTj/f8RCY/N5fLIS+w+lavkS/jLxk3Hy2uMQdLn9F8nhOgkN3zn0fAa
th0Qd79/ueVyr1Xli4tL0Z6nkTSrFUvpUqhzIFG4TzepX9dz5r8dkEmwdUUGSrbC
ORiN3xbTjpne3hwHt3oR
=jLfE
-----END PGP SIGNATURE-----

--NH1Gb8WkGNRicIRB4onElRwIKof80fjD0--
