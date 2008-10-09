From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into
	{libbtrfs,tools,tests}
Date: Thu, 09 Oct 2008 15:52:09 -0600
Message-ID: <1223589129.7861.61.camel@telesto>
References: <200810090420.49767.trapni@gentoo.org>
	 <1223549106.28324.14.camel@macbook.infradead.org>
	 <200810091555.38509.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w+7eIyCYO7mfho+W9H/5"
Cc: David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org
To: Christian Parpart <trapni@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810091555.38509.trapni@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-w+7eIyCYO7mfho+W9H/5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-09 at 15:55 +0200, Christian Parpart wrote:
> On Thursday 09 October 2008 12:45:06 David Woodhouse wrote:
> > On Thu, 2008-10-09 at 04:20 +0200, Christian Parpart wrote:
> > > this now makes use of autoconf/automake/libtool suite,
> >
> > Please, God, no.
> >
> > I will personally buy a licence for GNU make for anyone who needs one.
>=20
> In that case, you shall know what license automake is under, too,
> and despite your impressions i read above, if you don't want it, fine wit=
h me,=20
> but stick to reasonable facts instead of religios talk next time you pres=
s a=20
> reply button.

I nearly tried to make an argument against the autotools last night.
Today, I decided that I would rather explain why I had such a visceral
reaction to the announcement and not try to convince anyone of anything.

The GNU autotools kept me out of FOSS development for the better part of
a decade.

They obviously solve a common and important problem, or they wouldn't be
so widespread. But the knowledge gap between what can be gleaned from a
"learn C" book the knowledge required to navigate a project built with
autotools is enormous. At first I thought I was alone, but when I shared
my frustration with my programming friends I found all but one had the
same problem.=20

I tried reading the entire collection of autotools documentation, but
that didn't help very much. I tried installing anjuta, hoping that it
would cover up the complexity of the build process and just let me hack,
but it never seemed to work correctly.

The problem, in my opinion, is that the autotools are chock full of
solutions to problems that many programmers have not yet encountered.
Viewed through that lens, they look like cruft. And if files associated
with autoconf and automake look like cruft to someone, that's a truly
massive amount of cruft to wade through just to get started programming.

There's no way for me to tell whether bringing autotools to the btrfs
userspace code will help or hinder the project. However, I feel fairly
certain that it will exclude a large class of potential contributors
from the development process.

Maybe people are opposed to growing the btrfs development community by
incorporating programmers who are not well versed in the problems that
arise when porting software across different distributions and
platforms. Maybe only bad programmers don't like autoconf. Decide for
yourselves. :)

Cheers,
Eric


--=-w+7eIyCYO7mfho+W9H/5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBI7n0Je2L37HVup3ARAnFIAKDzw6sPWBWMHg9AWIOFzU7OiFRimwCg7qIQ
yXt5VI0lK3Z+UK8UWvsnB04=
=IweG
-----END PGP SIGNATURE-----

--=-w+7eIyCYO7mfho+W9H/5--

