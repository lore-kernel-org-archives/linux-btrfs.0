Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752384AbeC3X7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 19:59:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 52665AE83
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 23:59:38 +0000 (UTC)
Date: Sat, 31 Mar 2018 01:57:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: delayed-inode: Don't double reserve qgroup
 metadata for btrfs_delayed_item_reserve_metadata()
Message-ID: <20180330235711.GZ30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180329004922.9149-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180329004922.9149-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 08:49:22AM +0800, Qu Wenruo wrote:
> [BUG]
> With latest qgroup metadata reservation patch applied, it's possible to
> hit BUG_ON() when running btrfs/042:
> ------
>  run fstests btrfs/042 at 2018-03-28 12:14:26
>  BTRFS: device fsid cc876c27-bf31-44d6-bd6a-2c19b8c8e1b8 devid 1 transid 5 /dev/sdc1
>  BTRFS info (device sdc1): disk space caching is enabled
>  BTRFS info (device sdc1): has skinny extents
>  BTRFS info (device sdc1): flagging fs with big metadata feature
>  BTRFS info (device sdc1): creating UUID tree
>  BTRFS info (device sdc1): qgroup scan completed (inconsistency flag cleared)
>  ------------[ cut here ]------------
>  kernel BUG at fs/btrfs/delayed-inode.c:1467!
>  invalid opcode: 0000 [#1] PREEMPT SMP PTI
>  CPU: 12 PID: 28830 Comm: xfs_io Tainted: G          I      4.16.0-rc7-1.gab9e909-default+ #92
>  Hardware name: HP ProLiant DL380 G6, BIOS P62 10/01/2009
>  RIP: 0010:btrfs_insert_delayed_dir_index+0x230/0x240 [btrfs]
>  RSP: 0018:ffff9b4488777a30 EFLAGS: 00010282
>  RAX: 00000000ffffff86 RBX: ffff8f1bd86ee600 RCX: 0000000000000020
>  RDX: 000000000000000c RSI: 0000000000000004 RDI: ffff8f1bd3a830a8
>  RBP: ffff8f1bd86ee618 R08: 0000000000000000 R09: 0000000000000001
>  R10: 0000000000000000 R11: 0000000000000001 R12: ffff8f1bd5cdf908
>  R13: 0000000000000004 R14: ffff8f1bc38f5680 R15: ffff8f1bc6364820
>  FS:  00007ffae04eb700(0000) GS:ffff8f1bdaa00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000626880 CR3: 00000001155b6000 CR4: 00000000000006e0
>  Call Trace:
>   ? _raw_spin_unlock+0x24/0x40
>   btrfs_insert_dir_item+0x1a9/0x210 [btrfs]
>   btrfs_add_link+0xec/0x3d0 [btrfs]
>   btrfs_create+0x19c/0x1e0 [btrfs]
>   lookup_open+0x64c/0x720
>   ? __wake_up_common_lock+0x51/0x90
>   ? find_held_lock+0x3c/0xa0
>   path_openat+0x5ff/0xcf0
>   ? sched_clock+0x5/0x10
>   ? sched_clock_cpu+0xc/0xb0
>   do_filp_open+0x7e/0xd0
>   ? _raw_spin_unlock+0x24/0x40
>   do_sys_open+0x116/0x1e0
>   do_syscall_64+0x6e/0x110
>   entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>  RIP: 0033:0x7ffae00d3520
>  RSP: 002b:00007ffc0554bf48 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
>  RAX: ffffffffffffffda RBX: 0000000000004042 RCX: 00007ffae00d3520
>  RDX: 0000000000000180 RSI: 0000000000004042 RDI: 00007ffc0554d537
>  RBP: 0000000000000022 R08: 00007ffc0554c110 R09: 0000000000000001
>  R10: 0000000012ef9861 R11: 0000000000000246 R12: 00007ffadfe7220c
>  R13: 00007ffc0554c110 R14: 00007ffc0554d537 R15: 00007ffc0554c260
>  RIP: btrfs_insert_delayed_dir_index+0x230/0x240 [btrfs] RSP: ffff9b4488777a30
>  ---[ end trace 88182a219a9080f6 ]---
> ------
> Where the BUG_ON() is triggered by -EDQUOT.
> 
> [CAUSE]
> btrfs_qgroup_reserve_meta_prealloc() is called in
> btrfs_delayed_item_reserve_metadata(), however
> btrfs_delayed_item_reserve_metadata() is just migrating reserved space
> from current transaction to delayed_block_rsv, all metadata space is
> already reserved when starting a new transaction.
> 
> And for all @trans passed into btrfs_delayed_item_reserve_metadata(),
> they are all new transaction allocated by btrfs_start_transaction(), or
> operation won't increase btrfs reserved metadata space (delete item,
> like unlink).
> 
> So the extra btrfs_qgroup_reserve_meta_prealloc() call here could cause
> unexpected -EDQUOT and hit BUG_ON() for its caller.
> 
> [FIX]
> Fix it by just remove the btrfs_qgroup_reserve_meta_prealloc() call.
> 
> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-inode.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index f1bc110e229c..492af96d0e38 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -569,9 +569,6 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
>  	dst_rsv = &fs_info->delayed_block_rsv;
>  
>  	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> -	ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
> -	if (ret < 0)
> -		return ret;

I'd rather fold this to the original patch as it's still in the devel
queue and I don't see much point to add a buggy patch and fix
separatelly.

If you have a suggestion for a text to be put to changelog so at least
we have some sort of documentation about the special case for delayed
inode item reservation.
