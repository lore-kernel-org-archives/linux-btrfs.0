Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36968 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdESAAC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:00:02 -0400
Date: Thu, 18 May 2017 16:58:19 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: fix race with relocation recovery and fs_root
 setup
Message-ID: <20170518235819.GD23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495035516-3217-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 11:38:34AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If we have to recover relocation during mount, we'll ultimately have to
> evict the orphan inode.  That goes through the reservation dance, where
> priority_reclaim_metadata_space and flush_space expect fs_info->fs_root
> to be valid.  That's the next thing to be set up during mount, so we
> crash, almost always in flush_space trying to join the transaction
> but priority_reclaim_metadata_space is possible as well.  This call
> path has been problematic in the past WRT whether ->fs_root is valid
> yet.  Commit 957780eb278 (Btrfs: introduce ticketed enospc
> infrastructure) added new users that are called in the direct path
> instead of the async path that had already been worked around.
> 
> The thing is that we don't actually need the fs_root, specifically, for
> anything.  We either use it to determine whether the root is the
> chunk_root for use in choosing an allocation profile or as a root to pass
> btrfs_join_transaction before immediately committing it.  Anything that
> isn't the chunk root works in the former case and any root works in
> the latter.
> 
> A simple fix is to use a root we know will always be there: the
> extent_root.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Cc: <stable@vger.kernel.org> # v4.8+
> Fixes: 957780eb278 (Btrfs: introduce ticketed enospc infrastructure)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index be54776..9894c4e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4834,7 +4834,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	spin_unlock(&delayed_rsv->lock);
>  
>  commit:
> -	trans = btrfs_join_transaction(fs_info->fs_root);
> +	trans = btrfs_join_transaction(fs_info->extent_root);
>  	if (IS_ERR(trans))
>  		return -ENOSPC;
>  
> @@ -4852,7 +4852,7 @@ static int flush_space(struct btrfs_fs_info *fs_info,
>  		       struct btrfs_space_info *space_info, u64 num_bytes,
>  		       u64 orig_bytes, int state)
>  {
> -	struct btrfs_root *root = fs_info->fs_root;
> +	struct btrfs_root *root = fs_info->extent_root;
>  	struct btrfs_trans_handle *trans;
>  	int nr;
>  	int ret = 0;
> @@ -5052,7 +5052,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
>  	int flush_state = FLUSH_DELAYED_ITEMS_NR;
>  
>  	spin_lock(&space_info->lock);
> -	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->fs_root,
> +	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info->extent_root,
>  						      space_info);
>  	if (!to_reclaim) {
>  		spin_unlock(&space_info->lock);
> -- 
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
