Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38866 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaL3VoT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 16:44:19 -0500
Date: Tue, 30 Dec 2014 21:44:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs progs release 3.18
Message-ID: <20141230214417.GC26040@carfax.org.uk>
References: <09d8530e73aed4552f1b3a6297c20360@admin.virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
In-Reply-To: <09d8530e73aed4552f1b3a6297c20360@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 10:38:38PM +0100, Tomasz Chmielewski wrote:
> >* filesystem usage - give an overview of fs usage in a way (=E9=81=93,
> >=E3=81=BF=E3=81=A1, michi) that's more
> >* device usage - more detailed information about per-device allocations
> >  * same restrictions as for 'fi usage'
>=20
> Interesting.
>=20
> Used these to create a filesystem, with btrfs-progs v3.17.3:
>=20
> # mkfs.btrfs -O skinny-metadata -d raid1 -m raid1 /dev/sda4 /dev/sdb4 -f
>=20
>=20
> Now, with btrfs-progs 3.18 and these new options I can see that the
> fs is partially single, not RAID-1 - how come?

   It's always been like that with a new FS. The small single chunks
are part of the way that mkfs works, and will go away on the first
balance operation. It's harmless, and can safely be ignored.

   Hugo.

> # btrfs fil us /srv
> Overall:
>     Device size:                   5.25TiB
>     Device allocated:            510.04GiB
>     Device unallocated:            4.76TiB
>     Used:                        505.39GiB
>     Free (estimated):              2.38TiB      (min: 2.38TiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>=20
> Data,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>=20
> Data,RAID1: Size:252.00GiB, Used:250.56GiB
>    /dev/sda4     252.00GiB
>    /dev/sdb4     252.00GiB
>=20
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sda4       8.00MiB
>=20
> Metadata,RAID1: Size:3.00GiB, Used:2.13GiB
>    /dev/sda4       3.00GiB
>    /dev/sdb4       3.00GiB
>=20
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sda4       4.00MiB
>=20
> System,RAID1: Size:8.00MiB, Used:64.00KiB
>    /dev/sda4       8.00MiB
>    /dev/sdb4       8.00MiB
>=20
> Unallocated:
>    /dev/sda4       2.38TiB
>    /dev/sdb4       2.38TiB
>=20
>=20
> root@backup01 ~ # btrfs dev us /srv
> /dev/sda4, ID: 1
>    Device size:             2.63TiB
>    Data,single:             8.00MiB
>    Data,RAID1:            252.00GiB
>    Metadata,single:         8.00MiB
>    Metadata,RAID1:          3.00GiB
>    System,single:           4.00MiB
>    System,RAID1:            8.00MiB
>    Unallocated:             2.38TiB
>=20
> /dev/sdb4, ID: 2
>    Device size:             2.63TiB
>    Data,RAID1:            252.00GiB
>    Metadata,RAID1:          3.00GiB
>    System,RAID1:            8.00MiB
>    Unallocated:             2.38TiB
>=20
>=20

--=20
Hugo Mills             | The trouble with you, Ibid, is you think you know
hugo@... carfax.org.uk | everything.
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUoxywAAoJEFheFHXiqx3kAwYQAIpCHBHDwHg1R+UeKQkGfQUe
IAzANVHWSuBpTOQux1LupUPVuf88f092fakmCKfdgN+8vRhThUE1WY9VA/mWrTNM
yYeOMKPXYqeZZjKM5PHhdJ2lCQleOlIcIILCVM/inkVPGDSmfXVP/hO12ZH9Yl5a
Y6JG73QdWvv2vwRcG7xET5ynoWSy0x2eE2XGREVEpC4WpgE8hA/nBfc3YaJErXed
O+PKo3bgBBUNqgqw+7OjtyHByTJYRkxiz7kpINt5vHJTgFxpbsFj8uLuvJRLBCwd
JIUPoIkwduoxHtfs8ObzDaRceYyqENgvOVpYg0NmjsxTF5NQuLHZJZBHkwCVkTSD
gbAnB113RHewrnWzt4EgbK3j+jBLiYjKpEDdeAhF2KDCSypvu6hS2v3QJ5TYorMn
I/lEIbEO+IOEEDAYiJV45kucP24bpu0sLdR0X0I8veZUJqlAscBZkISAlO4fll/N
HEVFopaPuHxr+WnbtgugAZwY1WtynA9JzynbYllSjkk8GzT7TOQvexPKBky+fj1Z
9nEb+3nnFIyDKapTyeXxj9fAnAtvKQRqhaqD1+igjNL7Vhw1NryZH+/KbM4hdq8K
W711qKEobp+MEJ42hiXVcLA7TiVjUyr5vI7Vbxhk+0++kJSNaRhse+j5YcbrEwyH
E8zeNf6sl9O6k7dsMQuT
=5ll6
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
