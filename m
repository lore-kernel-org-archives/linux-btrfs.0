From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [PATCH] btrfs: btrfs_mark_extent_written writes correctly slot
Date: Thu, 11 Feb 2010 15:50:43 +0800
Message-ID: <4B73B6D3.4070901@oracle.com>
References: <20100211074300.GA7469@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100211074300.GA7469@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2010 03:43 PM, Shaohua Li wrote:
> My test do: fallocate a big file and do write. The file is 512M, but
> after file write is done btrfs-debug-tree shows:
> item 6 key (257 EXTENT_DATA 0) itemoff 3516 itemsize 53
>                 extent data disk byte 1103101952 nr 536870912
>                 extent data offset 0 nr 399634432 ram 536870912
>                 extent compression 0
> Looks like a regression introducted by
> 6c7d54ac87f338c479d9729e8392eca3f76e11e1, where we set wrong slot.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 9d08096..6ed434a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -720,13 +720,15 @@ again:
>  					inode->i_ino, orig_offset);
>  		BUG_ON(ret);
>  	}
> -	fi = btrfs_item_ptr(leaf, path->slots[0],
> -			   struct btrfs_file_extent_item);
>  	if (del_nr == 0) {
> +		fi = btrfs_item_ptr(leaf, path->slots[0],
> +			   struct btrfs_file_extent_item);
>  		btrfs_set_file_extent_type(leaf, fi,
>  					   BTRFS_FILE_EXTENT_REG);
>  		btrfs_mark_buffer_dirty(leaf);
>  	} else {
> +		fi = btrfs_item_ptr(leaf, del_slot - 1,
> +			   struct btrfs_file_extent_item);
>  		btrfs_set_file_extent_type(leaf, fi,
>  					   BTRFS_FILE_EXTENT_REG);
>  		btrfs_set_file_extent_num_bytes(leaf, fi,

Acked-by: Yan Zheng <zheng.yan@oracle.com>
