Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:54412 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2IJDwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Sep 2012 23:52:38 -0400
Date: Sun, 9 Sep 2012 20:52:37 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Josef Bacik <jbacik@fusionio.com>
cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: move the sb_end_intwrite until after the throttle
 logic
In-Reply-To: <1346854110-26909-1-git-send-email-jbacik@fusionio.com>
Message-ID: <alpine.DEB.2.00.1209092051250.32347@cobra.newdream.net>
References: <1346854110-26909-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 5 Sep 2012, Josef Bacik wrote:
> Sage reported the following lockdep backtrace
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> 3.6.0-rc2-ceph-00171-gc7ed62d #1 Not tainted
> -------------------------------------
> btrfs-cleaner/7607 is trying to release lock (sb_internal) at:
> [<ffffffffa00422ae>] btrfs_commit_transaction+0xa6e/0xb20 [btrfs]
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 1 lock held by btrfs-cleaner/7607:
>  #0:  (&fs_info->cleaner_mutex){+.+...}, at: [<ffffffffa003b405>] cleaner_kthread+0x95/0x120 [btrfs]
> 
> stack backtrace:
> Pid: 7607, comm: btrfs-cleaner Not tainted 3.6.0-rc2-ceph-00171-gc7ed62d #1
> Call Trace:
>  [<ffffffffa00422ae>] ? btrfs_commit_transaction+0xa6e/0xb20 [btrfs]
>  [<ffffffff810afa9e>] print_unlock_inbalance_bug+0xfe/0x110
>  [<ffffffff810b289e>] lock_release_non_nested+0x1ee/0x310
>  [<ffffffff81172f9b>] ? kmem_cache_free+0x7b/0x160
>  [<ffffffffa004106c>] ? put_transaction+0x8c/0x130 [btrfs]
>  [<ffffffffa00422ae>] ? btrfs_commit_transaction+0xa6e/0xb20 [btrfs]
>  [<ffffffff810b2a95>] lock_release+0xd5/0x220
>  [<ffffffff81173071>] ? kmem_cache_free+0x151/0x160
>  [<ffffffff8117d9ed>] __sb_end_write+0x7d/0x90
>  [<ffffffffa00422ae>] btrfs_commit_transaction+0xa6e/0xb20 [btrfs]
>  [<ffffffff81079850>] ? __init_waitqueue_head+0x60/0x60
>  [<ffffffff81634c6b>] ? _raw_spin_unlock+0x2b/0x40
>  [<ffffffffa0042758>] __btrfs_end_transaction+0x368/0x3c0 [btrfs]
>  [<ffffffffa0042808>] btrfs_end_transaction_throttle+0x18/0x20 [btrfs]
>  [<ffffffffa00318f0>] btrfs_drop_snapshot+0x410/0x600 [btrfs]
>  [<ffffffff8132babd>] ? do_raw_spin_unlock+0x5d/0xb0
>  [<ffffffffa00430ef>] btrfs_clean_old_snapshots+0xaf/0x150 [btrfs]
>  [<ffffffffa003b405>] ? cleaner_kthread+0x95/0x120 [btrfs]
>  [<ffffffffa003b419>] cleaner_kthread+0xa9/0x120 [btrfs]
>  [<ffffffffa003b370>] ? btrfs_destroy_delayed_refs.isra.102+0x220/0x220 [btrfs]
>  [<ffffffff810791ee>] kthread+0xae/0xc0
>  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8163e744>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81635430>] ? retint_restore_args+0x13/0x13
>  [<ffffffff81079140>] ? flush_kthread_work+0x1a0/0x1a0
>  [<ffffffff8163e740>] ? gs_change+0x13/0x13
> 
> This is because the throttle stuff can commit the transaction, which expects to
> be the one stopping the intwrite stuff, but we've already done it in the
> __btrfs_end_transaction.  Moving the sb_end_intewrite after this logic makes the
> lockdep go away.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

This appears to have done the trick (at least so far).  I'm running it on 
top of -rc5 and the 3 patches I posted on Aug 30th.

Tested-by: Sage Weil <sage@inktank.com>

Thanks!
sage


> ---
>  fs/btrfs/transaction.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index a86fc72..0163afa 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -551,8 +551,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	btrfs_trans_release_metadata(trans, root);
>  	trans->block_rsv = NULL;
>  
> -	sb_end_intwrite(root->fs_info->sb);
> -
>  	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
>  	    should_end_transaction(trans, root)) {
>  		trans->transaction->blocked = 1;
> @@ -573,6 +571,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  		}
>  	}
>  
> +	sb_end_intwrite(root->fs_info->sb);
> +
>  	WARN_ON(cur_trans != info->running_transaction);
>  	WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
>  	atomic_dec(&cur_trans->num_writers);
> -- 
> 1.7.11.4
> 
> 
