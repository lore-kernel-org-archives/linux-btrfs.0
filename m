Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33325 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaCWWwd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 18:52:33 -0400
Date: Sun, 23 Mar 2014 22:52:29 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Any use for mkfs.btrfs -d raid5 -m raid1 ?
Message-ID: <20140323225229.GJ25400@carfax.org.uk>
References: <20140323224435.GC18293@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG0Ll82vYr46+VA1"
In-Reply-To: <20140323224435.GC18293@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--LG0Ll82vYr46+VA1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 23, 2014 at 03:44:35PM -0700, Marc MERLIN wrote:
> If I lose 2 drives on a raid5, -m raid1 should ensure I haven't lost my
> metadate.
> From there, would I indeed have small files that would be stored entirely=
 on
> some of the drives that didn't go missing, and therefore I could recover
> some data with 2 missing drives?

   btrfs's RAID-1 is two copies only, so you may well have lost some
of your metadata. n-copies RAID-1 is coming Real Soon Now=E2=84=A2 (Chris h=
as
it on his todo list, along with fixing all the parity RAID stuff).

> Or is it kind of pointless/waste of space?
>=20
> Actually, would it make btrfs faster for metadata work since it can read
> from n drives in parallel and get data just a bit faster, or is that most=
ly
> negligeable?

   I don't think we've got good benchmarks from anyone on any of this
kind of thing.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Great oxymorons of the world, no. 9: Standard Deviation ---    =20

--LG0Ll82vYr46+VA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy9lrVheFHXiqx3kAQJ01w//YBPCXeOwG9GyXczM5fceBJ3f6ghZ7Bce
1zIFaSoGrQ0jguRrfaUV9OoK3efgidUaJXEox7Xjp9AlfqOabrwiuq/LY8OY/zR7
jOz7Go5HkOBS+nI9YBjSvlh8ZXtC3SgKn9THlXxD5bAOrVRwOFg3HkASl+EgBU4g
IGiyKc88faz3MB9y2SQ2KStGpkBFpKY6zcQpMkMWnviT0FMZtpOa5L/q8HNBwM3T
33/NDYV984xkxOD4S0pdIUjxua67fg/BsJ1pnjhL7gr966SstmjY2LSIAtzQDzZM
TOytowNThM77QK+23KAPcX1CBd5xQSI2RZSxzKqUmOF19vSTDvbV9Reiw4PNd3lv
P6+ww3CXs2+ZYwii+zaDXo9l5q5yFeKHHx7eQEq0eUBE2J/ovcL1+MFEBYIJZSg6
eOb/ZQXxVvQx8jQaS38s1msBuDGLDH8tg+rn/gvkyn37H7wIiRbcg4JYQfasi7Rc
SmlNBoCWX5fmpHXQZDC0Iz4CrjZN89ygGS1auJzyxXRIWvn4h+poHpd3lL74aGEJ
yX02bIjmKZLHqfPTQaArGm9yFG1cFbTRISt8TwHXzbnRcdVW3QexnIFM5Dm6BOdU
tsPqF/y061peQ22W4oKnmi8fPwFnkS4nsYCM7YKqtL+Z+HQwgRKiAdju+tN8sY67
bm2MhTFBmwU=
=6SDC
-----END PGP SIGNATURE-----

--LG0Ll82vYr46+VA1--
