Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52895 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaFOVhn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 17:37:43 -0400
Date: Sun, 15 Jun 2014 22:37:34 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Subject: Re: Slow startup of systemd-journal on BTRFS
Message-ID: <20140615213734.GO1756@carfax.org.uk>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
 <539B78F3.9070607@libero.it>
 <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
 <2067769.SxD8Z17WRg@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KGKeSgiE1VZnuONP"
In-Reply-To: <2067769.SxD8Z17WRg@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KGKeSgiE1VZnuONP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2014 at 11:31:07PM +0200, Martin Steigerwald wrote:
> Am Samstag, 14. Juni 2014, 02:53:20 schrieb Duncan:
> > > I am reaching the conclusion that fallocate is not the problem. The
> > > fallocate increase the filesize of about 8MB, which is enough for some
> > > logging. So it is not called very often.
> >=20
> > But...=20
> >=20
> > If a file isn't (properly[1]) set NOCOW (and the btrfs isn't mounted wi=
th=20
> > nodatacow), then an fallocate of 8 MiB will increase the file size by 8=
=20
> > MiB and write that out.  So far so good as at that point the 8 MiB shou=
ld=20
> > be a single extent.  But then, data gets written into 4 KiB blocks of=
=20
> > that 8 MiB one at a time, and because btrfs is COW, the new data in the=
=20
> > block must be written to a new location.
> >=20
> > Which effectively means that by the time the 8 MiB is filled, each 4 Ki=
B=20
> > block has been rewritten to a new location and is now an extent unto=20
> > itself.  So now that 8 MiB is composed of 2048 new extents, each one a=
=20
> > single 4 KiB block in size.
>=20
> I always thought that the whole point of fallocate is that it *doesn=B4t*=
 write=20
> out anything, but just reserves the space. Thus I don=B4t see how COW can=
 have=20
> any adverse effect here.

   Exactly. fallocate, as I understand it, says, "I'm going to write
[this much] data at some point soon; you may want to allocate that
space in a contiguous manner right now to make the process more
effcient". The space is not a formal part of the file data and so
doesn't need a CoW operation when it's first written to.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the premi=E8re,  is the ---    =
=20
                  last-ever performance the derri=E8re?                  =
=20

--KGKeSgiE1VZnuONP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU54SHlheFHXiqx3kAQLNAg//SEJUBIP6871ZpmMtzBeK++eSKb3XAk2Z
q3KcNAEb4trvvfvdb+YOSVgWoxh+DK66UYyilJYgYSxiFBcZeWhO176xD97yhtVq
V58U95LjhXIigTL+cQDl2RPrbkGvfDzhVhK/zdrF3wI2rOUVuFzj73mzEec7B1K7
uwj6WKbVdHeNLxVYyumi98QGn7jtEsmDvpN00yD1wTszrFCvjeSsAwvudxC+vEHz
v0xZGyedXUavxa/1bcTDxcVw4AeH+VUPmZ7TlGf7m82FFZSvzp6hesP+qoBKukkL
0Ohv6jU6NpHphtn+QxiyPdLRQ5DcFyqR7Bgbup3gJZjAjNrBiPfIWZI1+ppEKII/
C/Nb0vh8nobjMZqLTSAfSLbXuUSPNXeOw9K6P0PzIoQV8WJYdsZEbSeeKnqFa6As
Kf3Ccp4UUYpYIAFKPptqsvuOPYXBVbZKOAGt34dk5Ci0YX7IsdaF0LhoBVuUchVF
lYc8BWfGb5UY/WRCr9JNP+H+Bh6c6wBRVyh68k9TP0GlbtHFRdhqJadIVNjlIQIn
QOaqedAnjXM8kAO2wjspr9d/9Bx+QbC3P925d3WCbQHiexitlSd1f/3/Jk7lBfIU
3UMG6/sKejmctLfYBWEmnHdFVHdxvuTO6jIi/aF4SVJs3YlDDlVdwlMwfGsWJCq3
xY6GuRgY9n8=
=1pPP
-----END PGP SIGNATURE-----

--KGKeSgiE1VZnuONP--
