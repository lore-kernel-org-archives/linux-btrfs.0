Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59565 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBLLII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 06:08:08 -0500
Date: Wed, 12 Feb 2014 11:07:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jakob Truelsen <antialize@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: No space left on device
Message-ID: <20140212110744.GO6490@carfax.org.uk>
References: <CAEhsiNw3hLSu8zPw44ndR1xQ-fjFrzaSCw3GDa=1vhCY3BypnA@mail.gmail.com>
 <20140212102613.GN6490@carfax.org.uk>
 <CAEhsiNyLGFc0GWFH5Hh7hZ1c9WzX7JO7quuud9APB0k3=4yu6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAr+fMtvBxbbbkvl"
In-Reply-To: <CAEhsiNyLGFc0GWFH5Hh7hZ1c9WzX7JO7quuud9APB0k3=4yu6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bAr+fMtvBxbbbkvl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 11:45:34AM +0100, Jakob Truelsen wrote:
> Hi and thanks for the quick reply. Have remounted the filesystem with
> enospc_debug, and run the rebalance you suggested, with the trance
> below. So perhaps the next step is for me to figure out how to take a
> metadata image and send it to josef (perhaps with a box of tissues)

   You can get the metadata image with:

btrfs-image -c9 -t4 /dev/sda image-file-to-create

   It will probably be a couple of hundred megabytes in size (your
metadata size, compressed). It will contain filenames and xattrs, so
if those are sensitive, you may want to use -s to hide that
information.

   After that, probably the best place to make sure it's not lost is
to open an issue on bugzilla.kernel.org, making sure that you set the
Component to btrfs.

   Hugo.

> /Jakob
>=20
>=20
> [jakobt@soda ~]$ mount
> ...
> /dev/sda on /data type btrfs (rw,relatime,nospace_cache,enospc_debug)
>=20
> [jakobt@soda ~]$ sudo  btrfs balance start -dusage=3D0 /data
> ERROR: error during balancing '/data' - No space left on device
> There may be more info in syslog - try dmesg | tail
>=20
> [jakobt@soda ~]$ touch /data/jakobt/monkey
> touch: cannot touch =E2=80=98/data/jakobt/monkey=E2=80=99: No space left =
on device
>=20
> [jakobt@soda ~]$ dmesg | tail -n3
> [1117530.870965] btrfs: device label Data devid 1 transid 47091 /dev/sda
> [1117573.087580] btrfs: 426 enospc errors during balance
> [1117642.002437] btrfs: 426 enospc errors during balance

> On Wed, Feb 12, 2014 at 11:26 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Wed, Feb 12, 2014 at 10:51:12AM +0100, Jakob Truelsen wrote:
> >> Hello. I am experiencing "No space left on device" with a btrfs file
> >> system, yet I cannot seem to find any exhausted resource. Could some
> >> resource I do not know about be exhausted, or is this caused by
> >> something else. Below is a trace of information that might be usefull,
> >> please let me know if there is anything I can do to resolve the issue.
> >>
> >> /Jakob
> >>
> >> [jakobt@soda ~]$ uname -a
> >> Linux soda 3.12.8-1-ARCH #1 SMP PREEMPT Thu Jan 16 09:16:34 CET 2014
> >> x86_64 GNU/Linux
> >
> >    Were you using this kernel when the problem happened?
> >
> >> [jakobt@soda ~]$ btrfs --version
> >> Btrfs v3.12
> >>
> >> [jakobt@soda ~]$ mount
> >> ...
> >> /dev/sda on /data type btrfs (rw,relatime,nospace_cache)
> >>
> >> [jakobt@soda ~]$ df /data
> >> Filesystem     1K-blocks     Used Available Use% Mounted on
> >> /dev/sdb2       76594224 49247368  23433028  68% /
> >>
> >> [jakobt@soda ~]$ btrfs filesystem df /data
> >> Data, single: total=3D1.82TiB, used=3D518.04GiB
> >> System, DUP: total=3D8.00MiB, used=3D204.00KiB
> >> System, single: total=3D4.00MiB, used=3D0.00
> >> Metadata, DUP: total=3D1.00GiB, used=3D767.70MiB
> >
> >    ^^^ This is your problem, most likely in conjunction with all the
> > space on the device being allocated. Being a copy-on-write filesystem,
> > btrfs needs free space to make any update. If it doesn't have that
> > free space, you get "No space left on device". You typically need
> > somewhere around 0.5-1 GiB of headroom in metadata for normal
> > operation, so I'm surprised you got this far. :)
> >
> >    The FS should normally allocate more metadata space as it needs it,
> > but because (I think) your data allocation has taken up all the
> > available space on the device, there's no way for it to add more.
> >
> >> Metadata, single: total=3D8.00MiB, used=3D0.00
> >
> >> [jakobt@soda ~]$ touch /data/jakobt/hat
> >> touch: cannot touch =E2=80=98/data/jakobt/hat=E2=80=99: No space left =
on device
> >>
> >> [jakobt@soda ~]$ sudo btrfs fi balance start /data
> >> ERROR: error during balancing '/data' - No space left on device
> >> There may be more info in syslog - try dmesg | tail
> >
> >    Try:
> >
> > btrfs balance start -dusage=3D0 /data
> >
> > which should go looking for entirely unused block groups and reclaim
> > those. (If you don't use the -dusage=3D parameter, it will try to
> > balance everything, which takes a long time).
> >
> >> [jakobt@soda ~]$ dmesg | grep tail -n 2
> >> [1113177.878157] btrfs: device label Data devid 1 transid 44784 /dev/s=
da
> >> [1113507.641752] btrfs: 1866 enospc errors during balance
> >
> >    Although, that said... it looks like it's tried every block group
> > and failed with each one, so my suggestion above may not work in this
> > instance.
> >
> >    Let us know what happens with the balance command above anyway
> > (dmesg output is useful information at this point). If that doesn't
> > help, then we'll probably need to take a metadata image and throw it
> > in josef's direction, where he will start crying at having to deal
> > with enospc problems again. :)
> >
> >    Hugo.
> >

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---        =20
                           of the precipiate.                           =20

--bAr+fMtvBxbbbkvl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvtWAFheFHXiqx3kAQKohg//ejirOCQa7hBXX/4rEmyxfTizjxN5RezA
bRxzXaLkWHN18xsD1Fxn6eGQx1dBkb4g7GzNax/KWREFkJITls/ZXMlL5S8T44pn
lFOcrZc5Ed9URcJBoIz9ReG1ORTdpTjIm37G89KNDV0dWkzi/zaLgw5SJ/CgI+2W
w/J4KE5yI0vmdRKZDozBpBIQ/yZwQKkjrN99cJDKvHaeUH0M/5geMeHt2mIeQW36
ctFY/oXdMwsp6dvZ5gTAYj59f8TvtM+vy0DP9V7wIlElvM8PsU2E5GzCdEhJZt26
1uquA2VOGLm4tg+3eQbPWPD38Q8NaMPSijI8lIOsYDsKLGsNoCgKsrZwohpnvs/3
BebL/PCgYuP+Mw5MBaJDdfxtWJLZ79ojtnfPXPt7/q1WoySCfNfTam2TGzHgw3H1
lkyyxoMOjfONiUZtQaTzwZR0coI8q2voKF9bfOu7suQC4qiDxQTc4gc24NX8fSAC
qzIuAl+7bkvSLbwd5vCn59sYNuPSto0EQh+3KmPngMhmWMx0Vf2BzYxMaETVnB2W
ciNen/oGUFb8pYyyCcPwMKpbBYmA4ps4UoflIU/uEgpqPdHiHIEF/zedZoEFid8b
G+UZ3rBVjFSX8aplS3WG8jgJ4FdVOvgogYP1xRDhKDIbe6EgbNEr3/6g5J9ZVZcN
jxLRi+Jd0hc=
=Gh15
-----END PGP SIGNATURE-----

--bAr+fMtvBxbbbkvl--
