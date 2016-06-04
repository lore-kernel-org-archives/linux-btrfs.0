Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40238 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbcFDH5u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 03:57:50 -0400
Date: Sat, 4 Jun 2016 07:57:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "No space left on device" and balance doesn't work
Message-ID: <20160604075747.GD24492@carfax.org.uk>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
 <bcf8033b-bafe-f927-efdb-b898d2b00a24@gmail.com>
 <575274C1.8070801@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
In-Reply-To: <575274C1.8070801@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 04, 2016 at 09:27:13AM +0300, Andrei Borzenkov wrote:
> 02.06.2016 15:56, Austin S. Hemmelgarn =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >=20
> > In your particular situation, what's happened is that you have all the
> > space allocated to chunks, but have free space within those chunks.
> > Balance never puts data in existing chunks, and you can't allocate any
> > new chunks, so you can't run a balance.  However, because of that free
> > space in the chunks, you can still use the filesystem itself for
> > 'regular' filesystem operations.
> >=20
>=20
> How balance decides where to put data from chunks it frees? I.e. let's
> say I have one free data chunk and 10 chunks filled to 10%. Will "btrfs
> ba start -dusage=3D10" pack data from all 10 chunks into single one, this
> freeing 10 chunks for further processing?

   Yes, it will. Andrei's assertion is, I'm afraid, incorrect.

   Hugo.

--=20
Hugo Mills             | There's many a slip 'twixt wicket-keeper and gully.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXUon7AAoJEFheFHXiqx3kLIUQAKUH5AVnAFZH4wbQz5En+ElL
JovvFs+pwwvEWO8ycF/Hiaw92WllPBqKpUvObVHzL8aoVVQYPLqxkRMyWbSoGw9z
dPNAzv2i4unrOIeTuPzrQALhWYLwtgZ9OEza11V9e0bCRDCS7QpL3eWJnBOyqZC0
GF9lm+kTdZOjX53GfE5rImO8jBG9ZXXhodUOD3g1luF4dGc3P75GV6ikfCBre61e
JFYul2FJDiD9zIqkphKRC0bN6YFkdsnj58GBGR2gG1/T3YuW/fTMCbvRguATvLa5
2gj/bTe8K56gWtGHglDc1G/ArXnv+o5HoeX0qhP6EhUgtzMsv4tfgpMtT/O8E0Gb
lc1cmKxHrRaafE9D154vBN7XVQIwXqhhFU1YwWjAtVn9zw8b7w667Q7JSeF5JIlf
MsgzOwo4nyYUmJlpVgV7TBUhDwCL9rlWJFfxwEFiPGHYeg8OGZQxc2/2qBlOpbcK
l+1W1XfXBtIy7FVLzEMmvcgwYUtoU4qbXccpUXm2GiY2GlkwNaE2+sPWBjZgYCMf
CpMzIPoC65+qzQrEf5z/rKIDfIXKqhCV8cskMm8MYpkszpZEjT6Wi2BOgGNKaNzg
lG6FTGEFTevxsO6KtvSHldZLWC2Xrn/0qzDCvTBUkbrOYQfegar+oe2SWa6qEUDW
HCa3mifjkcQeZH9NExSo
=hEI1
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
