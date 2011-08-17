From: Dave <dave@thekilempire.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Wed, 17 Aug 2011 10:55:09 -0400
Message-ID: <20110817145509.GA23804@hendrix.borisch.local>
References: <4E41A6A4.9070702@uvm.edu>
 <4E4BCF0C.7060109@uvm.edu>
 <4E4BD05B.9070501@cchtml.com>
 <4E4BD272.8000704@uvm.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Cc: Michael Cronenworth <mike@cchtml.com>, linux-btrfs@vger.kernel.org
To: Andrew Guertin <andrew.guertin@uvm.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4BD272.8000704@uvm.edu>
List-ID: <linux-btrfs.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2011 at 10:38:42AM -0400, Andrew Guertin wrote:
> Well I'd expect it to be somewhat uncommon, or it wouldn't survive 3
> kernel versions :) But at least 3 people have reported it, and for me at
> least it's reliably reproducible enough to bisect, so I'm quite certain
> there's something going on.

I've been simply living with this issue.  I can reproduce it by rsyncing ve=
ry
large files to a btrfs volume.  My entire desktop will freeze for up to thr=
ee
minutes and no amount of nice/ionice can temper this.

Once I've finished the rsync certain apps will periodically hang (Firefox in
particular).  This behavior goes away after a reboot.

I'm running kernel version 3.0.
--=20
-=3D[dave]=3D-

Entropy isn't what it used to be.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EAREIAAYFAk5L1k0ACgkQXM0u5ajNnCixlgD+L8HupWgNgh0GAD5rxFkmuKdS
vtupmuCdK/OwqiGgzkgA/181lobnqnJkHt5zVa5UasYgWsss1jeNAfKywqPVszuZ
=8C1a
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
