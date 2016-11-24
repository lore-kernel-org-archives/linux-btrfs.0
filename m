Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46144 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbcKXDiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 22:38:12 -0500
Date: Wed, 23 Nov 2016 22:38:06 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: bees v0.1 - Best-Effort Extent-Same, a btrfs deduplication daemon
Message-ID: <20161124033806.GX21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cycRQitB/3DOnQyb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cycRQitB/3DOnQyb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I made a thing!

Bees ("Best-Effort Extent-Same") is a dedup daemon for btrfs.

Bees is a block-oriented userspace dedup designed to avoid scalability
problems on large filesystems.

Bees is designed to degrade gracefully when underprovisioned with RAM.
Bees does not use more RAM or storage as filesystem data size increases.
The dedup hash table size is fixed at creation time and does not change.
The effective dedup block size is dynamic and adjusts automatically to
fit the hash table into the configured RAM limit.  Hash table overflow
is not implemented to eliminate the IO overhead of hash table overflow.
Hash table entries are only 16 bytes per dedup block to keep the average
dedup block size small.

Bees does not require alignment between dedup blocks or extent boundaries
(i.e. it can handle any multiple-of-4K offset between dup block pairs).
Bees rearranges blocks into shared and unique extents if required to
work within current btrfs kernel dedup limitations.

Bees can dedup any combination of compressed and uncompressed extents.

Bees operates in a single pass which removes duplicate extents immediately
during scan.  There are no separate scanning and dedup phases.

Bees uses only data-safe btrfs kernel operations, so it can dedup live
data (e.g. build servers, sqlite databases, VM disk images).  It does
not modify file attributes or timestamps.

Bees does not store any information about filesystem structure, so it is
not affected by the number or size of files (except to the extent that
these cause performance problems for btrfs in general).  It retrieves such
information on demand through btrfs SEARCH_V2 and LOGICAL_INO ioctls.
This eliminates the storage required to maintain the equivalents of
these functions in userspace.  It's also why bees has no XFS support.

Bees is a daemon designed to run continuously and maintain its state
across crahes and reboots.  Bees uses checkpoints for persistence to
eliminate the IO overhead of a transactional data store.  On restart,
bees will dedup any data that was added to the filesystem since the
last checkpoint.

I use bees to dedup filesystems ranging in size from 16GB to 35TB, with
hash tables ranging in size from 128MB to 11GB.  It's well past time
for a v0.1 release, so here it is!

Bees is available on Github:

	https://github.com/Zygo/bees

Please enjoy this code.

--cycRQitB/3DOnQyb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg2YJ0ACgkQgfmLGlazG5x7JACgyjFkIFcqvkmxRno2mGq3Hk6A
ccwAn3DJiCPKqh+O43xxeMFxS/3rRisY
=dCW8
-----END PGP SIGNATURE-----

--cycRQitB/3DOnQyb--
