Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:38826 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbbFURbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jun 2015 13:31:23 -0400
Date: Sun, 21 Jun 2015 22:31:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is there a "nossd" option ?
Message-ID: <20150621223121.617b8894@natsu>
In-Reply-To: <1586648.BNplRrhkhg@zafu>
References: <1586648.BNplRrhkhg@zafu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l0TZUGRil/SmVFQVL_H040j"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/l0TZUGRil/SmVFQVL_H040j
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Jun 2015 19:13:10 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Hi,
>=20
> Running a 3.19 Ubuntu kernel,
>=20
> I'm currently budling a RAID-1 BTRFS set for which every underlying devic=
e is=20
> a LUKS-encrypted device itself built out of a bcache device comprised of =
a=20
> mechanical HD partition + an SSD cache partition.
>=20
> Looks like it's working.
>=20
> BUT I see that BTRFS decides by itself to mount with the "ssd" option as =
=20
> bcache makes it think the device is not "rotational".
>=20
> However I feel that a mechanical HD plus SSD bcache should probably not b=
e=20
> "SSD-optimized" as the underlying storage is indeed mechanical and bcache=
=20
> already manages the SSD part optimization by itself - and I'm afraid the =
"SSD=20
> optimization" could actually cause the mechanical storage to end up being=
 much=20
> more fragmented than it should...
>=20
> So the question is : Is there a mount option such as "nossd" that I could=
 use=20
> to inhibit the automatic SSD "choice" that BTRFS makes ?

Yes the "nossd" option (written literally like that) does in fact exist.
It would have taken you less time to try if it works, than to write this
long-winded message. :)


--=20
With respect,
Roman

--Sig_/l0TZUGRil/SmVFQVL_H040j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWG9OkACgkQTLKSvz+PZwguTgCfSF66/r4v+z6gJSVL0Pi3WPZ4
0YAAoJAQ3l3a6UnasXi1mBrcyEgoUllw
=UN8W
-----END PGP SIGNATURE-----

--Sig_/l0TZUGRil/SmVFQVL_H040j--
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
