From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Sat, 9 Apr 2011 00:19:20 +0300
Message-ID: <20110409001920.089c4409@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
	<20110409000932.6154c7b5@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r=FWQPGEUGFyI7PzoQMaJ+A"; protocol="application/pgp-signature"
Cc: liubo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409000932.6154c7b5@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/r=FWQPGEUGFyI7PzoQMaJ+A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > When a btrfs disk is created by mixed data & metadata option, it will h=
ave no
> > pure data or pure metadata space info.
> >=20
> > In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b344d=
6c920
> > (Btrfs: fix OOPS of empty filesystem after balance) initializes space i=
nfos at
> > the very beginning.  The problem is this initialization does not take t=
he mixed
> > case into account, which will cause btrfs will easily get into ENOSPC i=
n mixed
> > case.
> >=20
> > Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> > ---
>=20
> Tried to apply this patch on top of 2.6.39-rc2 and booted on the same par=
tition.
> It has 3.2 GBs free. With patch it started to report -ENOSPC right out.
> Attempt to delete some files caused OOps:

Sorry, I was too fast. The same OOps is reproducible on vanilla 2.6.39-rc2.=
 Will retest on 2.6.39-rc1.

--=20

  Sergei

--Sig_/r=FWQPGEUGFyI7PzoQMaJ+A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2fe9gACgkQcaHudmEf86qy5ACeJMIP71A2fui5CJzE5eIQeq5E
IvsAn2p81ykzS/GqGAWG1FI2KZRgcYeO
=IGsu
-----END PGP SIGNATURE-----

--Sig_/r=FWQPGEUGFyI7PzoQMaJ+A--
