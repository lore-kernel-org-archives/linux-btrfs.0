Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:56705 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaFDHTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 03:19:33 -0400
Date: Wed, 4 Jun 2014 09:19:26 +0200
From: Christian Hesse <mail@eworm.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/1] btrfs-progs: fix compiler warning
Message-ID: <20140604091926.37ad5ef2@leda.localdomain>
In-Reply-To: <538EC135.6060105@cn.fujitsu.com>
References: <1401794959-25907-1-git-send-email-mail@eworm.de>
	<538EC135.6060105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OletGAyR3aGhpbg6o9P0StW"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/OletGAyR3aGhpbg6o9P0StW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Qu Wenruo <quwenruo@cn.fujitsu.com> on Wed, 2014/06/04 14:48:
>=20
> -------- Original Message --------
> Subject: [PATCH 1/1] btrfs-progs: fix compiler warning
> From: Christian Hesse <mail@eworm.de>
> To: linux-btrfs@vger.kernel.org
> Date: 2014=E5=B9=B406=E6=9C=8803=E6=97=A5 19:29
> > gcc 4.9.0 gives a warning: array subscript is above array bounds
> >
> > Checking for "greater or equal" instead of just "equal" fixes this.
> >
> > Signed-off-by: Christian Hesse <mail@eworm.de>
> > ---
> >   cmds-restore.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/cmds-restore.c b/cmds-restore.c
> > index 96b97e1..534a49e 100644
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > @@ -169,7 +169,7 @@ again:
> >   			break;
> >   	}
> >  =20
> > -	if (level =3D=3D BTRFS_MAX_LEVEL)
> > +	if (level >=3D BTRFS_MAX_LEVEL)
> >   		return 1;
> >  =20
> >   	slot =3D path->slots[level] + 1;
>
> Also I faied to reproduce the bug.
> Using gcc-4.9.0-3 from Archlinux core repo.

Exactly the same here. ;)

> It seems to be related to default gcc flags from distribution?

Probably. I did compile with optimization, so adding -O2 may do the trick:

make CFLAGS=3D"${CFLAGS} -O2" all
--=20
Schoene Gruesse
Chris
                         O< ascii ribbon campaign
                   stop html mail - www.asciiribbon.org

--Sig_/OletGAyR3aGhpbg6o9P0StW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjsiDAAoJEFTtyRYJvJGDnM4QAJCKzK/whgQ3MhDkqFfs8pER
L6qLnbYkfpHIrL/chKd9Imd+PlKAvWIYVd4CSx5eZrhTlm1ScyN+D1S1qFKpN7lj
/wod4T2ccyVawD0xgJgcybNxwouyLsxo+fWn+jDQfyIHl2Rf8RIx0IwwftBHDTDj
x9Zcqp/blamCRJ/EQj113/qZWMX63rYFKT9Jb06+rdB4Z3iZS8HIPu3QtYZ3Oxst
IEiXe+AvUAJOr4TH+c97vp6vcDFAx2zsN7aszpmxLvSfJP3iELVafQ1QMF0IBv6t
/oP8DBnjg9wUI1iXjhRjaj3Wv8vA+kyxoUcQSfCh6sgmBCaMEiRsiFg/A144TI9M
qRcNojb3O+yrdvIja6CWxFzEhP7skP4MjEHCbFuTztkTNtmxcYnfDW4XfzKyxQ84
w6lfZoVeqimoEXDRfVVQ3+ukOft3kmS6gi+QevNwKH6uNSTKPpRuMTtEjAkaaefT
U1po6mFHSVKyF4ZXGBypWIkOPewlpdaFwIh0L3rqIq/dKEIPtN4n2ieQiWTriUvz
Fml3khqTYexECslrAEfR9Zc0VP5DRmolzwhyXv6MjQg8sHa1EVu4Aei5gpDxqv1J
Jyobaa/Hf8Lk57kPjAanFJaNROlYMY6CXC2dgpFYlcpVFPBIiUSqAOoz1FR9zEGU
ytZdCUtOC0aOiFKEPLCE
=AjGo
-----END PGP SIGNATURE-----

--Sig_/OletGAyR3aGhpbg6o9P0StW--
