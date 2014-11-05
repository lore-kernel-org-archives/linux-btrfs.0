Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42880 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaKEVpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Nov 2014 16:45:16 -0500
Date: Wed, 5 Nov 2014 21:45:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Cyril Scetbon <cyril.scetbon@free.fr>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Compatibility matrix kernel/tools
Message-ID: <20141105214515.GD21247@carfax.org.uk>
References: <4CB60C7D-97C0-4DA5-830B-CAD0E3D0C22E@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
In-Reply-To: <4CB60C7D-97C0-4DA5-830B-CAD0E3D0C22E@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2014 at 09:57:31PM +0100, Cyril Scetbon wrote:
> Hi,
> 
> Where can I find the compatibility matrix to know which btrfs-tools version should work with a chosen linux kernel ?

   Any of them should work with any kernel.

   For normal operation, if the tools are too old, they may not
support newer kernel features -- but that will simply mean you can't
access the feature, not that anything will be broken.

   If you're doing recovery work (btrfs check and friends) then using
the latest released version of the tools is strongly recommended.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- Putting U back in Honor,  Valor, and Trth ---            

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUWpprAAoJEFheFHXiqx3kALwP/jIiHTcB4nHDkYQNY5iS7UiP
PHPti5vzQ6RCarM5V6ycFyv29rbmnAnSW5j/sOR8Jujq+EdCFbVn5VE7FovCq3Uk
4g6SHKvXuhKo8EN3jC012DVAP7NF7pQUpI1rkp2KQ5HvPAJRXldg0lVFZYCddw1i
yZ77+HNgqCW800ZHx85nxGZ007CFb2hchuvTNUcusvFaGS2Hsv8kOj6c9YWRVy+y
C2yIwkcQacywDjhl2cEobCKjEi4jeRMTYvgUWk27JMfaNUi2g7T27bOepSMb45U0
yQESMIweELUjZhX2z4nnwfENBg3ZUyFX6oWzCVJCiTiaZbRWVRHjhLzilnP/obzc
c5YiSXS2ejozj8DI8z51/J5fPftrW9ljbmWq7KfmGOEjNr9VAjg7Z8/s5bleuElW
vn1EjF9GF+KmZEKj9sQlByu6mOamuxshDzqW1OpoB8U0WwMH8a7rRum4nPYB5WQy
mx/ZVXoeTdRzVURFpKqIy1cQY7wfufSSPFj4w55nO+0C9aYHretQQH+UxxFMx1vC
UzzRGU9Z4OQHK+PkEbqeIDLvCML4EqjLDnZmGl6r+aAJb4Z8HgtN+9kdEl8VfLT0
2WBtsAFil6tzmPQAT9zsG+B0MilOOoIRnBW6PjO+CY1UvpTTtkrv1kzEgJ2S47hd
xrFxtkVh84UrRR3tu0Te
=De5P
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
