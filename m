Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63825 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbaESBcZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 21:32:25 -0400
Message-ID: <53795F83.20109@fb.com>
Date: Sun, 18 May 2014 21:33:55 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 5/5] Btrfs: fix broken free space cache after the
 system crashed
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com> <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/15/2014 07:00 AM, Miao Xie wrote:
> When we mounted the filesystem after the crash, we got the following
> message:
>   BTRFS error (device xxx): block group 4315938816 has wrong amount of free space
>   BTRFS error (device xxx): failed to load free space cache for block group 4315938816
> 
> It is because we didn't update the metadata of the allocated space until
> the file data was written into the disk. During this time, there was no
> information about the allocated spaces in either the extent tree nor the
> free space cache. when we wrote out the free space cache at this time, those
> spaces were lost.
> 
> In ordered to fix this problem, I use a state tree for every block group
> to record those allocated spaces. We record the information when they are
> allocated, and clean up the information after the metadata update. Besides
> that, we also introduce a read-write semaphore to avoid the race between
> the allocation and the free space cache write out.
> 
> Only data block groups had this problem, so the above change is just
> for data space allocation.

I had this one in the integration branch, but lockdep reported troubles.  It
looks like lockdep is correct.  find_free_extent is nesting the cache rwsem
inside the groups rwsem, but btrfs_write_out_cache is holding the new cache
rwsem when it calls find_free_extent.

-chris

[ 2857.610731] ======================================================
[ 2857.623158] [ INFO: possible circular locking dependency detected ]
[ 2857.635771] 3.15.0-rc5-mason+ #43 Not tainted
[ 2857.644553] -------------------------------------------------------
[ 2857.657139] btrfs-transacti/19476 is trying to acquire lock:
[ 2857.668518]  (&found->groups_sem){++++..}, at: [<ffffffffa059dbc1>] find_free_extent+0x931/0xe20 [btrfs]
[ 2857.687771] 
[ 2857.687771] but task is already holding lock:
[ 2857.699566]  (&cache->data_rwsem){++++..}, at: [<ffffffffa05f78bf>] btrfs_write_out_cache+0x9f/0x170 [btrfs]
[ 2857.719480] 
[ 2857.719480] which lock already depends on the new lock.
[ 2857.719480] 
[ 2857.736021] 
[ 2857.736021] the existing dependency chain (in reverse order) is:
[ 2857.751120] 
-> #1 (&cache->data_rwsem){++++..}:
[ 2857.760823]        [<ffffffff810a14fe>] lock_acquire+0x8e/0x110
[ 2857.772772]        [<ffffffff81649cf7>] down_read+0x47/0x60
[ 2857.784028]        [<ffffffffa059db2c>] find_free_extent+0x89c/0xe20 [btrfs]
[ 2857.798253]        [<ffffffffa059e11b>] btrfs_reserve_extent+0x6b/0x140 [btrfs]
[ 2857.813041]        [<ffffffffa05b73ec>] cow_file_range+0x13c/0x460 [btrfs]
[ 2857.826892]        [<ffffffffa05bc097>] run_delalloc_range+0x347/0x380 [btrfs]
[ 2857.841510]        [<ffffffffa05d3f3d>] __extent_writepage+0x70d/0x870 [btrfs]
[ 2857.856129]        [<ffffffffa05d456a>] extent_write_cache_pages.clone.6+0x30a/0x410 [btrfs]
[ 2857.873185]        [<ffffffffa05d46c2>] extent_writepages+0x52/0x70 [btrfs]
[ 2857.887224]        [<ffffffffa05b3d57>] btrfs_writepages+0x27/0x30 [btrfs]
[ 2857.901078]        [<ffffffff81142543>] do_writepages+0x23/0x40
[ 2857.913034]        [<ffffffff81135b99>] __filemap_fdatawrite_range+0x59/0x60
[ 2857.927240]        [<ffffffff81135dec>] filemap_flush+0x1c/0x20
[ 2857.939215]        [<ffffffffa05b2502>] btrfs_run_delalloc_work+0x72/0xa0 [btrfs]
[ 2857.954367]        [<ffffffffa05e05fe>] normal_work_helper+0x6e/0x2d0 [btrfs]
[ 2857.968749]        [<ffffffff8106b9e2>] process_one_work+0x1d2/0x550
[ 2857.981561]        [<ffffffff8106cd8f>] worker_thread+0x11f/0x3a0
[ 2857.993856]        [<ffffffff8107317e>] kthread+0xde/0x100
[ 2858.004936]        [<ffffffff8165436c>] ret_from_fork+0x7c/0xb0
[ 2858.016887] 
-> #0 (&found->groups_sem){++++..}:
[ 2858.026590]        [<ffffffff810a12de>] __lock_acquire+0x161e/0x17b0
[ 2858.039407]        [<ffffffff810a14fe>] lock_acquire+0x8e/0x110
[ 2858.051370]        [<ffffffff81649cf7>] down_read+0x47/0x60
[ 2858.062629]        [<ffffffffa059dbc1>] find_free_extent+0x931/0xe20 [btrfs]
[ 2858.076841]        [<ffffffffa059e11b>] btrfs_reserve_extent+0x6b/0x140 [btrfs]
[ 2858.091629]        [<ffffffffa059e307>] btrfs_alloc_free_block+0x117/0x420 [btrfs]
[ 2858.106940]        [<ffffffffa0589a5b>] __btrfs_cow_block+0x11b/0x530 [btrfs]
[ 2858.121331]        [<ffffffffa058a4a0>] btrfs_cow_block+0x130/0x1e0 [btrfs]
[ 2858.135375]        [<ffffffffa058c999>] btrfs_search_slot+0x219/0x9c0 [btrfs]
[ 2858.149760]        [<ffffffffa05f7595>] __btrfs_write_out_cache+0x755/0x970 [btrfs]
[ 2858.165245]        [<ffffffffa05f7958>] btrfs_write_out_cache+0x138/0x170 [btrfs]
[ 2858.180411]        [<ffffffffa059ccb0>] btrfs_write_dirty_block_groups+0x480/0x600 [btrfs]
[ 2858.197107]        [<ffffffffa05ae7af>] commit_cowonly_roots+0x19f/0x250 [btrfs]
[ 2858.212084]        [<ffffffffa05afbc0>] btrfs_commit_transaction+0x450/0xa60 [btrfs]
[ 2858.227738]        [<ffffffffa05aa8a6>] transaction_kthread+0x216/0x290 [btrfs]
[ 2858.242533]        [<ffffffff8107317e>] kthread+0xde/0x100
[ 2858.253617]        [<ffffffff8165436c>] ret_from_fork+0x7c/0xb0
[ 2858.265569] 
[ 2858.265569] other info that might help us debug this:
[ 2858.265569] 
[ 2858.281780]  Possible unsafe locking scenario:
[ 2858.281780] 
[ 2858.293750]        CPU0                    CPU1
[ 2858.302869]        ----                    ----
[ 2858.312000]   lock(&cache->data_rwsem);
[ 2858.319828]                                lock(&found->groups_sem);
[ 2858.332661]                                lock(&cache->data_rwsem);
[ 2858.345508]   lock(&found->groups_sem);
[ 2858.353300] 
[ 2858.353300]  *** DEADLOCK ***
[ 2858.353300] 
[ 2858.365337] 4 locks held by btrfs-transacti/19476:
[ 2858.374993]  #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at: [<ffffffffa05aa740>] transaction_kthread+0xb0/0x290 [btrfs]
[ 2858.398451]  #1:  (&fs_info->reloc_mutex){+.+...}, at: [<ffffffffa05afaf0>] btrfs_commit_transaction+0x380/0xa60 [btrfs]
[ 2858.420535]  #2:  (&fs_info->tree_log_mutex){+.+...}, at: [<ffffffffa05afb66>] btrfs_commit_transaction+0x3f6/0xa60 [btrfs]
[ 2858.443135]  #3:  (&cache->data_rwsem){++++..}, at: [<ffffffffa05f78bf>] btrfs_write_out_cache+0x9f/0x170 [btrfs]
[ 2858.463953] 
[ 2858.463953] stack backtrace:
[ 2858.472807] CPU: 25 PID: 19476 Comm: btrfs-transacti Not tainted 3.15.0-rc5-mason+ #43
[ 2858.488772] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
[ 2858.504564]  ffffffff820f1b10 ffff8807ff5f94e8 ffffffff8164585c 0000000000000001
[ 2858.519677]  ffffffff820e6170 ffff8807ff5f9538 ffffffff8109e322 0000000000000004
[ 2858.534761]  ffff8807ff5f9598 ffff8807ff5f9538 ffff8808444fd118 ffff8808444fc890
[ 2858.549850] Call Trace:
[ 2858.554830]  [<ffffffff8164585c>] dump_stack+0x51/0x6d
[ 2858.565168]  [<ffffffff8109e322>] print_circular_bug+0x212/0x310
[ 2858.577247]  [<ffffffff810a12de>] __lock_acquire+0x161e/0x17b0
[ 2858.588979]  [<ffffffff810a14fe>] lock_acquire+0x8e/0x110
[ 2858.599845]  [<ffffffffa059dbc1>] ? find_free_extent+0x931/0xe20 [btrfs]
[ 2858.613312]  [<ffffffff81649cf7>] down_read+0x47/0x60
[ 2858.623501]  [<ffffffffa059dbc1>] ? find_free_extent+0x931/0xe20 [btrfs]
[ 2858.636978]  [<ffffffffa059dbc1>] find_free_extent+0x931/0xe20 [btrfs]
[ 2858.650092]  [<ffffffff8164b60b>] ? _raw_spin_unlock+0x2b/0x40
[ 2858.661842]  [<ffffffffa059e11b>] btrfs_reserve_extent+0x6b/0x140 [btrfs]
[ 2858.675483]  [<ffffffffa059e307>] btrfs_alloc_free_block+0x117/0x420 [btrfs]
[ 2858.689644]  [<ffffffff810a01d0>] ? __lock_acquire+0x510/0x17b0
[ 2858.701564]  [<ffffffffa05cc600>] ? find_extent_buffer+0x10/0xf0 [btrfs]
[ 2858.715034]  [<ffffffffa0589a5b>] __btrfs_cow_block+0x11b/0x530 [btrfs]
[ 2858.728333]  [<ffffffffa058a4a0>] btrfs_cow_block+0x130/0x1e0 [btrfs]
[ 2858.741284]  [<ffffffffa058c999>] btrfs_search_slot+0x219/0x9c0 [btrfs]
[ 2858.754597]  [<ffffffffa05f7595>] __btrfs_write_out_cache+0x755/0x970 [btrfs]
[ 2858.768946]  [<ffffffffa05f78c7>] ? btrfs_write_out_cache+0xa7/0x170 [btrfs]
[ 2858.783108]  [<ffffffffa05f7900>] ? btrfs_write_out_cache+0xe0/0x170 [btrfs]
[ 2858.797289]  [<ffffffffa05f7958>] btrfs_write_out_cache+0x138/0x170 [btrfs]
[ 2858.811278]  [<ffffffff8164b60b>] ? _raw_spin_unlock+0x2b/0x40
[ 2858.823017]  [<ffffffffa059ccb0>] btrfs_write_dirty_block_groups+0x480/0x600 [btrfs]
[ 2858.838646]  [<ffffffffa05ae7af>] commit_cowonly_roots+0x19f/0x250 [btrfs]
[ 2858.852461]  [<ffffffffa05afbc0>] btrfs_commit_transaction+0x450/0xa60 [btrfs]
[ 2858.867043]  [<ffffffffa05aa826>] ? transaction_kthread+0x196/0x290 [btrfs]
[ 2858.881032]  [<ffffffffa05aa8a6>] transaction_kthread+0x216/0x290 [btrfs]
[ 2858.894679]  [<ffffffffa05aa690>] ? close_ctree+0x2d0/0x2d0 [btrfs]
[ 2858.907276]  [<ffffffff8107317e>] kthread+0xde/0x100
[ 2858.917280]  [<ffffffff810730a0>] ? __init_kthread_worker+0x70/0x70
[ 2858.929873]  [<ffffffff8165436c>] ret_from_fork+0x7c/0xb0
[ 2858.940745]  [<ffffffff810730a0>] ? __init_kthread_worker+0x70/0x70
[ 2893.109104] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
