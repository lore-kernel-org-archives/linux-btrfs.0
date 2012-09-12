Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:59209 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2ILVQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 17:16:26 -0400
Received: from natsu (unknown [IPv6:fd14:8086:1337:1:1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 7473420019
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 21:16:25 +0000 (UTC)
Date: Thu, 13 Sep 2012 03:16:23 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: <linux-btrfs@vger.kernel.org>
Subject: "Task blocked for more than 120 seconds" on file copy
Message-ID: <20120913031623.1e2d18f5@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SPGATQAFrbj=tU9LIQ2FUWm"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SPGATQAFrbj=tU9LIQ2FUWm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I was copying a 60 GB file onto btrfs, and at the same time tried to stop/r=
estart Squid,
which has its cache on the same partition. Squid locked up until the copyin=
g was finished.
This filesystem was resized by about +100% just before, if this could matte=
r.
The kernel is 3.6.0-rc5. From dmesg:

[27175.299657] INFO: task squid3:15475 blocked for more than 120 seconds.
[27175.299665] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[27175.299670] squid3          D ffff88041fc13dc0     0 15475      1 0x0000=
0004
[27175.299673]  ffff880189735b38 0000000000000082 ffff88029588c470 ffff8801=
89735fd8
[27175.299677]  ffff880189735fd8 ffff880189735fd8 ffff8803c6ef5b40 ffff8802=
9588c470
[27175.299679]  ffff880189735b48 ffff880407a07b00 ffff88037ca3b9e8 00000000=
00000000
[27175.299681] Call Trace:
[27175.299688]  [<ffffffff8166afc9>] schedule+0x29/0x70
[27175.299715]  [<ffffffffa00e875d>] wait_current_trans.isra.28+0x9d/0x100 =
[btrfs]
[27175.299718]  [<ffffffff810794b0>] ? finish_wait+0x80/0x80
[27175.299729]  [<ffffffffa00e9e48>] start_transaction+0x148/0x3d0 [btrfs]
[27175.299737]  [<ffffffffa00c3efa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[27175.299747]  [<ffffffffa00ea3a3>] btrfs_start_transaction+0x13/0x20 [btr=
fs]
[27175.299757]  [<ffffffffa00f6a97>] btrfs_create+0x47/0x210 [btrfs]
[27175.299760]  [<ffffffff812a9a5c>] ? security_inode_permission+0x1c/0x30
[27175.299763]  [<ffffffff8118683c>] ? __inode_permission+0x5c/0xd0
[27175.299765]  [<ffffffff811894f5>] vfs_create+0xb5/0x110
[27175.299767]  [<ffffffff8118a285>] do_last+0xd35/0xe30
[27175.299769]  [<ffffffff8116d7fb>] ? kmem_cache_alloc_trace+0x11b/0x120
[27175.299772]  [<ffffffff8118a433>] path_openat+0xb3/0x4b0
[27175.299774]  [<ffffffff81185353>] ? putname+0x33/0x50
[27175.299775]  [<ffffffff8118a9eb>] ? user_path_at_empty+0x6b/0xa0
[27175.299777]  [<ffffffff8166bd9e>] ? _raw_spin_lock+0xe/0x20
[27175.299779]  [<ffffffff8117f7d7>] ? inode_get_bytes+0x47/0x60
[27175.299781]  [<ffffffff8118aa81>] do_filp_open+0x41/0xa0
[27175.299783]  [<ffffffff81197306>] ? alloc_fd+0xc6/0x110
[27175.299786]  [<ffffffff81179e46>] do_sys_open+0xf6/0x1e0
[27175.299788]  [<ffffffff81179f51>] sys_open+0x21/0x30
[27175.299791]  [<ffffffff81673e6d>] system_call_fastpath+0x1a/0x1f
[27295.008758] INFO: task squid3:15475 blocked for more than 120 seconds.
[27295.008766] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[27295.008770] squid3          D ffff88041fc13dc0     0 15475      1 0x0000=
0004
[27295.008774]  ffff880189735b38 0000000000000082 ffff88029588c470 ffff8801=
89735fd8
[27295.008777]  ffff880189735fd8 ffff880189735fd8 ffff8803c6ef5b40 ffff8802=
9588c470
[27295.008779]  ffff880189735b48 ffff880407a07b00 ffff88037ca3b9e8 00000000=
00000000
[27295.008781] Call Trace:
[27295.008787]  [<ffffffff8166afc9>] schedule+0x29/0x70
[27295.008809]  [<ffffffffa00e875d>] wait_current_trans.isra.28+0x9d/0x100 =
[btrfs]
[27295.008813]  [<ffffffff810794b0>] ? finish_wait+0x80/0x80
[27295.008823]  [<ffffffffa00e9e48>] start_transaction+0x148/0x3d0 [btrfs]
[27295.008831]  [<ffffffffa00c3efa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[27295.008841]  [<ffffffffa00ea3a3>] btrfs_start_transaction+0x13/0x20 [btr=
fs]
[27295.008851]  [<ffffffffa00f6a97>] btrfs_create+0x47/0x210 [btrfs]
[27295.008853]  [<ffffffff812a9a5c>] ? security_inode_permission+0x1c/0x30
[27295.008856]  [<ffffffff8118683c>] ? __inode_permission+0x5c/0xd0
[27295.008858]  [<ffffffff811894f5>] vfs_create+0xb5/0x110
[27295.008860]  [<ffffffff8118a285>] do_last+0xd35/0xe30
[27295.008863]  [<ffffffff8116d7fb>] ? kmem_cache_alloc_trace+0x11b/0x120
[27295.008865]  [<ffffffff8118a433>] path_openat+0xb3/0x4b0
[27295.008867]  [<ffffffff81185353>] ? putname+0x33/0x50
[27295.008868]  [<ffffffff8118a9eb>] ? user_path_at_empty+0x6b/0xa0
[27295.008870]  [<ffffffff8166bd9e>] ? _raw_spin_lock+0xe/0x20
[27295.008872]  [<ffffffff8117f7d7>] ? inode_get_bytes+0x47/0x60
[27295.008874]  [<ffffffff8118aa81>] do_filp_open+0x41/0xa0
[27295.008876]  [<ffffffff81197306>] ? alloc_fd+0xc6/0x110
[27295.008878]  [<ffffffff81179e46>] do_sys_open+0xf6/0x1e0
[27295.008880]  [<ffffffff81179f51>] sys_open+0x21/0x30
[27295.008883]  [<ffffffff81673e6d>] system_call_fastpath+0x1a/0x1f

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/SPGATQAFrbj=tU9LIQ2FUWm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBQ+6cACgkQTLKSvz+PZwgCcwCgh4gsdzcJbqWUUV7B/SzERjRU
3dsAn2BBMo0Ozv+U7qPcZwCF5b6v088T
=1HvL
-----END PGP SIGNATURE-----

--Sig_/SPGATQAFrbj=tU9LIQ2FUWm--
