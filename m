Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39209 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaD1MGN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 08:06:13 -0400
Date: Mon, 28 Apr 2014 13:06:11 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Confusing output of btrfs fi df
Message-ID: <20140428120611.GB10151@carfax.org.uk>
References: <20140428115702.GA26444@mars>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
In-Reply-To: <20140428115702.GA26444@mars>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 01:57:02PM +0200, Stefan Malte Schumacher wrote:
> 
> 
> > So try this one:
> > btrfs balance start -musage=0 -v
> 
> I fear that didn't work too. 
> 
> mars:/mnt # btrfs balance start -musage=0 -v btrfs/
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=0
>   SYSTEM (flags 0x2): balancing, usage=0
>   Done, had to relocate 1 out of 2708 chunks
>   
> mars:/mnt # btrfs fi df btrfs/
> Data, RAID1: total=2.64TiB, used=2.22TiB
> System, RAID1: total=8.00MiB, used=380.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=4.00GiB, used=2.94GiB
> 
> 
> >If that fails to remove the extra system chunk, then we have a mystery
> >indeed.  What's different on your system and why isn't it working?
> 
> I have no idea. Its just a plain openSUSE 13.1 and they consider btrfs
> support stable enough to use it as default filesystem in the upcoming
> 13.2. I could create the filesystem again and restore the data but of
> course I would actually need to know what went wrong the first time in
> order to avoid doing it again. Is there anything you need to know
> about my system which would be of use? (Controller, Disks, Mainboard
> etc. ?)  

   The question is, why is this important?

   The presence of that area won't affect the operation of the FS in
the slightest. The FS won't write any data to that area, and it's only
4MiB in size -- completely lost in the noise for a 2.6 TiB filesystem.
At worst, it's an extra line of output; slightly messy, but utterly
harmless.

   I think the default kernel for OpenSuSE 13.1 is 3.11, which may be
old enough that it doesn't have the patch that allows balancing of
chunk 0 (which is probably what's happening here).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "You are demons,  and I am in Hell!" "Well, technically, it's ---  
               London,  but it's an easy mistake to make."               

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU15EM1heFHXiqx3kAQIOMBAAuYxYQwZ+C+hs6ThS3wBW7ZN+3ssd/Vpi
mA0ZZrmJ7q7pBbDlyke0pbRMPZcT1WUK7FpCttylnvQna4ih0BgDDm+7wSTOSDEr
QmSCE2iN+WZMVzz71PR6ADENfIf2Ntkh+TwnmdHu3ssdNxXbobjLi0Jc+XAMn0fg
OOalKv1voGRBdZ9du+obisnXXa9xze1OryHh0qUdeArYktGS7n07xX2YTGRF5ein
LTcIEeKclTNjaRmnSJelRwHMFko2Kth4ZDtC2m6BqKV3321VX3555VoHXUXSVsAs
3cvGwxUkpXViK29BVAKb6Po8F1ewOy6r3kaxkJ8Fp074t0/R2LkVUmnO8CuEP3FX
MTQoOqSW3C8lzSaT/JOMETuGtZmPOG+n2rGxA42HMhnGwtG7RzyUp6xrFHJulVIF
qJzpy6ufR5O4Rm3bke1VShqFlYz+54OAynAiTtA2xm3514PnKZ32u9HAof7R0HMh
xD3GQ+esxmGrmoWpipDoEd1e9gobX763Yc/1DC6GXhnbuL2a3zQsbjMosamWF32z
Vv8eU4fPRTkkfQDb1JB1C4utwCf9xCWnR0qvcAjxBb5Imy060Ik/M1QlTCaTDbz7
DBBwnu+FBtoGezrxmoub+m8NYoeofOtN7thcb5Ag0nmg6l5vl1pnO5T1eNFxFTUD
CMcAHog5lkU=
=vSvI
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
