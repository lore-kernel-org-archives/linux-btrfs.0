From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 15:31:48 -0600
Message-ID: <1224711108.7399.12.camel@telesto>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com>
	 <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com>
	 <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com>
	 <48FF276B.6090602@kernel.org> <48FF296F.9060009@redhat.com>
	 <48FF515B.2030209@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d2VxP9X+SdZ+uQHesLUj"
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF515B.2030209@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-d2VxP9X+SdZ+uQHesLUj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 01:14 +0900, Tejun Heo wrote:
> Ric Wheeler wrote:
> > Waiting for the target to ack an IO is not sufficient, since the target
> > ack does not (with write cache enabled) mean that it is on persistent
> > storage.
>=20
> FS waiting for completion of all the dependent writes isn't too good
> latency and throughput-wise tho.  It would be best if FS can indicate
> dependencies between write commands and barrier so that barrier
> doesn't have to empty the whole queue.  Hmm... Can someone tell me how
> much such scheme would help?

The extent of my coding for ZFS on FUSE was in this area. Solaris has a
generic ioctl to flush the write cache on a block device but Linux does
not. I wrote a few routines to detect the type of block device and flush
the cache by talking to the hardware via an ioctl.

Tests with bonnie++ on my laptop showed that throughput and metadata
operations per second were not noticeably affected by completely
flushing the write cache when necessary versus never flushing the write
cache or using any kind of IO barrier.

Caveats:
*Not every HDD is a laptop HDD.
*ZFS on FUSE got average to poor results for metadata operations per
second since it hadn't been optimized for that yet.

Maybe fancier schemes aren't necessary?

Cheers,
Eric


--=-d2VxP9X+SdZ+uQHesLUj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASP+bxAanbLzqVaVfAQKNeAf/VPzWDSQfS9SSVBafuG/b8jV8qByD0xob
uOz7+QMoCC8H8+bPagumgz2L8UifzZabBQVuy5xVbc/eMNvFHAarndDIY/XY69cE
1JBO43BhOlx9VuxhYOznF/DXrfzzUK+0GOYJHfKbPXLRC5x4+g55R3DI84287uCO
JclZ1sDCyFhjOIQUc6mse/Un5RgyprAJkTbUL297YfBRNlF8avWhw2n73CiUJAPX
tQNRDB+I1PoLIPN1X2trjCMw/7M3cIdAlxJ+coWkE9tRl9HpMF05433lKJlwaOXN
g6ZP3nMDy/ZkdLa6mnThEQDp5eitzcVwWsMkhawOzoRok6rFhHlKOw==
=TW3R
-----END PGP SIGNATURE-----

--=-d2VxP9X+SdZ+uQHesLUj--

