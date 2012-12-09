Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44294 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab2LIOGe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 09:06:34 -0500
Date: Sun, 9 Dec 2012 22:04:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jim Schutt <jaschut@sandia.gov>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: 3.7.0-rc8 btrfs locking issue
Message-ID: <20121209140442.GA14309@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <50BF7129.90602@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50BF7129.90602@sandia.gov>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 05, 2012 at 09:07:05AM -0700, Jim Schutt wrote:
> Hi,
> 
> I'm hitting a btrfs locking issue with 3.7.0-rc8.
> 
> The btrfs filesystem in question is backing a Ceph OSD
> under a heavy write load from many cephfs clients.
> 
> I reported this issue a while ago:
>   http://www.spinics.net/lists/linux-btrfs/msg19370.html
> when I was testing what I thought might be part of the
> 3.7 btrfs patch queue, using Josef Bacik's btrfs-next tree.
> 
> I spent some time attempting to bisect the btrfs patch queue
> just before it was merged for 3.7, but got nowhere due to
> false negatives.
> 
> I've just been able to get back to testing 3.7-rc, and found
> that I can still trigger the issue.

Hi Jim,

Could you please apply the following patch to test if it works?

(It's against 3.7-rc8.)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..100289b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3346,7 +3346,8 @@ u64 btrfs_get_alloc_profile(struct btrfs_root
*root, int data)
 
 	if (data)
 		flags = BTRFS_BLOCK_GROUP_DATA;
-	else if (root == root->fs_info->chunk_root)
+	else if (root == root->fs_info->chunk_root ||
+		 root == root->fs_info->dev_root)
 		flags = BTRFS_BLOCK_GROUP_SYSTEM;
 	else
 		flags = BTRFS_BLOCK_GROUP_METADATA;
@@ -3535,6 +3536,7 @@ static u64 get_system_chunk_thresh(struct
btrfs_root *root, u64 type)
 		num_dev = 1;	/* DUP or single */
 
 	/* metadata for updaing devices and chunk tree */
+	num_dev = num_dev << 1
 	return btrfs_calc_trans_metadata_size(root, num_dev + 1);
 }
 
@@ -4351,7 +4353,7 @@ static void init_global_block_rsv(struct
btrfs_fs_info *fs_info)
 
 	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
-	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->dev_root->block_rsv = &fs_info->chunk_block_rsv;
 	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
 

thanks,
liubo


> 
> First I get this lockdep splat:
> 
> [ 1184.201331] =============================================
> [ 1184.206716] [ INFO: possible recursive locking detected ]
> [ 1184.212111] 3.7.0-rc8-00013-gdf2fc24 #438 Not tainted
> [ 1184.217156] ---------------------------------------------
> [ 1184.222544] ceph-osd/42177 is trying to acquire lock:
> [ 1184.227589]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.237270]
> [ 1184.237270] but task is already holding lock:
> [ 1184.243114]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.252786]
> [ 1184.252786] other info that might help us debug this:
> [ 1184.259303]  Possible unsafe locking scenario:
> [ 1184.259303]
> [ 1184.265220]        CPU0
> [ 1184.267680]        ----
> [ 1184.270133]   lock(&fs_info->chunk_mutex);
> [ 1184.274276]   lock(&fs_info->chunk_mutex);
> [ 1184.278417]
> [ 1184.278417]  *** DEADLOCK ***
> [ 1184.278417]
> [ 1184.284325]  May be due to missing lock nesting notation
> [ 1184.284325]
> [ 1184.291099] 4 locks held by ceph-osd/42177:
> [ 1184.295277]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffffa0584664>] btrfs_file_aio_write+0x64/0x320 [btrfs]
> [ 1184.305103]  #1:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffffa058466e>] btrfs_file_aio_write+0x6e/0x320 [btrfs]
> [ 1184.316108]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05746f4>] start_transaction+0x1c4/0x450 [btrfs]
> [ 1184.325632]  #3:  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.335761]
> [ 1184.335761] stack backtrace:
> [ 1184.340126] Pid: 42177, comm: ceph-osd Not tainted 3.7.0-rc8-00013-gdf2fc24 #438
> [ 1184.347508] Call Trace:
> [ 1184.349962]  [<ffffffff81042eca>] ? vprintk_emit+0x42a/0x4c0
> [ 1184.355619]  [<ffffffff8109b579>] print_deadlock_bug+0xe9/0x100
> [ 1184.361556]  [<ffffffff8109d246>] validate_chain+0x596/0x750
> [ 1184.367222]  [<ffffffff8109d849>] __lock_acquire+0x449/0x510
> [ 1184.372894]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.379417]  [<ffffffff8109d9d9>] lock_acquire+0xc9/0x120
> [ 1184.384855]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.391377]  [<ffffffff8109d849>] ? __lock_acquire+0x449/0x510
> [ 1184.397204]  [<ffffffff814ab17d>] __mutex_lock_common+0x5d/0x3a0
> [ 1184.403221]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.409762]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.416323]  [<ffffffffa055a5c9>] ? do_chunk_alloc+0x179/0x340 [btrfs]
> [ 1184.422849]  [<ffffffff814ab62a>] mutex_lock_nested+0x4a/0x60
> [ 1184.428640]  [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1184.435018]  [<ffffffffa05635bc>] find_free_extent+0xa3c/0xb70 [btrfs]
> [ 1184.441555]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1184.449051]  [<ffffffffa0563772>] btrfs_reserve_extent+0x82/0x190 [btrfs]
> [ 1184.455843]  [<ffffffffa0563905>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
> [ 1184.462828]  [<ffffffffa054fb6a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
> [ 1184.469471]  [<ffffffffa05a50d3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
> [ 1184.476962]  [<ffffffffa055056d>] btrfs_cow_block+0x18d/0x230 [btrfs]
> [ 1184.483426]  [<ffffffffa0553460>] btrfs_search_slot+0x360/0x730 [btrfs]
> [ 1184.490067]  [<ffffffffa055426d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
> [ 1184.497199]  [<ffffffff81159be3>] ? kmem_cache_alloc+0xd3/0x170
> [ 1184.503151]  [<ffffffffa0596f25>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
> [ 1184.510125]  [<ffffffffa059b0d7>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
> [ 1184.516928]  [<ffffffffa059b1de>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
> [ 1184.523374]  [<ffffffffa055a391>] ? check_system_chunk+0x71/0x130 [btrfs]
> [ 1184.530179]  [<ffffffffa055a71e>] do_chunk_alloc+0x2ce/0x340 [btrfs]
> [ 1184.536555]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1184.544070]  [<ffffffffa055e35c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
> [ 1184.551574]  [<ffffffffa055ff00>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
> [ 1184.558987]  [<ffffffffa05842de>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
> [ 1184.566042]  [<ffffffffa0584809>] btrfs_file_aio_write+0x209/0x320 [btrfs]
> [ 1184.572944]  [<ffffffffa0584600>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
> [ 1184.579984]  [<ffffffff81165014>] do_sync_readv_writev+0x94/0xe0
> [ 1184.585985]  [<ffffffff81166023>] do_readv_writev+0xe3/0x1e0
> [ 1184.591645]  [<ffffffff81183112>] ? fget_light+0x122/0x170
> [ 1184.597131]  [<ffffffff81166166>] vfs_writev+0x46/0x60
> [ 1184.602266]  [<ffffffff8116629f>] sys_writev+0x5f/0xc0
> [ 1184.607398]  [<ffffffff81264b6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1184.613832]  [<ffffffff814b7042>] system_call_fastpath+0x16/0x1b
> 
> and then a little later:
> 
> [ 1319.463719] INFO: task ceph-osd:42177 blocked for more than 120 seconds.
> [ 1319.470409] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1319.478227] ceph-osd        D 0000000000000246     0 42177      1 0x00000000
> [ 1319.485330]  ffff880402c4d358 0000000000000046 00007fffeccc49d0 ffff880402c4dfd8
> [ 1319.492852]  ffff880402c4c010 ffff880402c4c000 ffff880402c4c000 ffff880402c4c000
> [ 1319.500449]  ffff880402c4dfd8 ffff880402c4c000 ffff880c2151bec0 ffff8804e9403ec0
> [ 1319.508012] Call Trace:
> [ 1319.510495]  [<ffffffff814acc5d>] schedule+0x5d/0x60
> [ 1319.515478]  [<ffffffff814acf67>] schedule_preempt_disabled+0x27/0x40
> [ 1319.521967]  [<ffffffff814ab375>] __mutex_lock_common+0x255/0x3a0
> [ 1319.528090]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1319.534659]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1319.541264]  [<ffffffff814ab62a>] mutex_lock_nested+0x4a/0x60
> [ 1319.547118]  [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1319.553532]  [<ffffffffa05635bc>] find_free_extent+0xa3c/0xb70 [btrfs]
> [ 1319.560122]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1319.567620]  [<ffffffffa0563772>] btrfs_reserve_extent+0x82/0x190 [btrfs]
> [ 1319.574460]  [<ffffffffa0563905>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
> [ 1319.581464]  [<ffffffffa054fb6a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
> [ 1319.588117]  [<ffffffffa05a50d3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
> [ 1319.595644]  [<ffffffffa055056d>] btrfs_cow_block+0x18d/0x230 [btrfs]
> [ 1319.602110]  [<ffffffffa0553460>] btrfs_search_slot+0x360/0x730 [btrfs]
> [ 1319.608767]  [<ffffffffa055426d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
> [ 1319.615897]  [<ffffffff81159be3>] ? kmem_cache_alloc+0xd3/0x170
> [ 1319.621910]  [<ffffffffa0596f25>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
> [ 1319.628893]  [<ffffffffa059b0d7>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
> [ 1319.635736]  [<ffffffffa059b1de>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
> [ 1319.642184]  [<ffffffffa055a391>] ? check_system_chunk+0x71/0x130 [btrfs]
> [ 1319.649009]  [<ffffffffa055a71e>] do_chunk_alloc+0x2ce/0x340 [btrfs]
> [ 1319.655366]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1319.662935]  [<ffffffffa055e35c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
> [ 1319.670465]  [<ffffffffa055ff00>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
> [ 1319.677891]  [<ffffffffa05842de>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
> [ 1319.685000]  [<ffffffffa0584809>] btrfs_file_aio_write+0x209/0x320 [btrfs]
> [ 1319.691952]  [<ffffffffa0584600>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
> [ 1319.699054]  [<ffffffff81165014>] do_sync_readv_writev+0x94/0xe0
> [ 1319.705118]  [<ffffffff81166023>] do_readv_writev+0xe3/0x1e0
> [ 1319.710828]  [<ffffffff81183112>] ? fget_light+0x122/0x170
> [ 1319.716324]  [<ffffffff81166166>] vfs_writev+0x46/0x60
> [ 1319.721466]  [<ffffffff8116629f>] sys_writev+0x5f/0xc0
> [ 1319.726674]  [<ffffffff81264b6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1319.733198]  [<ffffffff814b7042>] system_call_fastpath+0x16/0x1b
> [ 1319.739274] INFO: lockdep is turned off.
> [ 1319.743261] INFO: task ceph-osd:42236 blocked for more than 120 seconds.
> [ 1319.749953] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1319.757812] ceph-osd        D 0000000000000246     0 42236      1 0x00000000
> [ 1319.765056]  ffff88052e7bdcc8 0000000000000046 ffff880624666120 ffff88052e7bdfd8
> [ 1319.772785]  ffff88052e7bc010 ffff88052e7bc000 ffff88052e7bc000 ffff88052e7bc000
> [ 1319.780332]  ffff88052e7bdfd8 ffff88052e7bc000 ffff88062453bec0 ffff88052e7b5e20
> [ 1319.787905] Call Trace:
> [ 1319.790368]  [<ffffffff814acc5d>] schedule+0x5d/0x60
> [ 1319.795335]  [<ffffffff814acf67>] schedule_preempt_disabled+0x27/0x40
> [ 1319.801762]  [<ffffffff814ab375>] __mutex_lock_common+0x255/0x3a0
> [ 1319.807861]  [<ffffffffa0548b4f>] ? btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1319.814143]  [<ffffffff811703cf>] ? final_putname+0x3f/0x50
> [ 1319.819724]  [<ffffffffa0548b4f>] ? btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1319.825982]  [<ffffffff814ab62a>] mutex_lock_nested+0x4a/0x60
> [ 1319.831731]  [<ffffffffa0548b4f>] btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1319.837846]  [<ffffffff811968c0>] statfs_by_dentry+0x60/0x90
> [ 1319.843508]  [<ffffffff81196a0b>] vfs_statfs+0x1b/0xb0
> [ 1319.848659]  [<ffffffff81196c00>] user_statfs+0x40/0x60
> [ 1319.853887]  [<ffffffff81196caa>] sys_statfs+0x2a/0x50
> [ 1319.859036]  [<ffffffff814b7042>] system_call_fastpath+0x16/0x1b
> [ 1319.865035] INFO: lockdep is turned off.
> 
> and then later still:
> 
> [ 1439.546768] INFO: task btrfs-transacti:27591 blocked for more than 120 seconds.
> [ 1439.554139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1439.561949] btrfs-transacti D ffff880993231810     0 27591      2 0x00000000
> [ 1439.569205]  ffff8808e79d3c58 0000000000000046 0000000000000000 ffff8808e79d3fd8
> [ 1439.576820]  ffff8808e79d2010 ffff8808e79d2000 ffff8808e79d2000 ffff8808e79d2000
> [ 1439.584384]  ffff8808e79d3fd8 ffff8808e79d2000 ffff880b3f165e20 ffff8808d8cdbec0
> [ 1439.592040] Call Trace:
> [ 1439.594573]  [<ffffffff814acc5d>] schedule+0x5d/0x60
> [ 1439.599646]  [<ffffffff814aac3d>] schedule_timeout+0x3d/0x260
> [ 1439.605402]  [<ffffffff8109c410>] ? trace_hardirqs_on_caller+0x20/0x1d0
> [ 1439.612023]  [<ffffffff8109c5cd>] ? trace_hardirqs_on+0xd/0x10
> [ 1439.617939]  [<ffffffff8106781a>] ? prepare_to_wait+0x7a/0x90
> [ 1439.623788]  [<ffffffffa0573a46>] btrfs_commit_transaction+0x336/0xa10 [btrfs]
> [ 1439.631128]  [<ffffffffa05748fb>] ? start_transaction+0x3cb/0x450 [btrfs]
> [ 1439.637943]  [<ffffffff810674e0>] ? wake_up_bit+0x40/0x40
> [ 1439.643380]  [<ffffffffa056c223>] transaction_kthread+0x123/0x210 [btrfs]
> [ 1439.650259]  [<ffffffffa056c100>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
> [ 1439.657134]  [<ffffffff81066dd1>] kthread+0xe1/0xf0
> [ 1439.662109]  [<ffffffff81066cf0>] ? __init_kthread_worker+0x70/0x70
> [ 1439.668398]  [<ffffffff814b6f9c>] ret_from_fork+0x7c/0xb0
> [ 1439.673858]  [<ffffffff81066cf0>] ? __init_kthread_worker+0x70/0x70
> [ 1439.680181] INFO: lockdep is turned off.
> [ 1439.685095] INFO: task ceph-osd:42177 blocked for more than 120 seconds.
> [ 1439.691847] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1439.699743] ceph-osd        D 0000000000000246     0 42177      1 0x00000000
> [ 1439.706941]  ffff880402c4d358 0000000000000046 00007fffeccc49d0 ffff880402c4dfd8
> [ 1439.714494]  ffff880402c4c010 ffff880402c4c000 ffff880402c4c000 ffff880402c4c000
> [ 1439.722039]  ffff880402c4dfd8 ffff880402c4c000 ffff880c2151bec0 ffff8804e9403ec0
> [ 1439.729688] Call Trace:
> [ 1439.732217]  [<ffffffff814acc5d>] schedule+0x5d/0x60
> [ 1439.737179]  [<ffffffff814acf67>] schedule_preempt_disabled+0x27/0x40
> [ 1439.743705]  [<ffffffff814ab375>] __mutex_lock_common+0x255/0x3a0
> [ 1439.749843]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1439.756481]  [<ffffffffa055a5d3>] ? do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1439.763037]  [<ffffffff814ab62a>] mutex_lock_nested+0x4a/0x60
> [ 1439.768854]  [<ffffffffa055a5d3>] do_chunk_alloc+0x183/0x340 [btrfs]
> [ 1439.775290]  [<ffffffffa05635bc>] find_free_extent+0xa3c/0xb70 [btrfs]
> [ 1439.781932]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1439.789534]  [<ffffffffa0563772>] btrfs_reserve_extent+0x82/0x190 [btrfs]
> [ 1439.796474]  [<ffffffffa0563905>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
> [ 1439.803499]  [<ffffffffa054fb6a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
> [ 1439.810253]  [<ffffffffa05a50d3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
> [ 1439.817877]  [<ffffffffa055056d>] btrfs_cow_block+0x18d/0x230 [btrfs]
> [ 1439.824427]  [<ffffffffa0553460>] btrfs_search_slot+0x360/0x730 [btrfs]
> [ 1439.831162]  [<ffffffffa055426d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
> [ 1439.838423]  [<ffffffff81159be3>] ? kmem_cache_alloc+0xd3/0x170
> [ 1439.844514]  [<ffffffffa0596f25>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
> [ 1439.851619]  [<ffffffffa059b0d7>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
> [ 1439.858535]  [<ffffffffa059b1de>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
> [ 1439.865079]  [<ffffffffa055a391>] ? check_system_chunk+0x71/0x130 [btrfs]
> [ 1439.871939]  [<ffffffffa055a71e>] do_chunk_alloc+0x2ce/0x340 [btrfs]
> [ 1439.878375]  [<ffffffffa05569e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
> [ 1439.885933]  [<ffffffffa055e35c>] btrfs_check_data_free_space+0x13c/0x2b0 [btrfs]
> [ 1439.893514]  [<ffffffffa055ff00>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
> [ 1439.901018]  [<ffffffffa05842de>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
> [ 1439.908226]  [<ffffffffa0584809>] btrfs_file_aio_write+0x209/0x320 [btrfs]
> [ 1439.915235]  [<ffffffffa0584600>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
> [ 1439.922375]  [<ffffffff81165014>] do_sync_readv_writev+0x94/0xe0
> [ 1439.928475]  [<ffffffff81166023>] do_readv_writev+0xe3/0x1e0
> [ 1439.934197]  [<ffffffff81183112>] ? fget_light+0x122/0x170
> [ 1439.939738]  [<ffffffff81166166>] vfs_writev+0x46/0x60
> [ 1439.944948]  [<ffffffff8116629f>] sys_writev+0x5f/0xc0
> [ 1439.950139]  [<ffffffff81264b6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 1439.956621]  [<ffffffff814b7042>] system_call_fastpath+0x16/0x1b
> [ 1439.962742] INFO: lockdep is turned off.
> [ 1439.966769] INFO: task ceph-osd:42236 blocked for more than 120 seconds.
> [ 1439.973558] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1439.981513] ceph-osd        D 0000000000000246     0 42236      1 0x00000000
> [ 1439.988788]  ffff88052e7bdcc8 0000000000000046 ffff880624666120 ffff88052e7bdfd8
> [ 1439.996611]  ffff88052e7bc010 ffff88052e7bc000 ffff88052e7bc000 ffff88052e7bc000
> [ 1440.004237]  ffff88052e7bdfd8 ffff88052e7bc000 ffff88062453bec0 ffff88052e7b5e20
> [ 1440.011956] Call Trace:
> [ 1440.014516]  [<ffffffff814acc5d>] schedule+0x5d/0x60
> [ 1440.019578]  [<ffffffff814acf67>] schedule_preempt_disabled+0x27/0x40
> [ 1440.026054]  [<ffffffff814ab375>] __mutex_lock_common+0x255/0x3a0
> [ 1440.032245]  [<ffffffffa0548b4f>] ? btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1440.038624]  [<ffffffff811703cf>] ? final_putname+0x3f/0x50
> [ 1440.044323]  [<ffffffffa0548b4f>] ? btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1440.050952]  [<ffffffff814ab62a>] mutex_lock_nested+0x4a/0x60
> [ 1440.056805]  [<ffffffffa0548b4f>] btrfs_statfs+0x5f/0x240 [btrfs]
> [ 1440.063029]  [<ffffffff811968c0>] statfs_by_dentry+0x60/0x90
> [ 1440.068739]  [<ffffffff81196a0b>] vfs_statfs+0x1b/0xb0
> [ 1440.073962]  [<ffffffff81196c00>] user_statfs+0x40/0x60
> [ 1440.079203]  [<ffffffff81196caa>] sys_statfs+0x2a/0x50
> [ 1440.084401]  [<ffffffff814b7042>] system_call_fastpath+0x16/0x1b
> [ 1440.090816] INFO: lockdep is turned off.
> 
> 
> Please let me know what I can do to help resolve this issue.
> 
> Thanks -- Jim
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
