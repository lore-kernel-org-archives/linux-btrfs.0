Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59151 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451Ab3GRWDO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 18:03:14 -0400
Date: Thu, 18 Jul 2013 23:03:09 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Questions about multi-device behavior
Message-ID: <20130718220309.GD20517@carfax.org.uk>
References: <1860433.azE0Vf7tMy@horus>
 <20130718173337.GN24343@twin.jikos.cz>
 <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
 <ks9ogo$8rg$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
In-Reply-To: <ks9ogo$8rg$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 02:59:58PM -0700, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 18/07/13 13:05, Chris Murphy wrote:
> > Sounds like if I have a degraded 'single' volume, I can simply cp or
> > rsync everything from that volume to another, and I'll end up with a
> > successful copy of the surviving data. True?
> 
> Not quite.  I did it with cp -a.  Because all the metadata survived, cp
> would create the target file, but then get an i/o error on opening/reading
> the source file.  It would print an error message, but not delete the
> empty target file. Consequently I ended up with loads of zero length files
> I had to go in and delete afterwards.

   The odds of having an undamaged file from that process are much
better for single than for RAID-0 (and aren't affected by having tools
which will cope better with IO errors -- although you'll get more of
each damaged file if you do). As the file size goes up, the odds of it
being damaged increase.

   Hugo.

> I briefly looked for an rsync option to keep going on source i/o errors
> but didn't find one.
> 
> Roger
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
> 
> iEYEARECAAYFAlHoZV4ACgkQmOOfHg372QRPFwCgob01TavS2qffBkxkuv0g9bl3
> pC8An25Mgx+cRXb0Kds+GRnzaj2P0Acy
> =UA5J
> -----END PGP SIGNATURE-----
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am an opera lover from planet Zog.  Take me to your lieder. ---  

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUehmHVheFHXiqx3kAQIRDQ//RI+KpcVaC8aE09719aXeum9NHyMpLPHB
LlFf1lQjfnZUbhrf1/64qxu+0DrOw3CzLOL/eznnPxzAVMTTPmbg1dGlse/8cFBZ
U6nrrnusgPJAyB8sjBBmceN6PZpNFvzsrN6WC3eIAsDsSKJ41AFydnLHr054MfRk
iE6fGebxDKvPZK8BeJ5ruhRut0r+2DepMnZ/gClIfxvbWRp6QJrRHmosQzmdu3d9
329twi/zELQGnzFevkrXh/vEtZpn9qaYirMyDeU/BJR7oeoNTFGsYPMKZiRcw7uD
ACqhHTznNEGNVgotHaIFrwkisD6mkD/g4J4GdD0Pe8vheNkdTm00r8z/EjEAQ1JW
uUMAdOQ9y5J42vCI7xaYhKNvGXzXuxBIYxgSPn9uDxkahXa6jnUkPYgBf5lQVfE8
btg1NAOBRDFPrgjUBnzfjPzrvxuxZm1cuK3254IbFNjy9kjN1TDI1Q6qnl8CN6M9
nhfW4xKk0ePypq82WAGn6u7f/6SgKP1Y6gjzjEffd8l/7FbqubPh4BEGg5+4L+OK
2gMwqWNlZ8/sEO8nB7TJ7EH74DP5jqvAwnN2qDpn7j6J2klXMzYkuroKT1AiSiVL
kKuNYOExCIhJa7Z5HyKSRU1Oor0jEPG4CtQ8RlB4VqLzNexvqiUlyPqGEPsHzBpE
e9l/ioz/I9I=
=CuP4
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
