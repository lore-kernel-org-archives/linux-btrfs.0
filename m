Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8855 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbbGWUWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 16:22:33 -0400
Date: Thu, 23 Jul 2015 16:21:55 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
Message-ID: <20150723202155.GC28964@ret.masoncoding.com>
References: <559C9A75.60506@cn.fujitsu.com>
 <55AF6250.8070602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55AF6250.8070602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 05:28:48PM +0800, Qu Wenruo wrote:
> Hi Chris,
> 
> Is there anything wrong with it?
> 
> It has been 2 weeks, and it's still not in your for linus branch.
> 
> Is there anything wrong?

I ran this through xfstests again, and got tasks deadlocked during
btrfs/061.  Looks like scrub is leaking an extent buffer lock?

I'll see what I can find, but posting here in case you've seen it
already.

155540 (kworker/u65:6) D
[<ffffffffa06898d0>] btrfs_tree_lock+0xf0/0x260 [btrfs]
[<ffffffffa066a7dc>] lock_extent_buffer_for_io+0x1ac/0x1e0 [btrfs]
[<ffffffffa066adc2>] btree_write_cache_pages+0x242/0x430 [btrfs]
[<ffffffffa064010f>] btree_writepages+0x6f/0x80 [btrfs]
[<ffffffff81172b23>] do_writepages+0x23/0x40
[<ffffffff81208c2d>] __writeback_single_inode+0x7d/0x780
[<ffffffff81209931>] writeback_sb_inodes+0x2b1/0x570
[<ffffffff81209de6>] wb_writeback+0x136/0x760
[<ffffffff8120a520>] wb_do_writeback+0x110/0x440
[<ffffffff8120a8e5>] wb_workfn+0x95/0x440
[<ffffffff81078788>] process_one_work+0x1e8/0x730
[<ffffffff81078dea>] worker_thread+0x11a/0x4d0
[<ffffffff8107e7b9>] kthread+0xe9/0x110
[<ffffffff816b128f>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff

240994 (btrfs-transacti) D
[<ffffffffa06470b9>] wait_for_commit+0x59/0x90 [btrfs]
[<ffffffffa0649b94>] btrfs_commit_transaction+0x284/0xd10 [btrfs]
[<ffffffffa0643c46>] transaction_kthread+0x246/0x2a0 [btrfs]
[<ffffffff8107e7b9>] kthread+0xe9/0x110
[<ffffffff816b128f>] ret_from_fork+0x3f/0x70
[<ffffffffffffffff>] 0xffffffffffffffff

241000 (btrfs) D
[<ffffffffa06898d0>] btrfs_tree_lock+0xf0/0x260 [btrfs]
[<ffffffffa066a7dc>] lock_extent_buffer_for_io+0x1ac/0x1e0 [btrfs]
[<ffffffffa066adc2>] btree_write_cache_pages+0x242/0x430 [btrfs]
[<ffffffffa064010f>] btree_writepages+0x6f/0x80 [btrfs]
[<ffffffff81172b23>] do_writepages+0x23/0x40
[<ffffffff811638a5>] __filemap_fdatawrite_range+0xb5/0x100
[<ffffffff81163c73>] filemap_fdatawrite_range+0x13/0x20
[<ffffffffa0648b24>] btrfs_write_marked_extents+0xf4/0x140 [btrfs]
[<ffffffffa0648bbb>] btrfs_write_and_wait_transaction+0x4b/0x90 [btrfs]
[<ffffffffa064a1c5>] btrfs_commit_transaction+0x8b5/0xd10 [btrfs]
[<ffffffffa06a646e>] relocate_block_group+0x41e/0x5e0 [btrfs]
[<ffffffffa06a67b4>] btrfs_relocate_block_group+0x184/0x2a0 [btrfs]
[<ffffffffa067722a>] btrfs_relocate_chunk+0x7a/0x110 [btrfs]
[<ffffffffa067836c>] btrfs_balance+0x9bc/0x1060 [btrfs]
[<ffffffffa0680ed8>] btrfs_ioctl_balance+0x1c8/0x330 [btrfs]
[<ffffffffa06888f9>] btrfs_ioctl+0x409/0x1150 [btrfs]
[<ffffffff811e9dfa>] do_vfs_ioctl+0x8a/0x570
[<ffffffff811ea372>] SyS_ioctl+0x92/0xa0
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241024 (btrfs) D
[<ffffffffa06aa9de>] __scrub_blocked_if_needed+0x7e/0xc0 [btrfs]
[<ffffffffa06aab22>] scrub_pause_off+0x32/0x70 [btrfs]
[<ffffffffa06b1b73>] scrub_enumerate_chunks+0x4d3/0x5d0 [btrfs]
[<ffffffffa06b1e36>] btrfs_scrub_dev+0x1c6/0x5a0 [btrfs]
[<ffffffffa0686381>] btrfs_ioctl_scrub+0xb1/0x120 [btrfs]
[<ffffffffa0688ef3>] btrfs_ioctl+0xa03/0x1150 [btrfs]
[<ffffffff811e9dfa>] do_vfs_ioctl+0x8a/0x570
[<ffffffff811ea372>] SyS_ioctl+0x92/0xa0
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241002 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241003 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241004 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241005 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241006 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241007 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241008 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241009 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241010 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241012 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241013 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241015 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241016 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241019 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241020 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

241021 (fsstress) D
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

16 hits: 
[<ffffffff81202ecf>] wb_wait_for_completion+0x5f/0x90
[<ffffffff81208199>] sync_inodes_sb+0x99/0x1c0
[<ffffffff8120ebc6>] sync_inodes_one_sb+0x16/0x20
[<ffffffff811d947f>] iterate_supers+0xaf/0xe0
[<ffffffff8120ec05>] sys_sync+0x35/0x90
[<ffffffff816b0e97>] entry_SYSCALL_64_fastpath+0x12/0x6f
[<ffffffffffffffff>] 0xffffffffffffffff

-----
