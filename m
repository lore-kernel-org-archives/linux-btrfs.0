Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43201 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbcBAUVO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 15:21:14 -0500
Date: Mon, 1 Feb 2016 20:21:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Question about a specific error.
Message-ID: <20160201202112.GB8313@carfax.org.uk>
References: <56AFB598.2020307@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
In-Reply-To: <56AFB598.2020307@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 01, 2016 at 02:44:24PM -0500, Austin S. Hemmelgarn wrote:
> In the process of trying to debug issues I'm having on one of my
> systems with a new kernel version, I decided to do a dry run check on
> the root filesystem.  'btrfs check' returned a bunch of lines like:
> 
> root 257 inode XXXXXX errors 2000, link count wrong
>         unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index
> 
> I got about 20 messages like this with varying values for everything
> except the filetype and error counts.  Based on what I can tell, these
> look like orphaned inodex, but I'm not certain.
> Is it safe to tell BTRFS to try and fix these errors?

   Yes, those are errors I'd expect btrfs check --repair to handle
properly.

   Hugo.

> I'm running btrfs-progs 4.3.1 on kernel 4.3.3 (at least, that's the version that
> works right now, I see the same errors on 4.4.1, but I have other issues
> there that are (hopefully) unrelated to BtRFS).

-- 
Hugo Mills             | Charting the inexorable advance of Western
hugo@... carfax.org.uk | syphilisation.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWr744AAoJEFheFHXiqx3klCIP/RaGI9+RT0vBN4vB+z3P9t91
eLxNrqhYPXBtXdfhL7c/AGHyoLph7sm4A8GgdwwzW0jVcBI2pA2WAx4MnuuC8f++
y0YNrTNpVnHT4bNBnNWeveTN6zhyrDTzrr54wcEqYKqH4hKjADj7LIhAsN76vc3z
83Bf/vgYZCrmt9CacOW1Uc9dJ4CUQ2M9TgxDKu5FmNhggCwU6Td8KH8CymLTKg96
joHRABJ/mIeBTZ1iWQVIAKH8D+e3IY9Bp4wFS3C/ey9PI3jt0SL3Eoj7PdsrR3Bb
t0cGLOin4Yiwjb237SJET4XZ0GJesuK4mauKJSmXNud8H9NB/VYuU5GBo0eqAkhE
jVhlQjr2HUUlO7wByo6Hy9ODbZJ+cR2gJu9VeYGPy5IPXZCGn4Yt7ZBOfkn8jOZk
X7DDEFNYM8SLvPuMbEV3h3gEQji+7hi7ocZmaxDP0p5CybaFzMHbbQrqZkxgZ/k4
HpbjlC5yaptMn4Qyk6O4m7+ZCL+koHqYyUZ7SIIRk9cvqOeC9qN75bTX53JnLCAz
YN7WfIQ8WHFu/oimPEPto4rQZ3r5YZcg8PloICVPsQMF69z/iSniG8sxgTlNZjWh
1XPu9ooUWn/hzF9Sv+flQIz/DSrYvNdy9GFZ3b4N+3FMW55RFQJHXcyJ7DNldIcq
q7Jx6poo1F9vcsTRjuoJ
=SzdD
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
