From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Online resize vs ENOSPC
Date: Mon, 9 Mar 2009 14:35:01 +0000
Message-ID: <20090309143501.GD6698@vlad.carfax.org.uk>
References: <20090309103141.GA5335@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090309103141.GA5335@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 09, 2009 at 10:31:41AM +0000, Hugo Mills wrote:
>    After an online resize, the filesystem reports its new size, but
> still runs out of space at the old size:
[...]
>    Unmounting and remounting the filesystem seems to make the new
> space available for use again.
> 
>    This is the second time I've had this happen to me now, so it seems
> to be more-or-less reproducible, although I haven't deliberately tried
> to trigger the behaviour yet.

   Just to confirm, I can indeed reproduce it trivially:

$ sudo lvcreate scratch -n testresize -L 5G
$ sudo mkfs.btrfs /dev/scratch/testresize
$ sudo mount /dev/scratch/testresize /mnt
$ sudo chmod ug+w /mnt
$ sudo chown hrm. /mnt
$ cd /mnt
$ dd if=/dev/zero of=foo.txt bs=1M count=4096
$ sudo lvextend scratch/testresize -L 9G
$ sudo btrfsctl -r 9G /mnt
$ dd if=/dev/zero of=foo2.txt bs=1M count=4096

and I get an out-of-space error within a few hundred blocks.

$ cd ..
$ sudo umount /mnt
$ sudo mount /dev/scratch/testresize /mnt
$ cd /mnt
$ dd if=/dev/zero of=foo2.txt bs=1M count=4096

and then I can write the full 4G of data.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- There are three mistaiks in this sentance. ---            

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJtSkVIKyzvlFcI40RAnDDAKCCQccw15sqXMFeicGHtelmij/MQQCbBAYe
Wfz4878rdIOG3U26zNa4S0M=
=3md5
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
