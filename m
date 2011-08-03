From: mck <mck@apache.org>
Subject: Re: Btrfs slowdown
Date: Wed, 03 Aug 2011 17:56:33 +0200
Message-ID: <1312386993.23947.7.camel@localhost>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
	 <4E2D2E7D.3040303@podzimek.org>  <4E2D3B4D.8050301@podzimek.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iyYfdcMOC3+CbEX+AK18"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2D3B4D.8050301@podzimek.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-iyYfdcMOC3+CbEX+AK18
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


I can confirm this as well (64-bit, Core i7, single-disk).

> The issue seems to be gone in 3.0.0.

After a few hours working 3.0.0 slows down on me too. The performance
becomes unusable and a reboot is a must. Certain applications
(particularly evolution ad firefox) are next to permanently greyed out.

I have had a couple of corrupted tree logs recently and had to use
btrfs-zero-log (mentioned in an earlier thread). Otherwise returning to
2.6.38 is the workaround.

~mck

--=20
"A mind that has been stretched will never return to it's original
dimension." Albert Einstein=20
| www.semb.wever.org | www.sesat.no=20
| http://tech.finn.no | http://xss-http-filter.sf.net


--=-iyYfdcMOC3+CbEX+AK18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk45b7EACgkQkdPrePiuutNv7ACghO4TBt6RczJA5K20tl3zAAXf
TDAAmwTE7y3x/RtYV/x9aO3+TR4V4Hpz
=ZIr2
-----END PGP SIGNATURE-----

--=-iyYfdcMOC3+CbEX+AK18--


