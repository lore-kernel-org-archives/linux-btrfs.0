Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47529 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2EXIlC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 04:41:02 -0400
Date: Thu, 24 May 2012 09:40:58 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Bj=F6rn_W=FCst?= <Bjoern.Wuest@iteratec.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Preparing single-disk setup for future multi-disk usage
Message-ID: <20120524084058.GD31037@carfax.org.uk>
References: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
In-Reply-To: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 24, 2012 at 08:05:23AM +0200, Bj=F6rn W=FCst wrote:
> Good morning,
>=20
>=20
> I currently have a single-disk setup where I want to use btrfs filesystem=
=2E Yet, I expect to add additional disks to this system in the future. Tho=
se disks shall be visible to the OS like a single disk, i.e. using multi-di=
sk feature in btrfs. While data shall be striped among those disks in the f=
uture, meta data shall be mirrored for better fault tolerance (loss of some=
 data is acceptable, while loss of all data is not acceptable).
>=20
> btrfs supports multi-disk setups and even adding additional devices at a =
later point of time. Thus, it is my preferred choice. However, I am puzzled=
 how the mkfs.btrfs command must be parametrized to have RAID1 for meta dat=
a and RAID0 for data with just a single disk / partition. Could I simply do=
 mkfs.btrfs -m raid1 -d raid0 /dev/sdaX (where X is the partition number) ?

   No, this will fail to work, as RAID-1 and -0 both require at least
two disks. What you need to do is use the default settings (mkfs.btrfs
/dev/sdaX) for now, which will give you DUP metadata (two copies of
each block, in different places on the disk), and "single" data (one
copy of the data).

   When you add a new disk, you can convert the replication to
something else, using the balance command:

# btrfs dev add /dev/sdY /mountpoint
# btrfs balance start -dconvert=3Draid0 /mountpoint

(Note that you don't need to specify -m raid1 to convert the metadata,
as the DUP->RAID-1 conversion is implicit where it's possible).

> Unfortunately, I do not have a disk to test it right now. The disk I am p=
lanning to use is with the post service still :) . Searching the Web could =
not reveal a similar scenario. All multi-disk examples assume that you alre=
ady have multiple disks and not that you are going to have them.

   The conversion code is quite new, so there's few examples out there
right now.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- There are three things you should never see being made: laws, --- =20
                        standards,  and sausages.                       =20

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPvfQaIKyzvlFcI40RAmFrAJ9xaHQVBrqkAhIGVjDQSspyahC0OwCgrt0/
cJHGU8kA6JgbF95mEabMznc=
=5clZ
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
