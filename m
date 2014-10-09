Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45893 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJILzx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 07:55:53 -0400
Date: Thu, 9 Oct 2014 12:55:50 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
Message-ID: <20141009115550.GA10301@carfax.org.uk>
References: <54358C77.2070808@redhat.com>
 <54367193.6000202@gmail.com>
 <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 11:53:23AM +0000, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
> excerpted:
> 
> > Also, you should be running btrfs scrub regularly to correct bit-rot
> > and force remapping of blocks with read errors.  While BTRFS
> > technically handles both transparently on reads, it only corrects thing
> > on disk when you do a scrub.
> 
> AFAIK that isn't quite correct.  Currently, the number of copies is 
> limited to two, meaning if one of the two is bad, there's a 50% chance of 
> btrfs reading the good one on first try.

   Scrub checks both copies, though. It's ordinary reads that don't.

   Hugo.

> If btrfs reads the good copy, it simply uses it.  If btrfs reads the bad 
> one, it checks the other one and assuming it's good, replaces the bad one 
> with the good one both for the read (which otherwise errors out), and by 
> overwriting the bad one.
> 
> But here's the rub.  The chances of detecting that bad block are 
> relatively low in most cases.  First, the system must try reading it for 
> some reason, but even then, chances are 50% it'll pick the good one and 
> won't even notice the bad one.
> 
> Thus, while btrfs may randomly bump into a bad block and rewrite it with 
> the good copy, scrub is the only way to systematically detect and (if 
> there's a good copy) fix these checksum errors.  It's not that btrfs 
> doesn't do it if it finds them, it's that the chances of finding them are 
> relatively low, unless you do a scrub, which systematically checks the 
> entire filesystem (well, other than files marked nocsum, or nocow, which 
> implies nocsum, or files written when mounted with nodatacow or 
> nodatasum).
> 
> At least that's the way it /should/ work.  I guess it's possible that 
> btrfs isn't doing those routine "bump-into-it-and-fix-it" fixes yet, but 
> if so, that's the first /I/ remember reading of it.
> 
> Other than that detail, what you posted matches my knowledge and 
> experience, such as it may be as a non-dev list regular, as well.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---      

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVDZ3w1heFHXiqx3kAQJ8Ig//ZnwJY4bGJ38WpOYdoD+9Zyw6gGkX7pnP
kvege14iE/0iZLQjtALlGN9lw0bKSHLSehZm/8gz0jAQcqVgL4FNzmqECk4ZlLwn
9wH4DPM4ejYAN2W8n/n6rkaJ1qs7NRjY3M7HODEVBMAx0rbE5XB8f6H8jNAeTOMX
MVHJqj37EcLH+2u8W1tyTPwYeVUG009jYfVpw7AUZpTVDhSaLqwh8wgRzAmJ1RPv
NmQVCLeSjVAU1XSAPgYjkJl5wKhQh2X7K8FCIAmyamuBckh1fNR7Lq18bymZx9i5
yCA3/Yhs95ILAQd2+4wbw/w7lz8p6cKIt5hQSFZVK/lAznPaqDl2RBDcHODX51Lk
Pcl4E4xKIvzyS1thPCgzKnH4bWCbvRy8bBP26nOURhRvun05B0gCIZoSj50MGfwq
Qlk5+WZAvhx4br04kWKLVs1WBNRRztKy+ZYcyedvvjAuRDvdZyQdF1jJ9/vhljXh
Z9cf45qhP9U9AdjtZtJQZwzQa6xfvuTcg0nDKw7iNz2P6tBPmnnBCxAFFaMZrXad
WliFTM+JsDMzzDTgmgC+w7o0MRlSxkweYhonLL1td064OXaXgvcnm1M8bfqONGIH
tyfNfJJIlC9Qf9vq1hlAZaq6pMXMT9P9f8WpqxkusPVKnYYg5i81HeKvjX91Jo2v
muw+cK7Hxr8=
=GeUv
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
