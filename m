Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42345 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbcKRKBb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 05:01:31 -0500
Date: Fri, 18 Nov 2016 10:01:26 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: root backup-reformat-restore
Message-ID: <20161118100126.GA20378@carfax.org.uk>
References: <7ef59dd2-fbfb-055a-3f5b-b11cc03f4cce@iki.fi>
 <20161118005253.GY16645@carfax.org.uk>
 <29627979-aaef-6f9e-d3b0-3f69333993f9@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
In-Reply-To: <29627979-aaef-6f9e-d3b0-3f69333993f9@iki.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 18, 2016 at 04:06:22AM +0200, Marcus Sundman wrote:
> On 18.11.2016 02:52, Hugo Mills wrote:
> >On Fri, Nov 18, 2016 at 02:38:25AM +0200, Marcus Sundman wrote:
> >>The FAQ says that "the best solution for small devices (under about
> >>16 GB) is to reformat the FS with the --mixed option to mkfs.btrfs".
> >>
> >>OK. Does anyone have any good suggestions for doing that with an
> >>existing / partition (which has special files and whatnot)?
> >>
> >>I assume a backup-restore cycle is needed, but with which program(s)?
> >  - If you don't have (or don't care about) any snapshots, then
> >     - if you can mount both the old and the new FS at the same time
> >        - mv
> 
> It's the same partition, so I probably won't have the new FS there
> at the same time.
> 
> >     - else, if you want to replace the old FS with the new
> >        - tar to a file elsewhere, and untar later
> 
> Can tar really preserve all special files' attributes? (I have
> separate partitions for /boot and /home, but the rest is in /)

   Yes, I've used it for moving / to a different machine before. Take
a look through the options and pick all the ones that look like
they're dealing with attributes. :)

   Hugo.

-- 
Hugo Mills             | Anyone who claims their cryptographic protocol is
hugo@... carfax.org.uk | secure is either a genius or a fool. Given the
http://carfax.org.uk/  | genius/fool ratio for our species, the odds aren't
PGP: E2AB1DE4          | good.                                  Bruce Schneier

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYLtF2AAoJEFheFHXiqx3kTmQQAKMClfD1SwYXxfTesiFmyp3C
d5cBrBBhVvxCC0Urn27JaZMybJX9Cj1hgApa0Mg8YijwSJEk5O2NFowXPKUznMEE
whl6ByqirFAAVxc6H5pT/S+9HAHZCI2qGXYELrsZbXqDeXY4gzTYVXMym98LpYa8
Ve7jqs0t/wQRLEM8Zn6gOWhtASA9vhQLYyS6+S1MGjFjpa3M/fH2KDbhF4Ot0OpP
VdXNogXoz7WDc+9lJVpanbabtn4XDDWUkKjP/0HYa0GPOFzqOVG5Rh3446PBsUtr
AS+cS/ZBvNXLTB9SA6teEF5BGip375ynUZFfhpAOt6LJ4hlZEdWvj+P4TPUyTrjk
W65eJ6Iw6mjthrQTUk9KnVIiJu3gkKiMZesIH3DUTeQC6MGPt9Sh2Cg/dQY/+fWY
wesFHSGLlwkteI9KAA0/pujNuemNN7OiBFZ0LUu/3Po+LQydR1AmHs8jxH2yXoa2
kaFyE5Ej47HMyv4d/I8CfYlFhCGqcZCz87joU4vo5sHD6hBfzZFR/jP25jd40+sQ
N4/Lhp2qc2W9LzCtop+c0yFHEQdnvYmvS/X6JAVv9DMo4CVHAwZqnlMxdck/kSO1
1oD3oHM36bWspI3n0eW8HWCHOroBvwWxZPOIujaZl8mcDXx88nUSGQIoBNYDOANs
Ri1u6Nw395hjdpKDP4at
=abHB
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
