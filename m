Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47255 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161484AbaKNVwC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 16:52:02 -0500
Date: Fri, 14 Nov 2014 21:51:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Two persistent problems
Message-ID: <20141114215159.GA32735@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Chris, Josef, anyone else who's interested,

   On IRC, I've been seeing reports of two persistent unsolved
problems. Neither is showing up very often, but both have turned up
often enough to indicate that there's something specific going on
worthy of investigation.

   One of them is definitely a btrfs problem. The other may be btrfs,
or something in the block layer, or just broken hardware; it's hard to
tell from where I sit.

Problem 1: ENOSPC on balance

   This has been going on since about March this year. I can
reasonably certainly recall 8-10 cases, possibly a number more. When
running a balance, the operation fails with ENOSPC when there's plenty
of space remaining unallocated. This happens on full balance, filtered
balance, and device delete. Other than the ENOSPC on balance, the FS
seems to work OK. It seems to be more prevalent on filesystems
converted from ext*. The first few or more reports of this didn't make
it to bugzilla, but a few of them since then have gone in.

Problem 2: Unexplained zeroes

   Failure to mount. Transid failure, "expected xyz, have 0". Chris
looked at an early one of these (for Ke, on IRC) back in September
(the 27th -- sadly, the public IRC logs aren't there for it, but I can
supply a copy of the private log). He rapidly came to the conclusion
that it was something bad going on with TRIM, replacing some blocks
with zeroes. Since then, I've seen a bunch of these coming past on
IRC. It seems to be a 3.17 thing. I can successfully predict the
presence of an SSD and -odiscard from the "have 0". I've successfully
persuaded several people to put this into bugzilla and capture
btrfs-images.  btrfs recover doesn't generally seem to be helpful in
recovering data.


   I think Josef had problem 1 in his sights, but I don't know if
additional images or reports are helpful at this point. For problem 2,
there's obviously something bad going on, but there's not much else to
go on -- and the inability to recover data isn't good.

   For each of these, what more information should I be trying to
collect from any future reporters?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- Great films about cricket:  Forrest Stump ---            

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUZnl+AAoJEFheFHXiqx3k7uwP/1vMoggKT7rgDFxQ+Rbgedjg
2rMpjVq6aKf6SXhTmDDNJlGEoH4Swt1zenhyT6qGdXvn/ROSBjxgv+wZM0WSqjM9
3B7pAOSt4livr7XZzGkPfyzwWzUAGP+aWNmlX90w5ZoBYiSCf/A63eky9ICHZoha
xgrSqNuuALO+SZcSFICl+kDg9T8Yl5tkDAH8LRVaTuxa9XrtYmTBaTkUb8zVDrfW
OBKtOpOUOW53UVthhU/W/tvkwXmAFTfC86hsJuM37T/h68XxuC90LuGGELHCGZyK
6mQl+1t5VgixuTG/0m0KL+LkQIXxGhSXCBLnl/LYvOu0DOphOTW0krmXWGGI/5ah
cvJPlQ8QMA/7iN1kMxMF3U0vP+iioPZ1yUZIjQPNjtH+IZ5TBDmTJn4kofZFOQ2F
NOLHXC4T8Ks2N1XnZd4jlyAHPrRQW+gi2hU2s4AhMFs9W7uQPopjNP0APEUQ99fn
OcGDlUXDlIAnwTsnfjj/FM3YmVlka5xV5WE8hx3m9++4YzmAFcQnCYOXnKAbUzH/
9WYewok/mUVICHWCvmQV3SxiQpP6l2x459Aetz7i6x/ksK+VA4SG85un8lCgPZTg
Sf/dij5k4DOgdEUxRsJdku4vyRCo8LwcN/vgwl6VG16pLpIAERGIPQIFy47lUGUp
Lpk/1Jt4AMfvvgf4sQlp
=m/Na
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
