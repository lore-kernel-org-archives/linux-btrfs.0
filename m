Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41039 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756705AbbGGJi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 05:38:56 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com> <581e0ffa1ce1dd6345519e7953bf4e895bda35ae.1428554023.git.zhaolei@cn.fujitsu.com> <20150707081352.GA1967@localhost.localdomain> <017501d0b895$9b9b52b0$d2d1f810$@cn.fujitsu.com> <20150707092640.GB1967@localhost.localdomain>
In-Reply-To: <20150707092640.GB1967@localhost.localdomain>
Subject: RE: [PATCH 6/9] btrfs: Fix NO_SPACE bug caused by delayed-iput
Date: Tue, 7 Jul 2015 17:38:51 +0800
Message-ID: <017901d0b898$bc083a60$3418af20$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Liubo

> -----Original Message-----
> From: Liu Bo [mailto:bo.li.liu@oracle.com]
> Sent: Tuesday, July 07, 2015 5:27 PM
> To: Zhao Lei
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 6/9] btrfs: Fix NO_SPACE bug caused by delayed-iput
> 
> On Tue, Jul 07, 2015 at 05:16:29PM +0800, Zhao Lei wrote:
> > Hi, Liubo
> >
> > > -----Original Message-----
> > > From: Liu Bo [mailto:bo.li.liu@oracle.com]
> > > Sent: Tuesday, July 07, 2015 4:14 PM
> > > To: Zhaolei
> > > Cc: linux-btrfs@vger.kernel.org
> > > Subject: Re: [PATCH 6/9] btrfs: Fix NO_SPACE bug caused by
> > > delayed-iput
> > >
> > > Hi,
> > >
> > > On Thu, Apr 09, 2015 at 12:34:41PM +0800, Zhaolei wrote:
> > > > From: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > >
> > > > Steps to reproduce:
> > > >   while true; do
> > > >     dd if=/dev/zero of=/btrfs_dir/file count=[fs_size * 75%]
> > > >     rm /btrfs_dir/file
> > > >     sync
> > > >   done
> > > >
> > > >   And we'll see dd failed because btrfs return NO_SPACE.
> > > >
> > > > Reason:
> > > >   Normally, btrfs_commit_transaction() call btrfs_run_delayed_iputs()
> > > >   in end to free fs space for next write, but sometimes it hadn't
> > > >   done work on time, because btrfs-cleaner thread get delayed-iputs
> > > >   from list before, but do iput() after next write.
> > > >
> > > >   This is log:
> > > >   [ 2569.050776] comm=btrfs-cleaner func=btrfs_evict_inode() begin
> > > >
> > > >   [ 2569.084280] comm=sync func=btrfs_commit_transaction() call
> > > btrfs_run_delayed_iputs()
> > > >   [ 2569.085418] comm=sync func=btrfs_commit_transaction() done
> > > btrfs_run_delayed_iputs()
> > > >   [ 2569.087554] comm=sync func=btrfs_commit_transaction() end
> > > >
> > > >   [ 2569.191081] comm=dd begin
> > > >   [ 2569.790112] comm=dd func=__btrfs_buffered_write() ret=-28
> > > >
> > > >   [ 2569.847479] comm=btrfs-cleaner func=add_pinned_bytes() 0 +
> > > 32677888 = 32677888
> > > >   [ 2569.849530] comm=btrfs-cleaner func=add_pinned_bytes()
> > > > 32677888 +
> > > 23834624 = 56512512
> > > >   ...
> > > >   [ 2569.903893] comm=btrfs-cleaner func=add_pinned_bytes()
> > > > 943976448
> > > + 21762048 = 965738496
> > > >   [ 2569.908270] comm=btrfs-cleaner func=btrfs_evict_inode() end
> > > >
> > > > Fix:
> > > >   Make btrfs_commit_transaction() wait current running btrfs-cleaner's
> > > >   delayed-iputs() done in end.
> > > >
> > > > Test:
> > > >   Use script similar to above(more complex),
> > > >   before patch:
> > > >     7 failed in 100 * 20 loop.
> > > >   after patch:
> > > >     0 failed in 100 * 20 loop.
> > > >
> > > > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > > > ---
> > > >  fs/btrfs/ctree.h       | 1 +
> > > >  fs/btrfs/disk-io.c     | 3 ++-
> > > >  fs/btrfs/extent-tree.c | 6 ++++++
> > > >  fs/btrfs/inode.c       | 4 ++++
> > > >  4 files changed, 13 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h index
> > > > f9c89ca..54d4d78 100644
> > > > --- a/fs/btrfs/ctree.h
> > > > +++ b/fs/btrfs/ctree.h
> > > > @@ -1513,6 +1513,7 @@ struct btrfs_fs_info {
> > > >
> > > >  	spinlock_t delayed_iput_lock;
> > > >  	struct list_head delayed_iputs;
> > > > +	struct rw_semaphore delayed_iput_sem;
> > > >
> > > >  	/* this protects tree_mod_seq_list */
> > > >  	spinlock_t tree_mod_seq_lock;
> > > > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c index
> > > > 639f266..6867471 100644
> > > > --- a/fs/btrfs/disk-io.c
> > > > +++ b/fs/btrfs/disk-io.c
> > > > @@ -2241,11 +2241,12 @@ int open_ctree(struct super_block *sb,
> > > >  	spin_lock_init(&fs_info->qgroup_op_lock);
> > > >  	spin_lock_init(&fs_info->buffer_lock);
> > > >  	spin_lock_init(&fs_info->unused_bgs_lock);
> > > > -	mutex_init(&fs_info->unused_bg_unpin_mutex);
> > > >  	rwlock_init(&fs_info->tree_mod_log_lock);
> > > > +	mutex_init(&fs_info->unused_bg_unpin_mutex);
> > > >  	mutex_init(&fs_info->reloc_mutex);
> > > >  	mutex_init(&fs_info->delalloc_root_mutex);
> > > >  	seqlock_init(&fs_info->profiles_lock);
> > > > +	init_rwsem(&fs_info->delayed_iput_sem);
> > > >
> > > >  	init_completion(&fs_info->kobj_unregister);
> > > >  	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
> > > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c index
> > > > 203ac63..6fd7dca 100644
> > > > --- a/fs/btrfs/extent-tree.c
> > > > +++ b/fs/btrfs/extent-tree.c
> > > > @@ -3732,6 +3732,12 @@ commit_trans:
> > > >  				ret = btrfs_commit_transaction(trans, root);
> > > >  				if (ret)
> > > >  					return ret;
> > > > +				/*
> > > > +				 * make sure that all running delayed iput are
> > > > +				 * done
> > > > +				 */
> > > > +				down_write(&root->fs_info->delayed_iput_sem);
> > > > +				up_write(&root->fs_info->delayed_iput_sem);
> > > >  				goto again;
> > > >  			} else {
> > > >  				btrfs_end_transaction(trans, root); diff --git
> > > a/fs/btrfs/inode.c
> > > > b/fs/btrfs/inode.c index d2e732d..34d10be 100644
> > > > --- a/fs/btrfs/inode.c
> > > > +++ b/fs/btrfs/inode.c
> > > > @@ -3110,6 +3110,8 @@ void btrfs_run_delayed_iputs(struct
> > > > btrfs_root
> > > *root)
> > > >  	if (empty)
> > > >  		return;
> > > >
> > > > +	down_read(&fs_info->delayed_iput_sem);
> > > > +
> > > >  	spin_lock(&fs_info->delayed_iput_lock);
> > > >  	list_splice_init(&fs_info->delayed_iputs, &list);
> > > >  	spin_unlock(&fs_info->delayed_iput_lock);
> > > > @@ -3120,6 +3122,8 @@ void btrfs_run_delayed_iputs(struct
> > > > btrfs_root
> > > *root)
> > > >  		iput(delayed->inode);
> > > >  		kfree(delayed);
> > > >  	}
> > > > +
> > > > +	up_read(&root->fs_info->delayed_iput_sem);
> > >
> > > By introducing this "delayed_iput_sem", fstests's generic/241 cries
> > > about a possible deadlock, can we use a waitqueue to avoid this?
> > >
> > >
> > > [ 2061.345955] =============================================
> > > [ 2061.346027] [ INFO: possible recursive locking detected ]
> > > [ 2061.346027] 4.1.0+ #268 Tainted: G        W
> > > [ 2061.346027] ---------------------------------------------
> > > [ 2061.346027] btrfs-cleaner/3045 is trying to acquire lock:
> > > [ 2061.346027]  (&fs_info->delayed_iput_sem){++++..}, at:
> > > [<ffffffff814063ab>] btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027] but task is already holding lock:
> > > [ 2061.346027]  (&fs_info->delayed_iput_sem){++++..}, at:
> > > [<ffffffff814063ab>]
> > > btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027] other info that might help us debug this:
> > > [ 2061.346027]  Possible unsafe locking scenario:
> > >
> > > [ 2061.346027]        CPU0
> > > [ 2061.346027]        ----
> > > [ 2061.346027]   lock(&fs_info->delayed_iput_sem);
> > > [ 2061.346027]   lock(&fs_info->delayed_iput_sem);
> > > [ 2061.346027]
> > >  *** DEADLOCK ***
> > >
> > > [ 2061.346027]  May be due to missing lock nesting notation
> > >
> > > [ 2061.346027] 2 locks held by btrfs-cleaner/3045:
> > > [ 2061.346027]  #0:  (&fs_info->cleaner_mutex){+.+.+.}, at:
> > > [<ffffffff813f6cc4>] cleaner_kthread+0x64/0x1a0 [ 2061.346027]  #1:
> > > (&fs_info->delayed_iput_sem){++++..}, at: [<ffffffff814063ab>]
> > > btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027] stack backtrace:
> > > [ 2061.346027] CPU: 0 PID: 3045 Comm: btrfs-cleaner Tainted: G
> W
> > > 4.1.0+ #268
> > > [ 2061.346027] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > > 1996), BIOS
> > > 1.7.5-20140709_153950- 04/01/2014 [ 2061.346027]  ffff88013760a700
> > > ffff8800b4aff888 ffffffff818bb68e 0000000000000007 [ 2061.346027]
> > > ffffffff828fa0a0 ffff8800b4aff968 ffffffff810db18d ffff8800b4aff978
> > > [ 2061.346027]  ffffffff00000000 ffff88013760a750 ffffffff00000001
> > > ffff88013760b470 [ 2061.346027] Call Trace:
> > > [ 2061.346027]  [<ffffffff818bb68e>] dump_stack+0x4c/0x65 [
> > > 2061.346027] [<ffffffff810db18d>] __lock_acquire+0x214d/0x22f0 [
> > > 2061.346027] [<ffffffff810d5e3d>] ? trace_hardirqs_off+0xd/0x10 [
> > > 2061.346027] [<ffffffff810d649d>] ? __lock_is_held+0x4d/0x70 [
> > > 2061.346027] [<ffffffff810dc050>] lock_acquire+0xd0/0x280 [
> > > 2061.346027] [<ffffffff814063ab>] ?
> > > btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027]  [<ffffffff818c275c>] down_read+0x4c/0x70 [
> > > 2061.346027] [<ffffffff814063ab>] ?
> > > btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027]  [<ffffffff818c48cb>] ? _raw_spin_unlock+0x2b/0x40 [
> > > 2061.346027]  [<ffffffff814063ab>]
> > > btrfs_run_delayed_iputs+0x6b/0x100
> > > [ 2061.346027]  [<ffffffff8140042f>] ?
> > > btrfs_commit_transaction+0xa1f/0xc50
> > > [ 2061.346027]  [<ffffffff81400454>]
> > > btrfs_commit_transaction+0xa44/0xc50
> > > [ 2061.346027]  [<ffffffff810cdbd0>] ? wait_woken+0xa0/0xa0 [
> > > 2061.346027] [<ffffffff813e5247>] flush_space+0x97/0x4b0 [
> > > 2061.346027] [<ffffffff818c48cb>] ? _raw_spin_unlock+0x2b/0x40 [
> > > 2061.346027] [<ffffffff813e5a3b>] ?
> > > reserve_metadata_bytes+0x20b/0x6d0
> > > [ 2061.346027]  [<ffffffff813e5a52>]
> > > reserve_metadata_bytes+0x222/0x6d0
> > > [ 2061.346027]  [<ffffffff813e6245>] ?
> > > btrfs_block_rsv_refill+0x65/0x90 [ 2061.346027]
> > > [<ffffffff813e6257>] btrfs_block_rsv_refill+0x77/0x90 [ 2061.346027]
> > > [<ffffffff8140c723>] btrfs_evict_inode+0x473/0x700 [ 2061.346027]
> > > [<ffffffff8123dcbb>] evict+0xab/0x170 [ 2061.346027]
> > > [<ffffffff8123e6fd>] iput+0x1cd/0x350 [ 2061.346027]
> > > [<ffffffff81406409>]
> > > btrfs_run_delayed_iputs+0xc9/0x100
> > > [ 2061.346027]  [<ffffffff813f6cc4>] ? cleaner_kthread+0x64/0x1a0 [
> > > 2061.346027]  [<ffffffff813f6dba>] cleaner_kthread+0x15a/0x1a0 [
> > > 2061.346027]  [<ffffffff813f6c60>] ? btree_invalidatepage+0x90/0x90
> > > [ 2061.346027]  [<ffffffff810a3d5f>] kthread+0xef/0x110 [
> > > 2061.346027] [<ffffffff810a3c70>] ?
> > > kthread_create_on_node+0x210/0x210
> > > [ 2061.346027]  [<ffffffff818c550f>] ret_from_fork+0x3f/0x70 [
> > > 2061.346027] [<ffffffff810a3c70>] ?
> > > kthread_create_on_node+0x210/0x210
> > >
> > Thanks for report above problem.
> > Seems it is caused by recursion of btrfs_run_delayed_iputs:
> >
> >   cleaner_kthread
> >   -> btrfs_run_delayed_iputs() *1
> >   -> get delayed_iput_sem lock *2
> >   -> iput()
> >   -> ...
> >   -> btrfs_commit_transaction()
> >   -> btrfs_run_delayed_iputs() *1
> >   -> get delayed_iput_sem lock (dead lock) *2
> >
> >   *1: recursion of btrfs_run_delayed_iputs()
> >   *2: dead lock of delayed_iput_sem
> 
> Yep, that's what stack trace shows, but I guess it hardly runs to deadlock, since
> we've checked if the list is empty before acquiring the semephore.
> 
Or some reason, which cause " fs_info->delayed_iputs not empty" in second call.
(only guess)

> >
> > I'll reproduce this problem in my env, and comfirm fix of above
> > problem.
> 
> It didn't occur every time, but quite often on my box.
> 
Got it.
So, 1000 times test.

Thanks
Zhaolei

> Thanks,
> 
> -liubo
> >
> > Thanks
> > Zhaolei
> >
> >
> > >
> > > Thanks,
> > >
> > > -liubo
> > > >  }
> > > >
> > > >  /*
> > > > --
> > > > 1.8.5.1
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > > > in the body of a message to majordomo@vger.kernel.org More
> > > > majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

