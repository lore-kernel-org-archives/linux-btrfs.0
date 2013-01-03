Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57267 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3ACRB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 12:01:56 -0500
Date: Thu, 3 Jan 2013 17:01:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
Message-ID: <20130103170151.GB19051@carfax.org.uk>
References: <20130103160853.GA19051@carfax.org.uk>
 <CO8i$PzPCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="alCHniwhwUTljuKz"
In-Reply-To: <CO8i$PzPCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--alCHniwhwUTljuKz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 05:29:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
>=20
> Du meintest am 03.01.13:
>=20
> >> please delete the option "-L" (for labelling) in "mkfs.btrfs", in
> >> some configurations it doesn't work as expected.
> >>
> >> My usual way:
> >>
> >>         mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...
> >>
> >> One call for some devices.
> >> Wenn I add the option "-L mylabel" then each device gets the same
> >> label, and therefore some other programs can't find the (one) device
> >> with the defined label.
>=20
> >    I'm sure we've been over this territory before. Devices are not
> > labelled; filesystems are labelled. You are labelling the whole
> > filesystem, which exists over several devices, so the same label will
> > be attached to every device in the filesystem.
>=20
> But for what purpose offers "mkfs.btrfs" this option?

   So that you don't have to run the label command immediately after
making the filesystem. Most mkfs implementations for different
filesystems have something similar, usually with the -L option.

> >> Especially
> >>
> >>      blkid
> >>      findfs LABEL=3Dmylabel
> >>
> >> don't work.
>=20
> >    How do you mean, "don't work"? What are they showing, and what do
> > you think should they be showing?
>=20
> Without this double-labelled (?) devices "blkid" shows all devices with =
=20

   "Double-labelled"? The filesystem has one label, belonging to the
filesystem. I don't see where the "double-labelling" comes in.

> (if defined) their labels. When I define the same label for more than 1 =
=20
> device (btrfs or ext2fs or ...) then "blkid" shows nothing. No output =20
> for any of the devices.

   This is a fault in the version of blkid you're running, then.
There's nothing to stop me from labelling two ext2 filesystems with
the same label. If blkid can't handle that, then it's got problems
beyond btrfs. On my main machine, it seems to work correctly:

$ sudo blkid
/dev/sda: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"5fd56eec-5e26-4c1f-a02a-f86550e4aefe" TYPE=3D"btrfs"
/dev/sdc: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"4e392bea-f39a-4cba-b78c-c712479bf3f0" TYPE=3D"btrfs"
/dev/sde: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"5e2555bd-bf36-430b-af5a-aa81604afc96" TYPE=3D"btrfs"
/dev/sdp: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"404d13f5-0231-46db-a311-ad7a4f99eef3" TYPE=3D"btrfs"
/dev/sdr: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"90469059-f012-4b6e-9233-8c591cbeaa80" TYPE=3D"btrfs"
/dev/sdq: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"646d3d32-5193-4fcd-afb2-43f14122a149" TYPE=3D"btrfs"
/dev/sds: LABEL=3D"media" UUID=3D"3993e50e-a926-48a4-867f-36b53d924c35" UUI=
D_SUB=3D"f4d4dbb2-f2bb-4e54-bbf9-4bb5474e9ef1" TYPE=3D"btrfs"

   My blkid version:

blkid from util-linux 2.20.1 (libblkid 2.20.0, 19-Oct-2011)

> "findfs": with double-labelled devices "findfs" doesn't find any label.

   On my system, the filesystem with label "media" exists on
/dev/sd{a,b,c,e,p,q,r,s}:

$ sudo blkid -L media
/dev/sdb
$ sudo findfs LABEL=3Dmedia
/dev/sdb

   In each case, it's giving me the path of a block device node which
I can use to mount the filesystem. As far as I know, this is the
correct and expected behaviour.

> > It looks like both of them print an
> > arbitrary device node of the devices that the FS lives on. Given that
> > both of these tools probably expect a one-to-one relationship between
> > a block device and a filesystem, this is not unreasonable.
>=20
> May be that "this is not unreasonable". But when "mkfs.btrfs" offers the =
=20
> "label" option I don't expect this behaviour.

   You're running mkfs. Why would you expect running mkfs *not* to
make a new filesystem? This is the behaviour on all other mkfses.

   From the man page:

DESCRIPTION
       mkfs.btrfs is used to create a btrfs filesystem (usually in a disk p=
ar=E2=80=90
       tition,  or  an  array of disk partitions).  device is the special f=
ile
       corresponding to the device (e.g /dev/sdXX  ).   If  multiple   devi=
ces
       are specified, btrfs is created spanning across the specified  devic=
es.

i.e. it's a tool to create a filesystem.

> I had mentioned this problem more than a year ago, it still exists.

   It's not a problem. Everything is working as expected and as
designed.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---            =20

--alCHniwhwUTljuKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOW5f79z9OVl50rAAQJSyxAAk9S2PrrQNoIQQuORzhVxSz0q8miCC9rE
TMdDYHQ68Xge3VlGHaZ7XwZTyQSMmGjbSje5dTbb4aBf6QFfBp5+bxp/I7i7gcqq
sGqDI1gJl+F8tCjdZL6gvC4cI7AF7kPGAODyHLu1dh7r9PrMdgssoI83QFUeuilW
E3FHX99PrEbKy+3d+5IucawES/BdVUvrIt83jPODEiXuT9rRPsuF/e5EQe1Ue9xp
Ho7M5HEkMU5ktN9EXi10TxpPPAXl1QxfrlQ5NHSwYHH00yLRIWzex6NcrizLvV2a
7zTIv2H8rPd9cWOTlJkAHfqGbWu9eg9EXEBu++wMPZD2FZ109pXv5jcTqz4ZvbzK
H0/0GXZGRRsI1T0UFzMoDF7ZUMiEmR/ZIAYlougkDy71rO74OSvrvp6zOsgnnLyb
m042KIIsLldIeiEADIeDMgq13bnLaeuqZI+yatd4dQrs7dELgkLMqBy44ph7xkiI
1xhMbySFfX6mN/9L3qKrlFMSNFVgzk7oZfX8cnYcFE8tuJNcxIC03CAFUWikatlE
l5kX98L6oJBx9bEjlo+yh3UPeoSq3rcvS8EaviDqoP3/48VyEIdh0+po+pmmsSv7
gD9jipwNPYU71WZfgt0J3ybNDS6h1gPmkYGnU5tA+hgiWtAl+SmTk3hkLrE0wNYU
ZiYzfGbj/h8=
=vnrw
-----END PGP SIGNATURE-----

--alCHniwhwUTljuKz--
