Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47817 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbIHMNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 08:13:00 -0400
Date: Tue, 8 Sep 2015 12:12:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter =?utf-8?B?S2XFoWU=?= <peter.kese@viidea.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid6 + hot spare question
Message-ID: <20150908121258.GM23944@carfax.org.uk>
References: <55EECD97.7090109@viidea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NJSRbAqOy4NeGDns"
In-Reply-To: <55EECD97.7090109@viidea.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NJSRbAqOy4NeGDns
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2015 at 01:59:19PM +0200, Peter Ke=C5=A1e wrote:
>=20
> I'm planning to set up a raid6 array with 4 x 4TB drives.
> Presumably that would result in 8TB of usable space + parity, which
> is about enough for my data (my data is currently 5TB in raid1,
> slowly growing at about 1 TB per year, but I often keep some
> additional backups if space permits).
>=20
> However I'd like to be prepared for a disk failure. Because my
> server is not easily accessible and disk replacement times can be
> long, I'm considering the idea of making a 5-drive raid6, thus
> getting 12TB useable space + parity. In this case, the extra 4TB
> drive would serve as some sort of a hot spare.
>=20
> My assumption is that if one hard drive fails before the volume is
> more than 8TB full, I can just rebalance and resize the volume from
> 12 TB back to 8 TB essentially going from 5-drive raid6 to 4-drive
> raid6).
>=20
> Can anyone confirm my assumption? Can I indeed rebalance from
> 5-drive raid6 to 4-drive raid6 if the volume is not too big?

   Yes, you can, provided, as you say, the data is small enough to fit
into the reduced filesystem.

   Hugo.

--=20
Hugo Mills             | "What's so bad about being drunk?"
hugo@... carfax.org.uk | "You ask a glass of water"
http://carfax.org.uk/  |                                         Arthur & F=
ord
PGP: E2AB1DE4          |                 The Hitch-Hiker's Guide to the Gal=
axy

--NJSRbAqOy4NeGDns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV7tDKAAoJEFheFHXiqx3kt/IP/31gx0s8xx275+brq//uu9lA
Vw2qZsiwhWpZHmY60P9bahkihdG/2k/avG2lAkxdILD1laFTY6MayplZpyd1SgWi
LZPbQXvKqrM9usY9Ob1hpv9aqlV/z/ci4bS7+GcIZZtEOEX7UkMwnrmA4dlVfAPP
fEcLWEgBlHJxyzgMW7QNqgHcPnuU3yVRmAZdhAdMHxI0JDtntl3VwTNL2g7jnqcl
XWPXUJA/TpwhNDg0c19aODv2SjdrfCw1A39WEUNODnsbFRtY+j3PA1da0Jfu0rIS
vrJXXvnPeVXkCSQ0/G77pSLE5Ra4GwRnJ5/aO4GIHpToOCfK4tCqBmUmdLZBIFZC
Pr9ywiXkV7e025kudLibNGtATeUtF+0+g/zhJsSXqDU+K85vK+34hDg7tYU81Ih+
PsZn96R77Snrsk3Fd4RMBxjdILKddL5TJfcAIgI/MkDsQy0xx6M97uTH83xMUwAB
fHApwW+0VRmXjAAu+wJAPakt13peocPHEK+wR7czA354TQ8BmDZwj+1SaJBpZYOn
4fGWwtxUbXnj9uj09dT35vlvKpwGtUHNvvOdMo2/4ekZJp0u0hJmmzkY8L0ZwjAy
sHkBqEpdEruRMezemzEW3nKLYGeDl2nwgNKfiTDaQL8UC2UNDrEniRDGbM+sglpL
HGsCznUW+jDGmUMTX+Rf
=Q3+4
-----END PGP SIGNATURE-----

--NJSRbAqOy4NeGDns--
