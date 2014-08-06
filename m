Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35584 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaHFM2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 08:28:30 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Date: Wed, 06 Aug 2014 14:28:17 +0200
Message-ID: <2081055.UhRBjlI1Dc@merkaba>
In-Reply-To: <20140806102918.GA3968@carfax.org.uk>
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com> <3143412.n5KSJct7YP@merkaba> <20140806102918.GA3968@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4616474.pi2G4bb5Gf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4616474.pi2G4bb5Gf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 6. August 2014, 11:29:19 schrieb Hugo Mills:
> On Wed, Aug 06, 2014 at 12:21:59PM +0200, Martin Steigerwald wrote:
> > It basically happened on about the first heavy write I/O occasion a=
fter
> > the BTRFS trees filled the complete device:
> >=20
> > I am now balancing the trees down to lower sizes manually with
> >=20
> > btrfs balance start -dusage=3D10 /home
> >=20
> > btrfs balance start -musage=3D10 /home
>=20
>    Note that balance has nothing to do with balancing the metadata
> trees. The tree structures are automatically balanced as part of thei=
r
> normal operation. A "btrfs balance start" is a much higher-level
> operation. It's called balance because the overall effect is to
> balance the data usage evenly across multiple devices. (Actually, to
> balance the available space evenly).
>=20
>    Also note that the data part isn't tree-structured, so referring t=
o
> "balancing the trees" with a -d flag is doubly misleading. :)

Hmm, it makes used size in

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: [=E2=80=A6]
        Total devices 2 FS bytes used 129.12GiB
        devid    1 size 160.00GiB used 142.03GiB path /dev/dm-0
        devid    2 size 160.00GiB used 142.03GiB path /dev/mapper/sata-=
home

and I thought this the is size used by the trees BTRFS creates.

So you say it does not balance shortest versus longest path but=E2=80=A6=
 as the tree=20
algorithm does this automatically=E2=80=A6 but just the *data* in the t=
ree?

In any way: I should not be required to do this kind of manual maintena=
nce in=20
order to prevent BTRFS from locking up hard on write accesses.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart4616474.pi2G4bb5Gf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlPiH2wACgkQmRvqrKWZhMflWwCfc/xp47wRK6g6V61m16PbnwlN
GxUAn18HqIa/3PyoRsnyBS82u2DpMvCW
=8xtp
-----END PGP SIGNATURE-----

--nextPart4616474.pi2G4bb5Gf--

