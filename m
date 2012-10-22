Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52389 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2JVJTI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 05:19:08 -0400
Date: Mon, 22 Oct 2012 10:19:04 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: device delete, error removing device
Message-ID: <20121022091904.GY25498@carfax.org.uk>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
 <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m9FEOsnejx470nED"
In-Reply-To: <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m9FEOsnejx470nED
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 12:02:08AM -0600, Chris Murphy wrote:
> 
> On Oct 21, 2012, at 10:32 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> > This is stock Fedora 18 beta kernel, 3.6.1-1.fc18.x86_64 #1 SMP Mon Oct 8 17:19:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
> 
> Probably not a good idea to omit this is a beta *test candidate* not a beta. 
> 
> Two things that make this possibly not realistic:
> 
> 1. The virtual disks are obviously very small, 3GB each with the 4th one only 12GB.
> 
> 2. The original 3 device volume was ~97% full with a single large file prior to adding the 4th device. Approximately 313MB free space remained on the volume.

   I'm not entirely sure what's going on here(*), but it looks like an
awkward interaction between the unequal sizes of the devices, the fact
that three of them are very small, and the RAID-0/RAID-1 on
data/metadata respectively.

   You can't relocate any of the data chunks, because RAID-0 requires
at least two chunks, and all your data chunks are more than 50% full,
so it can't put one 0.55 GiB chunk on the big disk and one 0.55 GiB
chunk on the remaining space on the small disk, which is the only way
it could proceed.

   You _may_ be able to get some more success by changing the data to
"single":

# btrfs balance start -dconvert=single /mountpoint

   You may also possibly be able to reclaim some metadata space with:

# btrfs balance start -m /mountpoint

but I think that's unlikely.

   Hugo.

(*) It may be an as-yet-undiscovered reservation problem, in which
case you get to see Josef scream loudly and hide under his desk,
gibbering.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                --- If it ain't broke,  hit it again. ---                

--m9FEOsnejx470nED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIUPh79z9OVl50rAAQLFAg//duqMtQKg+XXsG3PogkJpNwyT0xxjVhEB
o/qZFagZQqk6vx13ZRIpNhneQ+8oy+HTQ2wXtVDgkP0GsyyIivOYOqPPHFpPFRbw
LkHekwX4oLHjsXvSWARwcZEdsU5+PnEFLjO55AvF5Hms+CehkswagNLUHhqq3QWF
XLVioE5B/FSWQN8OGvRRXZrPvM3Em1+10P/oDs8FO5ErLMmKe0fyFXWixUepX+E2
6cQCby6mqn64W9AeyWXkMrj63otPepAuOzmjayA/n+v1Wj+YqSw6cBTyRm5I2W3C
OzB7Q4vWUneVYB5of5LccWhbyZzv9H9ZmDjCbnI2xdJYXJ0adNNI++KMXi8y97/q
tPUWFi1Xyk4AG5ZJ3JIzNkhH0A9lZazYP91cM1XiWCDB4kZTZXGIFnvJLfHHDEj3
1JEZ52//kMarpX+yyS+QJxAx0KxyHzo63M25YIkol5L9bbYIVXzszsuS6Ilr0Wds
vo1j5Vd/AxmECg6RSqMCZLTjdj2stRRfsTY+KJIvuWlAqYYDpR0a/wh77rZbexwF
IHxlxpfibNpOudvJxIggDbgxwbpJCsBWGCj1SnM5K1sgj8TfEidu0nTntru7ZEZo
JE5l6UuZzocTfNbEAkedL0uQr/WJd5rJmnSAAWrwNWZzfYQgM1CMBH0fFEbSJcNR
huoSojJ80v8=
=PZBf
-----END PGP SIGNATURE-----

--m9FEOsnejx470nED--
