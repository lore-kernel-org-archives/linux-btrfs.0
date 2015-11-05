Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59083 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031006AbbKELtQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 06:49:16 -0500
Date: Thu, 5 Nov 2015 11:49:14 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: OmegaPhil <OmegaPhil@startmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Unable to allocate for space usage in particular btrfs volume
Message-ID: <20151105114914.GD27446@carfax.org.uk>
References: <563A7452.4050202@startmail.com>
 <20151104213039.GC27446@carfax.org.uk>
 <563A7E45.1050806@startmail.com>
 <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
 <563B3323.8080609@startmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
In-Reply-To: <563B3323.8080609@startmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 05, 2015 at 10:44:51AM +0000, OmegaPhil wrote:
> So a couple of gig still unaccountable but irrelevant. Thanks, problem
> solved! Although hopefully checksumming will be allowed on nocow files
> in the future as thats currently 17% of all data unprotected and will
> get worse...

   It's not likely to happen. If you're modifying data in-place (as is
the case on nodatacow files), then there's a window of vulnerability
between modifying the data and modifying the checksum records during
which the checksums are incorrect. This breaks the consistency
guarantees of the FS.

   Hugo.

-- 
Hugo Mills             | Nostalgia isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWO0I6AAoJEFheFHXiqx3kjgcP+wTFO2NRE+5VilQCHpTbdJXx
t93kohw62IC7MzgpfpToH4SzWPTE8X7j0arpxMb4SftXE9vbkuydlUvg/yvmE6eT
VLRvZsuNHprV+6YvGd/SGTzTy7PvlwEZeKP7+Axq4SJAtut0agrT97q8x356rYGg
MYCm6Wkugtz2MaJcTmmFHKL7c+aqfyB3saCbfwV5uTSJbNUm0h0z2sZUYPd4IASa
b90VXIMosn94andew4fOI31HIoyffBkFMe2d4XER+j7pQikVVmzhi4iwaFT/U7oo
2/1iLRg/IksHJ/ZSB2lJYHlw6d5Ri2NkmackfFRES/fMEWXJDgMBDKNL1lSjFyxy
rhUDU0C/0qYyXztVbZqeIsUZBvylWPgSknDU5ZbrEgri5pvXW0FzAZtCMZJWcbj5
8FiqUpFnQo1+meIdMdArtz/Ltrftvt3zU2qeTk0mdvpcGwRzWe9K4YvhCK8JpJDY
7z5z842oWpO5lyFuw2lj/1LYpxFjDxppaVqWMb+qVxavvEvd7vklkkJpc6k8M61b
of0edeN7D2JRfOygW3mVgGil+yGoylF61icEvOtcSSY22asd3pzx709FyTkR3UzA
D8KEJzJfmNWGC2olgtYEPiF118mIvUJbtPR4eZtJgQQ+3v3pETkuhS5FHGamrdm9
2G8KLcQqZsjvjr9UMFqD
=h9+O
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--
