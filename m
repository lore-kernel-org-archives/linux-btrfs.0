Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44638 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751335AbbARDO0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Jan 2015 22:14:26 -0500
Date: Sat, 17 Jan 2015 22:14:23 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: repeatable btrfs deadlock in unlink, kernel versions v3.15..v3.18.3
Message-ID: <20150118031423.GA12780@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Processes keep getting stuck in btrfs_evict_inode during unlink.

I've seen this dozens of times, usually when two subvols on a btrfs
filesystem are active at the same time (i.e. it never happens on
single-subvol filesystems).  It happens on kernel versions v3.15..v3.18.3.

This used to happen with SyS_renameat2 on the stack, but I haven't seen
a stack trace including that function since late November (v3.18-rc6).

	[<ffffffff81387dc0>] lock_extent_bits+0x1b0/0x200
	[<ffffffff81375e99>] btrfs_evict_inode+0x139/0x550
	[<ffffffff8120d708>] evict+0xb8/0x190
	[<ffffffff8120dec5>] iput+0x105/0x1a0
	[<ffffffff812001d9>] do_unlinkat+0x189/0x2d0
	[<ffffffff81202e26>] SyS_unlink+0x16/0x20
	[<ffffffff8185e96d>] system_call_fastpath+0x1a/0x1f
	[<ffffffffffffffff>] 0xffffffffffffffff

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlS7JQ8ACgkQgfmLGlazG5xKMQCgxLSeDLVg7RP+tDlHXsM1BMCW
qTIAoJqVOi5nx+VaC6XOlgWAD/84XhyJ
=kQ89
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
