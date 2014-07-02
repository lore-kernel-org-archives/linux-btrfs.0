Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46051 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751748AbaGBC03 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 22:26:29 -0400
Message-ID: <53B36E41.4030601@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 10:28:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix race of using total_bytes_pinned
References: <1404206926-7953-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1404206926-7953-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 1 Jul 2014 17:28:46 +0800, Liu Bo wrote:
> This percpu counter @total_bytes_pinned is introduced to skip unnecessary
> operations of 'commit transaction', it accounts for those space we may free
> but are stuck in delayed refs.
> 
> And we zero out @space_info->total_bytes_pinned every transaction period so
> we have a better idea of how much space we'll actually free up by committing
> this transaction.  However, we do the 'zero out' part a little earlier, before
> we actually unpin space, so we end up returning ENOSPC when we actually have
> free space that's just unpinned from committing transaction.
> 
> xfstests/generic/074 complained then.
> 
> This fixes it by actually accounting the percpu pinned number when 'unpin',
> and when finding space for writing, if it finds that pinned bytes is less
> than needed, we first try again to check if we have space now, as someone
> may have committed transaction, yes means we're good, while no means we
> really have run out of space.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v3: Really account the percpu pinned number when unpin, instead of zeroing
>     it out, as we set transaction with UNBLOCKED before 'unpin', zeroing it
>     out may end up with messing percpu pinned number(suggested by Miao).
> v2: Add missing brakets for if statement
> 
>  fs/btrfs/extent-tree.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 99c2539..f36fb13 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3685,7 +3685,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	u64 used;
> -	int ret = 0, committed = 0, alloc_chunk = 1;
> +	int ret = 0, committed = 0, alloc_chunk = 1, check_pinned = 0;
>  
>  	/* make sure bytes are sectorsize aligned */
>  	bytes = ALIGN(bytes, root->sectorsize);
> @@ -3756,11 +3756,18 @@ alloc:
>  		 * allocation don't bother committing the transaction.
>  		 */
>  		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
> -					   bytes) < 0)
> -			committed = 1;
> +					   bytes) < 0) {
> +			if (check_pinned) {
> +				committed = 1;	/* really run out of space. */
> +			} else {
> +				check_pinned = 1;
> +				spin_unlock(&data_sinfo->lock);
> +				goto again;
> +			}
> +		}

Is there anything wrong in the original code? I think we needn't change the code here
because we are not sure anyone would commit the transaction, and though someone is
committing the transaction, the process is slow, we still need commit the transaction
by ourselves mostly(In fact, this commit is just to wait the transaction to complete)
(The above analysis has not been confirmed)

Thanks
Miao

>  		spin_unlock(&data_sinfo->lock);
>  
> -		/* commit the current transaction and try again */
> +	/* commit the current transaction and try again */
>  commit_trans:
>  		if (!committed &&
>  		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
> @@ -5678,7 +5685,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
>  	struct btrfs_caching_control *next;
>  	struct btrfs_caching_control *caching_ctl;
>  	struct btrfs_block_group_cache *cache;
> -	struct btrfs_space_info *space_info;
>  
>  	down_write(&fs_info->commit_root_sem);
>  
> @@ -5701,9 +5707,6 @@ void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
>  
>  	up_write(&fs_info->commit_root_sem);
>  
> -	list_for_each_entry_rcu(space_info, &fs_info->space_info, list)
> -		percpu_counter_set(&space_info->total_bytes_pinned, 0);
> -
>  	update_global_block_rsv(fs_info);
>  }
>  
> @@ -5741,6 +5744,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
>  		spin_lock(&cache->lock);
>  		cache->pinned -= len;
>  		space_info->bytes_pinned -= len;
> +		percpu_counter_add(&space_info->total_bytes_pinned, -len);
>  		if (cache->ro) {
>  			space_info->bytes_readonly += len;
>  			readonly = true;
> 

