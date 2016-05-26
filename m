Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48111 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbcEZQTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 12:19:53 -0400
Date: Thu, 26 May 2016 12:19:52 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@gmail.com>
Subject: mixed inline, non-inline extents leading to EIO when reading small
 files
Message-ID: <20160526161952.GH15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kR3zbvD4cgoYnS/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I frequently see these in /etc/lvm/backup/*.  Something that LVM does
when it writes these files triggers the problem.  This problem occurs
in kernels 3.18..4.4.11 (i.e. all the kernels I've tested).

btrfs-debug-tree finds this:

        item 26 key (2702988 INODE_ITEM 0) itemoff 12632 itemsize 160
                inode generation 49642 transid 49799 size 7856 nbytes 8192
                block group 0 mode 100644 links 1 uid 0 gid 0
                rdev 0 flags 0x0
        item 27 key (2702988 INODE_REF 2799) itemoff 12617 itemsize 15
                inode ref index 4 namelen 5 name: volgr
        item 28 key (2702988 EXTENT_DATA 0) itemoff 11247 itemsize 1370
                inline extent data size 1349 ram 4096 compress(zlib)
        item 29 key (2702988 EXTENT_DATA 4096) itemoff 11194 itemsize 53
                extent data disk byte 1161560064 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression(none)

When the problem occurs it usually affects all files in /etc/lvm/backup.
I have seen it randomly in other parts of the filesystem but it's much
rarer elsewhere.

Attempts to read this file return EIO.  There are no errors reported in
scrub or kmesg.

Filesystem is mounted with options:

	noatime,compress-force=zlib,flushoncommit,space_cache,skip_balance,commit=300

Am I missing anything?

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldHIigACgkQgfmLGlazG5zm/wCbBJKHM5VKms1bEl9jctgmz0B8
Hk8AniF67LBNXOz5MLRSQV59gBhRMri3
=LJdO
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
