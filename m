Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36632 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753261AbbAXSGE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 13:06:04 -0500
Date: Sat, 24 Jan 2015 13:06:01 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: spuious I/O errors from btrfs...at the caching layer?
Message-ID: <20150124180601.GA15018@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I am seeing a lot of spurious I/O errors that look like they come from
the cache-facing side of btrfs.  While running a heavy load with some
extent-sharing (e.g. building 20 Linux kernels at once from source trees
copied with 'cp -a --reflink=always'), some files will return spurious
EIO on read.  It happens often enough to prevent a Linux kernel build
about 1/3 of the time.

I believe the I/O errors to be spurious because:

	- there is no kernel message of any kind during the event

	- scrub detects 0 errors

	- device stats report 0 errors

	- the drive firmware reports nothing wrong through SMART

	- there seems to be no attempt to read the disk when the error
	is reported

	- "sysctl vm.drop_caches={1,2}" makes the I/O error go away.

Files become unreadable at random, and stay unreadable indefinitely;
however, any time I discover a file that gives EIO on read, I can
poke vm.drop_caches and make the EIO go away.  The file can then be
read normally and has correct contents.  The disk does not seem to be
involved in the I/O error return.

This seems to happen more often when snapshots are being deleted;
however, it occurs on systems with no snapshots as well (though
in these cases the system had snapshots in the past).

When a file returns EIO on read, other snapshots of the same file also
return EIO on read.  I have not been able to test whether this affects
reflink copies (clones) as well.

Observed from 3.17..3.18.3.  All filesystems affected use skinny-metadata.
No filesystems that are not using skinny-metadata seem to have this
problem.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTD3wkACgkQgfmLGlazG5wx0ACffEO9Hjy9niiBZfoEGBdB6u55
X9IAn3qMRUeKd8NquGdIPFzogSX8sO24
=Bev4
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
