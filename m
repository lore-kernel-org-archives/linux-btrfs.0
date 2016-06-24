Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbcFXB6q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 21:58:46 -0400
Subject: Re: btrfs-progs 4.6 won't build on CentOS6
To: Steven Haigh <netwiz@crc.id.au>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <576C93C7.3030605@suse.com>
Date: Thu, 23 Jun 2016 21:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mGPGIwKPHqNDDIilLibEFXKoFSrdqiVTD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mGPGIwKPHqNDDIilLibEFXKoFSrdqiVTD
Content-Type: multipart/mixed; boundary="auIElQPN7brpCEkKn57D6nL9gB734Vl4v"
From: Jeff Mahoney <jeffm@suse.com>
To: Steven Haigh <netwiz@crc.id.au>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <576C93C7.3030605@suse.com>
Subject: Re: btrfs-progs 4.6 won't build on CentOS6
References: <3864856543476b0f69224f6b6be3ed26@crc.id.au>
In-Reply-To: <3864856543476b0f69224f6b6be3ed26@crc.id.au>

--auIElQPN7brpCEkKn57D6nL9gB734Vl4v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/23/16 9:49 PM, Steven Haigh wrote:
> I've tried to build the new tools for CentOS 6 / Scientific Linux 6 /
> RHEL 6 etc.
>=20
> During the build process, I see:
> cmds-fi-du.c: In function 'du_calc_file_space':
> cmds-fi-du.c:330: error: 'FIEMAP_EXTENT_SHARED' undeclared (first use i=
n
> this function)
> cmds-fi-du.c:330: error: (Each undeclared identifier is reported only o=
nce
> cmds-fi-du.c:330: error: for each function it appears in.)
> make: *** [cmds-fi-du.o] Error 1
>=20
> I'm guessing this is probably due to a different GCC version used? I'm
> guessing this is a simple fix for someone with knowhow... :)
>=20

This is due to too-old headers.  That define was added in 2.6.33.

#define FIEMAP_EXTENT_SHARED            0x00002000 /* Space shared with o=
ther
                                                    * files. */

Just add that above that routine and you'll be good to go.  The right fix=

is to add it to the tools, ofc.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--auIElQPN7brpCEkKn57D6nL9gB734Vl4v--

--mGPGIwKPHqNDDIilLibEFXKoFSrdqiVTD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXbJPPAAoJEB57S2MheeWyJDoP/j1eqI0MUz/60XTf5miIAK5r
D7mSQV/2Vpwuev8X4qqdYO6zLyC/fwGPRhy4oy+xWc5pfqOfTWfFRl04LEj3M7JX
IAePXUiHtFQk2TFHuiP+aS0sy+WZpCQIR85ZGDX1EeKH7GRlXaetQgmAQdi8c3aj
9F7DAeq7rZijgqp0wP5U6h1FyPWnSfBBfN2eFHjrynkX9O1tBwLahLxhDQqF+l8b
0PSPkpZ3n/9W+wz57sGuSYjWbBfbMbIiT4l2Z5ThTxgKKnWEcdtJerzfKkxIbqIR
qCWZVEgZvZu53cIOBV+Ain4VOBnrPD8o0Yj0MHm8L9Wi0EvskSA5QumCmt1Y/uvz
M++VkhcRoGY07Ic6svzfvr5qkx90/qr9Wh94r6C0vVOED/ZcxwPexAgerqQZjwSJ
B83tugj/+OcimaMy0AZD8aGLo2hcFPtG7xXbsHJECMQl4pfWJcUE9KZYDXh3npLy
/P2+l4EpOpafg6y3xZMzKUg8o8BWiEI4CgjiUe17nr52teSRYMLA+qsSybq+l36+
6C5GnyC1aL1CDiydqb2H8lNgaN22QAhNnMj3gWk09VtjY6JeVUrGH1XsA4Wcw6cJ
ami0SEBjHXjYZfzOVmpktTG96ESWJHd3D+Nj8bAZcArYrJqDFNWMtSja7J1wJLFi
C4csU76Z9Yj8apNiBnno
=RH/Y
-----END PGP SIGNATURE-----

--mGPGIwKPHqNDDIilLibEFXKoFSrdqiVTD--
