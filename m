Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42141 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbbCWXWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 19:22:14 -0400
Date: Mon, 23 Mar 2015 23:22:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Message-ID: <20150323232212.GL31762@carfax.org.uk>
References: <meq6hm$lbh$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H83aLI5Lttn3Hg7B"
In-Reply-To: <meq6hm$lbh$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H83aLI5Lttn3Hg7B
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2015 at 11:10:46PM +0000, Martin wrote:
> As titled:
>=20
>=20
> Does btrfs have dedup (on raid1 multiple disks) that can be enabled?

   The current state of play is on the wiki:

https://btrfs.wiki.kernel.org/index.php/Deduplication

> Can anyone relate any experiences?

   duperemove is reported as working.

> Is there (or will there be,) a bad penalty of fragmentation?

   With duperemove, it operates on an extent scale, not at the level
of blocks, so the fragmentation isn't so bad.

   Hugo.

--=20
Hugo Mills             | =A91973 Unclear Research Ltd
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--H83aLI5Lttn3Hg7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVEKAkAAoJEFheFHXiqx3kD2AQALj0w/99uZS2Xld5EpaKRi4t
4t2zAdgomnQlgXLf3VD2TdPt5ruhuHShlMVkj6WY/GDapRBOr6VRE53pkMTww4Hm
jB2pXgHFJyPtJBwl5rtAEmmQ3ongEaJIZgdZD4UDP+flNfAOWGMCQ+e7SFaq0xPy
ZMvcry4Vd464ZxBSAdQujSOH+OhfTQg0UtmJXim5/6TP2B8W7pgldW5QwUxvRIGn
IF6ZOoAFIo2UuGLzSHRzykoGOZb42Dcy/1VULl+3Ow1L5njRX5GDtsx2W6MSUQAU
zoWzQUNp3aLKGio2e12s5EUlkNtQl9UXU5jRozbhBc5/stNkySti/9iyPuzIfdS1
/Xnm/3KCNSiSX4BsEIlsYHU/jUmgO4mv3bzKbiaLlZJhvE7aLrsMdXi7mpSzBRNu
if74gBmMgTiVa4tlHPm+1aIFxhY7/6Wz/VcbWRHTNtN32IDkq8fBDbw5mypmHuDa
a8oFG1lPMArxibVgNSj0qOu909Xbrmi/LCtYC53S18F77JgTmq333Tw+/FMYHvIl
RufSm9G05ATh4RRnUXexCzFRpTQq0YMDkuZShPXN4IuvbSq+O2ZCRAdcQpjYaGF2
0N4gTFxnA25vZ0bcej7NvyiLpC7+t/+dZ/FCwwJ+ky2WJclipxR02LXaXpsrnW2m
kn3Cjwpc4rhEsYxdN/cS
=2Whk
-----END PGP SIGNATURE-----

--H83aLI5Lttn3Hg7B--
