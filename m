Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45127 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbEZSIV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 14:08:21 -0400
Date: Tue, 26 May 2015 18:08:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
Message-ID: <20150526180820.GG16826@carfax.org.uk>
References: <20150526173634.GU11340@wantstofly.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nqkreNcslJAfgyzk"
In-Reply-To: <20150526173634.GU11340@wantstofly.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nqkreNcslJAfgyzk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2015 at 08:36:34PM +0300, Lennert Buytenhek wrote:
> Hi!
>=20
> The btrfs filesystem on my newly installed laptop has managed to
> hose itself rather thoroughly, and it's now in a state where it
> works okay if you don't write too much to it, but if you do, it
> starts returning -ENOSPC on a random subset of your filesystem
> operations until you let it cool down again.
>=20
> This was a fresh Fedora 21 install, upgraded to F22, installed
> about a month ago, with a ~250G btrfs filesystem on a 256G SSD,
> and this system has only even run 4.0, and it has never had more
> than ~60G on it.  It's currently running:
>
> # uname -a
> Linux foobox 4.0.1-300.fc22.x86_64 #1 SMP Wed Apr 29 15:48:25 UTC 2015 x8=
6_64 x86_64 x86_64 GNU/Linux
>=20
> # btrfs --version
> btrfs-progs v4.0
>=20
> # btrfs fi show
> Label: 'foobox'  uuid: [...]
>         Total devices 1 FS bytes used 58.87GiB
>         devid    1 size 229.97GiB used 229.97GiB path /dev/[...]

   All the space has been allocated for some purpose.

> # btrfs fi df /
> Data, single: total=3D227.94GiB, used=3D58.16GiB
> System, DUP: total=3D8.00MiB, used=3D48.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, DUP: total=3D1.00GiB, used=3D730.80MiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D256.00MiB, used=3D0.00B

   For a filesystem of this size, a very small proportion has gone to
metadata for some reason. This is odd. Given that it's happened,
though, all the other behaviour is as expected.

> It's currently still in a funky state:
>=20
> [root@foobox lib]# df /
> Filesystem     1K-blocks     Used Available Use% Mounted on
> /dev/dm-0      241145856 62743256 178027464  27% /

   Looks reasonable, give the figures above.

> [root@foobox lib]# pwd
> /var/lib
> [root@foobox lib]# touch foo
> [root@foobox lib]# rm -f foo
> [root@foobox lib]# ls -ald abrt
> drwxr-xr-x. 1 root root 56 May 21 10:02 abrt
> [root@foobox lib]# mv abrt abrt2
> mv: cannot move =E2=80=98abrt=E2=80=99 to =E2=80=98abrt2=E2=80=99: No spa=
ce left on device
> [root@foobox lib]#=20
>=20
> Any tests anyone wants to run on this before I wipe and reinstall
> the box?

   No tests needed. Just run a filtered balance on it to clean up
unused chunks:

# btrfs balance start -dusage=3D5 /

as suggested in the FAQ [1].

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28=
=2E3E16GiB.29

--=20
Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
hugo@... carfax.org.uk | and Unix. This is not a coincidence.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--nqkreNcslJAfgyzk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZLaTAAoJEFheFHXiqx3kizcQAIdW/6VQ+cXhoycQk+YhMygy
GhbSkJ6cmXbVA3CtbaIqAG/b4i3zSU0yB+V9ov58NnqQL9WZ7uYmErppQSMBojBe
/DwUn0ypGZn3CIb7W/JLPijJ/qyToUKwitBZwp5OfAKXipQ635WrGNUY5T2UmGed
1avloUW58Qg4Gln8JT6mJQ9S9+o09QdtKYSL2VwRA38v6Ix+2eAxhIE8418EmA8J
hNbMqz/4gG9IsZioO4SLFRr1zRfty2AlxMPJi6ZouzY9pscgrZKcHtPQDYFaD2DZ
JGSoKSN942e8RBJGtDzvryx0aFMISj65IQVBQQA8oxT3CzVY8M2maE1+ePytteHB
Du34pf/mPG801O2lQxqiLMszFlY8NqQ9ftc78nOr683QmUu2BAnUm/wTHXMpSjAK
yQQd74ws0AP1FmwfxBVEMveTcNayutprJk1saKpsA/nnKllcsfkSUImeSHpPryjy
ePdBkJQ+G17Gta4Gb9MPerJeDnt6Y/R/KHYggRsmbsZ0+91meqHsYjdnAHP6RFpZ
C3it+RQ2t7FkR5PaBiMNKZ5MaAKLxwvGVph6BMYvRzbR1J/nYTe+RCeNQRt088hw
RjFTogrHndROt7dcZObUuXp8YzHas7AZjslZRVSrIvGuOvhe2tJT3Bqq16eiqP6E
M/W9sSvQ/EwkIH42LnEd
=oJy3
-----END PGP SIGNATURE-----

--nqkreNcslJAfgyzk--
