Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38828 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3LRPLS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 10:11:18 -0500
Date: Wed, 18 Dec 2013 15:11:17 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: no space left, metadata usage almost full?
Message-ID: <20131218151117.GN11281@carfax.org.uk>
References: <20131218213728.07d47dd5@virtall.com>
 <20131218124652.GL11281@carfax.org.uk>
 <20131218235439.480170e0@virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7VkxxUl3xUvPtoxk"
In-Reply-To: <20131218235439.480170e0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7VkxxUl3xUvPtoxk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2013 at 11:54:39PM +0900, Tomasz Chmielewski wrote:
> On Wed, 18 Dec 2013 12:46:52 +0000
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > > # btrfs fi df /home
> > > Data, RAID1: total=2.51TiB, used=1.58TiB
> > > System, RAID1: total=32.00MiB, used=372.00KiB
> > > Metadata, RAID1: total=48.00GiB, used=47.23GiB
> > > # btrfs fi balance start -dusage=5 /home
> 
> >    Currently, yes, it is the only approach.
> >    Hope the above helps,
> 
> So the balance finished, and metadata is still almost full:
> 
> # btrfs fi df /home
> Data, RAID1: total=1.60TiB, used=1.58TiB
> System, RAID1: total=32.00MiB, used=248.00KiB
> Metadata, RAID1: total=49.00GiB, used=47.24GiB
> 
> Confused about the output - does it actually look any better?

   Yes, because...

> # btrfs fi show /home
> Label: crawler-btrfs  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
>         Total devices 2 FS bytes used 1.63TiB
>         devid    3 size 2.56TiB used 1.66TiB path /dev/sdb4
>         devid    4 size 2.56TiB used 1.66TiB path /dev/sda4

   ... you have unallocated space here, so the FS can now allocate
more metadata as it needs to.

> Does it mean that data/system/metadata will be able to grow now,
> until their size in total in 2.56TiB?

   Yes.

   Although note that where btrfs fi df reports space, that's _usable_
space (i.e. how much data you can fit in it), but where btrfs fi show
reports space, it's disk bytes (i.e. how much of the disk has useful
content on it). With RAID-1, the first figure is half the second
figure. In your case, that's simple, but with different RAID levels
for data and metadata the calculation becomes a little bit more
complicated.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- What part of "gestalt" don't you understand? ---           

--7VkxxUl3xUvPtoxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUrG7FVheFHXiqx3kAQIhrxAAr27WJ0tA63K6GHwce9wLebSDNCb77u3o
XGtNmwdknmZxt2RHy8Fn1FrsZ9VoVvdO5bHTmi1ydnGHmplVCmhwQFkjIjs68p6w
48Aeqp20LN+pOxpxpbZHLN7cKo3pj7g/pTDEncihqQnF+UD6GFDOE0azeurGtwX2
TfDZtQKJOvycJspU6Z6VVhkqhTke6eLSA4yN5aBMOq+BQbg6MkPXa26298C8Ai7v
jrsHD2hD5QpbofbCcXJWAtYWCe59i3QLEA0W6noQsKSVCpJ9yKU+fd1WQptvBTmC
AAdV5vEN1AhAmQQEW9BMNo45ZEuPAB2HalxtSjl9Wym4csFqk2OCjBLmOdoluc5U
lKGGzrLcnw4UcGHeOW3YuqFuqB4F+zcUCZKgQifSnj5bh8b12iEqLZQKX+kWnQ4S
pGHexlsZEV49Ic0Um7Qkz4lAzuubSJ/Jvc0DxBhgk3iMa3JQiByhFQ6C2a9OkqUe
a4Y9/byp4yGabn3HLRt21s0/4M1e53fyw+r2Fg9YSrWmvEdCMJ11oLz8IPbXx7f2
9ncfOBj8GLB1wb18L2yg1c/I4wvT5kOyGO/tAbpDd3eRrj5tjrwNKhstDtqrNxw1
eNVPfVexYieQrZxKrFGaRGkAdt2hqz8vO/W6Di7ETsBLtbZDLfLSHvnEZcFkQBlv
kTLxL8n0y+c=
=v60Y
-----END PGP SIGNATURE-----

--7VkxxUl3xUvPtoxk--
