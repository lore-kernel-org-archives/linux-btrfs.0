Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:36216 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab2LLWKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 17:10:32 -0500
Date: Wed, 12 Dec 2012 17:10:28 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] btrfs-next issues detected with xfstest, part #2
Message-ID: <20121212221028.GD3152@localhost.localdomain>
References: <50C89FE6.4020307@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50C89FE6.4020307@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 08:16:54AM -0700, Stefan Behrens wrote:
> This is the last part.
> 
> ./check 078-299
> 
> [112]
> Dec 12 12:51:05 qvarne root: run xfstest 112
> device fsid 55bc7fff-2ed3-48c4-94d8-e4ec5157ae21 devid 1 transid 35 /dev/sdg
> btrfs: enabling check integrity
> btrfs: use lzo compression
> btrfs: enabling auto defrag
> btrfs: disk space caching is enabled
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/locking.c:265!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class
> CPU 2
> Pid: 31783, comm: fsx Tainted: G        W    3.7.0+ #106 Supermicro X8SIL/X8SIL
> RIP: 0010:[<ffffffffa0112d90>]  [<ffffffffa0112d90>] btrfs_assert_tree_locked+0x10/0x20 [btrfs]
> RSP: 0018:ffff88022ef899c8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8801e35aea20 RCX: 0000000000000001
> RDX: 00000001dd212000 RSI: ffff880000000000 RDI: ffff880225977700
> RBP: ffff88022ef899c8 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000006 R11: 0000000000000001 R12: 0000000000000001
> R13: 0000000000000001 R14: ffff88022b551000 R15: ffff880230aaebe0
> FS:  00007f46ad977700(0000) GS:ffff880236a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f46ad8e9000 CR3: 0000000231cec000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process fsx (pid: 31783, threadinfo ffff88022ef88000, task ffff88022e1b2270)
> Stack:
>  ffff88022ef89a68 ffffffffa00bbf1b 0000000000000006 0000000000000006
>  0000000000000035 0000000000000005 ffff88022ef89a68 ffffffff00000001
>  ffff880200000001 00000f6600000006 ffff880100000001 ffff880225975e40
> Call Trace:
>  [<ffffffffa00bbf1b>] push_leaf_left+0xab/0x1a0 [btrfs]
>  [<ffffffffa00bf75d>] btrfs_del_items+0x37d/0x4f0 [btrfs]
>  [<ffffffffa00ff3c4>] ? read_extent_buffer+0xb4/0x110 [btrfs]
>  [<ffffffffa0116325>] drop_adjacent_extents.isra.24+0x465/0x480 [btrfs]
>  [<ffffffffa0116628>] log_one_extent.isra.25+0x2e8/0x710 [btrfs]
>  [<ffffffffa0118cdc>] ? btrfs_log_inode+0x7fc/0x8e0 [btrfs]
>  [<ffffffffa0118cce>] btrfs_log_inode+0x7ee/0x8e0 [btrfs]
>  [<ffffffffa011a9ca>] btrfs_log_inode_parent+0x18a/0x450 [btrfs]
>  [<ffffffffa011accf>] btrfs_log_dentry_safe+0x3f/0x60 [btrfs]
>  [<ffffffffa00efa57>] btrfs_sync_file+0x147/0x2c0 [btrfs]
>  [<ffffffff811c7526>] vfs_fsync+0x26/0x30
>  [<ffffffff81178f9c>] sys_msync+0x13c/0x1c0
>  [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
> Code: 5d 41 5e 41 5f 5d c3 be e8 00 00 00 48 c7 c7 06 27 15 a0 e8 33 38 f7 e0 eb bb 90 8b 87 cc 00 00 00 55 48 89 e5 85 c0 74 02 5d c3 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
>  00 55 48 89 e5 48
> RIP  [<ffffffffa0112d90>] btrfs_assert_tree_locked+0x10/0x20 [btrfs]
>  RSP <ffff88022ef899c8>
> ---[ end trace 2f6666e1b1941b46 ]---
> 
> A sysrq-b was required to reboot the box.
> 

Well I fixed this one ;).  Thanks,

Josef
