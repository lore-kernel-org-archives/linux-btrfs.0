Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58031 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaCWLrP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 07:47:15 -0400
Date: Sun, 23 Mar 2014 11:47:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ERROR: error during balancing '.' - No space left on device
Message-ID: <20140323114712.GC25400@carfax.org.uk>
References: <20140323070144.GG12833@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
In-Reply-To: <20140323070144.GG12833@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 23, 2014 at 12:01:44AM -0700, Marc MERLIN wrote:
> legolas:/mnt/btrfs_pool2# btrfs balance .
> ERROR: error during balancing '.' - No space left on device
> There may be more info in syslog - try dmesg | tail
> [ 8454.159635] BTRFS info (device dm-1): relocating block group 288329039872 flags 1
> [ 8590.167294] BTRFS info (device dm-1): relocating block group 232494465024 flags 1
> [ 9200.801177] BTRFS info (device dm-1): relocating block group 85928706048 flags 1
> [ 9533.830623] BTRFS info (device dm-1): 824 enospc errors during balance
> 
> But:
> legolas:/mnt/btrfs_pool2# btrfs fi show `pwd`
> Label: btrfs_pool2  uuid: 6afd4707-876c-46d6-9de2-21c4085b7bed
> 	Total devices 1 FS bytes used 646.41GiB
> 	devid    1 size 820.45GiB used 820.45GiB path /dev/mapper/disk2
> Btrfs v3.12
> legolas:/mnt/btrfs_pool2# 
> Data, single: total=800.42GiB, used=636.91GiB
> System, DUP: total=8.00MiB, used=92.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=10.00GiB, used=9.50GiB

  ^^^ This is where you're full. There's a block reserve here that
  (should be) usable for doing a balance, and it seems to be about 500
  MiB or so that's the point at which problems show up.

> Metadata, single: total=8.00MiB, used=0.00
> 
> I can't see how I'm full, and now that I can't run balance to fix
> things, this is making things worse.

   I think you probably shouldn't be doing a full balance, but a
filtered one:

# btrfs balance start -dusage=5 /mnt/btrfs_pool

which should only try to clean up chunks which have little usage (so
it's much faster to run).

> Kernel is 3.14.
> 
> What am I missing?

   Not much. We do seem to have a problem with not being able to run
balance in recent kernels under some circumstances -- you're not the
only person who's reported this kind of problem lately.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Don't worry, he's not drunk. He's like that all the time. ---    

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy7Jv1heFHXiqx3kAQKkeQ/+JDq+I8ewl54FIczksgIipcUePKIbWRg8
HLJj9BTvJglrFYH3KHdA+7J9RYYvvUrZ1+eE1qVi+pGhX0iskJh8QGqw8pSgIvV0
nx75foD370hI18J9Uq+a4aIcOfzxTM2RqO0rbv8lOH249YlzTZI9aeAlP6LNYCjZ
uVXH2ly2T/qEvzD+bTsaMEloIZC3l/sHnvwqkaf487oeW2beuhlmMq3wR2uOHavn
V4A0o+Hiv8S2ZftIQflS5A2T62+p4kTBumhoh3nf9WQg2no2FQDIOl/KFQWLH6Pn
/M1A1zioL2oWccE1MQllTFWKCAaobFHTzD8lNY+aJXUqc7SZISFfbW/aRO3Jv040
+Z/x3e0On0fLyocIXzdpAg1vkUPpo1mQDSUDG0J85z0vIvFu6mbLDIwvB3aS+fKs
yt0XUti6lEOMFjfjf5R3ZKwBvmqR1rpbGjyUAp2nrhAAMD13OR03fDm6mPxoSasK
y+sJfAn0ve0nyUL2G/dO3gXLFgXWorJntwkbj3nBASFSOjCqVgwtur2CWvBu5BjB
WImlOoFBmKo6/gWy2oIaFeknCcxoRhPFVfdN6Er7Up8RR2COZsB0CRbA1O8b+ZP1
FFwdupfukagyls1Q0IYDR6WdP0d+MeAcHheRMh4d14nTVqs1VJYgC90nW7EDXq4u
Y7NW7qTTWSE=
=Li0r
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
