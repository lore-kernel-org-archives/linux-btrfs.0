Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39562 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbbL3QI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 11:08:58 -0500
Date: Wed, 30 Dec 2015 11:08:47 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix race between free space endio workers and
 space cache writeout
Message-ID: <20151230160847.nqfpu2bkwlt52eyb@ret.masoncoding.com>
References: <1451491324-23937-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1451491324-23937-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 30, 2015 at 04:02:04PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> While running a stress test I ran into the following trace/transaction
> abort:
> 
> [471626.672243] ------------[ cut here ]------------
> [471626.673322] WARNING: CPU: 9 PID: 19107 at fs/btrfs/extent-tree.c:3740 btrfs_write_dirty_block_groups+0x17c/0x214 [btrfs]()
> [471626.675492] BTRFS: Transaction aborted (error -2)
> [471626.676748] Modules linked in: btrfs dm_flakey dm_mod crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse parport_pc i2c_piix
> [471626.688802] CPU: 14 PID: 19107 Comm: fsstress Tainted: G        W       4.3.0-rc5-btrfs-next-17+ #1
> [471626.690148] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
> [471626.691901]  0000000000000000 ffff880016037cf0 ffffffff812566f4 ffff880016037d38
> [471626.695009]  ffff880016037d28 ffffffff8104d0a6 ffffffffa040c84e 00000000fffffffe
> [471626.697490]  ffff88011fe855f8 ffff88000c484cb0 ffff88000d195000 ffff880016037d90
> [471626.699201] Call Trace:
> [471626.699804]  [<ffffffff812566f4>] dump_stack+0x4e/0x79
> [471626.701049]  [<ffffffff8104d0a6>] warn_slowpath_common+0x9f/0xb8
> [471626.702542]  [<ffffffffa040c84e>] ? btrfs_write_dirty_block_groups+0x17c/0x214 [btrfs]
> [471626.704326]  [<ffffffff8104d107>] warn_slowpath_fmt+0x48/0x50
> [471626.705636]  [<ffffffffa0403717>] ? write_one_cache_group.isra.32+0x77/0x82 [btrfs]
> [471626.707048]  [<ffffffffa040c84e>] btrfs_write_dirty_block_groups+0x17c/0x214 [btrfs]
> [471626.708616]  [<ffffffffa048a50a>] commit_cowonly_roots+0x1d7/0x25a [btrfs]
> [471626.709950]  [<ffffffffa041e34a>] btrfs_commit_transaction+0x4c4/0x991 [btrfs]
> [471626.711286]  [<ffffffff81081c61>] ? signal_pending_state+0x31/0x31
> [471626.712611]  [<ffffffffa03f6df4>] btrfs_sync_fs+0x145/0x1ad [btrfs]
> [471626.715610]  [<ffffffff811962a2>] ? SyS_tee+0x226/0x226
> [471626.716718]  [<ffffffff811962c2>] sync_fs_one_sb+0x20/0x22
> [471626.717672]  [<ffffffff8116fc01>] iterate_supers+0x75/0xc2
> [471626.718800]  [<ffffffff8119669a>] sys_sync+0x52/0x80
> [471626.719990]  [<ffffffff8147cd97>] entry_SYSCALL_64_fastpath+0x12/0x6f
> [471626.721835] ---[ end trace baf57f43d76693f4 ]---
> [471626.722954] BTRFS: error (device sdc) in btrfs_write_dirty_block_groups:3740: errno=-2 No such entry
> 
> This is a very rare situation and it happened due to a race between a free
> space endio worker and writing the space caches for dirty block groups at
> a transaction's commit critical section. The steps leading to this are:
> 

Ugh, thanks Filipe.  I'll get this one into integration after I get back
from vacation (I'm out next week).

-chris
