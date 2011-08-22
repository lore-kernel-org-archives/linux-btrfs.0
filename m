From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: BTRFS corruption - the filesystem grows and the new files
 appears (at least)
Date: Mon, 22 Aug 2011 18:40:14 +0100
Message-ID: <1314034830.29318.6.camel@picard>
References: <1314018424.11180.7.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-SE5B9t6UrCoaxib/PXV3"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314018424.11180.7.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-SE5B9t6UrCoaxib/PXV3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-08-22 at 14:06 +0100, Maciej Marcin Piechotka wrote:
> Hello,
>=20
> I got btrfs corruption and I'm not sure if it is known yet. i suspect
> that it happened after hard reset (I got freeze first so I'm not sure if
> it wasn't caused by something else).
>=20
> The symptoms are that the allocation grows at all time during
> read/writes (it reached 49 GB for 30 GB of data on disk in total).
> Btrfsck reported several errors (and wasted space) but the partition
> mounted nonetheless. I created the disk image and copy the data from
> image to the partition. I haven't compared the checksums of files but I
> haven't found any other then 1 new file with random (i.e. the nautilus
> complained that the name is not valid) name.
>=20
> Is is known error or should I include the debug data (the btrfsck output
> etc.)? My kernel is 3.0.3.
>=20
> Regards

1. This is a data corruption. I got ~20 files corrupted (at least)
2. The output of btrfsck (I "reproduced" it twice - each time it was on
new partition with rsync from mounted image):

# btrfsck /media/BACKUP/home.4.img=20
Device 1 (/media/BACKUP/home.4.img) opened in fd 4
couldn't open because of unsupported option features (8).
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
root 256 inode 286682 errors 400
root 256 inode 286901 errors 400
root 256 inode 286915 errors 400
root 256 inode 286918 errors 400
root 256 inode 286934 errors 400
root 256 inode 18446744073709551604 errors 2000
root 256 inode 18446744073709551605 errors 1
found 41491558400 bytes used err is 1
total csum bytes: 40017208
total tree bytes: 512430080
total fs tree bytes: 429453312
btree space waste bytes: 132018866
file data blocks allocated: 41102532608
 referenced 42599010304
Btrfs v0.19-36-ge36502e-dirty
# btrfsck /media/BACKUP/home.5.img
Device 1 (/media/BACKUP/home.5.img) opened in fd 4
couldn't open because of unsupported option features (8).
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
root 257 inode 1911 errors 400
root 257 inode 6629 errors 400
root 257 inode 190598 errors 400
root 257 inode 194632 errors 400
root 257 inode 199345 errors 400
root 257 inode 199613 errors 400
root 257 inode 201378 errors 400
root 257 inode 18446744073709551604 errors 2000
root 257 inode 18446744073709551605 errors 1
root 259 inode 18446744073709551604 errors 2000
root 259 inode 18446744073709551605 errors 1
found 33812979712 bytes used err is 1
total csum bytes: 32674804
total tree bytes: 351416320
total fs tree bytes: 280096768
btree space waste bytes: 76978911
file data blocks allocated: 33551613952
 referenced 38453358592
Btrfs v0.19-36-ge36502e-dirty

3. I believe that it happens on 3.0.3 but I didn't had it on 3.0.1. Each
time the screen went blank and computer freezed. The second time I got
the well-known kernel OOPS bug.

Regards

--=-SE5B9t6UrCoaxib/PXV3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOUpSOAAoJEJIdee2Vr4aPsWYP+wfCqFZOVEhFN2b8u9UvYfqs
1+bZVCGuEjaBNNAx/gKp4SrWyIz46/q+log0tDYwFsIzx5jchjrouUpNyioGVRCj
YEInVjR1Zrh9lYim2EKAEDkGgup/0I2hUHk8JrF081n0+L9nkyI4eUtSlvw2BJyy
Me1HjRzBTzqIxP1Y+bKCag1LzYQZtt/eJB5fMv0jE3GKrkO7BcfT/FDjZe6nyZQ7
sL24SCyjIGZRVxLKMTNAGjZTslEvA3VvhXV83Hzath3/ilraMNDcmfpfYficJe8T
R8f4SUsaXPCDtkWgJnOFZx2Bol0GeDXj4Z9IaNkxm3kCm1Rsy7nQKzdyzLHtVQlT
kHENhCE6GLAMXjtf2pwhAMzm7LvtSR7FNk1OJTPZXAO5kuCGSrsbgiJIik+YrF7o
AUr2CJ/4fBOP1Z+QqUQ7zypZQ1d1vr03Wr/9e2A7/bNmPlNeJPty4iATWGleK+q1
OewkYoYW0UaGGlfw3igK7//cO3PeSZ/0kZu+DxDAmwLhKYSavSGClkqklb0nqHxF
LAtQjERHyVhDf2Y3DneoeKJbdmF9JcEqptTrxMMiTkH7w/WkRNRvOwTuMao4IpUH
zviY8Qvrssiqyu9yEV6XnH8ytfejW84mqCopCUmoaTYV3gjrJ6ZFG2x2MmjdQ9Kb
bSJggXCxJbZHgaEWYpAh
=YT31
-----END PGP SIGNATURE-----

--=-SE5B9t6UrCoaxib/PXV3--


