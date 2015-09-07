Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45577 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbIGSFY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Sep 2015 14:05:24 -0400
Date: Mon, 7 Sep 2015 18:05:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount multi disk volume with recovery mode
Message-ID: <20150907180522.GI23944@carfax.org.uk>
References: <loom.20150904T230705-944@post.gmane.org>
 <20150904211738.GB23944@carfax.org.uk>
 <CAEyaVk+U5dFt79d_yd+LAujQLRsy8o7_VfPS+==uRPa_2f-oVg@mail.gmail.com>
 <20150905104253.GD23944@carfax.org.uk>
 <CAJCQCtRyN0zQXgCfdqB8af_S=sCWpkZTP6M9+Yb4mxOB-crBrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qD3brAgIG4LbUq6d"
In-Reply-To: <CAJCQCtRyN0zQXgCfdqB8af_S=sCWpkZTP6M9+Yb4mxOB-crBrA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qD3brAgIG4LbUq6d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 07, 2015 at 11:58:45AM -0600, Chris Murphy wrote:
> On Sat, Sep 5, 2015 at 4:42 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Sep 05, 2015 at 12:13:30PM +0200, Ivan Petrovic wrote:
> 
> >> So you're saying that I can't make first and third partition to work
> >> with it's data? Maybe I'll try with btrfs-restore, do you think it can
> >> rescue this 2 drives?
> >
> >    Unlikely. Like I said, if the FS was using single storage for
> > everything, a random 33% of the filesystem has gone away. There's
> > probably not enough of it left to make anything coherent.
> 
> With single profile for everything, is metadata and data guaranteed to
> be co-located on the same device? If not, then there's no way for this
> to be recovered. If they are, then I think recovery would depend on
> the system chunk always being device-n mirrored, which we don't have.

   No, there's no guarantee of co-location of data and metadata.

   Hugo.

-- 
Hugo Mills             | UNIX: Italian pen maker
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--qD3brAgIG4LbUq6d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV7dHiAAoJEFheFHXiqx3kubIP/Rp7VhX38PlU1iwlP1AG769e
e5fePZgSe8sAR4qzYqxz+pA6oZ4SPZI643ZloKBQko0bfucmpfS39ZCiLdwveYFL
kmkKVj3KAimljybz9jQxcPPxiSVKywGNkqgQFnGEh/TYyeVeLbmjAOHxoDPhdm9R
i9v9WsmlELSxRHSjjF0+B1LYK1mgiuBXmQAv9VaaKGhED+Wu+1oi6nk5qZOvnBOF
l95k6N9bvuiWjOlefbfM71dJeW7hjv6hdp3zr3kbCcw6rjD+U7E+EnA0/Bg2l8UI
xIQSdXAlPgpHY/Ec3a4UbCrUZBzeIA9AFOURBayi/KwV9d1RYMjn06LHb/kf3cYI
kLneaR+mcYyIuNRg5zmOnjZvcvwAzUukuJv1Yw8JxP1wwASTXAjgf0V351DGm0dv
JDxf7EjX0MT2uvA0WU2CjI6FTwSGGDFlvl0zruBhlKQaZEakKTCXardeuElKXhZK
ZfND1d2G6IaSB9VpLbFvw0iWRm72uCm4Cjx94TPCl8XWb6cQtIHq2z2aLsvP+AgY
f2LQhZzvGCoPTvzrmC0CmUaOfXsF2fnYQRZ0DMnHxef+96cbkYlDyo8am3jfFn3M
oskckwp4ARtKc/EWYLwq2g6OhPst0FTRFyN0MnhJ3iFKsLjvKXsTih+4BVY6hjxx
Nma7+E8O0kZZyGW/wfif
=lzcP
-----END PGP SIGNATURE-----

--qD3brAgIG4LbUq6d--
