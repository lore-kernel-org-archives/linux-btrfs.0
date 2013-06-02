Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35886 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3FBQaW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 12:30:22 -0400
Date: Sun, 2 Jun 2013 17:30:15 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Tim Eggleston <lists@timeggleston.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 total capacity incorrect
Message-ID: <20130602163015.GG20133@carfax.org.uk>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
In-Reply-To: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 02, 2013 at 05:17:11PM +0100, Tim Eggleston wrote:
> Hi list,
> 
> I have a 4-device RAID10 array of 2TB drives on btrfs. It works
> great. I recently added an additional 4 drives to the array. There
> is only about 2TB in use across the whole array (which should have
> an effective capacity of about 8TB). However I have noticed that
> when I issue btrfs filesystem df against the mountpoint, in the
> "total" field, I get the same value as the "used" field:
> 
> root@mckinley:/# btrfs fi df /mnt/shares/btrfsvol0
> Data, RAID10: total=2.06TB, used=2.06TB
> System, RAID10: total=64.00MB, used=188.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID10: total=3.00GB, used=2.29GB
> 
> Here's my btrfs filesystem show:
> 
> root@mckinley:/# btrfs fi show
> Label: 'btrfsvol0'  uuid: 1a735971-3ad7-4046-b25b-e834a74f2fbb
> 	Total devices 8 FS bytes used 2.06TB
> 	devid    7 size 1.82TB used 527.77GB path /dev/sdk1
> 	devid    8 size 1.82TB used 527.77GB path /dev/sdg1
> 	devid    6 size 1.82TB used 527.77GB path /dev/sdi1
> 	devid    5 size 1.82TB used 527.77GB path /dev/sde1
> 	devid    4 size 1.82TB used 527.77GB path /dev/sdj1
> 	devid    2 size 1.82TB used 527.77GB path /dev/sdf1
> 	devid    1 size 1.82TB used 527.77GB path /dev/sdh1
> 	devid    3 size 1.82TB used 527.77GB path /dev/sdc1

   You have 8*527.77 GB = 4222.16 GB of raw space allocated for all
purposes. Since RAID-10 takes twice the raw bytes to store data, that
gives you 2111.08 GB of usable space so far.

   From the df output, 2.06 TB ~= 2109.44 GB is allocated as data, and
all of that space is used. 3.00 GB is allocated as metadata, and most
of that is used. That adds up (within rounding errors) to the 2111.08
GB above.

   Additional space will be allocated from the available unallocated
space as the FS needs it.

> This is running the Ubuntu build of kernel 3.9.4 and btrfs-progs
> from git (v0.20-rc1-324-g650e656).
> 
> Am I being an idiot and missing something here? I must admit that I
> still find the df output a bit cryptic (entirely my failure to
> understand, nothing else), but on another system with only a single
> device the "total" field returns the capacity of the device.

   That's probably already fully-allocated, so used=size in btrfs fi
show. If it's a single device, then you're probably not using any
replication, so the raw storage is equal to the possible storage.

   HTH,
   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- I can resist everything except temptation ---            

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUatzF1heFHXiqx3kAQJ1MhAAuJCkS8i4KV2WffCL7I2tSAoKthBEFVq1
LUgP2C2CtnzLInqdQpKBbMz/E1IvoAm3Xz2NeLbsNX66lntX0VWiZ5C7kgczJ3Qf
lS5lJAOWLoJi3s5g7/sPutVkkInv1sB0B5yg5yNSErbEu0tJD4L9IfiarTspVs3q
5pcUAXFzc8m76C1k03SrMOCRdzNjPvaqDWBGAEzpBiVUXzf0DbBc1Ws8nyXWM0dl
07/UDzY439Lex+d/qHHwLRw6H9wd0zV30iQu/cst9VQvfQq0Ixzwr2nsCnbtFafX
ai78LcFQofpLkuy4LyxRSaY2R0N3TTJEZ4cVKQfWHQjQjN+rKPV8ClwlWzaes6Hm
1+yGigw6Z690vE5jcSVmNAP1CdhJY2ZL+TYT97xIk/UTFa1vuYniUNC5Gq5EVfqW
Xcwb1yBucsJSYhvypf5KuK+0ECUxxBFYFztgH3mW1MUf6mXUyAu0Y33kPn+oooAQ
0vzuC42RZifrCJ20G/KxKEf9Dgyv33gAQShoVBF2IrbWwS2p/ly84GInKUA+LIpF
sxSaFpFX6q0LTdq2IEEf95V3oxVlfotulmbQz7YN/RahojCFDYXy/SI3o0HO86BF
QKihAPxy2ZLdgU3RD5S364c9ycUNVlpiV86hIq+Id+ihV6ddq82GaXd2HsuK2QPf
4StoQodu5nM=
=Wh5X
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
