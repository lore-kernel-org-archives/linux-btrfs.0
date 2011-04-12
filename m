From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Wed, 13 Apr 2011 00:23:33 +0300
Message-ID: <20110413002333.3d78d4d1@sf>
References: <20110410133710.0ef34cb6@sf>
	<20110410184249.483d8d67@sf>
	<20110410230622.09e965ae@sf>
	<20110410232403.617c3b7f@sf>
	<20110410235846.135e801e@sf>
	<4DA32055.2030104@redhat.com>
	<20110411224452.4a5149da@sf>
	<4DA35B98.3010800@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aVo_awc9eZJyudFY=KBqwrx"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	cwillu <cwillu@cwillu.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA35B98.3010800@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/aVo_awc9eZJyudFY=KBqwrx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Apr 2011 15:50:48 -0400
Josef Bacik <josef@redhat.com> wrote:

> On 04/11/2011 03:44 PM, Sergei Trofimovich wrote:
> >> Fix data corruption caused by memcpy() usage on overlapping data.
> >> I've observed it first when found out usermode linux crash on btrfs.

...

> Fair enough, BUG_ON() it is.  Repost that version and you can add my
>=20
> Reviewed-by: Josef Bacik <josef@redhat.com>

Thank you! Added and resent as:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09357.html

--=20

  Sergei

--Sig_/aVo_awc9eZJyudFY=KBqwrx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEUEARECAAYFAk2kwt0ACgkQcaHudmEf86pl5gCXRh+cxSeT/cJO9Gb39hDeT2zh
ewCfZCUV8XPUvERy8xNILeaTHrJq8I0=
=z/O7
-----END PGP SIGNATURE-----

--Sig_/aVo_awc9eZJyudFY=KBqwrx--
