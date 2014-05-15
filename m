Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46541 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaEOQTF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 12:19:05 -0400
Date: Thu, 15 May 2014 17:18:58 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell@coker.com.au>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: staggered stripes
Message-ID: <20140515161858.GA25467@carfax.org.uk>
References: <2751140.Zb1qMBeNgk@xev>
 <pan$a10c6$96b782de$86a74a2f$b7f37af@cox.net>
 <4172915.as80o3hoBa@xev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <4172915.as80o3hoBa@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2014 at 12:38:04AM +1000, Russell Coker wrote:
> On Thu, 15 May 2014 09:31:42 Duncan wrote:
> > > Does the BTRFS RAID functionality do such staggered stripes?  If not
> > > could it be added?
> > 
> > AFAIK nothing like that yet, but it's reasonably likely to be implemented
> > later.  N-way-mirroring is roadmapped for next up after raid56
> > completion, however.
> 
> It's RAID-5/6 when we really need such staggering.  It's a reasonably common 
> configuration choice to use two different brands of disk for a RAID-1 array.  
> As the correlation between parts of the disks with errors only applied to 
> disks of the same make and model (and this is expected due to 
> firmware/manufacturing issues) the people who care about such things on RAID-1 
> have probably already dealt with the issue.
> 
> > You do mention the partition alternative, but not as I'd do it for such a
> > case.  Instead of doing a different sized buffer partition (or using the
> > mkfs.btrfs option to start at some offset into the device) on each
> > device, I'd simply do multiple partitions and reorder them on each
> > device.
> 
> If there are multiple partitions on a device then that will probably make 
> performance suck.  Also does BTRFS even allow special treatment of them or 
> will it put two copies from a RAID-10 on the same disk?

   It will do. However, we should be able to fix that with the new
allocator, if I ever get it finished...

   Hugo.

> > Tho N-way-mirroring would sure help here too, since if a given
> > area around the same address is assumed to be weak on each device, I'd
> > sure like greater than the current 2-way-mirroring, even if if I had a
> > different filesystem/partition at that spot on each one, since with only
> > two-way-mirroring if one copy is assumed to be weak, guess what, you're
> > down to only one reasonably reliable copy now, and that's not a good spot
> > to be in if that one copy happens to be hit by a cosmic ray or otherwise
> > fail checksum, without another reliable copy to fix it since that other
> > copy is in the weak area already.
> > 
> > Another alternative would be using something like mdraid's raid10 "far"
> > layout, with btrfs on top of that...
> 
> In the "copies= option" thread Brendan Hide stated that this sort of thing is 
> planned.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- Stick them with the pointy end. ---                 

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3To8lheFHXiqx3kAQJdGhAAr2NdKh0bu4n8Y+YBMtqvz0uzL5EOqAvD
SOR/lmLDRyZGgK627LSD9jiwm1Sfu5hVsjuw7DSKh2EK+3gFDdXOtfk3+PuX7JsX
RZhRjjHPwWKX/rZyCgrhbAUdFHZtctoPZYi3hjc6gKoQCGqo+eFwe4iBtjoxcjLm
IXHWa/xqitmE7ZdMotoXZ8G/RP+Nfxwyx2ZRGjtSy4vlBAPsZVlO+jt3MtdR4Qn1
/GJ1DtT2xCiZGJUxPNmY254+gHicQTkMTYDPRLxYhCLVtLPQhQ8wOKBddpOfzg9X
Pm/88D/sLTPlfVaF7JIcO4JZWHmbPE9MiC/+wlhoWEPUI5V2maI9H4GDqoyqNSGJ
2muhIbcEnPhWjFq14y9UDD4SEmndrrHzlJ89kmLO1fc5Fp8QaJWgWiixp0INTfHO
rFrIGMukzs9SoHJfAyaXnPDP42oGEr6eDUdMQedCOGeqMFd60M7NSrLao0C2GTOD
l09pc43UbviKId+TrcOU91WQgaxsdSQ67ww3or0rYdKldTUFJfezm8Ld5FBbT9l+
X/F2O7w4+aTz6XyYR/2Ns2GqbbIAmM+bIPrmhzst4vZjh28Y+oZA9nTAYOXozAWJ
LrSrmnsJxAHS56Yn7zAP5oejtFIq4CU9Ya0gWMpkDz6/sNXAJv7DXQYzvLfPvcPp
qX92zZxVFIo=
=Me4o
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
