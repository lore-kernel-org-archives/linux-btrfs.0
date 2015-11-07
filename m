Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42711 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbbKGTSS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 14:18:18 -0500
Date: Sat, 7 Nov 2015 19:18:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: boot from snapshot and take snapshot from here.
Message-ID: <20151107191817.GF27446@carfax.org.uk>
References: <4iu1hc-23v.ln1@aldebaran.xundeenergie.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fwqqG+mf3f7vyBCB"
In-Reply-To: <4iu1hc-23v.ln1@aldebaran.xundeenergie.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fwqqG+mf3f7vyBCB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 07, 2015 at 08:04:01PM +0100, Jakob Sch=FCrz wrote:
> Hi there!
>=20
> I can't find any Information for my Problem. And I try to explain, what
> I want.
[snip]
> BUT
>=20
> When i boot from f.e. @debian-snap2, the mechanics doesn't work any longe=
r.
>=20
> btrfs subvol snapshot @debian-snap2 @debian-snap3
>=20
> this works.
>=20
> btrfs send -p @debian-snap2 debian-snap3 | btrfs receive /backupmountpoint
>=20
> gives me an error, that btrfs can't find a subvol with a proper ID.
>=20
> Ho to do this, if i want to boot from a former snapshot (in case of a
> mistaken system-upgrade) and i want to transfer the later snapshots to
> the external HD - only the differences?

   Basically, you can't right now. It's a known limitation, and can, I
think, be fixed, but it'll need a change to the send stream format,
which is a tricky migration to do (because there's currently no format
identifier in it, which makes it hard to handle both formats easily).

> There is nothing on the internet on this problem (I've found). But i
> think this is a usecase, which I'm not alone needing it...

   You're not alone. It will come eventually, but only when David's in
a position to deal with the issues of changing the send stream.

   Hugo.

--=20
Hugo Mills             | "No! My collection of rare, incurable diseases!
hugo@... carfax.org.uk | Violated!"
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                Stimpson J. Cat, The Ren & Stimpy S=
how

--fwqqG+mf3f7vyBCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWPk54AAoJEFheFHXiqx3ki8gP/0qo4YMef9Rt3vLIPNq0rcPt
m5LYWXKSQU722/H0K8Qa6ghJEwCdKxTNer3xJ8Q720l5yfki6WS0ie4aLpbb27jN
o10eFNN+hM+3jMiCaQDK4Up2wp37TbkI8D1gXg+WZv1KboHGyrcmJDgMGL+MjQjo
WDPLbSJg3XVV2PNZzvYt2ZTQn0kSx5eXbG82X4jPeqJXqaPq5ieLZOxBdJCcBbLh
tHv4V0olWk8TXMcQe0O3Ma1p5VcqaAKrHQrYolBcapak3QDw+Kf/qlCAKd2Tk3fN
nndnAxIuXn+lKpHLc/r/eWyAg8670NeHb5pPKkUuuQQclQo6pg9x+bcBtag3LMO8
41KL6MDvrg4Hyt4GCoUvRDbxu4UaqUxpTRkv+Z0wX+gYLZdWGmJo6gFnkuoo4o3j
FTWD0h9QiLvgCr8lIk5rYJp5nXTGxwXCndtNq1P5WQ2FaPiNlpXc4GdU9izUSRmU
qQv4JOrYEYeoWEijUDiw2SN9uSb2LtcWmLqc63wWSsWxl0Hm5QbQcmxL9rMd96h4
Ht9Dp3ZtXis1E88ESSzXE/IOEEUEai4KBgjw9U7VfRLXEDxctjj9OnpVe+0TCAPB
Yfg7wbijsY7KHMinyC5Flx+xI5nSyzW69mDPS186yha72CFbQnAN24vSjnnp7W9V
3TsssqAWyztTut3WTL69
=0VzB
-----END PGP SIGNATURE-----

--fwqqG+mf3f7vyBCB--
