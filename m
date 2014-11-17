Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56664 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaKQLKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 06:10:46 -0500
Date: Mon, 17 Nov 2014 11:10:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Two persistent problems
Message-ID: <20141117111044.GD32735@carfax.org.uk>
References: <20141114215159.GA32735@carfax.org.uk>
 <54667B7A.8050704@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
In-Reply-To: <54667B7A.8050704@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 14, 2014 at 05:00:26PM -0500, Josef Bacik wrote:
> On 11/14/2014 04:51 PM, Hugo Mills wrote:
> >    Chris, Josef, anyone else who's interested,
> >
> >    On IRC, I've been seeing reports of two persistent unsolved
> >problems. Neither is showing up very often, but both have turned up
> >often enough to indicate that there's something specific going on
> >worthy of investigation.
> >
> >    One of them is definitely a btrfs problem. The other may be btrfs,
> >or something in the block layer, or just broken hardware; it's hard to
> >tell from where I sit.
> >
> >Problem 1: ENOSPC on balance
> >
> >    This has been going on since about March this year. I can
> >reasonably certainly recall 8-10 cases, possibly a number more. When
> >running a balance, the operation fails with ENOSPC when there's plenty
> >of space remaining unallocated. This happens on full balance, filtered
> >balance, and device delete. Other than the ENOSPC on balance, the FS
> >seems to work OK. It seems to be more prevalent on filesystems
> >converted from ext*. The first few or more reports of this didn't make
> >it to bugzilla, but a few of them since then have gone in.
> >
> >Problem 2: Unexplained zeroes
> >
> >    Failure to mount. Transid failure, "expected xyz, have 0". Chris
> >looked at an early one of these (for Ke, on IRC) back in September
> >(the 27th -- sadly, the public IRC logs aren't there for it, but I can
> >supply a copy of the private log). He rapidly came to the conclusion
> >that it was something bad going on with TRIM, replacing some blocks
> >with zeroes. Since then, I've seen a bunch of these coming past on
> >IRC. It seems to be a 3.17 thing. I can successfully predict the
> >presence of an SSD and -odiscard from the "have 0". I've successfully
> >persuaded several people to put this into bugzilla and capture
> >btrfs-images.  btrfs recover doesn't generally seem to be helpful in
> >recovering data.
> >
> >
> >    I think Josef had problem 1 in his sights, but I don't know if
> >additional images or reports are helpful at this point. For problem 2,
> >there's obviously something bad going on, but there's not much else to
> >go on -- and the inability to recover data isn't good.
> >
> >    For each of these, what more information should I be trying to
> >collect from any future reporters?
> >
> >
> 
> So for #2 I've been looking at that the last two weeks.  I'm always
> paranoid we're screwing up one of our data integrity sort of things,
> either not waiting on IO to complete properly or something like
> that. I've built a dm target to be as evil as possible and have been
> running it trying to make bad things happen.  I got slightly side
> tracked since my stress test exposed a bug in the tree log stuff an
> csums which I just fixed.  Now that I've fixed that I'm going back
> to try and make the "expected blah, have 0" type errors happen.

   I've searched the bugzilla archive and found the two reports that I
know of (87061 and 87021); I couldn't see any others. I've requested
more information on both -- nothing obviously in common, except SSD
and (probably) discard. I tried to tag them both with "trim" for easy
finding, but that seems to have been lost somewhere. I'll try that
again when I get home this evening and have access to my password.

> As for the ENOSPC I keep meaning to look into it and I keep getting
> distracted with other more horrible things.  Ideally I'd like to
> reproduce it myself, so more info on that front would be good, like
> do all reports use RAID/compression/some other odd set of features?
> Thanks for taking care of this stuff Hugo, #2 is the worst one and
> I'd like to be absolutely sure it's not our bug, once I'm happy we
> aren't I'll look at the balance thing.

   OK, good to know you're on both of these. I think the "easy"
solution to reproduce the ENOSPC is to convert an ext4 filesystem. It
doesn't seem to be a unique characteristic, but it is a frequent
correlation. We had another one today, after an FS conversion -- I've
asked them to attach a btrfs-image dump and the enospc_debug log to
the bugzilla report.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- 2 + 2 = 5,  for sufficiently large values of 2. ---         

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUade0AAoJEFheFHXiqx3kBZcP/3yHn6bygpNpvDTC8lp8DYoz
F5IJI+VFNehYTSPlY0aGIqYR/tcT+9FqglRZEb6BW2eTLRH8xVfwxJih2vdTAHvu
3+JZ1JzlJhh2sa+Q0tYaeaiEkZnH+S7Yyt0GVgqjqpotCb/lnquHPAEoaFxqeIjz
L8pXoYOH4NqbyD3ETkvFJwsUBAMDicltVxils07H3EHYil5tBVbSU/eMNq0ztipZ
dN0Rrs1JKATDfb0Y6aEIC1jtI9XkoiBnvDquTFCkuMys+cTf/lI2m3dacmbajdD8
mICAEyg3hbytKgXOsZcbzMqWiIpJPynY7qZ2TgxLdd65X3uplmg/+AyHjnq0wm6M
CKlZ7Z5myPiHRmPwc6RmbvUzRu/YxGRPlFv9FRrbMV9tWhHe/ngQpeQc2VrTFh3S
rNZK3i2TrBcLpjWojkqlVvFOLm6GCYLkEuh6i8+KOQIet5+8O1jxn6aFGYn0IGGa
zBdnzC3SUPFYMxHf3fV1ENiW7puN7I8t6WP6f58e+SpEW1y++VANYI0hi2+8SX3I
jDbVpzdYtVHRrkXlaX4sw+9VlCBuVfxgwlvBC1TSBiKDKEF+Md0J4nIR9hvMRdq7
n/uXWZOhnnwAY6KcjpO4S84zZPm1ZTMsissIRbISmDJjUhbG5Iwy6WULPo+BlAE3
rkq6h7GfUIu6jxBCkZ1f
=UHxX
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
