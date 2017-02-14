Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19528 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdBNAu2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 19:50:28 -0500
Date: Mon, 13 Feb 2017 16:49:28 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: relocation: Enhance kernel error output for
 relocation
Message-ID: <20170214004928.GA771@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170213072627.18778-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170213072627.18778-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 03:26:27PM +0800, Qu Wenruo wrote:
> When balance(relocation) fails, btrfs-progs will report like:
> 
> ERROR: error during balancing '/mnt/scratch': Input/output error
> There may be more info in syslog - try dmesg | tail
> 
> However in some case, for example debugging btrfs/125 with small file
> size, kernel only have some recoverable csum error message and nothing
> useful at all.
> 
> This patch will add error messages in relocation to help both end user to
> wipe out some obvious problems, like ENOSPC.
> And for developers, they can locate the problem to specific function just
> by kernel message.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/relocation.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 379711048fb0..c9474377a59c 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4011,6 +4011,8 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  					rc->block_rsv, rc->block_rsv->size,
>  					BTRFS_RESERVE_FLUSH_ALL);
>  		if (ret) {
> +			btrfs_err(fs_info, "failed to reserve space: %d(%s)",
> +				  ret, btrfs_decode_error(ret));
>  			err = ret;
>  			break;
>  		}
> @@ -4019,6 +4021,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  		if (IS_ERR(trans)) {
>  			err = PTR_ERR(trans);
>  			trans = NULL;
> +			btrfs_err(fs_info,
> +				  "failed to start transaction: %d(%s)",
> +				  err, btrfs_decode_error(err));
>  			break;
>  		}
>  restart:
> @@ -4028,8 +4033,11 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  		}
>  
>  		ret = find_next_extent(rc, path, &key);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			btrfs_err(fs_info, "failed to find next extent: %d(%s)",
> +				  ret, btrfs_decode_error(ret));
>  			err = ret;
> +		}
>  		if (ret != 0)
>  			break;
>  
> @@ -4081,9 +4089,17 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  
>  		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>  			ret = add_tree_block(rc, &key, path, &blocks);
> +			if (ret < 0)
> +				btrfs_err(fs_info,
> +					  "failed to record tree block: %d(%s)",
> +					  ret, btrfs_decode_error(ret));
>  		} else if (rc->stage == UPDATE_DATA_PTRS &&
>  			   (flags & BTRFS_EXTENT_FLAG_DATA)) {
>  			ret = add_data_references(rc, &key, path, &blocks);
> +			if (ret < 0)
> +				btrfs_err(fs_info,
> +					  "failed to record data extent: %d(%s)",
> +					  ret, btrfs_decode_error(ret));
>  		} else {
>  			btrfs_release_path(path);
>  			ret = 0;
> @@ -4103,6 +4119,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  				rc->backref_cache.last_trans = trans->transid - 1;
>  
>  				if (ret != -EAGAIN) {
> +					btrfs_err(fs_info,
> +					"faild to relocate tree blocks: %d(%s)",
> +						  ret, btrfs_decode_error(ret));
>  					err = ret;
>  					break;
>  				}
> @@ -4121,6 +4140,9 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  			ret = relocate_data_extent(rc->data_inode,
>  						   &key, &rc->cluster);
>  			if (ret < 0) {
> +				btrfs_err(fs_info,
> +				"failed to relocate data extent: %d(%s)",
> +					  ret, btrfs_decode_error(ret));
>  				err = ret;
>  				break;
>  			}
> @@ -4147,8 +4169,12 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  	if (!err) {
>  		ret = relocate_file_extent_cluster(rc->data_inode,
>  						   &rc->cluster);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			btrfs_err(fs_info,
> +			"failed to relocate file extent cluster: %d(%s)",
> +				  ret, btrfs_decode_error(ret));
>  			err = ret;
> +		}
>  	}
>  
>  	rc->create_reloc_tree = 0;
> @@ -4158,6 +4184,10 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>  	btrfs_block_rsv_release(fs_info, rc->block_rsv, (u64)-1);
>  
>  	err = prepare_to_merge(rc, err);
> +	if (err < 0)
> +		btrfs_err(fs_info,
> +			  "failed to preapre merge relocate trees: %d(%s)",
> +			  ret, btrfs_decode_error(ret));

s/ret/err

Please fix the same typo in the rest parts.

Thanks,

-liubo
>  
>  	merge_reloc_roots(rc);
>  
> @@ -4336,6 +4366,9 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  
>  	ret = btrfs_inc_block_group_ro(extent_root, rc->block_group);
>  	if (ret) {
> +		btrfs_err(fs_info,
> +			"failed to set block group read-only: %d(%s)",
> +			  err, btrfs_decode_error(err));
>  		err = ret;
>  		goto out;
>  	}
> @@ -4351,10 +4384,19 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  					path);
>  	btrfs_free_path(path);
>  
> -	if (!IS_ERR(inode))
> +	if (!IS_ERR(inode)) {
>  		ret = delete_block_group_cache(fs_info, rc->block_group, inode, 0);
> -	else
> +		if (ret < 0)
> +			btrfs_err(fs_info,
> +				"failed to delete block group cache: %d(%s)",
> +				  err, btrfs_decode_error(err));
> +	} else {
>  		ret = PTR_ERR(inode);
> +		if (ret < 0 && ret != -ENOENT)
> +			btrfs_err(fs_info,
> +				"failed to lookup free space inode: %d(%s)",
> +				  err, btrfs_decode_error(err));
> +	}
>  
>  	if (ret && ret != -ENOENT) {
>  		err = ret;
> @@ -4364,6 +4406,8 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  	rc->data_inode = create_reloc_inode(fs_info, rc->block_group);
>  	if (IS_ERR(rc->data_inode)) {
>  		err = PTR_ERR(rc->data_inode);
> +		btrfs_err(fs_info, "failed to create relocate inode: %d(%s)",
> +			  err, btrfs_decode_error(err));
>  		rc->data_inode = NULL;
>  		goto out;
>  	}
> @@ -4394,6 +4438,9 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  			ret = btrfs_wait_ordered_range(rc->data_inode, 0,
>  						       (u64)-1);
>  			if (ret) {
> +				btrfs_err(fs_info,
> +					"failed to wait ordered range: %d(%s)",
> +					  ret, btrfs_decode_error(ret));
>  				err = ret;
>  				goto out;
>  			}
> @@ -4407,6 +4454,11 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
>  	WARN_ON(rc->block_group->reserved > 0);
>  	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
>  out:
> +	if (err < 0)
> +		btrfs_err(fs_info,
> +			  "failed to relocate block group %llu: %d(%s)",
> +			  rc->block_group->key.objectid, ret,
> +			  btrfs_decode_error(ret));
>  	if (err && rw)
>  		btrfs_dec_block_group_ro(rc->block_group);
>  	iput(rc->data_inode);
> -- 
> 2.11.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
