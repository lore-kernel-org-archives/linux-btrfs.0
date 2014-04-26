Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54145 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDZOa1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 10:30:27 -0400
Date: Sat, 26 Apr 2014 15:30:23 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Confusing output of btrfs fi df
Message-ID: <20140426143023.GK2391@carfax.org.uk>
References: <20140426140915.GA12958@mars>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
In-Reply-To: <20140426140915.GA12958@mars>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 26, 2014 at 04:09:15PM +0200, Stefan Malte Schumacher wrote:
> Hello
> 
> Yesterday I created a btrfs-filesystem on two disk, using raid1 for
> data and metadata. I then mounted it and rsynced several TB of data
> onto it.
> 
> mkfs.btrfs -m raid1 -d raid1 /dev/sdf /dev/sdg
> 
> The command btrfs fi df /mnt/btrfs result in the following output:
> 
> Data, RAID1: total=2.64TiB, used=2.22TiB
> Data, single: total=8.00MiB, used=0.00
> System, RAID1: total=8.00MiB, used=380.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=4.00GiB, used=2.94GiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> I am a bit confused because of the "single"-entries. They are not
> shown in the UseCases-example on the btrfs-website and I wonder if I
> did something wrong.

   They're harmless -- it's a side-effect of the way that mkfs works.
They'll go away if you balance them:

   btrfs balance start -dprofiles=single -mprofiles=single -sprofiles=single /mountpoint

> I also would like to know if its possible to label a multi-disk
> filesystem after creation. 

   btrfs fi label should do this.

> For your information, I am using Btrfs v3.12+20131125 and kernel
> 3.11.10-7 64bit. My distribution is an openSUSE 13.1.

   You might want to look at upgrading to 3.13 or 3.14 kernel, which
has 6 months or so extra bug fixes in it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Keming (n.) The result of poor kerning ---              

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1vC/lheFHXiqx3kAQKQ7Q/9EW1SibCnc6HjGOQCTnVI4+83aH5Q4Dyo
yyphntUFuHmEIXzXJ1usuGcxy83i8itDVR+o7Al7brSPZKW1zL1XNGNbM+dKLQ5Q
7GNtT6f+LhLP05F4NJvItg132OgytYSiHXxla+p15oox1cEUHD2rbeghDUh/pfII
/RPvWbhfhNqkItaDunkHD6HHN625Fsi6dUUhAZUH1cnQX/g2nO3u5wNNmVxUH06v
Z54KC8S1q/V9yBxk2qWggQmGouuOBJDjju+fZ57VNlu0pWMB8FqIc/OlEgW/6VbS
M2gPIjDrCL2m/KSAG58clvh0K0VUSZsHSDpkZCM2sMeI5RXWqElLLg/ysJALSjtS
cGu0JGEHEpShL6uUEZSXy1Qhs1Na0tke5YP/W8Y5F7uNNg+0+CXSS6FHkqhKKy5Q
u2O1ToiDw1J+uTHwahCmW1plkU6W8U9LS/iGorC45LZb8A6QStMfgVAoXeAyOv08
fKhiNz5w6RFcr5vAtt7OfagNbsXRNmuBB4LPrXv75Uo7V9XRMk9GudW39tJRGBUj
Odf2PnbFyhEq+vz7yCFQsz9K/Zcgi7POadPfBtQdvmUoJVnnGKdn5A+xRRTREdZi
++Fv/Ywek/LWOePXFoMLGDvCSdORKsXpqPs/qd0/seOCGgtp6ON4XkK3D9q7eppp
K7Nixt3ZO3s=
=0q2U
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
