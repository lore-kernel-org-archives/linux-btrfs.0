Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:56191 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbCVVZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 17:25:13 -0400
Date: Mon, 23 Mar 2015 02:25:14 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ochi <ochi@arcor.de>
Cc: rbellamy@pteradigm.com, linux-btrfs@vger.kernel.org
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
Message-ID: <20150323022514.2d805594@natsu>
In-Reply-To: <550F3103.7080609@arcor.de>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
	<550F3103.7080609@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//bPphq+gUaw/5=dQ7MFUKmN"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//bPphq+gUaw/5=dQ7MFUKmN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Mar 2015 22:15:47 +0100
Ochi <ochi@arcor.de> wrote:

> > When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
> > INFO: task mount:302 blocked for more than 120 seconds.
> > INFO: task btrfs-transacti:329 blocked for more than 120 seconds.
>=20
> I had a similar behavior today after I accidentally pulled the power=20
> plug of my machine (Arch Linux, Kernel 3.19.2). I tried to boot several=20
> times, but "mount" timed out.

This message by itself is not a "time out" of any kind, it's just a warning
which says exactly what it says and nothing more. If you are certain that
there was no access whatsoever to the HDD/SSD (the access light not flashin=
g),
then yeah maybe it got stuck. But it also could be it simply needed 1-2 more
minutes to complete whatever it was doing.

--=20
With respect,
Roman

--Sig_//bPphq+gUaw/5=dQ7MFUKmN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUPMzoACgkQTLKSvz+PZwgOSACeKT6M+h4+0htEgWfRLNe6MHB1
l3oAnRb9tknKrhLaD1j7J22MVvCXiTUu
=SLsh
-----END PGP SIGNATURE-----

--Sig_//bPphq+gUaw/5=dQ7MFUKmN--
