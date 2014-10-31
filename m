Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54768 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaKAM5x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 08:57:53 -0400
Date: Fri, 31 Oct 2014 20:18:45 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rich Turner <rturner@storix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: which subvolume is mounted?
Message-ID: <20141031201844.GH907@carfax.org.uk>
References: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkqCAaSJIySsbD6j"
In-Reply-To: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VkqCAaSJIySsbD6j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 09:23:27AM -0700, Rich Turner wrote:
> let=E2=80=99s first assume the contents of /etc/fstab are either not used=
 or invalid in mounting the subvolumes. given the following =E2=80=98df=E2=
=80=99 command, how do i know which subvolume of the btrfs filesystem on /d=
ev/sda3 is mounted at each mount point (/, /var, /opt, /home)? i would have=
 expected to see the mount option used to define the subvolume (subvolid or=
 subvol option) in /proc/mounts.

   I already answered this on IRC, but just for the record (and to
test whether my mail is working): it's in /proc/self/mountinfo. The
fourth field of each line is the location that the mountpoint came
=66rom in the filesystem, which is what you're after.

   Hugo.

> # df
> Filesystem     1K-blocks    Used Available Use% Mounted on
> /dev/sda3        6839296 1698564   4903212  26% /
> devtmpfs          501464       0    501464   0% /dev
> tmpfs             507316       0    507316   0% /dev/shm
> tmpfs             507316    6720    500596   2% /run
> tmpfs             507316       0    507316   0% /sys/fs/cgroup
> /dev/sda3        6839296 1698564   4903212  26% /var
> /dev/sda3        6839296 1698564   4903212  26% /opt
> /dev/sda3        6839296 1698564   4903212  26% /home
> /dev/sda1         517868   93040    424828  18% /boot
>=20
> # btrfs subvolume list -a --sort=3D+rootid /
> ID 257 gen 7800 top level 5 path <FS_TREE>/root
> ID 258 gen 4127 top level 5 path <FS_TREE>/home
> ID 259 gen 7801 top level 5 path <FS_TREE>/var
> ID 260 gen 7795 top level 5 path <FS_TREE>/opt
>=20
> # uname -a
> Linux turner11.storix 3.10.0-123.el7.x86_64 #1 SMP Mon May 5 11:16:57 EDT=
 2014 x86_64 x86_64 x86_64 GNU/Linux
>=20
> # btrfs --version
> Btrfs v3.12
>=20
> # btrfs fi show
> Label: rhel_turner11  uuid: cd3c0e50-d726-44e2-9bfa-19b11614136a
> 	Total devices 1 FS bytes used 1.62GiB
> 	devid    1 size 6.52GiB used 2.24GiB path /dev/sda3
>=20
> Btrfs v3.12
>=20
> # btrfs fi df /
> Data, single: total=3D1.98GiB, used=3D1.58GiB
> System, single: total=3D4.00MiB, used=3D16.00KiB
> Metadata, single: total=3D264.00MiB, used=3D36.03MiB
>=20


>=20
>=20


--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Your problem is that you've got too much taste to be ---      =20
                             a web developer                            =20

--VkqCAaSJIySsbD6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUU+6kAAoJEFheFHXiqx3krTYQAKMt2Y6Y6HOMLiF66VfOB0La
fgzZaP1jAp1CY52Qu1K5ZX3+DaVmwEXXrODoxsujXO338tUGU6rwrWoZ+L3O3mmX
vqLkBwgBRstx/o6lRP/tTVFTgACXtucA92GnEd883pxxePGHawy63qbh1TQsYPpZ
t6IJyL9aof8QmUQmfqnv8YFI4t/FT/g+H0d48kLvejYmG4XRg+iFa6KrKu26MB1b
KM2YMz//g7q2TmUD8VHAtGSo49O/7tyXY42ORLEgaTvJbCSfjEBK73STZu99dJMA
Mod6qOyABrCvmyGzGVAA8cPC0gzUvJ3891oysp1Xovz2s37rN48N3KU1coxFOn2E
j75oNxeHG6rDBnpy37hdP2YiYdS0hDa6kHo7fLC7Fk7Hk14fdLltCXyWe9DRxZUx
MI8X7+uHXxQCmHoUGLDo+kRihGPhpN2VtX07UodZhCcQXkGF0MB6d7VOoc01M+ji
QkZqso3Fa0xMBl/LaGQZUJK0xaZXNK9fpcTwwcGGdCG+en9hghSlUsytTdoZDaMi
d+RMqYX2YD0ptEAPCWs9rXMLsjf2fgUGhUCqnEanrbd34WR6FslaW9L3AQ14MyW/
NQDBWIoW2MFSdnCe32zvEPB7IpdyBbZJQwRpaHEBumEuGmNK+V6CwKGW2ZT5HIzh
6VNuXzgi7RfR4CLvKFkT
=wL8m
-----END PGP SIGNATURE-----

--VkqCAaSJIySsbD6j--
