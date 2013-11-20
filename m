Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32852 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTIKC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 03:10:02 -0500
Date: Wed, 20 Nov 2013 08:09:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Message-ID: <20131120080958.GA28883@carfax.org.uk>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
 <20131119090602.GV4315@carfax.org.uk>
 <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
In-Reply-To: <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2013 at 11:16:58PM +0000, Duncan wrote:
> Hugo Mills posted on Tue, 19 Nov 2013 09:06:02 +0000 as excerpted:
>=20
> > This will happen with RAID-10. The allocator will write stripes as wide
> > as it can: in this case, the first stripes will run across all 8
> > devices, until the SSDs are full, and then will write across the
> > remaining 4 devices.
>=20
> Hugo, it doesn't change the outcome for this case, but either your=20
> assertion above is incorrect, or the wiki discussion is incorrect (of=20
> course, or possibly I'm the one misunderstanding something, in which case=
=20
> hopefully replies to this will correct my understanding).
>=20
> Because I distinctly recall reading on the wiki that for raid, regardless=
=20
> of the raid level, btrfs always allocates in pairs (well, I guess it'd be=
=20
> pairs of pairs for raid10 mode, and I believe that statement pre-dated=20
> raid5/6 support so that isn't included).  I was actually shocked by that=
=20
> because while I knew that was the case for raid1, I had thought that=20
> other raid levels would stripe as widely as possible, which is what you=
=20
> assert above as well.

   That's incorrect. I used to think that, a few years ago, and it got
into at least one piece of documentation as a result, but once I
worked out the actual behaviour, I did try to correct it (I definitely
remember fixing the sysadmin guide this way). For striped levels
(RAID-0, 10, 5, 6), the FS will use as many stripes as possible -- for
RAID-10, this means an even number; for the others, this is all the
devices with free space on, down to a RAID-level dependent minimum.

RAID-0:  min 2 devices
RAID-10: min 4 devices
RAID-5:  min 2 devices (I think)
RAID-6:  min 3 devices (I think)

> Now I just have to find where I read that on the wiki...
>=20
> OK, here's one spot, FAQ, md-raid/device-mapper-raid/btrfs-raid=20
> differences, btrfs:
>=20
> https://btrfs.wiki.kernel.org/index.php/FAQ#btrfs
>=20
> >>>>
>=20
> btrfs combines all the drives into a storage pool first, and then=20
> duplicates the chunks as file data is created. RAID-1 is defined=20
> currently as "2 copies of all the data on different disks". This differs=
=20
> from MD-RAID and dmraid, in that those make exactly n copies for n disks.=
=20
> In a btrfs RAID-1 on 3 1TB drives we get 1.5TB of usable data. Because=20
> each block is only copied to 2 drives, writing a given block only=20
> requires exactly 2 drives spin up, reading requires only 1 drive to=20
> spinup.

   This is correct.

> RAID-0 is similarly defined, with the stripe split among exactly 2 disks.=
=20
> 3 1TB drives yield 3TB usable space, but to read a given stripe only=20
> requires 2 disks.

   This is definitely wrong. RAID-0 will use all 3 drives for each
stripe.

> RAID-10 is built on top of these definitions. Every stripe is split=20
> across to exactly 2 RAID1 sets and those RAID1 sets are written to=20
> exactly 2 disk (hense 4 disk minimum). A btrfs raid-10 volume with 6 1TB=
=20
> drives will yield 3TB usable space with 2 copies of all data, but only 4

   This is also wrong. You will get 3 TB usage out of 6 =D7 1 TB drives,
but the individual stripes will be 3 drives wide. You would have the
same behaviour (2 copies of 3 stripes wide) on a 7-device array.

> <<<<
>=20
> [Yes, that ending sentence is incomplete in the wiki.]
>=20
> So we have:
>=20
> 1) raid1 is exactly two copies of data, paired devices.
>=20
> 2) raid0 is a stripe exactly two devices wide (reinforced by to read a=20
> stripe takes only two devices), so again paired devices.
>=20
> 3) raid10 is a combination of the above raid0 and raid1 definitions,=20
> exactly two raid1 pairs, paired in raid0.
>=20
> So btrfs raid10 is pairs of pairs, each raid0 stripe a pair of raid1=20
> mirrors.  If there's 8 devices, four smaller, four larger, the first =20
> allocated chunks should be one per device, until the smaller devices fill=
=20
> up it'll chunk across the remaining four, but it'll be pairs of pairs of=
=20
> pairs, two pair(0)-of-pair(1) stripes wide instead of a single quad(0)-of-
> pair(1) stripe wide.

   If the RAID code used pairs for its stripes, that'd be the case,
but it doesn't...

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---              =20

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoxuVlheFHXiqx3kAQKgtw/9Em2dxlc2PhrBCF8x3nDivDlEZQGhXeWQ
xlejPYLuvcl0xIVsAGeV7sjY2mJLndfsUi4j65gDZpM8EvPkdHuOtzDaR19qkqRg
Mkgx+LUELTzcVJaJeLsnSv5xZI+sGTiDyuReoEfgC0fZ3BxP2bESYijYcnWcvAZS
U8GFAhdpCiX/Zx5oCcqvX8u1bzalhftCmKHah28bFRwrYHgFECKEre7tEwPTQWwJ
rVYGTPIQJk9E054NiLFIslDRf4K6Sw+Qytw8oQZHzgeAbuH/+njEtMpDfz1/FceF
gDloGbrakk9wJx2byvUN2yPzk+1YzP1ulS6dsfxtRDu1Rw5eHkfbn/4Us4bRi7UW
9tUlyVxiXbYO20By1EZ/CYziCv8nTJ7WTfLiCjV7t4TTYZcA7MQFcvy6dG0tH1tU
SBfcLi4qRI5bCwvVXVJIIydXs1oX+7EB6aOONwXRt3jTI33JQg73ZAM/jw2br+rq
h4JKo1XVsnLKZkkC+BXDztC+pHwrd3aGM/syy3hsbZeqMFGf5+TyRZPzEIiZl6nF
1YMSVrkbReTaeuAjM5lb8aU4t/aVhQaAn3eib6T6rsjfE6xfxU7FaiqDX0jghuU3
6UObv3VKcixtQjqfZEhtHOdbAN1ivpmM9AoPW7lSQZsyLh1NeZQEfxuF7b0+Hi0b
XRV0n4hOIVY=
=qr0o
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
