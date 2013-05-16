Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3EPGQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 02:16:16 -0400
Date: Thu, 16 May 2013 14:15:52 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com
Subject: Re: [PATCH 06/17] Btrfs: introduce grab/put functions for the root
 of the fs/file tree
Message-ID: <20130516061552.GI20202@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
 <1368604111-25073-7-git-send-email-miaox@cn.fujitsu.com>
 <20130516033645.GF20202@liubo.jp.oracle.com>
 <5194610F.1000603@cn.fujitsu.com>
 <20130516051556.GH20202@liubo.jp.oracle.com>
 <51946FD3.5000008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51946FD3.5000008@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 01:34:11PM +0800, Miao Xie wrote:
> On Thu, 16 May 2013 13:15:57 +0800, Liu Bo wrote:
> > On Thu, May 16, 2013 at 12:31:11PM +0800, Miao Xie wrote:
> >> On thu, 16 May 2013 11:36:46 +0800, Liu Bo wrote:
> >>> On Wed, May 15, 2013 at 03:48:20PM +0800, Miao Xie wrote:
> >>>> The grab/put funtions will be used in the next patch, which need grab
> >>>> the root object and ensure it is not freed. We use reference counter
> >>>> instead of the srcu lock is to aovid blocking the memory reclaim task,
> >>>> which invokes synchronize_srcu().
> >>>>
> >>>
> >>> I don't think this is necessary, we put 'kfree(root)' because we really
> >>> need to free them at the very end time, when there should be no inodes
> >>> linking on the root(we should have cleaned all inodes out from it).
> >>>
> >>> So when we flush delalloc inodes and wait for ordered extents to finish,
> >>> the root should be valid, otherwise someone is doing wrong things.
> >>>
> >>> And even with this grab_fs_root to avoid freeing root, it's just the
> >>> root that remains in memory, all its attributes, like root->node,
> >>> commit_root, root->inode_tree, are already NULL or empty.
> >>
> >> Please consider the case:
> >> 	Task1			Task2					Cleaner
> >> 	get the root
> >> 				flush all delalloc inodes
> >> 				drop subvolume
> >> 				iput the last inode
> >> 				  move the root into the dead list
> >> 									drop subvolume
> >> 									kfree(root)
> >> If Task1 accesses the root now, oops will happen.
> > 
> > Then it's task1's fault, why it is not protected by subvol_srcu section when
> > it's possible that someone like task2 sets root's refs to 0?
> > 
> > synchronize_srcu(subvol_srcu) before adding root into dead root list is
> > just for this race case, why do we need another?
> 
> Please read my changelog.

'The memory reclaim task' in the changelog refers to
	iput
	  -> inode_tree_del
, right?

I don't like special cases, this get/put is different from our usual way:
if (atomic_dec_and_test(refs)) {
	kfree(A->a);
	kfree(A->b);
	kfree(A);
}

According to the pictured case, task1 may also access root->something.

I must say that the patch itself looks harmless, the reason is not good enough.

thanks,
liubo

> 
> Miao
> 
> > 
> > thanks,
> > liubo
> > 
> >>
> >> I introduced there two functions just to protect the access of the root object, not its
> >> attributes, so don't worry about the attributes. (Please see the first sentence of the
> >> changelog.)
> >>
> >> Thanks
> >> Miao
> >>
> >>>
> >>> thanks,
> >>> liubo
> >>>
> >>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> >>>> ---
> >>>>  fs/btrfs/ctree.h       |  1 +
> >>>>  fs/btrfs/disk-io.c     |  5 +++--
> >>>>  fs/btrfs/disk-io.h     | 21 +++++++++++++++++++++
> >>>>  fs/btrfs/extent-tree.c |  2 +-
> >>>>  4 files changed, 26 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> >>>> index 845b77f..958ce6c 100644
> >>>> --- a/fs/btrfs/ctree.h
> >>>> +++ b/fs/btrfs/ctree.h
> >>>> @@ -1739,6 +1739,7 @@ struct btrfs_root {
> >>>>  	int force_cow;
> >>>>  
> >>>>  	spinlock_t root_item_lock;
> >>>> +	atomic_t refs;
> >>>>  };
> >>>>  
> >>>>  struct btrfs_ioctl_defrag_range_args {
> >>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>>> index 42d6ba2..642c861 100644
> >>>> --- a/fs/btrfs/disk-io.c
> >>>> +++ b/fs/btrfs/disk-io.c
> >>>> @@ -1216,6 +1216,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
> >>>>  	atomic_set(&root->log_writers, 0);
> >>>>  	atomic_set(&root->log_batch, 0);
> >>>>  	atomic_set(&root->orphan_inodes, 0);
> >>>> +	atomic_set(&root->refs, 1);
> >>>>  	root->log_transid = 0;
> >>>>  	root->last_log_commit = 0;
> >>>>  	extent_io_tree_init(&root->dirty_log_pages,
> >>>> @@ -2049,7 +2050,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
> >>>>  		} else {
> >>>>  			free_extent_buffer(gang[0]->node);
> >>>>  			free_extent_buffer(gang[0]->commit_root);
> >>>> -			kfree(gang[0]);
> >>>> +			btrfs_put_fs_root(gang[0]);
> >>>>  		}
> >>>>  	}
> >>>>  
> >>>> @@ -3415,7 +3416,7 @@ static void free_fs_root(struct btrfs_root *root)
> >>>>  	kfree(root->free_ino_ctl);
> >>>>  	kfree(root->free_ino_pinned);
> >>>>  	kfree(root->name);
> >>>> -	kfree(root);
> >>>> +	btrfs_put_fs_root(root);
> >>>>  }
> >>>>  
> >>>>  void btrfs_free_fs_root(struct btrfs_root *root)
> >>>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> >>>> index 534d583..b71acd6e 100644
> >>>> --- a/fs/btrfs/disk-io.h
> >>>> +++ b/fs/btrfs/disk-io.h
> >>>> @@ -76,6 +76,27 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
> >>>>  void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
> >>>>  				 struct btrfs_root *root);
> >>>>  void btrfs_free_fs_root(struct btrfs_root *root);
> >>>> +
> >>>> +/*
> >>>> + * This function is used to grab the root, and avoid it is freed when we
> >>>> + * access it. But it doesn't ensure that the tree is not dropped.
> >>>> + *
> >>>> + * If you want to ensure the whole tree is safe, you should use
> >>>> + * 	fs_info->subvol_srcu
> >>>> + */
> >>>> +static inline struct btrfs_root *btrfs_grab_fs_root(struct btrfs_root *root)
> >>>> +{
> >>>> +	if (atomic_inc_not_zero(&root->refs))
> >>>> +		return root;
> >>>> +	return NULL;
> >>>> +}
> >>>> +
> >>>> +static inline void btrfs_put_fs_root(struct btrfs_root *root)
> >>>> +{
> >>>> +	if (atomic_dec_and_test(&root->refs))
> >>>> +		kfree(root);
> >>>> +}
> >>>> +
> >>>>  void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
> >>>>  int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
> >>>>  			  int atomic);
> >>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>>> index 08e42c8..08f9862 100644
> >>>> --- a/fs/btrfs/extent-tree.c
> >>>> +++ b/fs/btrfs/extent-tree.c
> >>>> @@ -7463,7 +7463,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
> >>>>  	} else {
> >>>>  		free_extent_buffer(root->node);
> >>>>  		free_extent_buffer(root->commit_root);
> >>>> -		kfree(root);
> >>>> +		btrfs_put_fs_root(root);
> >>>>  	}
> >>>>  out_end_trans:
> >>>>  	btrfs_end_transaction_throttle(trans, tree_root);
> >>>> -- 
> >>>> 1.8.1.4
> >>>>
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> > 
> 
