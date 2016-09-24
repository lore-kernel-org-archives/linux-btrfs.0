Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34078 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754918AbcIXMn1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 08:43:27 -0400
Date: Sat, 24 Sep 2016 12:43:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: Alexander Tomokhov <alexoundos@ya.ru>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160924124323.GS7138@carfax.org.uk>
References: <767591474719974@web21o.yandex.ru>
 <20160924174012.51d44caa@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1WN/MJ7JJGqVzwIW"
In-Reply-To: <20160924174012.51d44caa@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1WN/MJ7JJGqVzwIW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 24, 2016 at 05:40:12PM +0500, Roman Mamedov wrote:
> On Sat, 24 Sep 2016 15:26:14 +0300
> Alexander Tomokhov <alexoundos@ya.ru> wrote:
> 
> > does setting No_COW on a file (chattr +C) imply disabling data checksumming on it?
> 
> Yes. IIRC the reasoning was that it's more difficult to track checksums of
> data which is being overwritten in-place (as opposed to CoW).

   It's because you can't update the data and the checksum atomically
-- at some point in the writing process, they must be inconsistent.
This is considered a Bad Thing.

   Hugo.

> > may it disable checksumming only for newly written extents and keep for reading existing ones?
> 
> You can't apply chattr +C to any files of non-zero length, so by definition
> there won't be any pre-existing checksummed extents in that file.
> 
> -- 
> With respect,
> Roman



-- 
Hugo Mills             | Comic Sans goes into a bar, and the barman says, "We
hugo@... carfax.org.uk | don't serve your type here."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--1WN/MJ7JJGqVzwIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX5nTrAAoJEFheFHXiqx3kXQMQAI9yAXSDLtDccg+W6ofyHWys
dCB6BT/93IpnzaNk8G+Hcx8UaI7KOj9sdwXksuyKwLng8nNbIzztLv3Nt6yCw1Co
0vqQ5+90euF7c39iXtxpGFGccj7YIOf+JR2DDM6gqGsYBD6lCPLZWW76/uW56Opy
M/0WYeGs6s9xT3/DV2h79waQ47aZbufrfp/MPGe4vaiP2qsSSdyFSdqOLO/XdUhR
C9r/zgfikwH+FO0Tv6qi5VWFkgyZva0RAw7D4P2U5BBwclko6OeNOUPO0PMqve65
BP1EMKFa56mmq+fG0G2VHuCv8FO0as6ZLr0r03CJyU7CP9EQVnFbUWR2BRPGTjBl
iAkijWUC5p3wQvNd3jziJvvYUrPLXwZQHA/B4b4yQBAGjPcsWhWznJsVkUoqR5qU
qGwm4E0q47mh4ASVd/OYanKuUglET3J+D5ql5slWsrn5zuKun3e6FXEA5r/XP3Al
zqSsMhSAWUOqYxWNN6EAsGquFnh0qutm2ySeCpEFlEL29J4ydSXjh35KTlHniOgB
kICJwaedY19HedaargpQ9WSiHBhhuBvcjHiPjIY7zCIuNh4BzUbBi0naVG9xQtG/
GO6mOqzIkcZyb89g7bH5gyzPp8Ea0X4QK7ZQTmDUBHeiaWtBk7PuC2zs5jH15ql6
SREeYOMaSaOT1T3uGXkb
=OXNP
-----END PGP SIGNATURE-----

--1WN/MJ7JJGqVzwIW--
