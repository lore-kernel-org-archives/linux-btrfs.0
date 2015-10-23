Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36159 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751212AbbJWW0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 18:26:18 -0400
Date: Fri, 23 Oct 2015 18:26:16 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Possible FIEMAP deadlock?
Message-ID: <20151023222616.GG4400@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hTiIB9CRvBOLTyqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This looks like a deadlock in FIEMAP:

	# cat /proc/version
	Linux version 4.1.8-zb64+ (root@buildhost) (gcc version 4.9.2 (Debian 4.9.2-10) ) #1 SMP PREEMPT Tue Sep 22 00:54:04 EDT 2015

	# cat /proc/6943/stack
	[<ffffffff8142b93d>] lock_extent_bits+0x1ad/0x200
	[<ffffffff81431e04>] extent_fiemap+0x1a4/0x580
	[<ffffffff8140f695>] btrfs_fiemap+0x45/0x50
	[<ffffffff81277367>] do_vfs_ioctl+0x157/0x560
	[<ffffffff812777f1>] SyS_ioctl+0x81/0xa0
	[<ffffffff81b037b2>] system_call_fastpath+0x16/0x7a
	[<ffffffffffffffff>] 0xffffffffffffffff

	# cat /proc/8914/stack
	[<ffffffff8142b93d>] lock_extent_bits+0x1ad/0x200
	[<ffffffff81431e04>] extent_fiemap+0x1a4/0x580
	[<ffffffff8140f695>] btrfs_fiemap+0x45/0x50
	[<ffffffff81277367>] do_vfs_ioctl+0x157/0x560
	[<ffffffff812777f1>] SyS_ioctl+0x81/0xa0
	[<ffffffff81b037b2>] system_call_fastpath+0x16/0x7a
	[<ffffffffffffffff>] 0xffffffffffffffff

	# ls -l /proc/6943/fd /proc/8914/fd
	/proc/6943/fd:
	total 0
	lrwx------ 1 root root 64 Oct 23 03:58 0 -> /dev/pts/47
	lrwx------ 1 root root 64 Oct 23 03:58 1 -> /dev/pts/47
	lrwx------ 1 root root 64 Oct 23 03:57 2 -> /dev/pts/47
	lr-x------ 1 root root 64 Oct 23 03:58 3 -> /dedup-arena/current
	lr-x------ 1 root root 64 Oct 23 03:58 4 -> /dedup-arena/current
	lr-x------ 1 root root 64 Oct 23 03:58 5 -> /dedup-arena/current/home/builder/workdir/android/nex1/LINUX/android/out/target/product/mxp1010_qsb/symbols/system/lib/libwebcore.so
	lrwx------ 1 root root 64 Oct 23 03:58 6 -> /dedup-arena/current/home/builder/backup/home/builder/workdir/android/nex1/LINUX/android/out/target/product/mxp1010_qsb/symbols/system/lib/libwebcore.so

	/proc/8914/fd:
	total 0
	lrwx------ 1 root root 64 Oct 23 03:58 0 -> /dev/pts/52
	lrwx------ 1 root root 64 Oct 23 03:58 1 -> /dev/pts/52
	lrwx------ 1 root root 64 Oct 23 03:57 2 -> /dev/pts/52
	lr-x------ 1 root root 64 Oct 23 03:58 3 -> /dedup-arena/snapshots/2015-08-31-00-19-42
	lr-x------ 1 root root 64 Oct 23 03:58 4 -> /dedup-arena/snapshots/2015-08-31-00-19-42
	lr-x------ 1 root root 64 Oct 23 03:58 5 -> /dedup-arena/snapshots/2015-08-31-00-19-42/home/builder/workdir/android/nex1/LINUX/android/out/target/product/mxp1010_qsb/symbols/system/lib/libwebcore.so
	lrwx------ 1 root root 64 Oct 23 03:58 6 -> /dedup-arena/current/home/builder/workdir/android/nex1/LINUX/android/out/target/product/mxp1010_qsb/symbols/system/lib/libwebcore.so

Note that "snapshots/2015-08-31-00-19-42" is a snapshot of the "current"
subvol, and these particular files most likely share extents within the
"current" subvol due to dedup (I can't compare their FIEMAPs so I don't
know for sure ;).

I am able to get a FIEMAP from /proc/8914/fd/5, but when I try to FIEMAP
the other two files my FIEMAP process gets stuck in lock_extent_bits.

	# ls -liL /proc/6943/fd /proc/8914/fd
	/proc/6943/fd/:
	total 528088
	       50 crw--w---- 1 root tty    136, 47 Oct 18 20:13 0
	       50 crw--w---- 1 root tty    136, 47 Oct 18 20:13 1
	       50 crw--w---- 1 root tty    136, 47 Oct 18 20:13 2
	102531369 drwx------ 1 root root       126 Oct  8 21:37 3
	102531369 drwx------ 1 root root       126 Oct  8 21:37 4
	 25449434 -rw-r--r-- 1 root root 270378576 Aug 28  2009 5
	104189066 -rw-r--r-- 1 root root 270378576 Aug 28  2009 6

	/proc/8914/fd/:
	total 528088
	      55 crw--w---- 1 root tty    136, 52 Oct 18 23:06 0
	      55 crw--w---- 1 root tty    136, 52 Oct 18 23:06 1
	      55 crw--w---- 1 root tty    136, 52 Oct 18 23:06 2
	     256 drwxr-xr-x 1 root root       534 Aug 31 00:19 3
	     256 drwxr-xr-x 1 root root       534 Aug 31 00:19 4
	25449434 -rw-r--r-- 1 root root 270378576 Aug 28  2009 5
	25449434 -rw-r--r-- 1 root root 270378576 Aug 28  2009 6


--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYqtAgACgkQgfmLGlazG5xqrACg3nXCMLOOE2ZrctRDBbyXU8Ll
lJoAn26QF6HjWl6whAtJv80p/XHo8sDQ
=d85M
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
