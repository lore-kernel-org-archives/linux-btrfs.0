Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44489 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab2FNEep (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 00:34:45 -0400
Message-ID: <1339648469.4942.71.camel@deadeye.wl.decadent.org.uk>
Subject: Re: btrfs: filenames collide with snapshot/subvolume names
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?Q?=CE=93=CE=B9=CF=8E=CF=81=CE=B3=CE=BF=CF=82_?=
	 =?UTF-8?Q?=CE=A0=CE=AC=CE=BB=CE=BB=CE=B1=CF=82?=
	<gpall@ccf.auth.gr>,
        663067@bugs.debian.org
Date: Thu, 14 Jun 2012 05:34:29 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FtSojiqYjEEiUn1Ykepo"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-FtSojiqYjEEiUn1Ykepo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=CE=93=CE=B9=CF=8E=CF=81=CE=B3=CE=BF=CF=82 (Giorgos?) reports:
> Namely, being inside a snapshot directory, I can't create a file/director=
y
> with the name of the snapshot directory.
>=20
> For example, inside /mnt/aSnap, I can't create a file named 'aSnap', so I=
'm
> filling this bug report.

It seems that the snapshot directory is partially created before the
snapshot is taken, so that the snapshot directory half-exists (can be
looked up, but doesn't appear in listings) inside the snapshot itself.

This doesn't seem to be the recommended way to organise subvolumes, but
it seems like it should at least result in a coherent filesystem within
each subvolume.

Ben.

> Below follows full reproduction of this behavior:
>=20
> aris tmp # dd if=3D/dev/zero of=3DFILE bs=3D4k seek=3D`echo 5*1024*1024 |=
 bc` count=3D1
> 1+0 records in
> 1+0 records out
> 4096 bytes (4.1 kB) copied, 1.8695e-05 s, 219 MB/s
> aris tmp # losetup /dev/loop0 FILE=20
> aris tmp # losetup -a
> /dev/loop0: [fe01]:263872 (/tmp/FILE)
> aris tmp # mkfs.btrfs -Ltest /dev/loop0
>=20
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>=20
> fs created label test on /dev/loop0
>         nodesize 4096 leafsize 4096 sectorsize 4096 size 20.00GB
> Btrfs Btrfs v0.19
> aris tmp # mount /dev/loop0 /mnt/
> aris tmp # cd /mnt
> aris mnt # ls -la
> total 8
> dr-xr-xr-x  1 root root    0 Mar  8 12:07 .
> drwxr-xr-x 24 root root 4096 Mar  8 11:41 ..
> aris mnt # mkdir dir1
> aris mnt # mkdir dir2
> aris mnt # mkdir dir3
> aris mnt # l
> total 0
> drwxr-xr-x 1 root root 0 Mar  8 12:08 dir1
> drwxr-xr-x 1 root root 0 Mar  8 12:08 dir2
> drwxr-xr-x 1 root root 0 Mar  8 12:08 dir3
> aris mnt # btrfs subvolume snapshot /mnt/ /mnt/aSnap
> Create a snapshot of '/mnt/' in '/mnt/aSnap'
> aris mnt # cd /mnt/aSnap/
> aris aSnap # ls -la
> total 8
> dr-xr-xr-x 1 root root 34 Mar  8 12:08 .
> dr-xr-xr-x 1 root root 34 Mar  8 12:08 ..
> drwxr-xr-x 1 root root  0 Mar  8 12:08 dir1
> drwxr-xr-x 1 root root  0 Mar  8 12:08 dir2
> drwxr-xr-x 1 root root  0 Mar  8 12:08 dir3
> aris aSnap # date > aSnap
> bash: aSnap: Is a directory

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-FtSojiqYjEEiUn1Ykepo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9lp1ue/yOyVhhEJAQoWFA/+Kn/lW19c3CBffVAYsb23gNRENwuBrBbm
IexS+hiBR46GABbTLiHC5qytAMqXdYeGd3AJcleNXvJQ6Awbij4qPuOcz1MvQAkn
pdX87rfyouiy3gqaJFEN7ItDmrG6n4oAgP8ShDwdOVmXtigMXl09tPgB+CZEboUj
pqRVeUtcHceLugFzEdvfLpeo3aqXyOZVSDYAFCJ5jvsgYhMwXtQmxK4tbJEEBzN/
oFZBKczlEGuQtQg9p1Maeoa2jBKzNQJt0xU1bbddxOiHrWyemtLFseZGt5M58cyz
orkbXotvnuvw6milfX2aRTqQh4KZ7CJRXcCYvwOXttTCLp8q+P7ZoNjFCZT+43wX
NxLnXudcqfaIFhZ3T69tlYEJV7z1UnRHrkWE0jo6f7tjDWtWuOJnXhteulIuip6z
dQ5rEwVqkVEQMcBoDtT60x72aQpkovm0gvK7zem2rqVZyAWIyjpO3aRxeW/jDcb0
jez4W87Ohsp41tgo8+EYJNMPBLBh3BBUtdsEYTa4AbSfnARHDhf+xx37dUGQL0As
1uHY7IQ9eXuTLln50fdvwMrB5xYFtVOuEcBU7faP3E7d6fucf2fCU/BECvlb3E+B
X7JgwX2KJQc0TVll2xhpJVKBDSIzrvXmTyz7p/FGSM0QX7qX/VoRYhNbR10Z6swi
I8ByvkfY6go=
=idgb
-----END PGP SIGNATURE-----

--=-FtSojiqYjEEiUn1Ykepo--
