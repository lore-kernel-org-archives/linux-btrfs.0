Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:44937 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaCBJNR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 04:13:17 -0500
Received: by mail-la0-f52.google.com with SMTP id ec20so3094045lab.11
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Mar 2014 01:13:16 -0800 (PST)
Received: from vuvuzela.stingr.net ([2001:b08:e:1:6ab5:99ff:fe4f:770a])
        by mx.google.com with ESMTPSA id th3sm11431969lbb.11.2014.03.02.01.13.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Mar 2014 01:13:15 -0800 (PST)
Date: Sun, 2 Mar 2014 13:13:01 +0400
From: Paul Komkoff <i@stingr.net>
To: linux-btrfs@vger.kernel.org
Subject: Beyond-repair corruption, btrfs on ssd
Message-ID: <20140302091301.GA14259@vuvuzela.stingr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings.

Suddenly, a filesystem on SSD became corrupted. None of the usual repair mechanisms work.
check_tree_block complains (have=0) for blocks in root (?), I have modified it to print
buf->data and for affected blocks the entire header is filled with zeros.

I have a full image if anyone wants to take a look. It's rather large but btrfs-image
is useless as well.

At this moment I suspect that nothing can be done already, but I'm guessing it would be
nice to figure out what went wrong.

I suspect it started here:
Mar 02 00:58:22 host kernel: BTRFS info (device sdc): forced readonly
Mar 02 00:58:22 host kernel: BTRFS error (device sdc) in __btrfs_free_extent:5729: errno=-28 No space left
Mar 02 00:58:22 host kernel: ---[ end trace ec264dde20b326e3 ]---
Mar 02 00:58:22 host kernel:  [<ffffffff81676aa9>] system_call_fastpath+0x16/0x1b
Mar 02 00:58:22 host kernel:  [<ffffffff810f13b6>] ? __audit_syscall_exit+0x1f6/0x2a0
Mar 02 00:58:22 host kernel:  [<ffffffff811af479>] SyS_write+0x49/0xa0
Mar 02 00:58:22 host kernel:  [<ffffffff811aea3d>] vfs_write+0xbd/0x1e0
Mar 02 00:58:22 host kernel:  [<ffffffff811ae34a>] do_sync_write+0x5a/0x90
Mar 02 00:58:22 host kernel:  [<ffffffff81551f7e>] ? sock_aio_write+0xfe/0x130
Mar 02 00:58:22 host kernel:  [<ffffffffa0249f85>] btrfs_file_aio_write+0x215/0x520 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa0249b37>] __btrfs_buffered_write+0x257/0x490 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa0221f03>] btrfs_delalloc_reserve_metadata+0x153/0x4a0 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffff8108be40>] ? wake_up_atomic_t+0x30/0x30
Mar 02 00:58:22 host kernel:  [<ffffffffa0220c8b>] reserve_metadata_bytes+0x29b/0x8e0 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa0220510>] ? btrfs_get_alloc_profile+0x30/0x40 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa02378ee>] btrfs_commit_transaction+0x4e/0x970 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa02277a0>] btrfs_run_delayed_refs+0xe0/0x540 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa02229cf>] ? run_clustered_refs+0x51f/0xeb0 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa0222885>] run_clustered_refs+0x3d5/0xeb0 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa027be14>] ? btrfs_merge_delayed_refs+0x1f4/0x3d0 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa021e890>] __btrfs_free_extent+0x520/0xa60 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffffa020dbbd>] __btrfs_abort_transaction+0x11d/0x130 [btrfs]
Mar 02 00:58:22 host kernel:  [<ffffffff810691fc>] warn_slowpath_fmt+0x4c/0x50
Mar 02 00:58:22 host kernel:  [<ffffffff8106918d>] warn_slowpath_common+0x7d/0xa0
Mar 02 00:58:22 host kernel:  [<ffffffff81667af7>] dump_stack+0x45/0x56
Mar 02 00:58:22 host kernel: Call Trace:
Mar 02 00:58:22 host kernel:  ffff8806104613c0 ffffffffa02a8b80 0000000000001661 ffff8800250258b8
Mar 02 00:58:22 host kernel:  ffff880025025858 ffffffff8106918d 00000000ffffffe4 ffff880613460800
Mar 02 00:58:22 host kernel:  0000000000000009 ffff880025025820 ffffffff81667af7 ffff880025025868
Mar 02 00:58:22 host kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X58 Extreme3, BIOS P2.80 10/31/2011
Mar 02 00:58:22 host kernel: CPU: 1 PID: 9925 Comm: mysqld Not tainted 3.12.9-301.fc20.x86_64 #1
Mar 02 00:58:22 host kernel: Modules linked in: ip_set_hash_ip ip_set nfnetlink cfg80211 rfkill ip6table_nat nf_nat_ipv6 xt_REDIRECT iptable_nat
Mar 02 00:58:22 host kernel: btrfs: Transaction aborted (error -28)
Mar 02 00:58:22 host kernel: WARNING: CPU: 1 PID: 9925 at fs/btrfs/super.c:255 __btrfs_abort_transaction+0x11d/0x130 [btrfs]()
Mar 02 00:58:22 host kernel: ------------[ cut here ]------------

Thanks.
