Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:38712 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755988AbcJRWmN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 18:42:13 -0400
Date: Tue, 18 Oct 2016 18:42:05 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, axboe@fb.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:45:07AM -0400, Dave Jones wrote:

 > WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
 > list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
 > CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13 
 >  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
 >  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880
 >  ffff880503878b80 ffffe8ffff806648 ffffe8ffffc06600 ffff880502808008
 > Call Trace:
 > [<ffffffff8d32007c>] dump_stack+0x4f/0x73
 > [<ffffffff8d07a6c1>] __warn+0xc1/0xe0
 > [<ffffffff8d07a73a>] warn_slowpath_fmt+0x5a/0x80
 > [<ffffffff8d33e689>] __list_add+0x89/0xb0
 > [<ffffffff8d30a1c8>] blk_sq_make_request+0x2f8/0x350
 > [<ffffffff8d2fd9cc>] ? generic_make_request+0xec/0x240
 > [<ffffffff8d2fd9d9>] generic_make_request+0xf9/0x240
 > [<ffffffff8d2fdb98>] submit_bio+0x78/0x150
 > [<ffffffff8d349c05>] ? __percpu_counter_add+0x85/0xb0
 > [<ffffffffc03627de>] btrfs_map_bio+0x19e/0x330 [btrfs]
 > [<ffffffffc03289ca>] btree_submit_bio_hook+0xfa/0x110 [btrfs]
 > [<ffffffffc034ff15>] submit_one_bio+0x65/0xa0 [btrfs]
 > [<ffffffffc0358cb0>] read_extent_buffer_pages+0x2f0/0x3d0 [btrfs]
 > [<ffffffffc0327020>] ? free_root_pointers+0x60/0x60 [btrfs]
 > [<ffffffffc03283c8>] btree_read_extent_buffer_pages.constprop.55+0xa8/0x110 [btrfs]
 > [<ffffffffc0328bcd>] read_tree_block+0x2d/0x50 [btrfs]
 > [<ffffffffc03080a4>] read_block_for_search.isra.33+0x134/0x330 [btrfs]
 > [<ffffffff8d7c2d6c>] ? _raw_write_unlock+0x2c/0x50
 > [<ffffffffc0302fec>] ? unlock_up+0x16c/0x1a0 [btrfs]
 > [<ffffffffc030a3d0>] btrfs_search_slot+0x450/0xa40 [btrfs]
 > [<ffffffffc0324983>] btrfs_del_csums+0xe3/0x2e0 [btrfs]
 > [<ffffffffc03134fd>] __btrfs_free_extent.isra.82+0x32d/0xc90 [btrfs]
 > [<ffffffffc03178b3>] __btrfs_run_delayed_refs+0x4d3/0x1010 [btrfs]
 > [<ffffffff8d33e5d7>] ? debug_smp_processor_id+0x17/0x20
 > [<ffffffff8d0c6109>] ? get_lock_stats+0x19/0x50
 > [<ffffffffc031b32c>] btrfs_run_delayed_refs+0x9c/0x2d0 [btrfs]
 > [<ffffffffc033d628>] btrfs_truncate_inode_items+0x888/0xda0 [btrfs]
 > [<ffffffffc033dc25>] btrfs_truncate+0xe5/0x2b0 [btrfs]
 > [<ffffffffc033e569>] btrfs_setattr+0x249/0x360 [btrfs]
 > [<ffffffff8d1f4092>] notify_change+0x252/0x440
 > [<ffffffff8d1d164e>] do_truncate+0x6e/0xc0
 > [<ffffffff8d1d1a4c>] do_sys_ftruncate.constprop.19+0x10c/0x170
 > [<ffffffff8d33e5f3>] ? __this_cpu_preempt_check+0x13/0x20
 > [<ffffffff8d1d1ad9>] SyS_ftruncate+0x9/0x10
 > [<ffffffff8d00259c>] do_syscall_64+0x5c/0x170
 > [<ffffffff8d7c2f8b>] entry_SYSCALL64_slow_path+0x25/0x25

So Chris had me do a run on ext4 just for giggles. It took a while, but
eventually this fell out...


WARNING: CPU: 3 PID: 21324 at lib/list_debug.c:33 __list_add+0x89/0xb0
list_add corruption. prev->next should be next (ffffe8ffffc05648), but was ffffc9000028bcd8. (prev=ffff880503a145c0).
CPU: 3 PID: 21324 Comm: modprobe Not tainted 4.9.0-rc1-think+ #1 
 ffffc90000a6b7b8 ffffffff81320e3c ffffc90000a6b808 0000000000000000
 ffffc90000a6b7f8 ffffffff8107a711 0000002100000246 ffff8805039f1740
 ffff880503a145c0 ffffe8ffffc05648 ffffe8ffffa05600 ffff880502c39548
Call Trace:
 [<ffffffff81320e3c>] dump_stack+0x4f/0x73
 [<ffffffff8107a711>] __warn+0xc1/0xe0
 [<ffffffff8107a78a>] warn_slowpath_fmt+0x5a/0x80
 [<ffffffff8133f499>] __list_add+0x89/0xb0
 [<ffffffff8130af88>] blk_sq_make_request+0x2f8/0x350
 [<ffffffff812fe6dc>] ? generic_make_request+0xec/0x240
 [<ffffffff812fe6e9>] generic_make_request+0xf9/0x240
 [<ffffffff812fe8a8>] submit_bio+0x78/0x150
 [<ffffffff8120bde6>] ? __find_get_block+0x126/0x130
 [<ffffffff8120cbff>] submit_bh_wbc+0x16f/0x1e0
 [<ffffffff8120a400>] ? __end_buffer_read_notouch+0x20/0x20
 [<ffffffff8120d958>] ll_rw_block+0xa8/0xb0
 [<ffffffff8120da0f>] __breadahead+0x3f/0x70
 [<ffffffff81264ffc>] __ext4_get_inode_loc+0x37c/0x3d0
 [<ffffffff8126806d>] ext4_iget+0x8d/0xb90
 [<ffffffff811f0759>] ? d_alloc_parallel+0x329/0x700
 [<ffffffff81268b9a>] ext4_iget_normal+0x2a/0x30
 [<ffffffff81273cd6>] ext4_lookup+0x136/0x250
 [<ffffffff811e118d>] lookup_slow+0x12d/0x220
 [<ffffffff811e3897>] walk_component+0x1e7/0x310
 [<ffffffff811e33f8>] ? path_init+0x4d8/0x520
 [<ffffffff811e4022>] path_lookupat+0x62/0x120
 [<ffffffff811e4f22>] ? getname_flags+0x32/0x180
 [<ffffffff811e5278>] filename_lookup+0xa8/0x130
 [<ffffffff81352526>] ? strncpy_from_user+0x46/0x170
 [<ffffffff811e4f3e>] ? getname_flags+0x4e/0x180
 [<ffffffff811e53d1>] user_path_at_empty+0x31/0x40
 [<ffffffff811d9df1>] vfs_fstatat+0x61/0xc0
 [<ffffffff810c8b9f>] ? __lock_acquire.isra.32+0x1cf/0x8c0
 [<ffffffff811da30e>] SYSC_newstat+0x2e/0x60
 [<ffffffff8133f403>] ? __this_cpu_preempt_check+0x13/0x20
 [<ffffffff811da499>] SyS_newstat+0x9/0x10
 [<ffffffff8100259c>] do_syscall_64+0x5c/0x170
 [<ffffffff817c27cb>] entry_SYSCALL64_slow_path+0x25/0x25

So this one isn't a btrfs specific problem as I first thought.

This sometimes reproduces within minutes, sometimes hours, which makes
it a pain to bisect.  It only started showing up this merge window though.

	Dave

