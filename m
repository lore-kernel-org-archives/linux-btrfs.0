From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: RAID not RAIDing? Or at least not showing correct usage?
Date: Sat, 24 Sep 2011 20:35:47 +0100
Message-ID: <20110924193547.GB2459@carfax.org.uk>
References: <96eceb54b5f19f36507deb29d049fbaf@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <96eceb54b5f19f36507deb29d049fbaf@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 24, 2011 at 02:51:12PM -0400, Ken D'Ambrosio wrote:
> Hi, all.  I'd never done RAID on btrfs before, so bear with me if I'm missing
> something obvious.  I just created a RAIDed btrfs partition with 
> 
> mkfs.btrfs -m raid10 -d raid10 -L bigguy /dev/sdb /dev/sdc

   This won't work -- you need a minimum of 4 devices to run raid10.

> (I also did the same, but with RAID-1, getting the same results I'm about to
> outline.)  That's two 3-TB disks; since they're RAIDed, I expected to wind up
> with ~3 TB of free space.  But df reports 5858378624 available.  Knowing that
> df and btrfs don't always see eye-to-eye, I copied over a 350 MB .avi, and
> fired up btrfs-show, which came back with:
> 
> Label: bigguy  uuid: 5e062e02-f55e-4d7f-866c-3b851b3c6e02
> 	Total devices 2 FS bytes used 350.57MB
> 	devid    1 size 2.73TB used 1.27GB path /dev/sdb
> 	devid    2 size 2.73TB used 0.00 path /dev/sdc
> 
> That don't look very mirrored to me.  All the instructions I found said I
> should just mount /dev/sd(b|c) singly; is there, instead, a logical RAID
> partition I should be mounting?  Or... is there something else I'm just
> missing?

   I would expect it to look like this if you did mkfs with raid10,
but not raid1.

   You can see what it thinks it's doing with:

$ btrfs filesystem df <mountpoint>

which will give you the space allocated and used, and replication
method, for each of data, metadata and system information. The values
returned are values *before* replication (so 1G of RAID1 shown here
will show up as 2G used with "btrfs fi show").

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "Your problem is that you have a negative personality." ---     
                             "No,  I don't!"                             

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOfjETIKyzvlFcI40RAvJtAKCjUNVk4iqoGyPYiKCDOIycQyogcQCbBlMq
isW9YWXR62WkNbW9sH6jaNc=
=qvOY
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
