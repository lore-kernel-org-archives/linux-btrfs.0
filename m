Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50647 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752735AbeFKEt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 00:49:58 -0400
Subject: Re: [PATCH 05/15] btrfs-progs: Make update_block_group take fs_info
 instead of root
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-6-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6c33d29c-a1ae-c275-acf1-358004feb68a@gmx.com>
Date: Mon, 11 Jun 2018 12:49:45 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> This is in preparation of delayed refs code.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  extent-tree.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index 07b5fb99e8cf..6e7a19323efc 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1912,12 +1912,10 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> -static int update_block_group(struct btrfs_root *root,
> -			      u64 bytenr, u64 num_bytes, int alloc,
> -			      int mark_free)
> +static int update_block_group(struct btrfs_fs_info *info, u64 bytenr,
> +			      u64 num_bytes, int alloc, int mark_free)
>  {
>  	struct btrfs_block_group_cache *cache;
> -	struct btrfs_fs_info *info = root->fs_info;
>  	u64 total = num_bytes;
>  	u64 old_val;
>  	u64 byte_in_group;
> @@ -2368,7 +2366,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>  			BUG_ON(ret);
>  		}
>  
> -		update_block_group(root, bytenr, num_bytes, 0, mark_free);
> +		update_block_group(trans->fs_info, bytenr, num_bytes, 0,
> +				   mark_free);
>  	}
>  fail:
>  	btrfs_free_path(path);
> @@ -2730,7 +2729,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>  	btrfs_mark_buffer_dirty(leaf);
>  	btrfs_free_path(path);
>  
> -	ret = update_block_group(root, ins->objectid, fs_info->nodesize,
> +	ret = update_block_group(fs_info, ins->objectid, fs_info->nodesize,
>  				 1, 0);
>  	return ret;
>  }
> @@ -3413,7 +3412,7 @@ int btrfs_update_block_group(struct btrfs_root *root,
>  			     u64 bytenr, u64 num_bytes, int alloc,
>  			     int mark_free)
>  {
> -	return update_block_group(root, bytenr, num_bytes,
> +	return update_block_group(root->fs_info, bytenr, num_bytes,
>  				  alloc, mark_free);
>  }
>  
> 
