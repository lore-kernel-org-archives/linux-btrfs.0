Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57405 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaCWTKS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 15:10:18 -0400
Date: Sun, 23 Mar 2014 12:10:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Message-ID: <20140323191017.GB3732@merlins.org>
References: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net> <20140323114712.GC25400@carfax.org.uk> <20140323162000.GK12833@merlins.org> <20140323162825.GF25400@carfax.org.uk> <20140323170314.GM12833@merlins.org> <20140323173409.GG25400@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
In-Reply-To: <20140323173409.GG25400@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 23, 2014 at 05:34:09PM +0000, Hugo Mills wrote:
>    xaba on IRC has just pointed out that it looks like you're running
> this on a mounted filesystem -- it needs to be unmounted for
> btrfs-image to work reliably.
=20
Sorry, I didn't realize that, although it makes sense. btrfs-image really
should fail though:
https://bugzilla.kernel.org/show_bug.cgi?id=3D72791

I got the image, but it's 1.5GB (1TB filesystem), but kernel bugzilla times
out after 1% of upload (repeatedly)
Placeholder bug:
https://bugzilla.kernel.org/show_bug.cgi?id=3D72801

Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQCVAwUBUy8xmX4xUKZ2O+kBAQJ7DAP/WpfCck6hFhOw4M/94EtrCviFz+ZcznHk
dCkneN3wALM9c/bsL/jJv6LemfkGRdra8IQurxAH9e11DHqQetOJIuxwgE1XyCsS
FMFFKPQijHi8tqQKLV6uwpoeusrob9aj5AkOEgDbaOZ0nqwS2VC/eUPlCIKED08y
hQU4/5ZW/0M=
=p7wu
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
