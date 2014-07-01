Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaGACeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 22:34:05 -0400
Date: Tue, 1 Jul 2014 10:33:52 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix race of using total_bytes_pinned
Message-ID: <20140701023351.GA10619@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1404125167-3185-1-git-send-email-bo.li.liu@oracle.com>
 <53B217CA.5010804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B217CA.5010804@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 10:07:06AM +0800, Miao Xie wrote:
> On Mon, 30 Jun 2014 18:46:07 +0800, Liu Bo wrote:
> > This percpu counter @total_bytes_pinned is introduced to skip unnecessary
> > operations of 'commit transaction', it accounts for those space we may free
> > but are stuck in delayed refs.
> > 
> > And we zero out @space_info->total_bytes_pinned every transaction period so
> > we have a better idea of how much space we'll actually free up by committing
> > this transaction.  However, we do the 'zero out' part a little earlier, before
> > we actually unpin space, so we end up returning ENOSPC when we actually have
> > free space that's just unpinned from committing transaction.
> > 
> > xfstests/generic/074 complained then.
> > 
> > This fixes it by zeroing out the percpu pinned number after 'unpin' and when
> > finding space for writing, if it finds that pinned bytes is less than needed,
> > we first try again to check if we have space now, as someone may have
> > committed transaction, yes means we're good, while no means we really have
> > run out of space.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > v2: add missing brakets of if statement.
> > 
> >  fs/btrfs/extent-tree.c | 22 ++++++++++++++--------
> >  1 file changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 99c2539..57793da 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -3685,7 +3685,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> >  	struct btrfs_fs_info *fs_info = root->fs_info;
> >  	u64 used;
> > -	int ret = 0, committed = 0, alloc_chunk = 1;
> > +	int ret = 0, committed = 0, alloc_chunk = 1, check_pinned = 0;
> >  
> >  	/* make sure bytes are sectorsize aligned */
> >  	bytes = ALIGN(bytes, root->sectorsize);
> > @@ -3756,11 +3756,18 @@ alloc:
> >  		 * allocation don't bother committing the transaction.
> >  		 */
> >  		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
> > -					   bytes) < 0)
> > -			committed = 1;
> > +					   bytes) < 0) {
> > +			if (check_pinned) {
> > +				committed = 1;	/* really run out of space. */
> > +			} else {
> > +				check_pinned = 1;
> > +				spin_unlock(&data_sinfo->lock);
> > +				goto again;
> > +			}
> > +		}
> >  		spin_unlock(&data_sinfo->lock);
> >  
> > -		/* commit the current transaction and try again */
> > +	/* commit the current transaction and try again */
> >  commit_trans:
> >  		if (!committed &&
> >  		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
> > @@ -5678,7 +5685,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
> >  	struct btrfs_caching_control *next;
> >  	struct btrfs_caching_control *caching_ctl;
> >  	struct btrfs_block_group_cache *cache;
> > -	struct btrfs_space_info *space_info;
> >  
> >  	down_write(&fs_info->commit_root_sem);
> >  
> > @@ -5701,9 +5707,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
> >  
> >  	up_write(&fs_info->commit_root_sem);
> >  
> > -	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
> > -		percpu_counter_set(&space_info->total_bytes_pinned, 0);
> > -
> >  	update_global_block_rsv(fs_info);
> >  }
> >  
> > @@ -5771,6 +5774,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
> >  {
> >  	struct btrfs_fs_info *fs_info = root->fs_info;
> >  	struct extent_io_tree *unpin;
> > +	struct btrfs_space_info *space_info;
> >  	u64 start;
> >  	u64 end;
> >  	int ret;
> > @@ -5798,6 +5802,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
> >  		cond_resched();
> >  	}
> >  
> > +	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
> > +		percpu_counter_set(&space_info->total_bytes_pinned, 0);
> 
> This function is called after the transaction is unblocked, that is the new transaction can
> be started and some new pinned extents have been accounted into this counter, so we can not
> set to 0 directly.

Make sense, thanks for reviewing it.

> 
> There are several way to avoid the above problem, one is account the pinned space we free
> in btrfs_finish_extent_commit then subtract from the counter. The other is introduce a new counter,
> and we use those two counter alternately just like freed_extents variant in btrfs_fs_info structure.

I'd like to take the first one.

thanks,
-liubo

> 
> Thanks
> Miao
> 
> >  	return 0;
> >  }
> >  
> > 
> 
