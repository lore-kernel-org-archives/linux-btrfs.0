Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbdBHSm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 13:42:28 -0500
Date: Wed, 8 Feb 2017 19:40:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: create a helper to create em for IO
Message-ID: <20170208184017.GD16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807952-17604-1-git-send-email-bo.li.liu@oracle.com>
 <1485877822-28919-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485877822-28919-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 31, 2017 at 07:50:22AM -0800, Liu Bo wrote:
> We have similar codes to create and insert extent mapping around IO path,
> this merges them into a single helper.

Looks good, comments below.

> +static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
> +				       u64 orig_start, u64 block_start,
> +				       u64 block_len, u64 orig_block_len,
> +				       u64 ram_bytes, int compress_type,
> +				       int type);
>  
>  static int btrfs_dirty_inode(struct inode *inode);
>  
> @@ -690,7 +690,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
>  	struct btrfs_key ins;
>  	struct extent_map *em;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>  	struct extent_io_tree *io_tree;
>  	int ret = 0;
>  
> @@ -778,46 +777,19 @@ static noinline void submit_compressed_extents(struct inode *inode,
>  		 * here we're doing allocation and writeback of the
>  		 * compressed pages
>  		 */
> -		btrfs_drop_extent_cache(inode, async_extent->start,
> -					async_extent->start +
> -					async_extent->ram_size - 1, 0);
> -
> -		em = alloc_extent_map();
> -		if (!em) {
> -			ret = -ENOMEM;
> -			goto out_free_reserve;
> -		}
> -		em->start = async_extent->start;
> -		em->len = async_extent->ram_size;
> -		em->orig_start = em->start;
> -		em->mod_start = em->start;
> -		em->mod_len = em->len;
> -
> -		em->block_start = ins.objectid;
> -		em->block_len = ins.offset;
> -		em->orig_block_len = ins.offset;
> -		em->ram_bytes = async_extent->ram_size;
> -		em->bdev = fs_info->fs_devices->latest_bdev;
> -		em->compress_type = async_extent->compress_type;
> -		set_bit(EXTENT_FLAG_PINNED, &em->flags);
> -		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
> -		em->generation = -1;
> -
> -		while (1) {
> -			write_lock(&em_tree->lock);
> -			ret = add_extent_mapping(em_tree, em, 1);
> -			write_unlock(&em_tree->lock);
> -			if (ret != -EEXIST) {
> -				free_extent_map(em);
> -				break;
> -			}
> -			btrfs_drop_extent_cache(inode, async_extent->start,
> -						async_extent->start +
> -						async_extent->ram_size - 1, 0);
> -		}
> -
> -		if (ret)
> +		em = create_io_em(inode, async_extent->start,
> +				  async_extent->ram_size, /* len */
> +				  async_extent->start, /* orig_start */
> +				  ins.objectid, /* block_start */
> +				  ins.offset, /* block_len */
> +				  ins.offset, /* orig_block_len */
> +				  async_extent->ram_size, /* ram_bytes */
> +				  async_extent->compress_type,
> +				  BTRFS_ORDERED_COMPRESSED);
> +		if (IS_ERR(em))
> +			/* ret value is not necessary due to void function */
>  			goto out_free_reserve;
> +		free_extent_map(em);
>  
>  		ret = btrfs_add_ordered_extent_compress(inode,
>  						async_extent->start,
> @@ -952,7 +924,6 @@ static noinline int cow_file_range(struct inode *inode,
>  	u64 blocksize = fs_info->sectorsize;
>  	struct btrfs_key ins;
>  	struct extent_map *em;
> -	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>  	int ret = 0;
>  
>  	if (btrfs_is_free_space_inode(inode)) {
> @@ -1008,39 +979,18 @@ static noinline int cow_file_range(struct inode *inode,
>  		if (ret < 0)
>  			goto out_unlock;
>  
> -		em = alloc_extent_map();
> -		if (!em) {
> -			ret = -ENOMEM;
> -			goto out_reserve;
> -		}
> -		em->start = start;
> -		em->orig_start = em->start;
>  		ram_size = ins.offset;
> -		em->len = ins.offset;
> -		em->mod_start = em->start;
> -		em->mod_len = em->len;
> -
> -		em->block_start = ins.objectid;
> -		em->block_len = ins.offset;
> -		em->orig_block_len = ins.offset;
> -		em->ram_bytes = ram_size;
> -		em->bdev = fs_info->fs_devices->latest_bdev;
> -		set_bit(EXTENT_FLAG_PINNED, &em->flags);
> -		em->generation = -1;
> -
> -		while (1) {
> -			write_lock(&em_tree->lock);
> -			ret = add_extent_mapping(em_tree, em, 1);
> -			write_unlock(&em_tree->lock);
> -			if (ret != -EEXIST) {
> -				free_extent_map(em);
> -				break;
> -			}
> -			btrfs_drop_extent_cache(inode, start,
> -						start + ram_size - 1, 0);
> -		}
> -		if (ret)
> +		em = create_io_em(inode, start, ins.offset, /* len */
> +				  start, /* orig_start */
> +				  ins.objectid, /* block_start */
> +				  ins.offset, /* block_len */
> +				  ins.offset, /* orig_block_len */
> +				  ram_size, /* ram_bytes */
> +				  BTRFS_COMPRESS_NONE, /* compress_type */
> +				  0 /* type */);

Here the type is 0, as was previously a result of kmem_cache_zalloc, but
the value 0 also corresponds to BTRFS_ORDERED_IO_DONE. I suggest to add
another symbolic value that would represent the intentions here and not
reusing the existin value. A separate patch is fine, I'm adding this to
the queue.
