Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46268 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750764AbcLCUaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Dec 2016 15:30:05 -0500
Date: Sat, 3 Dec 2016 15:30:03 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: negative numbers are more plausible
 than sizes over 8 EiB
Message-ID: <20161203203003.GU8685@hungrycats.org>
References: <1480745978-24996-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161203182517.GA18526@mew>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yypaS3FvPkEUiGyo"
In-Reply-To: <20161203182517.GA18526@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yypaS3FvPkEUiGyo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 03, 2016 at 10:25:17AM -0800, Omar Sandoval wrote:
> On Sat, Dec 03, 2016 at 01:19:38AM -0500, Zygo Blaxell wrote:
> > I got tired of seeing "16.00EiB" whenever btrfs-progs encounters a
> > negative size value.
> >=20
> > e.g. during filesystem shrink we see:
> >=20
> > Unallocated:
> >    /dev/mapper/testvol0   16.00EiB
> >=20
> > Interpreting this as a signed quantity is much more useful:
> >=20
> > Unallocated:
> >    /dev/mapper/testvol0  -26.29GiB
> >=20
> > Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> > ---
> >  utils.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/utils.c b/utils.c
> > index 69b580a..bd2b66e 100644
> > --- a/utils.c
> > +++ b/utils.c
> > @@ -2594,20 +2594,23 @@ static const char* unit_suffix_binary[] =3D
> >  static const char* unit_suffix_decimal[] =3D
> >  	{ "B", "kB", "MB", "GB", "TB", "PB", "EB"};
> > =20
> > -int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigne=
d unit_mode)
> > +int pretty_size_snprintf(u64 usize, char *str, size_t str_size, unsign=
ed unit_mode)
> >  {
> >  	int num_divs;
> >  	float fraction;
> > -	u64 base =3D 0;
> > +	s64 base =3D 0;
> >  	int mult =3D 0;
> >  	const char** suffix =3D NULL;
> > -	u64 last_size;
> > +	s64 last_size;
> > =20
> >  	if (str_size =3D=3D 0)
> >  		return 0;
> > =20
> > +	/* Negative numbers are more plausible than sizes over 8 EiB. */
> > +	s64 size =3D (s64)usize;
>=20
> Just make pretty_size_snprintf() take an s64 size so it's clear from the
> function signature that it's signed instead of hidden in the definition.

I intentionally buried the unsigned -> signed conversion in the lowest
level function so I wouldn't trigger signed/unsigned conversion warnings
at all 46 call sites for pretty_size_mode.  The btrfs code uses u64
endemically for all size data, and I wasn't about to try to change that.

The word "pretty" in the function name should imply that what comes out
is a possibly lossy transformation of what goes in.  Since "16.00EiB"
is much more lossy than "-29.96GiB", I believe I am merely reducing the
lossiness quantitatively rather than qualitatively.

On the other hand, the signed/unsigned warning isn't enabled by default
in this project.  I can certainly do it that way if you prefer.

> > +
> >  	if ((unit_mode & ~UNITS_MODE_MASK) =3D=3D UNITS_RAW) {
> > -		snprintf(str, str_size, "%llu", size);
> > +		snprintf(str, str_size, "%lld", size);
> >  		return 0;
> >  	}
> > =20
> > @@ -2642,7 +2645,7 @@ int pretty_size_snprintf(u64 size, char *str, siz=
e_t str_size, unsigned unit_mod
> >  			   num_divs =3D 0;
> >  			   break;
> >  	default:
> > -		while (size >=3D mult) {
> > +		while ((size < 0 ? -size : size) >=3D mult) {
> >  			last_size =3D size;
> >  			size /=3D mult;
> >  			num_divs++;
> > --=20
> > 2.1.4
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--yypaS3FvPkEUiGyo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhDK0sACgkQgfmLGlazG5xYNwCgsH/UNbHezrghQxClf6eZpM8w
4mMAnjT+98z5yJZckmFRUDumVom8LYYN
=dA8f
-----END PGP SIGNATURE-----

--yypaS3FvPkEUiGyo--
