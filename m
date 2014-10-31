Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54774 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbaKAM6Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Nov 2014 08:58:16 -0400
Date: Fri, 31 Oct 2014 16:35:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rich Turner <rturner@storix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: which subvolume is mounted?
Message-ID: <20141031163501.GG907@carfax.org.uk>
References: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zGQnqpIoxlsbsOfg"
In-Reply-To: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zGQnqpIoxlsbsOfg
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

   It's in /proc/self/mountinfo -- look at the fourth field in the
table, which is the subvolume within the FS. Completely non-obvious,
I'm afraid, but at least it is there. (Apparently there were some
problems with getting the information into /proc/mounts).

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
          --- Great films about cricket:  Silly Point Break ---         =20

--zGQnqpIoxlsbsOfg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUU7o1AAoJEFheFHXiqx3kJzQP/i4WHvwNGZwuP6hjsIrLk1MX
q/bsCus5tX2C+Y6kyYi9hBsBGMYEeAuXnxwlM+VoiMskh3w5ThnlKdIOF1QQ94IP
2pO9d8NdSkmNluT6bMQun2vtzxYsgISwcjcftxx3zfXmf+eYMbEvTOcdX60BFj2L
WfwDnkpfxFSV+ttdTyA3cORIWMAi7jrNsWGNVrxh5+bnq9G6dOtfrKb1fwVO34so
qoaz5qCuhGl3uumRJJD8hWK2uzEt/DTBZdFwRAVhBnG08c86PrzNqbpJiRmXj85c
a6qbTJEf0ayMw0RmJVkv/7l5X3mNRYwfBnkD8E5vuohI+RUL3W/0D7XrM+OCMA7h
4ujENHooqLDPf5G3gaMwTfnYqp5U1DGtdHsO8x8t712lSvtQTCJPdJ6eUB2cChAe
O109IwQknne6VhvBxiZv5WCn5S64PImR92eZrz1eikoZvgzK/wSS7sCLoAUGQr4g
w2GIYrY8LfsYIBDn6hqhWikGaGzLvuVEdrPb292QI0TeFlJRZjAoonAJMVIE2x+t
TkmXC9MyKKk06we8ien7Ty229pggiJUmF3K81qqyCecKn6c9UcDm5dU5w2lhgFHa
jCCREfZAAi4wik8eIOIoS5YNPsPe3/SKcmHODfPVYzLVUXyNHMTX3ayFTFAWksFd
KNtZ8s4E3UynUK5DUdoi
=rpTA
-----END PGP SIGNATURE-----

--zGQnqpIoxlsbsOfg--
