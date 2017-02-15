Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48328 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752201AbdBOVYd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:24:33 -0500
Date: Wed, 15 Feb 2017 13:23:37 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/29] btrfs: remove unused parameter from
 add_pending_csums
Message-ID: <20170215212337.GG19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <9ceb2cc30952a3af639e31c4f51c380f3ce0ffad.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9ceb2cc30952a3af639e31c4f51c380f3ce0ffad.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:10AM +0100, David Sterba wrote:
> Never used.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/inode.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7ed693294498..3ac7474f921d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1961,8 +1961,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
>   * at IO completion time based on sums calculated at bio submission time.
>   */
>  static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
> -			     struct inode *inode, u64 file_offset,
> -			     struct list_head *list)
> +			     struct inode *inode, struct list_head *list)
>  {
>  	struct btrfs_ordered_sum *sum;
>  
> @@ -2956,8 +2955,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>  		goto out_unlock;
>  	}
>  
> -	add_pending_csums(trans, inode, ordered_extent->file_offset,
> -			  &ordered_extent->list);
> +	add_pending_csums(trans, inode, &ordered_extent->list);
>  
>  	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
>  	ret = btrfs_update_inode_fallback(trans, root, inode);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
