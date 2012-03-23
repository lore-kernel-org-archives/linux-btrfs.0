From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 16:44:35 +0600
Message-ID: <20120323164435.4c21f92e@natsu>
References: <20120323061159.GA11099@mcelrath.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PhvYwxnjRTbooYdXjw1mA4q"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Bob McElrath <bob@mcelrath.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323061159.GA11099@mcelrath.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/PhvYwxnjRTbooYdXjw1mA4q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Mar 2012 06:11:59 +0000
Bob McElrath <bob@mcelrath.org> wrote:

> http://superuser.com/questions/387851/a-zfs-or-lvm-or-md-redundant-hetero=
geneous-storage-proposal/388536
>=20
> In a nutshell: organize your heterogenous disks into two "halves", the su=
m of
> which are of roughly equal size, and create a raid1 array across those two
> halves.

This seems to be an extremely simplistic concept and also a very inefficient
use of storage space, while not even providing enough redundancy (can't
reliably tolerate an any-two-disks failure even).

I suggest that you go with http://linuxconfig.org/prouhd-raid-for-the-end-u=
ser
instead. Depending on how many drives you have, the widest portion can be r=
aid
6, then decreasing to RAID5 for the second stage, then finally to RAID1 for
the tail.

Also remember that with MD you can also create arrays from arrays. So e.g. a
RAID0 of two 500GB members can join a RAID6 of 1TB members. More on this id=
ea:
http://louwrentius.com/blog/2008/08/building-a-raid-6-array-of-mixed-drives/

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/PhvYwxnjRTbooYdXjw1mA4q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9sVBMACgkQTLKSvz+PZwgQOQCglA1QcUgxpzxBHXSF1XGK8GUA
uJUAn0w2bgA8OFijGeE8sptaHhMXtZMQ
=iHxU
-----END PGP SIGNATURE-----

--Sig_/PhvYwxnjRTbooYdXjw1mA4q--
