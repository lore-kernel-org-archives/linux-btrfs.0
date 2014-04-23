Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59952 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaDWWxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:53:07 -0400
Date: Wed, 23 Apr 2014 23:53:02 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Sergey Ivanyuk <modemch@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid6, disks of different sizes, ENOSPC errors despite having
 plenty of space
Message-ID: <20140423225302.GC2391@carfax.org.uk>
References: <CACZaor2-NMo2PeZ=pO0ygz=VjE4JDoORp4Np8unVGd3buwKBxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
In-Reply-To: <CACZaor2-NMo2PeZ=pO0ygz=VjE4JDoORp4Np8unVGd3buwKBxw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 05:04:10PM -0400, Sergey Ivanyuk wrote:
> Hi,
> 
> I have a filesystem that I've converted to raid6 from raid1, on 4 drives (I
> have another copy of the data):
> 
>         Total devices 4 FS bytes used 924.64GiB
>         devid    1 size 1.82TiB used 474.00GiB path /dev/sdd
>         devid    2 size 465.76GiB used 465.76GiB path /dev/sda
>         devid    3 size 465.76GiB used 465.76GiB path /dev/sdb
>         devid    4 size 465.76GiB used 465.73GiB path /dev/sdc
> 
> Data, RAID6: total=924.00GiB, used=923.42GiB
> System, RAID1: total=32.00MiB, used=208.00KiB
> Metadata, RAID1: total=1.70GiB, used=1.28GiB
> Metadata, DUP: total=384.00MiB, used=252.13MiB
> unknown, single: total=512.00MiB, used=0.00
> 
> 
> Recent btrfs-progs built from source, kernel 3.15.0-rc2 on armv7l. Despite
> having plenty of space left on the larger drive, attempting to copy more
> data onto the filesystem results in a kworker process pegged at 100% CPU
> for a very long time (10s of minutes), at which point the writes proceed
> for some time, and the process repeats until the eventual "No space left on
> device" error. Balancing fails with the same error, even if attempting to
> convert back to raid1.
> 
> I realize that this likely has something to do with the disparity between
> device sizes, and per the wiki a fixed-width stripe may help, though I'm
> not sure if it's possible to change the stripe width in my situation, since
> I can't rebalance. Is there anything I can do to get this filesystem back
> to writable state?

   With those device sizes, yes, you're going to have limits on the
available data you can store -- with RAID-6, it'll be 465.76*(4-2) =
931.52 GB (less metadata space), so your conclusion above is indeed
correct.

   We don't have the fixed-width stripe feature implemented yet, which
probably explains why you can't use it. :) You can play with an
approximation of the consequences, once the feature is there, at
http://carfax.org.uk/btrfs-usage/ . Without that feature, though,
there's not much you can do to improve the situation. What might help
in converting back to RAID-1 is adding a small device to the FS
temporarily before doing the conversion, and then removing it again
afterwards.

> Also, here's a stack trace for the stuck kworker process, which appears to
> be a bug since it does this for a very long time:

   This is probably something different.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Computer Science is not about computers,  any more than ---     
                     astronomy is about telescopes.                      

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1hETlheFHXiqx3kAQJ0zg/+NuhdS2wNX0f+rNFk7VOd3vajcynLRk2v
mtYJ8fIpQGWE96hu/t/mMvfU4K5yg7b5bcPbtthXN92IScEsJJn5m8xUT6d/B/ev
/oIpOA2SYLvR3DGbBl9xLhB39FztWf9VPMjnny4KPA4ucrFMksAeI9AmAh5AzmYv
ac+ScAQOOaq18bt94kuDkqH1JttN6MhqdN09XM/pXWNFznoyPByCM8bYa2cLqE0o
K2Ec5pLO5NT9eb+i0NkWvf6cQEHVTKjEGwpUjn+GAuSuuPQR2glsw1I3Zk7rzV48
zUhcJFC3Kbs793JVF3yenEduBLstNGsxTuVps1Sld7Y+l7jz++DgsiFjmJvQA1gN
aL2wq+Gn0wBkFRE6+H26zFnKhe0dhxMQ8596opHEnwSK8E/0RHtffJ3aSLiqwE3U
dL1YtZN+gn8zmOg5S2zuKxTG1bzjdreiYakmmGcsji/ntvQH/EM4wiXp3cPNiP4k
yf4fvice2l5nQ4nC4aFSyZ6MWPq3NHhXBC3OHdOj0HqqWQdrcDbKgiE9RmnL8+zs
awStwXRyGxjTUSKGiG/qv+TMazI5sJCpO6xJTriGPePQrZm8WyCA9ZJ1/8IKY6SG
AAFw0vB478R68rH0bxBsjH1Sr1I5NQsKAq9fIkFDb6iv42RJyKKSXFQWrQ68KeDg
PlRUc7+/V+4=
=Zjw7
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
