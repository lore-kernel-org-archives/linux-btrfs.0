Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42944 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932392AbeFFI3l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 04:29:41 -0400
Subject: Re: [PATCH v2 3/6] btrfs-progs: check/original: Detect and repair
 wrong inline ram_bytes
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180606072717.28854-4-wqu@suse.com>
 <20180606082607.9885-1-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <19ff0eb6-1e28-0d19-edf8-08491b496af2@cn.fujitsu.com>
Date: Wed, 6 Jun 2018 16:35:41 +0800
MIME-Version: 1.0
In-Reply-To: <20180606082607.9885-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/06/2018 04:26 PM, Qu Wenruo wrote:
> It looks like that around 2014, btrfs kernel has a regression that would
> cause offset-by-one ram_bytes for inline extent.
> 
> Add the ability to repair it in original mode.
> 
> Reported-by: Steve Leung <sjleung@shaw.ca>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
> changelog:
> v2:
>   Add extra output for print_inode_error().
>   Reword the repair output message.
>   Clear the error bitmap if repaired.
> ---
>  check/main.c          | 47 +++++++++++++++++++++++++++++++++++++++++--
>  check/mode-original.h |  1 +
>  2 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 52ef181add61..c739c094cef3 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -578,6 +578,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
>  		fprintf(stderr, ", orphan file extent");
>  	if (errors & I_ERR_ODD_INODE_FLAGS)
>  		fprintf(stderr, ", odd inode flags");
> +	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
> +		fprintf(stderr, ", invalid inline ram bytes");
>  	fprintf(stderr, "\n");
>  	/* Print the orphan extents if needed */
>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
> @@ -1483,6 +1485,9 @@ static int process_file_extent(struct btrfs_root *root,
>  		} else {
>  			if (num_bytes > max_inline_size)
>  				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
> +			if (btrfs_file_extent_inline_item_len(eb, item) !=
> +			    num_bytes)
> +				rec->errors |= I_ERR_INLINE_RAM_BYTES_WRONG;
>  		}
>  		rec->found_size += num_bytes;
>  		num_bytes = (num_bytes + mask) & ~mask;
> @@ -2534,6 +2539,41 @@ out:
>  	return ret;
>  }
>  
> +static int repair_inline_ram_bytes(struct btrfs_trans_handle *trans,
> +				   struct btrfs_root *root,
> +				   struct btrfs_path *path,
> +				   struct inode_record *rec)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_item *i;
> +	u64 on_disk_item_len;
> +	int ret;
> +
> +	key.objectid = rec->ino;
> +	key.offset = 0;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +
> +	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
> +	if (ret > 0)
> +		ret = -ENOENT;
> +	if (ret < 0)
> +		goto out;
> +
> +	i = btrfs_item_nr(path->slots[0]);
> +	on_disk_item_len = btrfs_file_extent_inline_item_len(path->nodes[0], i);
> +	fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			    struct btrfs_file_extent_item);
> +	btrfs_set_file_extent_ram_bytes(path->nodes[0], fi, on_disk_item_len);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +	printf("Repaired inline ram_bytes for root %llu ino %llu\n",
> +		root->objectid, rec->ino);
> +	rec->errors &= ~I_ERR_INLINE_RAM_BYTES_WRONG;
> +out:
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
>  static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  {
>  	struct btrfs_trans_handle *trans;
> @@ -2545,8 +2585,9 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  			     I_ERR_LINK_COUNT_WRONG |
>  			     I_ERR_NO_INODE_ITEM |
>  			     I_ERR_FILE_EXTENT_ORPHAN |
> -			     I_ERR_FILE_EXTENT_DISCOUNT|
> -			     I_ERR_FILE_NBYTES_WRONG)))
> +			     I_ERR_FILE_EXTENT_DISCOUNT |
> +			     I_ERR_FILE_NBYTES_WRONG |
> +			     I_ERR_INLINE_RAM_BYTES_WRONG)))
>  		return rec->errors;
>  
>  	/*
> @@ -2575,6 +2616,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  		ret = repair_inode_nlinks(trans, root, &path, rec);
>  	if (!ret && rec->errors & I_ERR_FILE_NBYTES_WRONG)
>  		ret = repair_inode_nbytes(trans, root, &path, rec);
> +	if (!ret && rec->errors & I_ERR_INLINE_RAM_BYTES_WRONG)
> +		ret = repair_inline_ram_bytes(trans, root, &path, rec);
>  	btrfs_commit_transaction(trans, root);
>  	btrfs_release_path(&path);
>  	return ret;
> diff --git a/check/mode-original.h b/check/mode-original.h
> index 13cfa5b9e1b3..ec2842e0b3be 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -187,6 +187,7 @@ struct file_extent_hole {
>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>  #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
> +#define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
>  
>  struct inode_record {
>  	struct list_head backrefs;
> 


