Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34684 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3BURZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 12:25:06 -0500
Date: Thu, 21 Feb 2013 17:25:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
Message-ID: <20130221172502.GF14283@carfax.org.uk>
References: <51264146.3070504@petaramesh.org>
 <1361462073.18057.23.camel@cwalton-XPS-8300>
 <512644DA.3050409@petaramesh.org>
 <20130221163844.GD14283@carfax.org.uk>
 <51265355.1020409@petaramesh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QNDPHrPUIc00TOLW"
In-Reply-To: <51265355.1020409@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--QNDPHrPUIc00TOLW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 06:03:17PM +0100, Sw=E2mi Petaramesh wrote:
> Le 21/02/2013 17:38, Hugo Mills a =E9crit :
> > Plus, if something does go wrong with your FS, and you're running an
> > older kernel, you'll get limited amounts of sympathy, because quite a
> > lot of the problems people encounter with older kernels have already
> > been fixed in newer ones.
>=20
> The matter, as usual, is that what may be a "new" kernel from a user's
> standpoint, may be an "old" kernel from a developer's standpoint.
>=20
> Should this exclude all standard users from developer's "sympathy", or
> reduce it to very limited amounts ?

   For an filesystem still under heavy development, and still marked
"experimental", yes, it should. In fact, *particularly* for a
filesystem, where a bug can cause persistent damage which isn't easily
fixable by upgrading to a later kernel (which is the case with most
kernel bugs).

> Users are supposed to use released material, not bleeding-edge
> compile-it-yourself devs toys...

   Correct. But btrfs isn't at that stage yet. It's getting visibly
closer, but it's not quite there. Hence the very strong recommendation
to keep up with the latest code.

   Hugo.

> > Finally, Ubuntu publish the latest kernels in a PPA[1], so there's not
> > really much excuse for not keeping up with them.=20
>=20
> Yep. AFAIK the MAINLINE PPA is a Ubuntu-packaged STANDARD kernel without
> any of the specific Ubuntu kernel patches.
>=20
> That makes it very inappropriate for daily use, and the Ubuntu devs ask
> for trying it ONLY when reporting kernel bugs, to check if said bug may
> have been fixed upstream in latest kernel, or not.
>=20
> Last time I tried this standard kernel, on one of my machines, it just
> wouldn't boot ; on another one, it couldn't manage power (battery etc)
> correctly, and on the machine on which I write this email, it couldn't
> see my SD card reader anymore - for this one is managed by a driver
> which still didn't make it into the standard kernel.
>=20
> I use Ubuntu on several -dekstop- machines that benefit and need the
> Ubuntu patches on their Ubuntus. I'm not (currently) running a headless
> generic server for which my main and only concern would be BTRFS...
>=20
> So I try to stick to the very old - albeit maximum 6 months old ! -
> stock Ubuntu kernel...

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I get nervous when I see words like 'mayhaps' in a novel, ---   =20
                because I fear that just round the corner               =20
                          is lurking 'forsooth'                         =20

--QNDPHrPUIc00TOLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSZYbr9z9OVl50rAAQLvYw//UkaSxA4ekqw3FhK4FGF81Oy3GVDMNC9f
4YSe0zt8FHzK+6cdiVQcJi3gejvQBzcn/Ak9It0AwHdw4y/t1muAe42ZygZl/PuI
yf0rE4bZIH9iQ2Q1mz79LITZWWHjL9YOJxocE1mTaJnXkjayPGHGwBRn2lg7fyr9
+sUpFKXVKoRK99eWcRPESlU56QWccurEQ5HQEU3ofN0TwWYkXOU9E3cDGHEFSd0u
3nlxVnreOqCdyaIS/xAtTsBs3RfXClQ6+HcJ+hg8PDJuHyobQnoLLtEnQgBem9do
uyGRZvQVBn0w5AdTTlBobjAz49nNxZ0LpDhRtFqOId0T13oIcZdCkmHh0taGyysv
W3BlpMh6ZMN27jzY6ZhDlZmpLKDofu+b7zDO0hK3eVBuDMqB0zAmw2YrHniFj5Qn
asZ3soghtphunI9IwoMoLcAGWalJClStYsrVVulTbNjX3r2xCotUr28S08d0K5Gm
4xQHQPsN2/Cd31pUx/V5TBwL1r+TXm1aAmvxllxS2Oqhfnegn5UPvG44bvDRn3cR
9TlNXSzTvOfnMNCKxGfNWSaOgK3hmNc/U4wEgd/sNKSG04hZGnmE3/nPAsGzk7OR
bOGdgz/PkbvVKQ98YnVgavFkDFJYNQnUeFwgYYY/kJhvxFCg4ACK4baJnvUM0nkg
x4anddjDkCg=
=AC7U
-----END PGP SIGNATURE-----

--QNDPHrPUIc00TOLW--
