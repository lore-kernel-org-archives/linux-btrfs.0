Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52692 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdH1MQP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 08:16:15 -0400
Date: Mon, 28 Aug 2017 12:16:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        "Janos Toth F." <toth.f.janos@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: deleted subvols don't go away?
Message-ID: <20170828121612.GA30990@carfax.org.uk>
References: <1503854146.5155.2.camel@scientia.net>
 <CANznX5Hs9i5PzeJib=XGuDwPzUCEbbvh8LrY1+7xwpadB8BiNQ@mail.gmail.com>
 <cab790fa-22f7-b05d-b18e-000c7d1a81cd@gmail.com>
 <1503907621.1671.5.camel@scientia.net>
 <83c6b0bb-a120-e0e3-dfc3-069ede63906f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
In-Reply-To: <83c6b0bb-a120-e0e3-dfc3-069ede63906f@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2017 at 03:03:47PM +0300, Nikolay Borisov wrote:
> 
> 
> On 28.08.2017 11:07, Christoph Anton Mitterer wrote:
> > Thanks...
> > 
> > Still a bit strange that it displays that entry... especially with a
> > generation that seems newer than what I thought was the actually last
> > generation on the fs.
> 
> Snapshot destroy is a 2-phase process. The first phase deletes just the
> root references. After it you see what you've described. Then, later,
> when the cleaner thread runs again the snapshot's root item is going to
> be deleted for good and you no longer will see it.

   It's worth noting also that if the subvol is still used in some way
(still mounted, nested subvol, processes with CWD in it, open files),
then it won't be cleaned up until the usage stops. Basically the same
behaviour as deleting a file. This could also explain the more recent
than expected generation values.

   Hugo.

-- 
Hugo Mills             | "Big data" doesn't just mean increasing the font
hugo@... carfax.org.uk | size.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZpAmMAAoJEFheFHXiqx3kjO0P/0QPMrLVqNTSpbuJJ20Tlrya
d1RPlK99DbvcWIPlxgsIYh7gpggUhpRztWqXI9gqbXk1dw5nDgwKTNHfJDnAZe0K
MJjT3CRrGylV1hNdSd6Wx3Xp67LMz9gAQEufJHd9MkMqQKhDzgr0w838RaQEhM2p
gLsmt6cxYFOei6lF6e9awXb1q1GhutjaOmJsvQc+Noo0i1VfrsbesJ9+74cptg+D
iKFkPLntJiAzGX3i9W9WuL8POu/mTI6tYaXvJNhbowONXnyh2VR/um+MXYf2HyUk
QHT5J2j5AIQprp5z/uiBYJffGjZGH4nQFTtIXQs/K/9aP5S9SNQw6Gf/4t4H4Mh2
9wtzQsAfHCe1b6niLhDMaKfE7D7SglMgVevctsV8nWFSPzoyTiftU7zAcf8iT6lL
RxgFCH65swMKJRzikIwFd1quN7osvDaFIFRZXdxIYSYvNiFWsoMcqjhYFdx2UKPy
aZsjcLARd7gkivOKmml1pKHX6npZza2OWPe4A3QZDKtxZARZAfhJktClytblcw0T
isJ87MPNz+i4uaM0eKioo/4F2fcdfqDk5iW0TtS5HbqbvBXeL6/4OO16MC2k15JU
NZsR8X97vUJhiXdTzqglfwBDsNrUYxvLOAHn4jvWaYkHg2TgxZE/KqTGjQk1/umb
cNraOWKLfMqFUDOxqDEg
=h4nx
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
