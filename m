Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993413AbbEEPer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 11:34:47 -0400
Date: Tue, 5 May 2015 17:34:44 +0200
From: David Sterba <dsterba@suse.cz>
To: xuw2015@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: introduce BTRFS_BLOCK_SIZE to replace number
 4096
Message-ID: <20150505153444.GI5099@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430384845-9666-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

General comment: everywhere the superblock "4096" is used, the right
replacement is BTRFS_SUPER_INFO_SIZE

On Thu, Apr 30, 2015 at 05:07:23PM +0800, xuw2015@gmail.com wrote:
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2548,8 +2548,8 @@ int open_ctree(struct super_block *sb,
>  	btrfs_init_balance(fs_info);
>  	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
>  
> -	sb->s_blocksize = 4096;
> -	sb->s_blocksize_bits = blksize_bits(4096);
> +	sb->s_blocksize = BTRFS_BLOCK_SIZE;
> +	sb->s_blocksize_bits = blksize_bits(BTRFS_BLOCK_SIZE);
>  	sb->s_bdi = &fs_info->bdi;
>  
>  	btrfs_init_btree_inode(fs_info, tree_root);
> @@ -3144,7 +3144,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>  		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
>  					i_size_read(bdev->bd_inode))
>  			break;
> -		bh = __bread(bdev, bytenr / 4096,
> +		bh = __bread(bdev, bytenr / BTRFS_BLOCK_SIZE,

That one is really BTRFS_SUPER_INFO_SIZE

>  					BTRFS_SUPER_INFO_SIZE);
>  		if (!bh)
>  			continue;
> @@ -3199,7 +3199,7 @@ static int write_dev_supers(struct btrfs_device *device,
>  			break;
>  
>  		if (wait) {
> -			bh = __find_get_block(device->bdev, bytenr / 4096,
> +			bh = __find_get_block(device->bdev, bytenr / BTRFS_BLOCK_SIZE,

same here

>  					      BTRFS_SUPER_INFO_SIZE);
>  			if (!bh) {
>  				errors++;
> @@ -3229,7 +3229,7 @@ static int write_dev_supers(struct btrfs_device *device,
>  			 * one reference for us, and we leave it for the
>  			 * caller
>  			 */
> -			bh = __getblk(device->bdev, bytenr / 4096,
> +			bh = __getblk(device->bdev, bytenr / BTRFS_BLOCK_SIZE,

same here

>  				      BTRFS_SUPER_INFO_SIZE);
>  			if (!bh) {
>  				printk(KERN_ERR "BTRFS: couldn't get super "
> @@ -3904,13 +3904,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
>  	 * items yet, they'll be verified later. Issue just a warning.
>  	 */
> -	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_root(sb), BTRFS_BLOCK_SIZE))
>  		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
>  				btrfs_super_root(sb));
> -	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), BTRFS_BLOCK_SIZE))
>  		printk(KERN_WARNING "BTRFS: chunk_root block unaligned: %llu\n",
>  				btrfs_super_chunk_root(sb));
> -	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_log_root(sb), BTRFS_BLOCK_SIZE))
>  		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
>  				btrfs_super_log_root(sb));

Throughout btrfs_check_super_valid 4096 is used as a minimum block size
and the macro should be more descriptive.

>  
> @@ -3918,14 +3918,14 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	 * Check the lower bound, the alignment and other constraints are
>  	 * checked later.
>  	 */
> -	if (btrfs_super_nodesize(sb) < 4096) {
> -		printk(KERN_ERR "BTRFS: nodesize too small: %u < 4096\n",
> -				btrfs_super_nodesize(sb));
> +	if (btrfs_super_nodesize(sb) < BTRFS_BLOCK_SIZE) {
> +		printk(KERN_ERR "BTRFS: nodesize too small: %u < %d\n",
> +				btrfs_super_nodesize(sb), BTRFS_BLOCK_SIZE);
>  		ret = -EINVAL;
>  	}
> -	if (btrfs_super_sectorsize(sb) < 4096) {
> -		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 4096\n",
> -				btrfs_super_sectorsize(sb));
> +	if (btrfs_super_sectorsize(sb) < BTRFS_BLOCK_SIZE) {
> +		printk(KERN_ERR "BTRFS: sectorsize too small: %u < %d\n",
> +				btrfs_super_sectorsize(sb), BTRFS_BLOCK_SIZE);
>  		ret = -EINVAL;
>  	}
>  
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index d4cbfee..4d246ff 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -19,8 +19,9 @@
>  #ifndef __DISKIO__
>  #define __DISKIO__
>  
> +#define BTRFS_BLOCK_SIZE 4096
>  #define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
> -#define BTRFS_SUPER_INFO_SIZE 4096
> +#define BTRFS_SUPER_INFO_SIZE BTRFS_BLOCK_SIZE

This should stay 4096, super info size is defined as 4096, block size
can vary according to page size.

IOW, I don't see the point to introduce BTRFS_BLOCK_SIZE, it should be
something like BTRFS_MIN_BLOCK_SIZE and used in the validation
functions.
