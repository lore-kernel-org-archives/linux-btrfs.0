Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49033 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLXRHW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 12:07:22 -0500
Date: Wed, 24 Dec 2014 17:07:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ali AlipourR <alipoor90@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: making btrfs on raw images
Message-ID: <20141224170719.GI25267@carfax.org.uk>
References: <CABvhJLgvP+sg57r8LrweLXDV48QMCqCLnveK3WLLKqrRSLDu6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+nYw8KZ/oNxZ8JS"
In-Reply-To: <CABvhJLgvP+sg57r8LrweLXDV48QMCqCLnveK3WLLKqrRSLDu6g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--X+nYw8KZ/oNxZ8JS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 24, 2014 at 08:26:13PM +0330, Ali AlipourR wrote:
> Hi
> 
> Do inserting images in loop device before using mkfs.btrfs on them is necessary?
> 
> I ask this because mkfs.btrfs gives warnings when I make btrfs on
> images directly without inserting them into loop device, do this has
> any drawbacks?

   No drawbacks. I've used this method for testing purposes.
Obviously, you'll have to set up the loop devices to mount the FS, but
mkfs shouldn't have any problems.

   Hugo.

-- 
Hugo Mills             | 2 + 2 = 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--X+nYw8KZ/oNxZ8JS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUmvLHAAoJEFheFHXiqx3kchsP/iO3HIHtCuOWwF5x3dlRY188
OnmP6tuV8mFizV6T1sAGi9HoWHDKCgphi1/arFqLkmZlezsJO8tU3yZQLMLlsE0F
0lLPsUFrz+Aiomd5MeEewCNh6icDXsGNrUGVAlIZCU45B/EPwJ2Pb8CIqtm/znd1
ThQvDboxX7viLh1Pqq9LtXq2gDAq6O4c7mG2j/8eNxWxC7ef+5tdZvBj/FVq7IxD
u0KTZmzVHTOiYS+N8DKqERWk5eLjBjgwMflGePdb4vM0JqkAaNpKns/xw/GoPUtr
SposOoexP3PZhXPKkLX43/zkwX4slg3QvJFcGZ+lEDbqak3dZIsnbAvnrpzzpxtU
xuvo5WohkU8onUCiGtp4TvgAy7N7mj18/+fbjTwMfJxK72sLBjhXKsG9HgCDfPBF
6QYL1rdn+zss7KqUvzPUpz9Fq3cWto6WyyEJO8mrNJyjWHmZHrlawVu0hBC3YnIf
/5or1TUGjv2p8padvs0VQmDw0KBj0JPz0pkkAOg2ukvYvPH/8Cw11FDzRZ93ZuNG
9dfmZxdicoI1EyFkxYL6mbPb9hx/ymGRmzQoIr7sHmkP9ZCwveXUmbwLkpAVWInV
s2ukLrYumTdtGiWTUxQOgmjhrway1ZniwlijtYu7GlaRwKSc2CyhXy1MXZ7tDPL8
EfGJ3VDthbRJOaC5raB1
=QYYX
-----END PGP SIGNATURE-----

--X+nYw8KZ/oNxZ8JS--
