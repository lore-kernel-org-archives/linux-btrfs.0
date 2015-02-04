Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52828 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964903AbbBDVNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 16:13:18 -0500
Received: from [192.168.178.24] ([85.176.186.15]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0LhCDT-1Xp3hE2n4B-00oZXL for
 <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 22:13:15 +0100
Message-ID: <54D28B6A.8000200@gmx.de>
Date: Wed, 04 Feb 2015 22:13:14 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: INFO: trying to register non-static key with 3.18.5
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At a 32 bit Gentoo  Linux I get with 3.18.5 the following syslog message:

Feb  4 22:09:36 n22 kernel: INFO: trying to register non-static key.
Feb  4 22:09:36 n22 kernel: the code is fine but needs lockdep annotation.
Feb  4 22:09:36 n22 kernel: turning off the locking correctness validator.
Feb  4 22:09:36 n22 kernel: CPU: 0 PID: 2341 Comm: btrfs-cleaner Tainted: G     U         3.18.5 #1
Feb  4 22:09:36 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Feb  4 22:09:36 n22 kernel: 00000000 00000000 f04e5db0 c141af35 00000000 f04e5dbc c14188ae c1558ba4
Feb  4 22:09:36 n22 kernel: f04e5df8 c107ce56 00000000 00000000 f8438888 00000000 00000246 00000000
Feb  4 22:09:36 n22 kernel: f0e5c78c e1773150 00000000 e76c3a94 e76c3a94 00000246 00000000 f04e5e2c
Feb  4 22:09:36 n22 kernel: Call Trace:
Feb  4 22:09:36 n22 kernel: [<c141af35>] dump_stack+0x41/0x52
Feb  4 22:09:36 n22 kernel: [<c14188ae>] register_lock_class.part.22+0x32/0x36
Feb  4 22:09:36 n22 kernel: [<c107ce56>] __lock_acquire.isra.29+0x8e6/0x910
Feb  4 22:09:36 n22 kernel: [<f8438888>] ? btrfs_remove_chunk+0x2d8/0x810 [btrfs]
Feb  4 22:09:36 n22 kernel: [<c107d4b5>] lock_acquire+0x75/0xe0
Feb  4 22:09:36 n22 kernel: [<f83fad9d>] ? btrfs_delete_unused_bgs+0x22d/0x260 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f84388d6>] btrfs_remove_chunk+0x326/0x810 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f83fad9d>] ? btrfs_delete_unused_bgs+0x22d/0x260 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f8429f94>] ? free_extent_state.part.31+0x34/0x80 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f83fad9d>] btrfs_delete_unused_bgs+0x22d/0x260 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f8402952>] cleaner_kthread+0x132/0x180 [btrfs]
Feb  4 22:09:36 n22 kernel: [<f8402820>] ? btree_releasepage+0x40/0x40 [btrfs]
Feb  4 22:09:36 n22 kernel: [<c105b656>] kthread+0xa6/0xc0
Feb  4 22:09:36 n22 kernel: [<c1421a81>] ret_from_kernel_thread+0x21/0x30
Feb  4 22:09:36 n22 kernel: [<c105b5b0>] ? kthread_create_on_node+0x180/0x180

With the 3.17 series this was not observed AFAICT.

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

