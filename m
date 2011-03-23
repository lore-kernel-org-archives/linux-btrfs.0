From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V4] btrfs: implement delayed inode items operation
Date: Wed, 23 Mar 2011 17:47:01 +0800
Message-ID: <4D89C195.6020200@cn.fujitsu.com>
References: <4D8324DE.4010400@cn.fujitsu.com>	<20110322113310.50eaceb2.kitayama@cl.bb4u.ne.jp>	<4D8813A5.1040604@cn.fujitsu.com>	<20110322125051.222ccc5b.kitayama@cl.bb4u.ne.jp>	<4D8873EC.1040702@cn.fujitsu.com>	<20110322223324.ff6ee42a.kitayama@cl.bb4u.ne.jp>	<4D894C91.5040302@cn.fujitsu.com>	<20110323122409.6bc79eaf.kitayama@cl.bb4u.ne.jp>	<4D897066.7090409@cn.fujitsu.com> <20110323131918.0feda83a.kitayama@cl.bb4u.ne.jp>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000205060903060406000301"
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	David Sterba <dave@jikos.cz>, Ito <t-itoh@jp.fujitsu.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110323131918.0feda83a.kitayama@cl.bb4u.ne.jp>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000205060903060406000301
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

Hi, Kitayama-san

On wed, 23 Mar 2011 13:19:18 +0900, Itaru Kitayama wrote:
> On Wed, 23 Mar 2011 12:00:38 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> I is testing the new version, in which I fixed the slab shrinker problem reported by
>> Chris. In the new version, the delayed node is removed before the relative inode is
>> moved into the unused_inode list(the slab shrinker will reclaim inodes in this list).
>> Maybe this method can also fix this bug. So could you tell me the reproduce step
>> or the options of mkfs and mount? I will check if the new patch can fix this bug or not.
> 
> I used the default mkfs options for $TEST_DEV and enabled the space_cache and the
> compress=lzo options upon mounting the partition.

Unfortunately, I can trigger this warning, but by analyzing the following information,

> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.36-xie+ #122
> ---------------------------------------------------------
> kswapd0/49 just changed the state of lock:
>  (iprune_sem){++++.-}, at: [<ffffffff811316d0>] shrink_icache_memory+0x4d/0x213
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&delayed_node->mutex){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
[SNIP]
>     RECLAIM_FS-ON-W at:
>                              [<ffffffff81074292>] mark_held_locks+0x52/0x70
>                              [<ffffffff81074354>] lockdep_trace_alloc+0xa4/0xc2
>                              [<ffffffff8110f206>] __kmalloc+0x7f/0x154
>                              [<ffffffff811c2c21>] kzalloc+0x14/0x16
>                              [<ffffffff811c5e83>] cache_block_group+0x106/0x238
>                              [<ffffffff811c7069>] find_free_extent+0x4e2/0xa86
>                              [<ffffffff811c76c1>] btrfs_reserve_extent+0xb4/0x142
>                              [<ffffffff811c78b6>] btrfs_alloc_free_block+0x167/0x2af
>                              [<ffffffff811be610>] __btrfs_cow_block+0x103/0x346
>                              [<ffffffff811bedb8>] btrfs_cow_block+0x101/0x110
>                              [<ffffffff811c05d8>] btrfs_search_slot+0x143/0x513
>                              [<ffffffff811cf5ab>] btrfs_lookup_inode+0x2f/0x8f
>                              [<ffffffff81212405>] btrfs_update_delayed_inode+0x75/0x135
>                              [<ffffffff8121340d>] btrfs_run_delayed_items+0xd6/0x131
>                              [<ffffffff811d64d7>] btrfs_commit_transaction+0x28b/0x668
>                              [<ffffffff811ba786>] btrfs_sync_fs+0x6b/0x70
>                              [<ffffffff81140265>] __sync_filesystem+0x6b/0x83
>                              [<ffffffff81140347>] sync_filesystem+0x4c/0x50
>                              [<ffffffff8111fc56>] generic_shutdown_super+0x27/0xd7
>                              [<ffffffff8111fd5b>] kill_anon_super+0x16/0x54
>                              [<ffffffff8111effd>] deactivate_locked_super+0x26/0x46
>                              [<ffffffff8111f495>] deactivate_super+0x45/0x4a
>                              [<ffffffff81135962>] mntput_no_expire+0xd6/0x104
>                              [<ffffffff81136a87>] sys_umount+0x2c1/0x2ec
>                              [<ffffffff81002ddb>] system_call_fastpath+0x16/0x1b

we found GFP_KERNEL was passed into kzalloc(), I think this flag trigger the above lockdep
warning. the attached patch, which against the delayed items operation patch, may fix this
problem, Could you test it for me?

Thanks
Miao

--------------000205060903060406000301
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="0001-btrfs-use-GFP_NOFS-instead-of-GFP_KERNEL.patch"
Content-Disposition: attachment;
 filename="0001-btrfs-use-GFP_NOFS-instead-of-GFP_KERNEL.patch"

>From f84daee1d2060beae945a2774cda7af2ef7f3e61 Mon Sep 17 00:00:00 2001
From: Miao Xie <miaox@cn.fujitsu.com>
Date: Wed, 23 Mar 2011 16:01:16 +0800
Subject: [PATCH] btrfs: use GFP_NOFS instead of GFP_KERNEL

In the filesystem context, we must allocate memory by GFP_NOFS,
or we will start another filesystem operation and trigger lockdep warnning.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f1db57d..fe50cff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -471,7 +471,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	if (load_cache_only)
 		return 0;
 
-	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
+	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_NOFS);
 	BUG_ON(!caching_ctl);
 
 	INIT_LIST_HEAD(&caching_ctl->list);
-- 
1.7.3.1


--------------000205060903060406000301--
