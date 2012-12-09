Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:35196 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307Ab2LIKvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Dec 2012 05:51:07 -0500
Date: Sun, 9 Dec 2012 16:41:25 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-btrfs@vger.kernel.org,
        =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Subject: Re: BTRFS, getting darn slower everyday
Message-ID: <20121209164125.1bd91f23@natsu>
In-Reply-To: <alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr>
References: <50714AC8.4010100@petaramesh.org>
	<201210071259.05801.Martin@lichtvoll.de>
	<50718C44.2080701@petaramesh.org>
	<201210071648.54027.Martin@lichtvoll.de>
	<alpine.LNX.2.01.1212090614400.31120@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2ueMCaAqcC6+IwFo6mzaaD2"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/2ueMCaAqcC6+IwFo6mzaaD2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Dec 2012 06:17:39 +0100 (CET)
Jan Engelhardt <jengelh@inai.de> wrote:

>=20
> On Sunday 2012-10-07 16:48, Martin Steigerwald wrote:
> >>=20
> >> # btrfs su li /
> >> ID 256 top level 5 path UBUNTU
> >> ID 259 top level 5 path UBUNTU/@
> >> ID 261 top level 5 path UBUNTU/@tmp
> >> ID 262 top level 5 path UBUNTU/@home
> >>[...]
> >
> >This could be 100 or more subvolumes / snapshots.
> >Maybe slowness could be related to this one.
>=20
> Absolutely. COW snapshots cause severe fragmentation (it's
> in their nature).

CoW filesystem incurs fragmentation by its nature, not specifically snapsho=
ts.
Even without snapshots, rewriting portions of existing files will write the
new blocks not over the original ones, but elsewhere, thus increasing
fragmentation.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/2ueMCaAqcC6+IwFo6mzaaD2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDEatUACgkQTLKSvz+PZwh4mgCgmR9zqbzx03SwPQjKlxfyZh2R
oJsAnipGH5vqOjGN7bWwOWrex2bleMSi
=XcBs
-----END PGP SIGNATURE-----

--Sig_/2ueMCaAqcC6+IwFo6mzaaD2--
