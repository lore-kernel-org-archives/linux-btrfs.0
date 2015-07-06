Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35149 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbGFTtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 15:49:33 -0400
Date: Mon, 6 Jul 2015 19:49:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: size 2.73TiB used 240.97GiB  after balance
Message-ID: <20150706194932.GE10539@carfax.org.uk>
References: <559AD4E5.2030107@friedels.name>
 <559ADAB5.3050804@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
In-Reply-To: <559ADAB5.3050804@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 06, 2015 at 09:44:53PM +0200, Hendrik Friedel wrote:
> Hello,
> 
> ok, sdc seems to have failed (sorry, I checked only sdd and sdb
> SMART values, as sdc is brand new. Maybe a bad assumption, from my
> side.
> 
> I have mounted the device
> mount -o recovery,ro
> 
> So, what should I do now:
> btrfs device delete /dev/sdc /mnt
> 
> or
> 
> mount -o degraded /dev/sdb /mnt
> btrfs device delete missing /mnt
> 
> I do have a backup of the most valuable data.
> But if you consider one of the above options risky, I might better
> get a new drive before, but this might take a couple of days (in
> which sdc could further degrade).
> What is your recommendation?

   Physically remove the device from the array, mount with -o
degraded, optionally add the new device, and run a balance.

   Hugo.

-- 
Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
hugo@... carfax.org.uk | pub in Pimlico."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVmtvLAAoJEFheFHXiqx3kvesP/jqE5gGnjOXtktQvtkSXd2Rl
qLzlt/lnwrquGIzhriyySykbmKm0X/VEfdK6CK+VYeRrHijIrD8AyRBxqUMYbYud
Q+0+epoeAH0PaQWRDPI3ExSbZssCLd1YmYUr/QKH5uhV7OIGsW4o8+1tqAQEaCZh
VxJp6a9JYW6061b3Jl1aLKtxeTp+crPAkX8hxPpC0TwKifTRfonbDyBGSJMebdHz
F+nV3YDjurKImtuTp0V0DFnWIOiPKnBdX8pnfUwf5QUnnYjpuCApclsOoWdgzP9A
Vm6kxVU/KwmEDBICgnfPlveiad7qXEXkRe+j11CpWpa8TYncY5uIljSLcgALcm02
LvGYOr9K6D/GYQOkSx3V3ddZl5f4GanRmQswywhVV1HWahD6dymx7Bx2yb7FO3Sw
4vXPVXd6ElgFpMMAvM+wPQyMsAlKupAtKFtXCS1nUo+i6bAU099+fU9hI/X4NnlS
bmtsM1LozHHVU5vQ/fo/fL1VCQ5fmZv0LaE9/gdpd+x1lvWZAONHdNbYXvLkNyUT
5kAN3sZXUSbg7tnwRwkqZZ1EjTUQ0LH48/NfSuzScKdYCzHujgcyhNJZcN6CZHdW
GbtcSHc3usB/0Koct0pn0ZHkg9CV0UDbkewju9ezOk3dVIZJZiBF2bqkEW8erDYm
LcDUBjTIh0VB7u6UCnWl
=/G1l
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
