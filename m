Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:39671 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeCQUJR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 16:09:17 -0400
Received: by mail-qk0-f171.google.com with SMTP id j73so7160499qke.6
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Mar 2018 13:09:16 -0700 (PDT)
Date: Sat, 17 Mar 2018 16:09:14 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: Fix typos in docs and user-facing
 strings
Message-ID: <20180317200911.mtlilu473tfevvcc@DigitalMercury.dynalias.net>
References: <20180316003909.28800-1-nsteeves@gmail.com>
 <20180316003909.28800-2-nsteeves@gmail.com>
 <b2ccc0f4-7773-0448-7f50-5de2ff1c1bf9@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dl26rg5n426nwgk4"
In-Reply-To: <b2ccc0f4-7773-0448-7f50-5de2ff1c1bf9@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dl26rg5n426nwgk4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nikolay,

Thank you for nit-picking, I'm definitely not above reproach and often
make errors--especially in my own writing!  Reply follows below.

On Fri, Mar 16, 2018 at 10:00:34AM +0200, Nikolay Borisov wrote:
>=20
>=20
> On 16.03.2018 02:39, Nicholas D Steeves wrote:
> > Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
>=20
>=20
> All look fine except one nit, see below.
>=20
> > ---
> >  Documentation/btrfs-balance.asciidoc | 2 +-
> >  Documentation/btrfs-check.asciidoc   | 2 +-
> >  Documentation/btrfs-man5.asciidoc    | 8 ++++----
> >  cmds-subvolume.c                     | 2 +-
> >  4 files changed, 7 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs=
-balance.asciidoc
> > index 7017bed7..536243bc 100644
> > --- a/Documentation/btrfs-balance.asciidoc
> > +++ b/Documentation/btrfs-balance.asciidoc
> > @@ -204,7 +204,7 @@ The way balance operates, it usually needs to tempo=
rarily create a new block
> >  group and move the old data there, before the old block group can be r=
emoved.
> >  For that it needs the work space, otherwise it fails for ENOSPC reason=
s.
> >  This is not the same ENOSPC as if the free space is exhausted. This re=
fers to
> > -the space on the level of block groups, which are bigger parts of the =
filesytem
> > +the space on the level of block groups, which are bigger parts of the =
filesystem
> >  that contain many file extents.
> > =20
> >  The free work space can be calculated from the output of the *btrfs fi=
lesystem show*
> > diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-c=
heck.asciidoc
> > index cc76d846..b963eae5 100644
> > --- a/Documentation/btrfs-check.asciidoc
> > +++ b/Documentation/btrfs-check.asciidoc
> > @@ -122,7 +122,7 @@ NOTE: 'lowmem' mode does not work with '--repair' y=
et, and is still considered
> >  experimental.
> > =20
> >  --force::
> > -allow to work on a mounted filesystem. Note that this should work fine=
 on a
> > +allow work on a mounted filesystem. Note that this should work fine on=
 a
> Shouldn't we use the continuous aspect of the verb here, i.e.
> s/work/working ? (I'm not a native speaker so take it with a grain of sal=
t)

I'm not sure, but if the format is:
    "[implied subject] verb, other stuff", then:

[The --force argument] allows work on a mounted filesystem. [1]
  or alternatively:
                       allows operations on a mounted filesystem. [2]
  or
                       allows operations to work on a mounted filesystem. [=
3]

but if we're in imperative/declarative then:

                       [Allow] Work on a mounted filesystem. [4]
and not
                       [Allow] Working on a mounted filesystem. [5]

Because "Working on a mounted filesystem" [5] is a sentence fragment
(also see related discussing at [6] below).  I chose [4] because it
required the fewest changes ;-)

In "Allow work on a mounted filesystem" [4]

"Allow" is the verb and "work" is the object, but if "Allow" is
dropped and the phrase becomes "work on a mounted filesystem" then
"work" becomes the verb, using its identically spelled verb form. The
following is also grammatically correct if the rule is:

"(argument_name functioning as imperative verb), [participial phrase]"
eg:                    --force, allowing work on a mounted filesystem. [6]

but IIRC [6] is considered poor style for Science writing and
documentation--not to mention it also might make translation
difficult, and finally it breaks whenever --argument cannot function
as a verb.  It's also tricky to analyse ing-verbs to tell if they're
gerund or participial when dealing with the truncated grammatical
context that is conventional in manpages.

As ever, I might be wrong, but this is my reasoning :-)

Cheers,
Nicholas


--dl26rg5n426nwgk4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlqtdeQACgkQWogwR199
EGFAPRAAttQLgc/38niUa/srB81Q8LRHutJiXAQfv/AEmO6bPL/wN3DEDK5UG4SK
B/D2UJ/XjOXDg0IHb2zJ+qt/j9o/RHwKeNTGcLAshXpWUK3urn6Y8/6AHLJ1hU+0
CVk9Ho9jIgc5jnKwQHIC2YxeDUa5JggI1RmgWZ3PFglELzi7LDJAc9ig6sBvR/Us
YRo2yqawYD+/iywEYWJZAdwt9yzxNZA9gc3tmGesU+XGMEiKvLxmz5cUzc180HzE
+iGL1QfZwcD/tDDDj5irfKhh5RQ6Re0wt1QGTJmwhf3+9XX245u2y0F7G46RgztW
PD/VKn/yefuQadEhjsxVARYOcuEnaHDDGlRj/iW2M1GUI7yjYs8eqjfN0KtID1nI
jUtzsMOKJbbhXa81Q3qSt93ft3R9FcUxHneH69+hh0CHg4zAX60ia1O0qVHuOBd4
K9RZqyEhTkbmPhqHJ1+mrECnmFRQd25/k9BMjcXQAI83T65crhU6pCVWTtuP4gt+
i2pEa9Z6YLvsCz0htwC2FQsNy9fD6cA91OQ5od+2cwtOplPHGEkXGD7VMz0qiARf
Uon1xyPrVc5exVQ/rnAiXg4V4Ra1IDwlgxcWeT/Dc+O+NGCRLq/FQdOvQbMhm7Pd
VQq3cU3Xbi+jrivgPMGPELXBBBP7UXARfpMxJMSGzaGoZSv2PG4=
=cDiR
-----END PGP SIGNATURE-----

--dl26rg5n426nwgk4--
