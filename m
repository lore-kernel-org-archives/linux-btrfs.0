Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36894 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2JVTuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 15:50:08 -0400
Date: Mon, 22 Oct 2012 20:50:02 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: device delete, error removing device
Message-ID: <20121022195002.GB25498@carfax.org.uk>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
 <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
 <20121022091904.GY25498@carfax.org.uk>
 <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
 <50857C8F.9030401@gmail.com>
 <E9CD3D97-968D-4475-A699-95D803210DF1@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O2g7+miYGsIKoR9l"
In-Reply-To: <E9CD3D97-968D-4475-A699-95D803210DF1@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--O2g7+miYGsIKoR9l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 01:36:31PM -0600, Chris Murphy wrote:
> On Oct 22, 2012, at 11:18 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > 
> >   It's more like a balance which moves everything that has some (part
> > of its) existence on a device. So when you have RAID-0 or RAID-1 data,
> > all of the related chunks on other disks get moved too (so in RAID-1,
> > it's the mirror chunk as well as the chunk on the removed disk that
> > gets rewritten).
> 
> Does this mean "device delete" depends on an ability to make writes
> to the device being removed? I immediately think of SSD failures,
> which seem to fail writing, while still being able to reliably read.
> Would that behavior inhibit the ability to remove the device from
> the volume?

   No, the device being removed isn't modified at all. (Which causes
its own set of weird problemettes, but I think most of those have gone
away).

> >> [ 2152.257163] btrfs: no missing devices found to remove
> >> 
> >> So they're missing but not missing?
> > 
> >   If you run sync, or wait for 30 seconds, you'll find that fi show
> > shows the correct information again -- btrfs fi show reads the
> > superblocks directly, and if you run it immediately after the dev del,
> > they've not been flushed back to disk yet.
>
> Even after an hour, btrfs fi show says there are missing devices.
> After mkfs.btrfs on that "missing" device, 'btrfs fi show' no longer
> shows the missing device message.

   Hmm. Someone had this on IRC yesterday. It sounds like something's
not properly destroying the superblock(s) on the removed device.

> >   I think we should probably default to single on multi-device
> > filesystems, not RAID-0, as this kind of problem bites a lot of
> > people, particularly when trying to drop the second disk in a pair.
> 
> I'm not thinking of an obvious advantage raid0 has over single other
> than performance. It seems the more common general purpose use case
> is better served by single, especially the likelihood of volumes
> being grown with arbitrary drive capacities.

   Indeed.

> I found this [1] thread discussing a case where a -d single volume
> is upgraded to the raid0 profile. I'm not finding this to be the
> case when trying it today. mkfs.btrfs on 1 drive, then adding a 2nd
> drive, produces:
> Data: total=8.00MB, used=128.00KB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=409.56MB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
>
> This appears to retain the single profile. This is expected at this
> point? What I find a bit problematic is that metadata is still DUP
> rather than being automatically upgraded to raid1.

   Yes, the automatic single -> RAID-0 upgrade was fixed. If you
haven't run a balance on (at least) the metadata after adding the new
device, then you won't get the DUP -> RAID-1 upgrade on metadata. (I
can tell you haven't run the balance, because you still have the empty
single metadata chunk).

> What is the likelihood of a mkfs.btrfs 2+ device change in the
> default data profile from raid0 to single?

   Non-zero. I think it mostly just wants someone to write the patch,
and then beat off any resulting bikeshedding. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- I spent most of my money on drink, women and fast cars. The ---   
                      rest I wasted.  -- James Hunt                      

--O2g7+miYGsIKoR9l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIWjar9z9OVl50rAAQIg4A/9HdPzWonFrgyECc2mmmcFSDXWr/hJ2LuZ
elu6aGrslSPMd5DF2htUQG5q/I8IaX5AuADpKKuBoMq2vjAh4oeLgjmlDTj6h8t+
ZAYkuNepbvbItVRdFAFv+GM0xOsYC3Ton7HHkprwIG0G60aMnXAxsimZw30NOnco
jrLAR3R6bMX36FL2T10H21anH/SZrHdRO4bx6dBm4okn8nlRAU3qpnztycRtzo1y
txAaybtMHtwKaTGp6exk6mce1F97W/rV3gW84Tn0MgpGOpLRiBEcXI1bAWF+isoT
0miQzeEVX9s3aPmAfIftorpDVsu1tozaXO2AuFYZz2aR67hkPMoRlTVJFC1YRXgi
S7HMti2OiotEssUtyLtv2hV6TKm3+TyaRJL9V0jQ0yDLveMqRFkpjFKUIMTJjaoN
F5qTZ250RRZIUDTVYTsxMjzQWulrZwYMjpi5bNeSWRp2ySqjX/sGD+3++IrXps5r
beCTUeOIMRburJohft/o1eURmYm6QwSmad4oXhsb8cwdgooO21i3WR+R/3gnO1jE
2c3Ruzi8l1Q/Vl+Sd8lIMmU/psTGuec8tMKRCRoBD43wujoN59gmT/TR8ANPtnyH
/KB2ZdvGr5T9e0qgGP34UzzzBVczdbeMOGygljQxeOvRNpNN9OZMLF4A7/WqEfGM
muHIAbZPSog=
=y2id
-----END PGP SIGNATURE-----

--O2g7+miYGsIKoR9l--
