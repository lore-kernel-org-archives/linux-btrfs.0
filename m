Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32873 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbHLRn4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 13:43:56 -0400
Date: Wed, 12 Aug 2015 17:43:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150812174352.GN12976@carfax.org.uk>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tn/+KOyBVBGpvvUM"
In-Reply-To: <CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tn/+KOyBVBGpvvUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[adding Ulli back into the cc list]

On Wed, Aug 12, 2015 at 11:03:00AM -0600, Chris Murphy wrote:
> On Wed, Aug 12, 2015 at 7:07 AM, Ulli Horlacher
> <framstag@rus.uni-stuttgart.de> wrote:
>=20
> > /dev/sdb and /dev/sde are in reality the same physical disk!
>=20
> When does all of this confusion happen? Is it already confused before
> mkfs or only after mkfs or only after mount? I would find out what
> instigates it, wipe all signatures from everything, reboot, start from
> scratch, and then strace the command that causes the confusion. And
> attach that output as well as the entire dmesg to a bug report. Just
> my 2 cents, I have no idea what's going on but sounds like a block
> layer and/or drdb bug that's triggered by Btrfs multiple device
> setups.

   If (some of) the DRBD host devices are also physically present on
the machine to which the DRBDs are exported, then you're in the same
situation as having block-level snapshots or dd copies of the data --
the FS will see two devices (the backing store and the DRBD) which are
have the same UUID. It will pick an arbitrary one to write to, which
is probably not something that the DRBD driver will cope with very
well, I suspect.

   I think the solution here would be to blacklist the backing store
=66rom btrfs dev scan. I recall that there was such a capability at some
point -- I don't know if it made it into the userspace tools?

   Hugo.

--=20
Hugo Mills             | Great oxymorons of the world, no. 7:
hugo@... carfax.org.uk | The Simple Truth
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--tn/+KOyBVBGpvvUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVy4XYAAoJEFheFHXiqx3ktaoP/2PGuSUFfwNUTf7HGElWDUzH
5mr8drOLPsy38I241TgSdPqTjU/IDeMmJ+XFecGIS65e9aOL1ggl+fiBJ/Oo8g61
uDkNUlJoZSg//rDmUG22WQ5vzlRDsN29sCLpXvlgeWoMel4l6MicehtCcqOyAw8p
qHnHzHEae8NIvA+gFrtr/HX4x/jE09SInAGR6BfL4s2nrkjxxak+8zlRZ39pj6bd
G1BdKLCRj61P5AySIqleju+SJI9+HyTGfBCJ+yD4RozTx3JhQ6IkIwXgnTp6bfxK
Uu5IcoVRw5fFTThkUm0vgyPLw2heXAWnjsMoJq6NxpesXf+hqTQRTtHi1gsv5cTh
L+LCkSldNpSLaWQDMGmuJ0ELMdyoODe6XBqVtJcjiKeq9AUIA2aVeTQ6XZWget75
qXzso81DKsHfi8WCpgG1l2gcb8aYLz0F7cdH4PqK8UqlHXZAzNs3wZyXInu7GoRN
VIOb6kfg8FSDuNzWAinWFlZlj/AASrRqqr9euti56ULxnY40A8WgBjSuaVzacY6s
uI4tyIHyL4qo5mxmmQZNujNMMyDPzMwR72nRlhjsluJQ7iGMefRgi6JJq3wLw6d4
54svtU8Wz5URQun49wJQxb6fWJNLjjFIpV23J7LI4wO6bwdHE2Lz/tjvY7ag1dOL
pMlQXf82RMFW3RxmatYO
=Hkcc
-----END PGP SIGNATURE-----

--tn/+KOyBVBGpvvUM--
