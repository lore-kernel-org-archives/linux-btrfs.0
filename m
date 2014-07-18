Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:37099 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbaGRKzd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 06:55:33 -0400
Date: Fri, 18 Jul 2014 16:55:26 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
Message-ID: <20140718165526.1269b43e@natsu>
In-Reply-To: <pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
References: <1405627978.2630.39.camel@s-Air>
	<e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
	<pan$b430d$ca43159e$977364a9$ed50906b@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h1P3uSEmpyjAG4aRXR1L.TN"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/h1P3uSEmpyjAG4aRXR1L.TN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2014 10:45:37 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Russell Coker posted on Fri, 18 Jul 2014 14:35:20 +1000 as excerpted:
>=20
> > Daily snapshots work welk with kernel 3.14 and above (I had problems
> > with 3.13 and previous). I have snapshots every 15 mins on some subvols.
> >=20
> > Very large numbers of snapshots can cause performance problems. I
> > suggest keeping below 1000 snapshots at this time.
>=20
> The other caveat with btrfs snapshots is how they deal with NOCOW files,=
=20
> the usual workaround recommended for large (Gig-ish-plus) internal-
> rewrite-pattern files such as databases and VM images.

And "how" do they deal with them? To the best of my knowledge there is no
"caveat" whatsoever, NOCOW and snapshots interact perfectly, exactly as it
should be (snapshotted and then changed bits get COW'ed, but only once).

--=20
With respect,
Roman

--Sig_/h1P3uSEmpyjAG4aRXR1L.TN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPI/R4ACgkQTLKSvz+PZwg3yQCfR4AC3N547FmbTjh/pbDUz3j7
H80AnjTwXcagB0+jRbEe13kV70thiU9v
=GUni
-----END PGP SIGNATURE-----

--Sig_/h1P3uSEmpyjAG4aRXR1L.TN--
