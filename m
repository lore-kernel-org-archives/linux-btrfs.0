Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51001 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934942Ab3BTOyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:54:13 -0500
Date: Wed, 20 Feb 2013 14:54:09 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
Message-ID: <20130220145409.GA14283@carfax.org.uk>
References: <20130201095947.GA32445@gmail.com>
 <20130201103031.GQ16285@carfax.org.uk>
 <5124CA35.2080009@elastichosts.com>
 <CAMU1PDhjNpJTO14oB26Dxy+HoEwKEEKcxByh6CO+8DiTd1Grfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <CAMU1PDhjNpJTO14oB26Dxy+HoEwKEEKcxByh6CO+8DiTd1Grfw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 02:15:52PM +0000, Mike Fleetwood wrote:
> On 20 February 2013 13:05, Audrius Butkevicius
> <audrius.butkevicius@elastichosts.com> wrote:
> > On 01/02/2013 10:30, Hugo Mills wrote:
> >>
> >> On Fri, Feb 01, 2013 at 09:59:49AM +0000, Audrius Butkevicius wrote:
> >>>
> >>> Add '-b' and '--bytes' options to btrfs filesystem df and show, for
> >>> easier
> >>> integration with scripts. This causes all sizes to be displayed in
> >>> decimal
> >>> bytes instead of pretty-printed with human-readable suffices KB, MB, etc.
> >>
> >>     Please, not this way.
> >>
> >
> > Hi Hugo,
> >
> > Just wanted to check which approach you'd prefer to see me adopt:
> >
> > 1. Providing an option which is handled near the entry point (prior going to
> > commands), which would toggle a global flag to indicate the format.
> >
> > 2. An option in every function which uses pretty sizes. (Though -B seems to
> > be used by scrub, -b is used by calc-size and mkfs utils, -u is used by
> > subvolume list and so on, meaning the option might have to be different for
> > different commands)

   Option 1 has an icky global (but one that's pretty much read-only,
so it's not all that bad). Option 2 pushes a piece of information
through a whole load of functions which really don't have to know
about it themselves.

   Either way, it's not particularly elegant, but either way would
work. Unless someone else (Chris? Dave?) has any particular feelings
either way, I'd probably go for option 1.

> > 3. An environment variable BTRFS_UNITS, which when set to b[ytes], changes
> > the behaviour of pretty printing. Avoids having to touch the multiple sets
> > of ad-hoc option parsing code, but is perhaps a slightly non-standard
> > interface.

   Yuck. Don't do that.

> Just for reference du and df use the following options:
>     -b, --bytes    (du only)
>     -h, --human-readable

and
  -H, --si              likewise, but use powers of 1000 not 1024

>     -k               (equivalent to --block-size=1K)
>     --block-size=n[SUFFIX]    (suffixes KB, MB, GB, ... mean 1000,
> 1000^2, 1000^3 ... and K, M, G, ... mean 1024, 1024^2, 1024^3, ...)

  ls has --block-size, -k, -h, --human-readable and --si, but not -H
(which overlaps with another option) or -b.

   I'm not too fussed about -k being there. -h and -H and their long
forms are the ones I'd definitely want to see. --block-size is useful
to give consistent numbers.

   I'd _like_ to see "bytes" as the default option (which also means
that we don't need to use up -b), but that changes the behaviour of
the tool (for anyone who was parsing the output of it in scripts), so
we probably shouldn't do that. OTOH, we're going to be changing the
output of the tool anyway with this change, so maybe it's worth doing
it all at once...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUSTjkb9z9OVl50rAAQKSfQ/9FeyklM1BEXJUrKI2E1FVOoY4Bo780c/6
c3CYY+myESnfp8hxzTpeIvoRk2CdyUNfX56nJNALGTH1BVO2HS/pOVmpn42cR6IB
YLcIuyAPoFM/B3GDAez05k2bb58yD+IhNV9N2Gqy57gfKyWzye3/wtbjZeHSIaQG
TxwxK+lRWlXTqj/6xu8hbj659ogEjN39+l6DbJTIRI3j/I1L5YIAvSykuQSo0Mgo
1aIp84EH07O0ium6YMsp35LMvRa7qmvAr9gvzbF0co+Yoxob4EQF7b20q0H/Komb
bKhlV/0/dCIMbNP7mmShI8UEoWcG9dfPjqElXbpjnb2XkTkvqzvYPEiB/K9V78UQ
ntkVpygLTsSfdkB0AWQw7crqHxPE9FNa6iVS7kqsETDpuecfYApTWQoShfR+rniF
wUSCeMkHjTsp1/eZaFb1gKwc8tRaKN/E+dE4pAyF7GXL80SAFmAUX6N4dRbuqey1
KTj/aJv4G976TKBGvlX5s6QtvsRI028n/MDU3BB/hmoM1AhW/R93yYdNYLhMce5v
7L2ZaDcm5JyUIpCPOzQ52rhRG0BxHmlEJn9qhh5/fnOY7GL6OvXH7xNfB3Cat5GD
nzI8wUWKRLrkZg4jupGWNeXuruQC3Rny0YudXgSUDnY3gmPpLk8eUA8hOiseCH4g
whYE7sLjYgI=
=NBsl
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
