From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Fri, 22 Apr 2011 22:43:57 +0300
Message-ID: <20110422224357.1ca3ff3d@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t5l3R_Mv5oH=3NElVoIPyog"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9ECAF5.50108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/t5l3R_Mv5oH=3NElVoIPyog
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Apr 2011 16:44:37 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

>=20
> When a btrfs disk is created by mixed data & metadata option, it will hav=
e no
> pure data or pure metadata space info.
>=20
> In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b344d6c=
920
> (Btrfs: fix OOPS of empty filesystem after balance) initializes space inf=
os at
> the very beginning.  The problem is this initialization does not take the=
 mixed
> case into account, which will cause btrfs will easily get into ENOSPC in =
mixed
> case.
>=20
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---

This morning I've got an ENOSPC OOps on --mixed (properly created this time=
) FS
and 2.6.39-rc4 kernel. After applying this patch OOps gone away.

Unfortunately, I haven't saved the trace and can't reproduce it yet.

--=20

  Sergei

--Sig_/t5l3R_Mv5oH=3NElVoIPyog
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2x2oMACgkQcaHudmEf86plsQCeOFIB+76OMo4kOr5bUcWihc9p
RSUAnjQcDmwnmcvnEB8xFXpDwBZUsGQ+
=fAgz
-----END PGP SIGNATURE-----

--Sig_/t5l3R_Mv5oH=3NElVoIPyog--
