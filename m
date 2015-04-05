Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57894 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbDEKEX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Apr 2015 06:04:23 -0400
Date: Sun, 5 Apr 2015 10:04:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell@coker.com.au>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs hangs 3.19-10
Message-ID: <20150405100417.GE13864@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
 <20150404130047.GC13864@carfax.org.uk>
 <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
 <201504050330.47299.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
In-Reply-To: <201504050330.47299.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 05, 2015 at 03:30:47AM +0000, Russell Coker wrote:
> On Sun, 5 Apr 2015 03:16:21 AM Duncan wrote:
> > Hugo Mills posted on Sat, 04 Apr 2015 13:00:47 +0000 as excerpted:
> > > On Sat, Apr 04, 2015 at 12:55:08PM +0000, Russell Coker wrote:
> > >> As an aside are there options to mkfs.btrfs that would make a
> > >> filesystem mountable by kernel 3.2.65?  If so I'll file a Debian/Jes=
sie
> > >> bug report requesting that a specific mention be added to the man pa=
ge.
> > >=20
> > > Yes, there are. It's probably -O^extref, but if you can show the
> > > dmesg output from the 3.2 kernel on the failed mount (so that it shows
> > > what the actual failure was), we should be able to give you a more
> > > precise answer.
>=20
> [698190.987065] Btrfs loaded
> [698190.999992] device fsid 118e2c64-6ce1-4f21-85e2-2d6aea8f0fa5 devid 1=
=20
> transid 426 /dev/sdf1
> [698191.000981] btrfs: disk space caching is enabled
> [698191.000986] BTRFS: couldn't mount because of unsupported optional fea=
tures=20
> (60).

   That's these, I think:

#define BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF    (1ULL << 6)

so it's definitely -O^extref. I don't see where big_metadata comes
=66rom, though. That's not a -O option. Try with -O^extref and see where
that gets you. (Also, don't mount the FS on a newer kernel -- it may
be setting big metadata automatically, although it probably shouldn't
do).

   Hugo.

> [698191.018176] btrfs: open_ctree failed
>=20
> > So I was thinking about this, and the several other earlier options whe=
re
> > support wasn't added until kernel X, and had an idea...
> >=20
> > How easy and useful might it be to add to mkfs.btrfs appropriate option-
> > group aliases such that if one knew the oldest kernel one was likely to
> > deal with, all one would need to do for the mkfs would be to set for
> > example, -O3.2, or even simply --3.2 (or maybe even --32), and have
> > mkfs.btrfs automatically set/unset the appropriate options so it would
> > "just work" with that kernel and anything newer?
>=20
> That would be really useful.  Also it would be good if the code structure=
=20
> allowed adding extra aliases, so for Debian we could add an option -Owhee=
zy.
>=20

--=20
Hugo Mills             | Nostalgia isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVIQihAAoJEFheFHXiqx3kWVAP/iwhiB1FhTF3geGSCtSVEzB9
5/Rcy1VUQmBR/MgU1gjTdXeHDiSyW7E/2nK8KrafgMYGWaVQ44ukJGdqBUVWJxyC
6tGGuWP8oYTQmkA833z74ClGkxVUEroUBOvP1iVnGEw1y+WJnWgJnUupeh90ZqSi
63TrcCK1xxlSrZafZ3bhahjhghWq6CIeMLcl5yPO8tsqSgscIL+iLwk2gA2V+7Lb
zTt+7+3smF8ma+idgxHLByWgI3HPd4tLUJv0OIFF+ct1aCJJBZptE0k1F1pXLP6X
wcqCF1bUCwVZYOy1ZuvIQe9KLxsJ5QeQaUZbZUGXUB0LXDAiVCbHdsFZ/34I1Nm6
Dua60zFr/00W1mevqlmD48P35ZUgVi3Qym4tSMQgrfJ53yEpzya++xnmhBjklMmf
xLR0oHIqaiM5/9l7Kr5hGyDX+5lduOTBMURNyaaY8b2WXV8gZAUuyMDtpuHsKXkj
8gdTKabObAVIecHehN+AuoErSscBI+3vt2lAb5LemCEXGCki12qBr2xyaWdbbczj
FuvyI3c4c3s7UATwQ2usIQH9AAGCryKvMA7lwtNrTl+oA2LX5rD08xYWL8OINtML
b0tGcL+DKycfH1RccXfVN/7PjvsiIreHBmiKy4h0o07v8YtNom+zenQKP09BAVkx
InM+PlTcGvpAwTePkikQ
=X4Vr
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
