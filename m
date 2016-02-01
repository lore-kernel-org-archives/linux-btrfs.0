Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43300 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbcBAVbE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 16:31:04 -0500
Date: Mon, 1 Feb 2016 21:31:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Question about a specific error.
Message-ID: <20160201213102.GC8313@carfax.org.uk>
References: <56AFB598.2020307@gmail.com>
 <20160201202112.GB8313@carfax.org.uk>
 <56AFC213.8040501@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
In-Reply-To: <56AFC213.8040501@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 01, 2016 at 03:37:39PM -0500, Austin S. Hemmelgarn wrote:
> On 2016-02-01 15:21, Hugo Mills wrote:
> >On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
> >>In the process of trying to debug issues I'm having on one of my
> >>systems with a new kernel version, I decided to do a dry run check on
> >>the root filesystem.  'btrfs check' returned a bunch of lines like:
> >>
> >>root 257 inode XXXXXX errors 2000, link count wrong
> >>         unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index
> >>
> >>I got about 20 messages like this with varying values for everything
> >>except the filetype and error counts.  Based on what I can tell, these
> >>look like orphaned inodex, but I'm not certain.
> >>Is it safe to tell BTRFS to try and fix these errors?
> >
> >    Yes, those are errors I'd expect btrfs check --repair to handle
> >properly.
> >
> Out of curiosity, do you happen to know if this is how btrfs check
> reports orphaned inodes, or is this something else entirely?

   I don't know, sorry.

   Hugo.

-- 
Hugo Mills             | We teach people management skills by examining
hugo@... carfax.org.uk | characters in Shakespeare. You could look at
http://carfax.org.uk/  | Claudius's crisis management techniques, for
PGP: E2AB1DE4          | example.       Richard Smith-Jones, Slings and Arrows

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWr86WAAoJEFheFHXiqx3kgSAP/i7ErHb/1qCgtioAHE2xCu41
ddQ+CihMXdhXE7DnR9uSNfg0mDGTZ4a4L9tstEbFKTntAUJByXJALo4SzXX2Nikw
9SNIN47PrL1r0JwmqsDAeNlykrHsXBHqOAXCiuW5W9Mpn6q45GawhCAlvBZH6x1d
i2iA4rmwE1aLssUjG7HCsiggIjIizD9lKen+Bo9G8YtNuW8OFT2bba7QYwTiReBn
VTMkHM+BI2bIKQJpobf/rakr0sCd3Nzp/Yc6gUfLnsmnP9CmqHZeKjKeC4qTOSeO
4K8kMIehP31hSrsNla9X5Q/KdktYnRRbmPE4Gxah9eTZbOh+moo0AwaAPUW77bMF
WFHLzfSVUJOmKRaiYroPCmvq84HgA4lIDTRrhgoJEdxdNZ/dl+qFakl7AX+g0lps
LwozGkzzTH6/jfcwlqdVQaHaqLNnxTcsdxJ/95VGmKM8hwTFlAljyKn0UqM6MIP6
kL4fSchi19i1CgDTLq+f49RjJPJkZJJe2pQbA23DA9b3NM5kjU49JlCqsT2CIgK5
eixEV8XLGUXOmPryYGLkdHmKNJ6ZIVCXEA4HwqBOxEiyGDWRHbZme5t+NXg2IYie
gKM/6f7IbsThd+fKmMH2wMQNLJAXvwhA0Qjr4f56WHikIgwbrf1rGO+8A+afH1BI
JI3w4pppJNxDBBNMs+fQ
=rlDe
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
