Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50962 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaA3Vn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:43:57 -0500
Date: Thu, 30 Jan 2014 21:43:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Maziarz, Jeremy M." <jmaziarz@mitre.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Stop using btrfs
Message-ID: <20140130214333.GA18327@carfax.org.uk>
References: <CC0E5F0A-26F9-46B9-9C24-1DDD1FF72004@mitre.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <CC0E5F0A-26F9-46B9-9C24-1DDD1FF72004@mitre.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2014 at 09:27:55PM +0000, Maziarz, Jeremy M. wrote:
> Everyone, here is a noob question: how do completely delete a btrfs filesystem (RAID10)?

   wipefs, on each device, is the precision approach -- it will very
carefully damage the magic number in the first superblock on each
device, which is enough to make most tools ignore the filesystem.

   Alternatively, the nuclear approach is simply to overwrite the
first megabyte or so of the filesystem with zeros, with something like:

dd count=1k bs=1k if=/dev/zero of=/dev/sda

> $ sudo btrfs filesystem show
> Label: none  uuid: 0ee72c25-9169-4836-873d-468ebdea8c1a
> 	Total devices 4 FS bytes used 92.00KB
> 	devid    1 size 1.82TB used 76.02GB path /dev/sda
> 	devid    2 size 1.82TB used 76.00GB path /dev/sdb
> 	devid    3 size 1.82TB used 76.01GB path /dev/sdd
> 	devid    4 size 1.82TB used 76.01GB path /dev/sde
> 
> Btrfs Btrfs v0.19

   Incidentally, this is a very old version of the userspace tools. If
you're running this, it's quite likely that you also have a fairly old
kernel, which may account for any other problems you might be
experiencing...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUurHhVheFHXiqx3kAQLnnRAAiX2LdVWERfRaQWVrRtvyT5oR2Pfzf4ky
grOcFwxgERg8O4KLok7T3S99tMb/wjM5gAvQnojokahnvtCl0c7PAjTQsMuDsqrX
ik7JGFHVAoGoAZ29pelk0/uJHYNUslCUiQ8y2SmBbcPS4zUL76q6e4M+thDrQRq5
6Np5e+4jTt46oFCxsOEMysHSn4IKc+Ycai6PPwdcXILSJUzoVOA2A6X/leN/hKTi
CmULJGjtPJS77RtATpBsiOi6E+uIFloP5zSg+vS2meRBfDFOsga8SynGw5wDqo0l
tyJJr1leFhhwLWB4eHgKmoO+dztqzCmvX0Q/Lwj7qmP3YHSUYdBVMqvaY7gvOuZW
8pwOIo4WgB+We+ZgOJwlH5f1OCJjNyvezWyfBFllnD0Y4yJRAjp2GOBwudQR9i6H
V+cJOTxE8l/HmtaM5jeBkjht2pZGs1u0Mc+GlpragVVrdGaWKFRz2AGjMyd00TuR
acs7rN4lfEUCZjzBly9WmIZ00SU1Y/OQ5dA7g1vEKUku3iqMai/fTIMNX8JZMVTK
CcM1zXFE5tSGaHFtsdB8v1qFohQ2gJevQ6SJH60ltQo6aY4MORRlnmZlGrLJH7es
ZBm2G5vVUNIikrKuERQkfEKVmof0Q2uwfvEgBgH67uJ4NwUL1QmoWj0VWWWOZGFF
lWAvTtAu2ag=
=APJv
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
