Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42765 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBMSXv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 13:23:51 -0500
Date: Thu, 13 Feb 2014 18:23:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Salter <jim@jrs-s.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
Message-ID: <20140213182327.GX6490@carfax.org.uk>
References: <52FCEF46.3070306@jrs-s.net>
 <20140213162140.GW6490@carfax.org.uk>
 <52FCF383.9090304@jrs-s.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7fXEoLLey27Fs/d6"
In-Reply-To: <52FCF383.9090304@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7fXEoLLey27Fs/d6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 11:32:03AM -0500, Jim Salter wrote:
> That is FANTASTIC news.  Thank you for wielding the LART gently. =)

   No LART necessary. :) Nobody knows everything, and it's not a
particularly heavily-documented or written-about feature at the moment
(mostly because it only exists in Chris's local git repo).

> I do a fair amount of public speaking and writing about next-gen
> filesystems (example: http://arstechnica.com/information-technology/2014/01/bitrot-and-atomic-cows-inside-next-gen-filesystems/)
> and I will be VERY sure to talk about the upcoming divorce of stripe
> size from array size in future presentations.  This makes me
> positively giddy.
> 
> FWIW, after writing the above article I got contacted by a
> proprietary storage vendor who wanted to tell me all about his
> midmarket/enterprise product, and he was pretty audibly flummoxed
> when I explained how btrfs-RAID1 distributes data and redundancy -
> his product does something similar (to be fair, his product also
> does a lot of other things btrfs doesn't inherently do, like
> clustered storage and synchronous dedup), and he had no idea that
> anything freely available did anything vaguely like it.

   That's quite entertaining for the bogglement factor. Although,
again, see my comment above...

   Hugo.

> I have a feeling the storage world - even the relatively
> well-informed part of it that's aware of ZFS - has little to no
> inclination how gigantic of a splash btrfs is going to make when it
> truly hits the mainstream.
> 
> >>This could be a pretty powerful setup IMO - if you implemented
> >>something like this, you'd be able to arbitrarily define your
> >>storage efficiency (percentage of parity blocks / data blocks) and
> >>your fault-tolerance level (how many drives you can afford to lose
> >>before failure) WITHOUT tying it directly to your underlying disks,
> >>or necessarily needing to rebalance as you add more disks to the
> >>array.  This would be a heck of a lot more flexible than ZFS'
> >>approach of adding more immutable vdevs.
> >>
> >>Please feel free to tell me why I'm dumb for either 1. not realizing
> >>the obvious flaw in this idea or 2. not realizing it's already being
> >>worked on in exactly this fashion. =)
> >    The latter. :)
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Nothing right in my left brain. Nothing left in ---         
                             my right brain.                             

--7fXEoLLey27Fs/d6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv0Nn1heFHXiqx3kAQJpDBAAqOBzUWAPtpI/IR1VmrQb0/ykU9LPvxw/
XirHB8e1nEraAxr9pLFVpzoG1r2xZBqfHYh8SmVbQWdThCQl6WcHKjWs8g2quCBd
0TM2r/8D1O+ZaubCF2FQ+k37Zc2zSxcku3V7zD5fTD+L13cEdK8QHk+6/YwEj8tf
BuV2U+sY05dXx9z//CtBiTGLQAVMdYPmvrDr5mhSYmo5yysVjhh2GKNApmsVrsnj
eu5IOU1YRLYnOcY6hL7Rk2Uhg5q7S9yu56qglmYrgS0AmalujxNBPZBYw2ZjVAcn
hEuY+t+zJ/T2cMgD2U40TVtZyFyGIFai9cgoCXjSWYPqAscsshWh8kmlU1i7CuNb
fxgT90gzRvMcgs0M07rUkLk4tZIsSg3C8/OueqBzrTa1BWl5o3jcsfP8WNwlCY1V
4BD/QjCDf9jhSheVWnBoQhFn1hcgAn+TDIX2hKE9xHcmRdGGG4SHU2ggxtuJvpZ7
4NGHHeMvxAVF00ZzGKjg0aiffeqwOwb6q2M3Nyd/CzW9oEHeTKC0JXUOdptoFqiC
Q8HTCWs9M7kt8/d34T3TzrAUcVPUM3hJtbO48A20p2yV4GnRI1iqF6n9HaRejT3J
Mo90PSw6vJ5uzELEkei2XkWbqRMReDzWP0a7GYLizCOo2EGxMw/pKDxXOKaOLOJ9
txcTZ1zFVBU=
=P2yA
-----END PGP SIGNATURE-----

--7fXEoLLey27Fs/d6--
