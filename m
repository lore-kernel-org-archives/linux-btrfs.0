Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46101 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965030AbbEMM7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 08:59:20 -0400
Date: Wed, 13 May 2015 12:59:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: =?iso-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>,
        David Alcorn <nroclaed@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Failed RAID0=> RAID1 Conversion
Message-ID: <20150513125917.GS18480@carfax.org.uk>
References: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
 <55532EA4.2080907@skagestad.org>
 <20150513111131.GR18480@carfax.org.uk>
 <CAL3q7H71A1mgLvPGqhuQp7mD+pxpR7JXdaz3dk3kRE4idYJTWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YvpO9wCO44Ze8QQC"
In-Reply-To: <CAL3q7H71A1mgLvPGqhuQp7mD+pxpR7JXdaz3dk3kRE4idYJTWg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YvpO9wCO44Ze8QQC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2015 at 12:30:23PM +0100, Filipe David Manana wrote:
> On Wed, May 13, 2015 at 12:11 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Wed, May 13, 2015 at 12:59:48PM +0200, Torbj=F8rn wrote:
> >> On 13. mai 2015 12:47, David Alcorn wrote:
> >> >I run Debian Jessie with a kernel upgrade to 4.0.0 from the Debian
> >> >experimental repository.  My BTRFS-Tools remain at 3.17.-1  I wanted
> >> >to convert a RAID0 array on /dev/sdb3 and /dev sdc3  from RAID0  to
> >> >RAID1 so I ran the commands:
> >> >
> >> >     mount /dev/sdb3 /mnt
> >> >     btrfs device add -f /dev/sdc3 /mnt
> >> >     btrfs balance start -dconvert=3Draid1 -mconvert=3Draid1 /mnt
> >> >
> >> >All appeared well with output similar to "395 of 395 chunks converted"
> >> >but I think nothing happened.  The array contains a subvolume @export
> >> >with size (per "du -sh @export") of  442G.  The pertinent output from
> >> >"btrfs filesystem show" reports:
> >> >
> >> >     Label: none  uuid: 647eb0f8-7732-40bc-a4a4-0d1b31a8ae16
> >> >             Total devices 2 FS bytes used 443.05GiB
> >> >             devid    1 size 1.36TiB used 223.03GiB path /dev/sdb3
> >> >             devid    2 size 1.36TiB used 223.03GiB path /dev/sdc3
> >> >
> >> >My array remains RAID0 if I understand the above output correctly.
> >> >This output persist through a reboot and no data was lost.  Where did
> >> >I err?
> >>
> >> For info about raid levels, use "btrfs filesystem df <mount point>"
> >> It should give you something like this:
> >> Data, RAID1: total=3D12.97GiB, used=3D12.28GiB
> >> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> >> Metadata, RAID1: total=3D1.00GiB, used=3D334.53MiB
> >> GlobalReserve, single: total=3D112.00MiB, used=3D0.00B
> >
> >    If this still says RAID0, then you've probably hit a known (and
> > since fixed) bug that stops restripe operations from working:
>=20
> As far as I can see, it hasn't been fixed as of 4.1-rc3 yet, nor any
> patch to fix it was posted to this list yet (other than Omar's revert
> patch).

   Ah, OK, I stand corrected. I thought it had been fixed, but I was
probably remembering Omar's revert patch.

   Hugo.

> > http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg43313.html
> >
> >    Hugo.
> >

--=20
Hugo Mills             | Purrmetheus stole fur from the Dogs, and was chain=
ed
hugo@... carfax.org.uk | up for beagles to eat his liver.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                         Rich and H=
ugo

--YvpO9wCO44Ze8QQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVU0qlAAoJEFheFHXiqx3ktPoP/3iRFqd35Bykj9vjp2gWjY5t
YUju7dMo7HmfRA2VPV0AAfUhLmbcIUvCBEqz0COr2yrqpAD2/paRAdSqi9uzfAKo
SsncUBbudD4Te5iPx7tUhqYG368NIdKh524700btirmpBf2UKB2m9+WtGejUNPIw
WrthlUZTtiOPrfc8TqTJCiYT5w70XKGzx5RW7ulpaJxp5YDYN/YCiqCygIlmuM2+
n1cCzAlVjsvqYzEqPK6z6850rYjYmC1uF9TZLkErskL9GITT0f69mfCoEJxk0mJ8
RR5UgViOZIXLOwFsiAA3BS8lEqCgzYlPuf5VbFj1kcK+nc26Zgnq3t4FtWTK+FXH
Hk4TvxSoeWsQsHDtZoXMGmS5BJ9dC+l4TN6UpNOzgGKwu3NOxWBTMmfawsRT1yuc
sJ7QHrB8DQKGueIQmV+VXxZPS3DVcBgwFFmfYVUPMX5Zk8WuXeaiyqYTJVelB8fm
vkxErSd3s/K1p1vooITy5wbimYp7ckNgWnVqG/G2IUv1+dy81rHO3LPSIkYikBD9
KZoVZfMwTsKYUseMnUYrxJRfg4+uTwT/UEVE9FjQeKbU9OJMt9OORPoJxQ6timrI
iUEb5opT465R0XOLBhhU6Iydc6QxP1xG0IaDlPHXz31Qqbo2QjZi87aB0X3s9ob8
rsHv4HLpVkgKTzt5blx1
=Tnyb
-----END PGP SIGNATURE-----

--YvpO9wCO44Ze8QQC--
