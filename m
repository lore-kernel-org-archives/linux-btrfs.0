Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37803 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcCAQ2B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:28:01 -0500
Date: Tue, 1 Mar 2016 16:27:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Carlos Ortega <carlos.omicron.ortega@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid
Message-ID: <20160301162758.GA27786@carfax.org.uk>
References: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
In-Reply-To: <CAO2Nr8dqVBiOSTLxdS-E_WoKk13mJkGJ9PB7qOBDq-1YhHi-Gg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 01, 2016 at 11:19:34AM -0500, Carlos Ortega wrote:
> I'd like to confirm that btrfs raid actually works.  My filesystem
> looks like it's a simple concatenation judging from its size in df -k
> output.  btrfs filesystem df says it's a raid10, I just don't
> completely trust it.  Also I'm stuck at version 3.19.1, I can't go
> higher.

   Don't trust plain df. It's likely to be lying to some degree. btrfs
fi df will tell you how much data is under RAID, and btrfs fi show
will tell you how much space is not yet allocated. There's a couple of
FAQ entries on how to interpret that output correctly.

> Can someone confirm that raid works in this version?  If so which
> levels of raid?  I'd prefer raid5 or raid6.

   Definitely don't use parity RAID on 3.19. It's not really something
I'd trust, personally, even on 4.4, except for testing purposes.

   TBH, I wouldn't really want to be running something as old as 3.19
either. The actual problems of running older kernels are, IME,
considerably worse than the perceived problems of upgrading. If you're
restricted to that version by some upstream supplier, then they should
be giving you support and recommending what's usable in that kernel.

   Hugo.

-- 
Hugo Mills             | There are three mistaikes in this sentance.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW1cMOAAoJEFheFHXiqx3kCO4P/jfDxvnrjST+QeNtTn145CTi
OzP9nyRWSFrk9zR00QTuO98NEb0bF4cAChojWYHuIoPQq+kVpuaEOSTP7k9cb/7s
K0V7ppS5EEi4EzvVumdP2HdP1s4JOLr5bOwkY/lpXKj2EHh23Xe5i343E0FvO+/2
8FodgEenvUdz5qV50w27RYXm97Znl2+vf7DpBnOGCX267tvXPKyxdhx5hskAEeCb
A+wPgifSM8vemss2PMixsNUjGg8v4KGhgzofINVLL15bZKH20pcEziTq6qkVjZ74
2OQHHqlgLue45nAxTp0w7jpVSmXRX7u3Nd073SwTk1zWxw3V5jrX6jeyQZvv41ob
i07Cfuqj8yF6FV8jKzaX6uV3GdnmM1tTUqADIBVY4o3lb1fGJJ8vws9AE1uJI2E0
oUP/WhA2+enY80mSrHSAF0MJwK8FdHIirsacJM7TWom/RcQoAzReOeZEi2oYI7Dw
xiRPxwPuCDGUoJBOoBJP89Z4+KDvDY3GPQFNYnfef/b7fjs6er9yeOn/xzYYdr82
cB4WcF9Scl7oGkozX/PJAm3pd3y77Mm5ppnoajWGFgCZ7d5vf25VjcSJi+yYkRps
TL4bb1+VK30u5VjxHVCI0ZDnlT2AgB7QuJmfxW/3rGN1jITzl5vZbKlBM7NZHFyT
lRAx9N0eRV05yDouHsgA
=OXrG
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
