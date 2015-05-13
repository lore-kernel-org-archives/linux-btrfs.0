Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45741 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbbEMLLf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 07:11:35 -0400
Date: Wed, 13 May 2015 11:11:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
Cc: David Alcorn <nroclaed@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Failed RAID0=> RAID1 Conversion
Message-ID: <20150513111131.GR18480@carfax.org.uk>
References: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
 <55532EA4.2080907@skagestad.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8a9NmTVi5AMeZ2v"
In-Reply-To: <55532EA4.2080907@skagestad.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Q8a9NmTVi5AMeZ2v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2015 at 12:59:48PM +0200, Torbj=F8rn wrote:
> On 13. mai 2015 12:47, David Alcorn wrote:
> >I run Debian Jessie with a kernel upgrade to 4.0.0 from the Debian
> >experimental repository.  My BTRFS-Tools remain at 3.17.-1  I wanted
> >to convert a RAID0 array on /dev/sdb3 and /dev sdc3  from RAID0  to
> >RAID1 so I ran the commands:
> >
> >	mount /dev/sdb3 /mnt
> >	btrfs device add -f /dev/sdc3 /mnt
> >	btrfs balance start -dconvert=3Draid1 -mconvert=3Draid1 /mnt
> >
> >All appeared well with output similar to "395 of 395 chunks converted"
> >but I think nothing happened.  The array contains a subvolume @export
> >with size (per "du -sh @export") of  442G.  The pertinent output from
> >"btrfs filesystem show" reports:
> >
> >	Label: none  uuid: 647eb0f8-7732-40bc-a4a4-0d1b31a8ae16=09
> >		Total devices 2 FS bytes used 443.05GiB
> >		devid    1 size 1.36TiB used 223.03GiB path /dev/sdb3
> >		devid    2 size 1.36TiB used 223.03GiB path /dev/sdc3
> >
> >My array remains RAID0 if I understand the above output correctly.
> >This output persist through a reboot and no data was lost.  Where did
> >I err?
>=20
> For info about raid levels, use "btrfs filesystem df <mount point>"
> It should give you something like this:
> Data, RAID1: total=3D12.97GiB, used=3D12.28GiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D1.00GiB, used=3D334.53MiB
> GlobalReserve, single: total=3D112.00MiB, used=3D0.00B

   If this still says RAID0, then you've probably hit a known (and
since fixed) bug that stops restripe operations from working:

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg43313.html

   Hugo.

--=20
Hugo Mills             | You can play with your friends' privates, but you
hugo@... carfax.org.uk | can't play with your friends' childrens' privates.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       C++ coding r=
ule

--Q8a9NmTVi5AMeZ2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVUzFjAAoJEFheFHXiqx3kc+MQAIJGnqdS2cSGYJiwYkq6vGwL
ZFbfn/0MTyIDErWt/Vha1spDS8n4cTxNvVG9s1T/7xbjR0aN0Wok9rJLC5JWFTwx
dTM3oDV3CHtafw9rqtA4Pc6I/8pODhsHW2q9zrlwBWNX6ziTtko2GD+regEeIfTC
DdxY+nh9CvHrC/8oO+QD05jm2RrMT3aUP1k8FIhF5hZf0x7/EvzDLOLFilozpXF0
B318xFvNDvsVY6XU1ckgYaQC2uXRViEmblp0ELmo5svzgdyRdgq8Rx8FT2x1ZgVh
PXfRBgBC+Q/1Et/uNsBP6IbMGuRoKNQFFGw3a+MEAoH5CbKW61NmZKMX+LYREcW4
F4KTej4e5aSLjiBwWgLWJ2w6J0hYnsrDW7/t/rdMFGRVnJtpG3g2UMXLzkZ1KHn6
uWHBqG5PuGCMVGpbaQjW6tfV0WYBQRevARDtfyIjc1VoCX+/xvn7ltwjXEZ4k33y
4eHRuuECUrnBZh+Dse+2jvWqcGkf+++QWi2AyVOtYX01XWmvSLoMmeVX+m9egcSk
qMGFUkbulCSpkLvlBwsKpHrW/CSKMV6zjfayC+DbwRzKs4Er0BlL8v9eMph6Hqyk
bkGOi2X+aU8eUE7UQvlCEy0tMTh7aIQD4u1c1qyws2Zx9O17oa6MtJoky632NxIU
5bh27RknJJzPyzc/2G9d
=f3eM
-----END PGP SIGNATURE-----

--Q8a9NmTVi5AMeZ2v--
