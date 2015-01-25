Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36687 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752701AbbAYQuw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 11:50:52 -0500
Date: Sun, 25 Jan 2015 11:50:36 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: spuious I/O errors from btrfs...at the caching layer?
Message-ID: <20150125165035.GA15935@hungrycats.org>
References: <20150124180601.GA15018@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <20150124180601.GA15018@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 24, 2015 at 01:06:01PM -0500, Zygo Blaxell wrote:
> I am seeing a lot of spurious I/O errors that look like they come from
> the cache-facing side of btrfs.  While running a heavy load with some
> extent-sharing (e.g. building 20 Linux kernels at once from source trees
> copied with 'cp -a --reflink=always'), some files will return spurious
> EIO on read.  It happens often enough to prevent a Linux kernel build
> about 1/3 of the time.
[...]
> Observed from 3.17..3.18.3.  All filesystems affected use skinny-metadata.
> No filesystems that are not using skinny-metadata seem to have this
> problem.

I ran a test overnight using 3.18.3 on a freshly formatted filesystem with
no skinny-metadata.

The test consisted of creating reflink copies of a Linux kernel source
tree and running kernel builds in each copy simultaneously, like this:

	# assume you have a ready-to-build kernel tree in 'linux'
	for x in $(seq 1 5); do
		cp -a --reflink linux linux-$x
	done

	# build all the kernels at once
	for x in $(seq 1 5); do
		(cd linux-$x && make -j10 2>&1 | tee make.log) &
	done

	wait
	# then tail all the make.logs and see how many failed due to
	# I/O errors

Spurious I/O errors occured with as few as two concurrent kernel builds.

The test machine has 16GB of RAM and the filesystem is also 16GB,
RAID1 on two spinning disks.


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTFHtsACgkQgfmLGlazG5xIcACg0MKIKh4bIn/zgdVLamtqdbhr
Sw8AnRixSHSCFaiFeIKVSh8T5IUl+8af
=H6Iu
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
