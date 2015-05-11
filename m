Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbbEKJKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 05:10:10 -0400
Date: Mon, 11 May 2015 11:10:07 +0200
From: David Sterba <dsterba@suse.cz>
To: xuw2015@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2] btrfs: replace the 4096 magic number for block size
Message-ID: <20150511091007.GJ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431326095-25176-1-git-send-email-xuw2015@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431326095-25176-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 02:34:55PM +0800, xuw2015@gmail.com wrote:
> From: George Wang <xuw2015@gmail.com>
> 
> There are a lot of 4096 magic number in disk-io.c and volumes.c. Most of them
> are used for block size of the bdev. By the block_size(bdev) and macor
> BTRFS_MIN_BLOCK_SIZE, it can be more descriptive.

There must be some misunderstanding. Not all the 4096 constants refer to
the same thing (and for that reason a symbolic name is better).

> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2548,8 +2548,8 @@ int open_ctree(struct super_block *sb,
>  	btrfs_init_balance(fs_info);
>  	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
>  
> -	sb->s_blocksize = 4096;
> -	sb->s_blocksize_bits = blksize_bits(4096);
> +	sb->s_blocksize = BTRFS_MIN_BLOCK_SIZE;
> +	sb->s_blocksize_bits = blksize_bits(BTRFS_MIN_BLOCK_SIZE);

At this point in open_ctree, we're reading the superblock. Superblock
has a fixed size, defined as BTRFS_SUPER_INFO_SIZE.

s_blocksize is not used outside of the filesystem, and AFAICS unused
until we read the superblock via btrfs_read_dev_super. So at this point
it looks redundant.

>  	sb->s_bdi = &fs_info->bdi;
>  
>  	btrfs_init_btree_inode(fs_info, tree_root);
> @@ -3140,11 +3140,12 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>  	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>  	 */
>  	for (i = 0; i < 1; i++) {
> +		unsigned int blksz = block_size(bdev);
>  		bytenr = btrfs_sb_offset(i);
>  		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
>  					i_size_read(bdev->bd_inode))
>  			break;
> -		bh = __bread(bdev, bytenr / 4096,
> +		bh = __bread(bdev, bytenr / blksz,

I think I wrote this in the first review comments, all 4096 in
btrfs_read_dev_super mean BTRFS_SUPER_INFO_SIZE. The block size is
hardcoded and not dependent on the block device.

>  					BTRFS_SUPER_INFO_SIZE);
>  		if (!bh)
>  			continue;
> @@ -3193,13 +3194,14 @@ static int write_dev_supers(struct btrfs_device *device,
> -			bh = __find_get_block(device->bdev, bytenr / 4096,
> +			bh = __find_get_block(device->bdev, bytenr / blksz,
> @@ -3229,7 +3231,7 @@ static int write_dev_supers(struct btrfs_device *device,
> -			bh = __getblk(device->bdev, bytenr / 4096,
> +			bh = __getblk(device->bdev, bytenr / blksz,

Same here.

> @@ -3904,13 +3906,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
>  	 * items yet, they'll be verified later. Issue just a warning.
>  	 */
> -	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_root(sb), BTRFS_MIN_BLOCK_SIZE))

> -	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), BTRFS_MIN_BLOCK_SIZE))

> -	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
> +	if (!IS_ALIGNED(btrfs_super_log_root(sb), BTRFS_MIN_BLOCK_SIZE))

> @@ -3918,14 +3920,14 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> -	if (btrfs_super_nodesize(sb) < 4096) {
> -		printk(KERN_ERR "BTRFS: nodesize too small: %u < 4096\n",
> -				btrfs_super_nodesize(sb));
> +	if (btrfs_super_nodesize(sb) < BTRFS_MIN_BLOCK_SIZE) {
> +		printk(KERN_ERR "BTRFS: nodesize too small: %u < %d\n",
> +				btrfs_super_nodesize(sb), BTRFS_MIN_BLOCK_SIZE);

> -	if (btrfs_super_sectorsize(sb) < 4096) {
> -		printk(KERN_ERR "BTRFS: sectorsize too small: %u < 4096\n",
> -				btrfs_super_sectorsize(sb));
> +	if (btrfs_super_sectorsize(sb) < BTRFS_MIN_BLOCK_SIZE) {
> +		printk(KERN_ERR "BTRFS: sectorsize too small: %u < %d\n",
> +				btrfs_super_sectorsize(sb), BTRFS_MIN_BLOCK_SIZE);

These are correct.

>  	}
>  
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index d4cbfee..6f43b33 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -21,6 +21,7 @@
>  
>  #define BTRFS_SUPER_INFO_OFFSET (64 * 1024)
>  #define BTRFS_SUPER_INFO_SIZE 4096
> +#define BTRFS_MIN_BLOCK_SIZE 4096
>  
>  #define BTRFS_SUPER_MIRROR_MAX	 3
>  #define BTRFS_SUPER_MIRROR_SHIFT 12
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8bcd2a0..1f9d0de 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -200,7 +200,7 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
>  
>  	if (flush)
>  		filemap_write_and_wait((*bdev)->bd_inode->i_mapping);
> -	ret = set_blocksize(*bdev, 4096);
> +	ret = set_blocksize(*bdev, BTRFS_MIN_BLOCK_SIZE);

The set_blocksize 4096s are yet another category, that does not fit
under BTRFS_MIN_BLOCK_SIZE. The argument has other constraints like it
has to be at most a PAGE_SIZE, so the "minimal block size" does not make
sense here. See below.

> @@ -1746,14 +1746,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
> -			bh = __bread(bdev, bytenr / 4096,
> -					BTRFS_SUPER_INFO_SIZE);
> +			bh = __bread(bdev, bytenr / blksz,

BTRFS_SUPER_INFO_SIZE again

> +							BTRFS_SUPER_INFO_SIZE);
>  			if (!bh)
>  				continue;
>  
> @@ -2167,7 +2169,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
> -	set_blocksize(device->bdev, 4096);
> +	set_blocksize(device->bdev, BTRFS_MIN_BLOCK_SIZE);
> @@ -2374,7 +2376,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
> -	set_blocksize(device->bdev, 4096);
> +	set_blocksize(device->bdev, BTRFS_MIN_BLOCK_SIZE);

And set_blocksize again, so I'd say best to add another define, called
BTRFS_BDEV_BLOCK_SIZE and use it for set_blocksize.
