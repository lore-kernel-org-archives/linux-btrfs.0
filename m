Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40790 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbcCAXwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 18:52:45 -0500
Date: Tue, 1 Mar 2016 15:55:05 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] Btrfs: fix fsync xattr loss in the fast fsync path
Message-ID: <20160301235505.GC27735@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1434541789-27941-1-git-send-email-fdmanana@kernel.org>
 <1434757491-28325-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434757491-28325-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 20, 2015 at 12:44:51AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After commit 4f764e515361 ("Btrfs: remove deleted xattrs on fsync log
> replay"), we can end up in a situation where during log replay we end up
> deleting xattrs that were never deleted when their file was last fsynced.
> 
> This happens in the fast fsync path (flag BTRFS_INODE_NEEDS_FULL_SYNC is
> not set in the inode) if the inode has the flag BTRFS_INODE_COPY_EVERYTHING
> set, the xattr was added in a past transaction and the leaf where the
> xattr is located was not updated (COWed or created) in the current
> transaction. In this scenario the xattr item never ends up in the log
> tree and therefore at log replay time, which makes the replay code delete
> the xattr from the fs/subvol tree as it thinks that xattr was deleted
> prior to the last fsync.
> 
> Fix this by always logging all xattrs, which is the simplest and most
> reliable way to detect deleted xattrs and replay the deletes at log replay
> time.
> 
> This issue is reproducible with the following test case for fstests:
[...]

This is a good candidate for stable, isn't it?

Thanks,

-liubo

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Updated reproducer test, no code changes.
>     The first version of the test actually only failed if my other
>     unrelated patch titled "Btrfs: fix fsync data loss after append write"
>     was applied. That's because it forced logging the inode item which
>     is necessary to trigger the xattr deletion replay code. So updated
>     the test such that it fails without that patch applied too.
> 
> V3: Changed to a simpler approach which doesn't require a new key type,
>     as the previous solution would make an older kernel not do the
>     xattr deletion replay for log trees created by a more recent kernel
>     with this patch.
> 
>  fs/btrfs/tree-log.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 104 insertions(+)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 4920fce..7ac45cf 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4123,6 +4123,86 @@ static int logged_inode_size(struct btrfs_root *log, struct inode *inode,
>  	return 0;
>  }
>  
> +/*
> + * At the moment we always log all xattrs. This is to figure out at log replay
> + * time which xattrs must have their deletion replayed. If a xattr is missing
> + * in the log tree and exists in the fs/subvol tree, we delete it. This is
> + * because if a xattr is deleted, the inode is fsynced and a power failure
> + * happens, causing the log to be replayed the next time the fs is mounted,
> + * we want the xattr to not exist anymore (same behaviour as other filesystems
> + * with a journal, ext3/4, xfs, f2fs, etc).
> + */
> +static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
> +				struct btrfs_root *root,
> +				struct inode *inode,
> +				struct btrfs_path *path,
> +				struct btrfs_path *dst_path)
> +{
> +	int ret;
> +	struct btrfs_key key;
> +	const u64 ino = btrfs_ino(inode);
> +	int ins_nr = 0;
> +	int start_slot = 0;
> +
> +	key.objectid = ino;
> +	key.type = BTRFS_XATTR_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	while (true) {
> +		int slot = path->slots[0];
> +		struct extent_buffer *leaf = path->nodes[0];
> +		int nritems = btrfs_header_nritems(leaf);
> +
> +		if (slot >= nritems) {
> +			if (ins_nr > 0) {
> +				u64 last_extent = 0;
> +
> +				ret = copy_items(trans, inode, dst_path, path,
> +						 &last_extent, start_slot,
> +						 ins_nr, 1, 0);
> +				/* can't be 1, extent items aren't processed */
> +				ASSERT(ret <= 0);
> +				if (ret < 0)
> +					return ret;
> +				ins_nr = 0;
> +			}
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				return ret;
> +			else if (ret > 0)
> +				break;
> +			continue;
> +		}
> +
> +		btrfs_item_key_to_cpu(leaf, &key, slot);
> +		if (key.objectid != ino || key.type != BTRFS_XATTR_ITEM_KEY)
> +			break;
> +
> +		if (ins_nr == 0)
> +			start_slot = slot;
> +		ins_nr++;
> +		path->slots[0]++;
> +		cond_resched();
> +	}
> +	if (ins_nr > 0) {
> +		u64 last_extent = 0;
> +
> +		ret = copy_items(trans, inode, dst_path, path,
> +				 &last_extent, start_slot,
> +				 ins_nr, 1, 0);
> +		/* can't be 1, extent items aren't processed */
> +		ASSERT(ret <= 0);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /* log a single inode in the tree log.
>   * At least one parent directory for this inode must exist in the tree
>   * or be logged already.
> @@ -4295,6 +4375,25 @@ again:
>  		if (min_key.type == BTRFS_INODE_ITEM_KEY)
>  			need_log_inode_item = false;
>  
> +		/* Skip xattrs, we log them later with btrfs_log_all_xattrs() */
> +		if (min_key.type == BTRFS_XATTR_ITEM_KEY) {
> +			if (ins_nr == 0)
> +				goto next_slot;
> +			ret = copy_items(trans, inode, dst_path, path,
> +					 &last_extent, ins_start_slot,
> +					 ins_nr, inode_only, logged_isize);
> +			if (ret < 0) {
> +				err = ret;
> +				goto out_unlock;
> +			}
> +			ins_nr = 0;
> +			if (ret) {
> +				btrfs_release_path(path);
> +				continue;
> +			}
> +			goto next_slot;
> +		}
> +
>  		src = path->nodes[0];
>  		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
>  			ins_nr++;
> @@ -4362,6 +4461,11 @@ next_slot:
>  		ins_nr = 0;
>  	}
>  
> +	btrfs_release_path(path);
> +	btrfs_release_path(dst_path);
> +	err = btrfs_log_all_xattrs(trans, root, inode, path, dst_path);
> +	if (err)
> +		goto out_unlock;
>  log_extents:
>  	btrfs_release_path(path);
>  	btrfs_release_path(dst_path);
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
