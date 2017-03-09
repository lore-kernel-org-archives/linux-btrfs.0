Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:33838 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932497AbdCIRhd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2017 12:37:33 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v29HbNvf003859
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 9 Mar 2017 17:37:23 GMT
Date: Thu, 9 Mar 2017 09:35:44 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@kernel.org
Subject: Re: [PATCH v7 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
Message-ID: <20170309173544.GB28780@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170308022552.14686-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170308022552.14686-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 10:25:51AM +0800, Qu Wenruo wrote:
> [BUG]
> When btrfs_reloc_clone_csum() reports error, it can underflow metadata
> and leads to kernel assertion on outstanding extents in
> run_delalloc_nocow() and cow_file_range().
> 
>  BTRFS info (device vdb5): relocating block group 12582912 flags data
>  BTRFS info (device vdb5): found 1 extents
>  assertion failed: inode->outstanding_extents >= num_extents, file: fs/btrfs//extent-tree.c, line: 5858
> 
> Currently, due to another bug blocking ordered extents, the bug is only
> reproducible under certain block group layout and using error injection.
> 
> a) Create one data block group with one 4K extent in it.
>    To avoid the bug that hangs btrfs due to ordered extent which never
>    finishes
> b) Make btrfs_reloc_clone_csum() always fail
> c) Relocate that block group
> 
> [CAUSE]
> run_delalloc_nocow() and cow_file_range() handles error from
> btrfs_reloc_clone_csum() wrongly:
> 
> (The ascii chart shows a more generic case of this bug other than the
> bug mentioned above)
> 
> |<------------------ delalloc range --------------------------->|
> | OE 1 | OE 2 | ... | OE n |
>                     |<----------- cleanup range --------------->|
> |<-----------  ----------->|
>              \/
>  btrfs_finish_ordered_io() range
> 
> So error handler, which calls extent_clear_unlock_delalloc() with
> EXTENT_DELALLOC and EXTENT_DO_ACCOUNT bits, and btrfs_finish_ordered_io()
> will both cover OE n, and free its metadata, causing metadata under flow.
> 
> [Fix]
> The fix is to ensure after calling btrfs_add_ordered_extent(), we only
> call error handler after increasing the iteration offset, so that
> cleanup range won't cover any created ordered extent.
> 
> |<------------------ delalloc range --------------------------->|
> | OE 1 | OE 2 | ... | OE n |
> |<-----------  ----------->|<---------- cleanup range --------->|
>              \/
>  btrfs_finish_ordered_io() range

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v6:
>   New, split from v5 patch, as this is a separate bug.
> v7:
>   Fix a wrong operator pointed out by Liu Bo.
>   Test case will follow soon.
> ---
>  fs/btrfs/inode.c | 51 +++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c40060cc481f..fe588bf30d02 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -998,15 +998,24 @@ static noinline int cow_file_range(struct inode *inode,
>  		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
>  			ret = btrfs_reloc_clone_csums(inode, start,
>  						      cur_alloc_size);
> +			/*
> +			 * Only drop cache here, and process as normal.
> +			 *
> +			 * We must not allow extent_clear_unlock_delalloc()
> +			 * at out_unlock label to free meta of this ordered
> +			 * extent, as its meta should be freed by
> +			 * btrfs_finish_ordered_io().
> +			 *
> +			 * So we must continue until @start is increased to
> +			 * skip current ordered extent.
> +			 */
>  			if (ret)
> -				goto out_drop_extent_cache;
> +				btrfs_drop_extent_cache(BTRFS_I(inode), start,
> +						start + ram_size - 1, 0);
>  		}
>  
>  		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>  
> -		if (disk_num_bytes < cur_alloc_size)
> -			break;
> -
>  		/* we're not doing compressed IO, don't unlock the first
>  		 * page (which the caller expects to stay locked), don't
>  		 * clear any dirty bits and don't set any writeback bits
> @@ -1022,10 +1031,21 @@ static noinline int cow_file_range(struct inode *inode,
>  					     delalloc_end, locked_page,
>  					     EXTENT_LOCKED | EXTENT_DELALLOC,
>  					     op);
> -		disk_num_bytes -= cur_alloc_size;
> +		if (disk_num_bytes < cur_alloc_size)
> +			disk_num_bytes = 0;
> +		else
> +			disk_num_bytes -= cur_alloc_size;
>  		num_bytes -= cur_alloc_size;
>  		alloc_hint = ins.objectid + ins.offset;
>  		start += cur_alloc_size;
> +
> +		/*
> +		 * btrfs_reloc_clone_csums() error, since start is increased
> +		 * extent_clear_unlock_delalloc() at out_unlock label won't
> +		 * free metadata of current ordered extent, we're OK to exit.
> +		 */
> +		if (ret)
> +			goto out_unlock;
>  	}
>  out:
>  	return ret;
> @@ -1414,15 +1434,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  		BUG_ON(ret); /* -ENOMEM */
>  
>  		if (root->root_key.objectid ==
> -		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
> +		    BTRFS_DATA_RELOC_TREE_OBJECTID)
> +			/*
> +			 * Error handled later, as we must prevent
> +			 * extent_clear_unlock_delalloc() in error handler
> +			 * from freeing metadata of created ordered extent.
> +			 */
>  			ret = btrfs_reloc_clone_csums(inode, cur_offset,
>  						      num_bytes);
> -			if (ret) {
> -				if (!nolock && nocow)
> -					btrfs_end_write_no_snapshoting(root);
> -				goto error;
> -			}
> -		}
>  
>  		extent_clear_unlock_delalloc(inode, cur_offset,
>  					     cur_offset + num_bytes - 1, end,
> @@ -1434,6 +1453,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>  		if (!nolock && nocow)
>  			btrfs_end_write_no_snapshoting(root);
>  		cur_offset = extent_end;
> +
> +		/*
> +		 * btrfs_reloc_clone_csums() error, now we're OK to call error
> +		 * handler, as metadata for created ordered extent will only
> +		 * be freed by btrfs_finish_ordered_io().
> +		 */
> +		if (ret)
> +			goto error;
>  		if (cur_offset > end)
>  			break;
>  	}
> -- 
> 2.12.0
> 
> 
> 
