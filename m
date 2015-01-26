Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38540 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751322AbbAZEWg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 23:22:36 -0500
Date: Sun, 25 Jan 2015 23:22:33 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Resolved...ish.  was: Re: spurious I/O errors from btrfs...at the
 caching layer?
Message-ID: <20150126042233.GC15935@hungrycats.org>
References: <20150124180601.GA15018@hungrycats.org>
 <20150125165035.GA15935@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
In-Reply-To: <20150125165035.GA15935@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

It seems that the rate of spurious I/O errors varies most according to
the vm.vfs_cache_pressure sysctl.  At '10' the I/O errors occur so often
that building a kernel is impossible.  At '100' I can't reproduce even
a single I/O error.

I guess this is own my fault for using non-default sysctl parameters,
although I wouldn't expect any value of this sysctl to cause these
symptoms... :-P


On Sun, Jan 25, 2015 at 11:50:36AM -0500, Zygo Blaxell wrote:
> On Sat, Jan 24, 2015 at 01:06:01PM -0500, Zygo Blaxell wrote:
> > I am seeing a lot of spurious I/O errors that look like they come from
> > the cache-facing side of btrfs.  While running a heavy load with some
> > extent-sharing (e.g. building 20 Linux kernels at once from source trees
> > copied with 'cp -a --reflink=3Dalways'), some files will return spurious
> > EIO on read.  It happens often enough to prevent a Linux kernel build
> > about 1/3 of the time.
> [...]
> > Observed from 3.17..3.18.3.  All filesystems affected use skinny-metada=
ta.
> > No filesystems that are not using skinny-metadata seem to have this
> > problem.
>=20
> I ran a test overnight using 3.18.3 on a freshly formatted filesystem with
> no skinny-metadata.
>=20
> The test consisted of creating reflink copies of a Linux kernel source
> tree and running kernel builds in each copy simultaneously, like this:
>=20
> 	# assume you have a ready-to-build kernel tree in 'linux'
> 	for x in $(seq 1 5); do
> 		cp -a --reflink linux linux-$x
> 	done
>=20
> 	# build all the kernels at once
> 	for x in $(seq 1 5); do
> 		(cd linux-$x && make -j10 2>&1 | tee make.log) &
> 	done
>=20
> 	wait
> 	# then tail all the make.logs and see how many failed due to
> 	# I/O errors
>=20
> Spurious I/O errors occured with as few as two concurrent kernel builds.
>=20
> The test machine has 16GB of RAM and the filesystem is also 16GB,
> RAID1 on two spinning disks.
>=20



--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTFwQkACgkQgfmLGlazG5zSTQCg19l7GPFUQBNBiTzyO+7eLQ0Q
u1gAnRUAWusP8QP1YQQEuxsFw2Oe9xSS
=pmiY
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
