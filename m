Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55401 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279Ab3FMVVE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 17:21:04 -0400
Date: Thu, 13 Jun 2013 22:21:00 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: raid0, raid1, raid5, what to choose?
Message-ID: <20130613212100.GG11290@carfax.org.uk>
References: <51BA34EC.1080800@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
In-Reply-To: <51BA34EC.1080800@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2013 at 11:09:00PM +0200, Hendrik Friedel wrote:
> Hello,
> 
> I'd appreciate your recommendation on this:
> 
> I have three hdd with 3TB each. I intend to use them as raid5 eventually.
> currently I use them like this:
> 
> # mount|grep sd
> /dev/sda1 on /mnt/Datenplatte type ext4
> /dev/sdb1 on /mnt/BTRFS/Video type btrfs
> /dev/sdb1 on /mnt/BTRFS/rsnapshot type btrfs
> 
> #df -h
> /dev/sda1       2,7T  1,3T  1,3T  51% /mnt/Datenplatte
> /dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/Video
> /dev/sdb1       5,5T  5,4T   93G  99% /mnt/BTRFS/rsnapshot
> 
> Now, what surprises me, and here I lack memory- is that sdb appears
> twice.. I think, I created a raid1, but how can I find out?

   Appearing twice in that list is more an indication that you have
multiple subvolumes -- check the subvol= options in /etc/fstab

> #/usr/local/smarthome# ~/btrfs/btrfs-progs/btrfs fi show /dev/sdb1
> Label: none  uuid: 989306aa-d291-4752-8477-0baf94f8c42f
>         Total devices 2 FS bytes used 2.68TB
>         devid    2 size 2.73TB used 2.73TB path /dev/sdc1
>         devid    1 size 2.73TB used 2.73TB path /dev/sdb1
> 
> Now, I wanted to convert it to raid0, because I lack space and
> redundancy is not important for the Videos and the Backup, but this
> fails:
> ~/btrfs/btrfs-progs/btrfs fi balance start -dconvert=raid0  /mnt/BTRFS/
> ERROR: error during balancing '/mnt/BTRFS/' - Inappropriate ioctl for device

   /mnt/BTRFS isn't a btrfs subvol, according to what you have listed
above. It's a subdirectory in /mnt which is contains two subdirs
(Video and rsnapshot) which are used as mountpoints for subvolumes.

   Try running the above command with /mnt/BTRFS/Video instead (or
rsnapshot -- it doesn't matter which).

> dmesg does not help here.
> 
> Anyway: This gave me some time to think about this. In fact, as soon
> as raid5 is stable, I want to have all three as a raid5. Will this
> be possible with a balance command? If so: will this be possible as
> soon as raid5 is stable, or will I have to wait longer?

   Yes, it's possible to convert to RAID-5 right now -- although the
code's not settled down into its final form quite yet. Note that
RAID-5 over two devices won't give you any space benefits over RAID-1
over two devices. (Or any reliability benefits either).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "Are you the man who rules the Universe?" "Well,  I ---       
                              try not to."                               

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUbo3vFheFHXiqx3kAQIlUQ//doXYOqj+PbgcEH7YExE5tNKuS3K0y4p8
n9iXwrc7XGwZxpp48z2kw1RkpjpiVA+LV75SlnMK7pu91c5EJX4w3gHSTlUh17np
ZKFLLrQvICh/5RNOOdllSeqwgG4zdo6M+BRrwhTzJ/2XUlRK1N4AdVO+H88sWNiD
TSQ+2cr5+jHdeJy0CYFCm2RSCh+da5t4qTPNiiCPJgmu6kTA4R2rT/wglXAEv0rq
UtcK02R02j9WSX+2J3axaEx/CY+KatJjFYDJDLUUVGBqor/i291q4yi4OAe4EJOZ
VWnjtEXXqV9iY5hMW3wLgg7fUcDHJWE6p8cG6TjL+320LzKOrEr+GFvU/xX4ju5R
jAeVOa0gem+Nz73PaiUHFiTIN2fDOAXP97ogUnbP9p355iYEIaXVzvS4cuZux0Pk
h82MxSeXCB/WGaeFuMBBHRY5I2gmrH4pen4r2BNKXk8azpVsFXsIVIOHt/C5u9JD
EU8ABLDGc1Khl/vRmiftUmr+owJ5HOUVcd+eF4USODFuQj5vPLoMRmznLIvndaE2
RNy3RTvBe6sfqJLToC5mRjj8pHJAOKiUW/8J8O0vwJPASKUOHYitDbWR5zRG2r3o
Q7UhQCsbmwq5TEioTBz0920Ikh1brwJkR2C6RLk7i6GMoj7kI7R0d5+teSH6ejch
W8JMHLUvcYg=
=l3o7
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
