Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:35158 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2HXWr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 18:47:56 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id A767080079
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 15:47:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 8228580079
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 15:47:56 -0700 (PDT)
Date: Fri, 24 Aug 2012 15:47:56 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: pass lockdep rwsem metadata to async commit
 transaction
In-Reply-To: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net>
Message-ID: <alpine.DEB.2.00.1208241545040.26910@cobra.newdream.net>
References: <alpine.DEB.2.00.1208241439490.26910@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sadly, now I hit another one:

[  378.433842] =============================================
[  378.433842] [ INFO: possible recursive locking detected ]
[  378.433845] 3.6.0-rc2-ceph-00143-g995fc06 #1 Not tainted
[  378.433845] ---------------------------------------------
[  378.433847] kworker/6:1/238 is trying to acquire lock:
[  378.433872]  (sb_internal#2){.+.+..}, at: [<ffffffffa0042b74>] start_transaction+0x124/0x430 [btrfs]
[  378.433873] 
[  378.433873] but task is already holding lock:
[  378.433890]  (sb_internal#2){.+.+..}, at: [<ffffffffa0042590>] do_async_commit+0x0/0x80 [btrfs]
[  378.433891] 
[  378.433891] other info that might help us debug this:
[  378.433892]  Possible unsafe locking scenario:
[  378.433892] 
[  378.433892]        CPU0
[  378.433893]        ----
[  378.433895]   lock(sb_internal#2);
[  378.433897]   lock(sb_internal#2);
[  378.433898] 
[  378.433898]  *** DEADLOCK ***
[  378.433898] 
[  378.433898]  May be due to missing lock nesting notation
[  378.433898] 
[  378.433899] 3 locks held by kworker/6:1/238:
[  378.433906]  #0:  (events){.+.+.+}, at: [<ffffffff810717d6>] process_one_work+0x136/0x5f0
[  378.433911]  #1:  ((&(&ac->work)->work)){+.+...}, at: [<ffffffff810717d6>] process_one_work+0x136/0x5f0
[  378.433929]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa0042590>] do_async_commit+0x0/0x80 [btrfs]
[  378.433932] 
[  378.433932] stack backtrace:
[  378.433935] Pid: 238, comm: kworker/6:1 Not tainted 3.6.0-rc2-ceph-00143-g995fc06 #1
[  378.433936] Call Trace:
[  378.433941]  [<ffffffff810b2032>] __lock_acquire+0x1512/0x1b90
[  378.433944]  [<ffffffff810ada73>] ? __bfs+0x23/0x270
[  378.433961]  [<ffffffffa0042b74>] ? start_transaction+0x124/0x430 [btrfs]
[  378.433964]  [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[  378.433980]  [<ffffffffa0042b74>] ? start_transaction+0x124/0x430 [btrfs]
[  378.433982]  [<ffffffff810b3546>] ? mark_held_locks+0x86/0x140
[  378.433987]  [<ffffffff8117dac6>] __sb_start_write+0xc6/0x1b0
[  378.434003]  [<ffffffffa0042b74>] ? start_transaction+0x124/0x430 [btrfs]
[  378.434019]  [<ffffffffa0042b74>] ? start_transaction+0x124/0x430 [btrfs]
[  378.434022]  [<ffffffff81172e75>] ? kmem_cache_alloc+0xb5/0x160
[  378.434024]  [<ffffffff81172f9b>] ? kmem_cache_free+0x7b/0x160
[  378.434042]  [<ffffffffa0058b48>] ? free_extent_state+0x58/0xd0 [btrfs]
[  378.434058]  [<ffffffffa0042b74>] start_transaction+0x124/0x430 [btrfs]
[  378.434076]  [<ffffffffa005940d>] ? __set_extent_bit+0x37d/0x4e0 [btrfs]
[  378.434092]  [<ffffffffa0042ed5>] btrfs_join_transaction+0x15/0x20 [btrfs]
[  378.434109]  [<ffffffffa00496b7>] cow_file_range+0x87/0x4a0 [btrfs]
[  378.434114]  [<ffffffff81634c6b>] ? _raw_spin_unlock+0x2b/0x40
[  378.434131]  [<ffffffffa004a80c>] run_delalloc_range+0x34c/0x370 [btrfs]
[  378.434149]  [<ffffffffa005cbb0>] __extent_writepage+0x5e0/0x770 [btrfs]
[  378.434152]  [<ffffffff810b3546>] ? mark_held_locks+0x86/0x140
[  378.434155]  [<ffffffff8112aa5e>] ? find_get_pages_tag+0x2e/0x1c0
[  378.434174]  [<ffffffffa005cffa>] extent_write_cache_pages.isra.25.constprop.39+0x2ba/0x410 [btrfs]
[  378.434187]  [<ffffffffa002f7cc>] ? btrfs_run_delayed_refs+0xac/0x550 [btrfs]
[  378.434190]  [<ffffffff81196117>] ? igrab+0x27/0x70
[  378.434208]  [<ffffffffa005d389>] extent_writepages+0x49/0x60 [btrfs]
[  378.434224]  [<ffffffffa0046a90>] ? btrfs_submit_direct+0x670/0x670 [btrfs]
[  378.434240]  [<ffffffffa00444c8>] btrfs_writepages+0x28/0x30 [btrfs]
[  378.434243]  [<ffffffff81136443>] do_writepages+0x23/0x40
[  378.434247]  [<ffffffff8112b839>] __filemap_fdatawrite_range+0x59/0x60
[  378.434249]  [<ffffffff8112c6ac>] filemap_flush+0x1c/0x20
[  378.434266]  [<ffffffffa0050b1e>] btrfs_start_delalloc_inodes+0xbe/0x200 [btrfs]
[  378.434270]  [<ffffffff8132babd>] ? do_raw_spin_unlock+0x5d/0xb0
[  378.434286]  [<ffffffffa0041ebd>] btrfs_commit_transaction+0x44d/0xb20 [btrfs]
[  378.434290]  [<ffffffff81079850>] ? __init_waitqueue_head+0x60/0x60
[  378.434293]  [<ffffffff810717d6>] ? process_one_work+0x136/0x5f0
[  378.434308]  [<ffffffffa00425f1>] do_async_commit+0x61/0x80 [btrfs]
[  378.434324]  [<ffffffffa0042590>] ? btrfs_commit_transaction+0xb20/0xb20 [btrfs]
[  378.434327]  [<ffffffff81071840>] process_one_work+0x1a0/0x5f0
[  378.434330]  [<ffffffff810717d6>] ? process_one_work+0x136/0x5f0
[  378.434346]  [<ffffffffa0042590>] ? btrfs_commit_transaction+0xb20/0xb20 [btrfs]
[  378.434350]  [<ffffffff8107360d>] worker_thread+0x18d/0x4c0
[  378.434354]  [<ffffffff81073480>] ? manage_workers.isra.22+0x2c0/0x2c0
[  378.434356]  [<ffffffff810791ee>] kthread+0xae/0xc0
[  378.434359]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
[  378.434363]  [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10
[  378.434366]  [<ffffffff81635430>] ? retint_restore_args+0x13/0x13
[  378.434368]  [<ffffffff81079140>] ? flush_kthread_work+0x1a0/0x1a0
[  378.434371]  [<ffffffff8163e740>] ? gs_change+0x13/0x13


On Fri, 24 Aug 2012, Sage Weil wrote:

> The freeze rwsem is taken by sb_start_intwrite() and dropped during the
> commit_ or end_transaction().  In the async case, that happens in a worker
> thread.  Tell lockdep the calling thread is releasing ownership of the
> rwsem and the async thread is picking it up.
> 
> Josef and I worked out a more complicated solution that made the async 
> commit thread join and potentially get a later transaction, but it failed 
> my initial smoke test and Dave pointed out that XFS avoids the issue by 
> just telling lockdep what's up.  This is much simpler.  XFS does the same
> thing in fs/xfs/xfs_aops.c.
> 
> Signed-off-by: Sage Weil <sage@inktank.com>
> ---
>  fs/btrfs/transaction.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 17be3de..efc41a5 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1228,6 +1228,14 @@ static void do_async_commit(struct work_struct *work)
>  	struct btrfs_async_commit *ac =
>  		container_of(work, struct btrfs_async_commit, work.work);
>  
> +	/*
> +	 * We've got freeze protection passed with the transaction.
> +	 * Tell lockdep about it.
> +	 */
> +	rwsem_acquire_read(
> +		&ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
> +		0, 1, _THIS_IP_);
> +
>  	btrfs_commit_transaction(ac->newtrans, ac->root);
>  	kfree(ac);
>  }
> @@ -1257,6 +1265,14 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
>  	atomic_inc(&cur_trans->use_count);
>  
>  	btrfs_end_transaction(trans, root);
> +
> +	/*
> +	 * Tell lockdep we've released the freeze rwsem, since the
> +	 * async commit thread will be the one to unlock it.
> +	 */
> +	rwsem_release(&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
> +		      1, _THIS_IP_);
> +
>  	schedule_delayed_work(&ac->work, 0);
>  
>  	/* wait for transaction to start and unblock */
> -- 
> 1.7.9
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
