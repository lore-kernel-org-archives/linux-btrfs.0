From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Sun, 26 Feb 2012 15:30:36 +0000
Message-ID: <20120226153036.GB18898@carfax.org.uk>
References: <C3b0ka5D1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3b0ka5D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 26, 2012 at 04:23:00PM +0100, Helmut Hullen wrote:
> Hallo, linux-btrfs,
> 
> maybe it's a big error using the commmand
> 
>   mkfs.btrfs -L xyz /dev/sdx1 /dev/sdy1 /dev/sdz1
> 
> (and so labelling many partitions) because each device/partition gets  
> the same label.
> 
> Mounting seems to be no problem, but (p.e.) "delete" doesn't kill the  
> btrfs informations shown with (p.e.) "blkid /dev/sdy1", especially it  
> doesn't delete the label.

   What do you mean by "delete" here?

   The label is a *filesystem* label, not a label for the block
device(s) it lives on, so it doesn't make much sense to talk about
putting an FS label on only one of the devices that the FS is on.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPSlAcIKyzvlFcI40RAqTEAKCfDHoMBefwbSVn4OLbntsCjLr6BgCeODex
xp9kSZI3WUAaO7/4VkVk8cQ=
=UZPf
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
