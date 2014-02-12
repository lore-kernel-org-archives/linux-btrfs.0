Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59182 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaBLK0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 05:26:36 -0500
Date: Wed, 12 Feb 2014 10:26:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jakob Truelsen <antialize@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: No space left on device
Message-ID: <20140212102613.GN6490@carfax.org.uk>
References: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TN8pJM9vJMHHFgJc"
In-Reply-To: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TN8pJM9vJMHHFgJc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 10:51:12AM +0100, Jakob Truelsen wrote:
> Hello. I am experiencing "No space left on device" with a btrfs file
> system, yet I cannot seem to find any exhausted resource. Could some
> resource I do not know about be exhausted, or is this caused by
> something else. Below is a trace of information that might be usefull,
> please let me know if there is anything I can do to resolve the issue.
>=20
> /Jakob
>=20
> [jakobt@soda ~]$ uname -a
> Linux soda 3.12.8-1-ARCH #1 SMP PREEMPT Thu Jan 16 09:16:34 CET 2014
> x86_64 GNU/Linux

   Were you using this kernel when the problem happened?

> [jakobt@soda ~]$ btrfs --version
> Btrfs v3.12
>=20
> [jakobt@soda ~]$ mount
> ...
> /dev/sda on /data type btrfs (rw,relatime,nospace_cache)
>=20
> [jakobt@soda ~]$ df /data
> Filesystem     1K-blocks     Used Available Use% Mounted on
> /dev/sdb2       76594224 49247368  23433028  68% /
>=20
> [jakobt@soda ~]$ btrfs filesystem df /data
> Data, single: total=3D1.82TiB, used=3D518.04GiB
> System, DUP: total=3D8.00MiB, used=3D204.00KiB
> System, single: total=3D4.00MiB, used=3D0.00
> Metadata, DUP: total=3D1.00GiB, used=3D767.70MiB

   ^^^ This is your problem, most likely in conjunction with all the
space on the device being allocated. Being a copy-on-write filesystem,
btrfs needs free space to make any update. If it doesn't have that
free space, you get "No space left on device". You typically need
somewhere around 0.5-1 GiB of headroom in metadata for normal
operation, so I'm surprised you got this far. :)

   The FS should normally allocate more metadata space as it needs it,
but because (I think) your data allocation has taken up all the
available space on the device, there's no way for it to add more.

> Metadata, single: total=3D8.00MiB, used=3D0.00

> [jakobt@soda ~]$ touch /data/jakobt/hat
> touch: cannot touch =E2=80=98/data/jakobt/hat=E2=80=99: No space left on =
device
>=20
> [jakobt@soda ~]$ sudo btrfs fi balance start /data
> ERROR: error during balancing '/data' - No space left on device
> There may be more info in syslog - try dmesg | tail

   Try:

btrfs balance start -dusage=3D0 /data

which should go looking for entirely unused block groups and reclaim
those. (If you don't use the -dusage=3D parameter, it will try to
balance everything, which takes a long time).

> [jakobt@soda ~]$ dmesg | grep tail -n 2
> [1113177.878157] btrfs: device label Data devid 1 transid 44784 /dev/sda
> [1113507.641752] btrfs: 1866 enospc errors during balance

   Although, that said... it looks like it's tried every block group
and failed with each one, so my suggestion above may not work in this
instance.

   Let us know what happens with the balance command above anyway
(dmesg output is useful information at this point). If that doesn't
help, then we'll probably need to take a metadata image and throw it
in josef's direction, where he will start crying at having to deal
with enospc problems again. :)

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---        =20
                           of the precipiate.                           =20

--TN8pJM9vJMHHFgJc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvtMRFheFHXiqx3kAQK5Kw/+IgT34dA/8W0G7rxQ//X0+7CHjMDQ/GtW
EE/xHl6N0kfALVJc6Oy/Aq81ykAbiXENN60/7ANtkV7iO91Levps9i1XjlMrNbbK
5VU9S6oEM1FQTwqkIh4BDUXR08X1LmwURNzEsuayBwuCkKQegn1/Ck9l8g0QW6dl
tus01/cwcGmJTgsDpbxljtzeb+aAQJGfpU6h014cB1xjU/Ym1w52xPOWNddP30u+
E+batSLkvcwCyIWvZLopj/PEU0DhQ4a6gRl7anudM6qdlPo/Fw6DPZdd5JObhpSg
7TdMpsJm8V9Pxl0exL/2+bE3nakUT/K1MsfysRlxe6Xi8yfoa8GYifQgT0rNpJfL
TbYEilYdlFMyVA9Yc33JnTKsOf40BH56clQxgFdGLJpiZvKiqNNsYfTDFNQT0bl5
yWKOecbhN+AGECV83EGaY9IMcR1Z1QpMbZc4kq7z7oTRdu2VMK47nGK9oKgIh9sE
QDlE4xgIUI/9Q4KixjC67hJJ4e5V8zSmpbKW8L+s/S1TExa1+C6EczR5ugElTsLc
hNh5nUEnZMIo2TMDwh0A88NpY0VK8VFMCUUsGYCl+aGXoXhA+bles5D1zEyUgGAa
b7VmWHwMgayY9+54Tpb86rJr2JrCCELbI1HyGrOsrSlrpIjsHGnezloPdyp4o+pB
C2BDNlVkL0M=
=vlGZ
-----END PGP SIGNATURE-----

--TN8pJM9vJMHHFgJc--
