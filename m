Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42783 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848AbaLLPxD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 10:53:03 -0500
Date: Fri, 12 Dec 2014 15:53:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi df output "unknown"
Message-ID: <20141212155300.GF1442@carfax.org.uk>
References: <CAAe=sHV8-8BK9xj2n0mhh_URoAYUNWg-y8QVFv-Efh7StRtYag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
In-Reply-To: <CAAe=sHV8-8BK9xj2n0mhh_URoAYUNWg-y8QVFv-Efh7StRtYag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 09:38:10AM -0600, sys.syphus wrote:
> why would there be "unknown" data below? i have 2 btrfs arrays and
> both have this going on. neither are active. any idea why and how to
> make it go away?
> 
> 
> Btrfs v3.12
  ^^^^^^^^^^^
  This is what's "wrong". Upgrade your userspace tools to (IIRC) 3.16
or later, and it'll report it as "BlockReserve", which is what it is.

   The kernel started reporting a new chunk type to account for the
block reserve, and your tools aren't new enough to know about it. For
now, just ignore it -- it's harmless.

   Hugo.

> btrfs fi df /media/btrfs
> Data, RAID1: total=314.00GiB, used=313.55GiB
> System, RAID1: total=32.00MiB, used=64.00KiB
> Metadata, RAID1: total=1.00GiB, used=422.45MiB
> unknown, single: total=144.00MiB, used=0.00

-- 
Hugo Mills             | I am but mad north-north-west: when the wind is
hugo@... carfax.org.uk | southerly, I know a hawk from a handsaw.
http://carfax.org.uk/  |
PGP: 65E74AC0          |                             Hamlet, Prince of Denmark

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUiw9cAAoJEFheFHXiqx3khz8P/2LGA1MasNp5uujdtPQpp4zW
QzfL+rKr9HhiGbOfty1kKTRj40wzJ4d2Q4f9ko92qvWJqDLooPSFOgNw4f7QpVOq
JwUpQXjQICDoUWKdR8rDxQulXOuT3dy6KpnUo4YpBIt4o+8qJMC1Zv37aTBJAkEf
bc9l02MLxpD6mmpovl6NIEBZoPnIiNbT+WvmhHRvDgCFWStM+mtCAgDwjn36D3X2
9c2qjjwJj9odN8qHs6qLV4WPvwUsRkfKROdhG0Exd4PcsC9HMNpD+cpKfbSmmSDt
SZpomsXdNwSRHRZ4bhBQz808rTeXzXEI+rZDGiyOaCjwVzGX8ZJxasyRQ8lACwEj
KZvNx7kG/zyIvYwHVVGaFY7//wjZ5prUdtnaPJQsw7ybgbrtE12m2QhDo6tYx6wb
DpKI+uxFXF8C/Bwf8V1jYQP0uB0aeBnxQExUwQxYh2RezVLdM98S9wRPsPjmpb5+
EvLxITW0i2WJAPHH1GboOjETMZTfchmA1/Pq+WQeDVy7mP7fR478twd6a5sMkW9o
kEKfruhpFEYpIKJUsFSlNxHExg4iTblsgdqsHydw2IShSskQEvC87ZypNEE6A0+k
ADbrSjoypz7pJwqhNhSKHWk1cKI8g0NoxRirfiate3p+hUe+ucxkrYnwB1J4v7HK
0fp6uP2YsUAbOD3hddHY
=dguE
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
