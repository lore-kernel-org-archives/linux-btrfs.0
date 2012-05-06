From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-raid10 <-> btrfs-raid1 confusion
Date: Sun, 6 May 2012 21:17:06 +0100
Message-ID: <20120506201706.GM9860@carfax.org.uk>
References: <4FA68F50.60505@gmail.com>
 <20120506152343.GL9860@carfax.org.uk>
 <4FA6D5D0.5050501@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtx0sNU5lZ46KfgK"
Cc: linux-btrfs@vger.kernel.org
To: Alexander Koch <lynix47@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA6D5D0.5050501@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--xtx0sNU5lZ46KfgK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 06, 2012 at 09:49:36PM +0200, Alexander Koch wrote:
> Thanks for clarifying things, Hugo :)
> 
> >    It won't -- "btrfs fi df" reports what's been allocated out of the
> > raw pool. To check that the disks have been added, you need "btrfs fi
> > show" (no parameters).
> 
> Okay, that gives me
> 
>     Label: 'archive'  uuid: 3818eedb-5379-4c40-9d3d-bd91f60d9094
>         Total devices 4 FS bytes used 1.68TB
>         devid    4 size 931.51GB used 664.03GB path /dev/dm-10
>         devid    3 size 931.51GB used 664.03GB path /dev/dm-9
>         devid    2 size 1.82TB used 1.56TB path /dev/dm-8
>         devid    1 size 1.82TB used 1.56TB path /dev/dm-7
> 
> so I conclude all disks are successfully assigned to the raw pool for my
> 'archive' volume.

   Yes, that all looks good.

> > You're not comparing the right numbers here. "btrfs fi show" shows
> > the raw available unallocated space that the filesystem has to play
> > with. "btrfs fi df" shows only what it's allocated so far, and how
> > much of the atllocation it has used -- in this case, because you've
> > added new disks, there's quite a bit of free space unallocated still,
> > so the numbers below won't add up to anything like 3TB.
> 
> So how is the available space in the raw pool finally allocated to the
> usable area? Must I manually enlarge the filesystem by issuing a
> 'btrfs fi resize max /mountpoint' (like assigning space of a VG to a
> logical volume in LVM) or is the space allocated automatically when the
> filesystem gets filled with data?

   The space is automatically allocated as it's needed.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hey, Virtual Memory! Now I can have a *really big* ramdisk! ---   

--xtx0sNU5lZ46KfgK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPptxCIKyzvlFcI40RAtbxAKCnjeIvh8hfpn9485l6YwVsqBvssQCggm9M
+ofLy+0Xdubg03tlsfxZzNk=
=yAJF
-----END PGP SIGNATURE-----

--xtx0sNU5lZ46KfgK--
