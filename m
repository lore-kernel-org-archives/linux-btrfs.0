Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35759 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935299Ab3BTOVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 09:21:20 -0500
Date: Wed, 20 Feb 2013 22:20:02 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130220142001.GB4941@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> Provide for modification of the limit of compressed extent size
> utilizing mount-time configuration settings.
> 
> The size of compressed extents was limited to 128K, which
> leads to fragmentation of the extents (although the extents
> themselves may still be located contiguously).  This limit is
> put in place to ease the RAM required when spreading compression
> across several CPUs, and to make sure the amount of IO required
> to do a random read is reasonably small.
> 
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
> Changelog v1 -> v2:
> - Use more self-documenting variable name:
>   compressed_extent_size -> max_compressed_extent_kb
> - Use #define BTRFS_DEFAULT_MAX_COMPR_EXTENTS instead of raw 128.
> - Fix min calculation for nr_pages.
> - Comment cleanup.
> - Use more self-documenting mount option parameter:
>   compressed_extent_size -> max_compressed_extent_kb
> - Fix formatting in btrfs_show_options.
> ---
>  fs/btrfs/ctree.h      |  6 ++++++
>  fs/btrfs/disk-io.c    |  1 +
>  fs/btrfs/inode.c      |  8 ++++----
>  fs/btrfs/relocation.c |  7 ++++---
>  fs/btrfs/super.c      | 20 +++++++++++++++++++-
>  5 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 547b7b0..a62f20c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -191,6 +191,9 @@ static int btrfs_csum_sizes[] = { 4, 0 };
>  /* ioprio of readahead is set to idle */
>  #define BTRFS_IOPRIO_READA (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0))
>  
> +/* Default value for maximum compressed extent size (kb) */
> +#define BTRFS_DEFAULT_MAX_COMPR_EXTENTS	128
> +
>  /*
>   * The key defines the order in the tree, and so it also defines (optimal)
>   * block layout.
> @@ -1477,6 +1480,8 @@ struct btrfs_fs_info {
>  	unsigned data_chunk_allocations;
>  	unsigned metadata_ratio;
>  
> +	unsigned max_compressed_extent_kb;
> +
>  	void *bdev_holder;
>  
>  	/* private scrub information */
> @@ -1829,6 +1834,7 @@ struct btrfs_ioctl_defrag_range_args {
>  #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
>  #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>  #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
> +#define BTRFS_MOUNT_COMPR_EXTENT_SIZE (1 << 23)
>  
>  #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>  #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 830bc17..775e7ba 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2056,6 +2056,7 @@ int open_ctree(struct super_block *sb,
>  	fs_info->trans_no_join = 0;
>  	fs_info->free_chunk_space = 0;
>  	fs_info->tree_mod_log = RB_ROOT;
> +	fs_info->max_compressed_extent_kb = BTRFS_DEFAULT_MAX_COMPR_EXTENTS;
>  
>  	/* readahead state */
>  	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 148abeb..78fc6eb 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -346,8 +346,8 @@ static noinline int compress_file_range(struct inode *inode,
>  	unsigned long nr_pages_ret = 0;
>  	unsigned long total_compressed = 0;
>  	unsigned long total_in = 0;
> -	unsigned long max_compressed = 128 * 1024;
> -	unsigned long max_uncompressed = 128 * 1024;
> +	unsigned long max_compressed = root->fs_info->max_compressed_extent_kb * 1024;
> +	unsigned long max_uncompressed = root->fs_info->max_compressed_extent_kb * 1024;
>  	int i;
>  	int will_compress;
>  	int compress_type = root->fs_info->compress_type;
> @@ -361,7 +361,7 @@ static noinline int compress_file_range(struct inode *inode,
>  again:
>  	will_compress = 0;
>  	nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
> -	nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
> +	nr_pages = min(nr_pages, max_compressed / PAGE_CACHE_SIZE);
>  
>  	/*
>  	 * we don't want to send crud past the end of i_size through
> @@ -386,7 +386,7 @@ again:
>  	 *
>  	 * We also want to make sure the amount of IO required to do
>  	 * a random read is reasonably small, so we limit the size of
> -	 * a compressed extent to 128k.
> +	 * a compressed extent.
>  	 */
>  	total_compressed = min(total_compressed, max_uncompressed);
>  	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 300e09a..64bbc9e 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -144,7 +144,7 @@ struct tree_block {
>  	unsigned int key_ready:1;
>  };
>  
> -#define MAX_EXTENTS 128
> +#define MAX_EXTENTS 512
>  
>  struct file_extent_cluster {
>  	u64 start;
> @@ -3055,6 +3055,7 @@ int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
>  			 struct file_extent_cluster *cluster)
>  {
>  	int ret;
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>  
>  	if (cluster->nr > 0 && extent_key->objectid != cluster->end + 1) {
>  		ret = relocate_file_extent_cluster(inode, cluster);
> @@ -3066,12 +3067,12 @@ int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
>  	if (!cluster->nr)
>  		cluster->start = extent_key->objectid;
>  	else
> -		BUG_ON(cluster->nr >= MAX_EXTENTS);
> +		BUG_ON(cluster->nr >= fs_info->max_compressed_extent_kb);
>  	cluster->end = extent_key->objectid + extent_key->offset - 1;
>  	cluster->boundary[cluster->nr] = extent_key->objectid;
>  	cluster->nr++;
>  
> -	if (cluster->nr >= MAX_EXTENTS) {
> +	if (cluster->nr >= fs_info->max_compressed_extent_kb) {
>  		ret = relocate_file_extent_cluster(inode, cluster);
>  		if (ret)
>  			return ret;

MAX_EXTENTS is irrelevant to compress, it's just for efficiency of relocation.

thanks,
liubo


> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d8982e9..25b8dc2 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -322,7 +322,7 @@ enum {
>  	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
>  	Opt_check_integrity, Opt_check_integrity_including_extent_data,
>  	Opt_check_integrity_print_mask, Opt_fatal_errors,
> -	Opt_err,
> +	Opt_max_compr_extent_kb, Opt_err,
>  };
>  
>  static match_table_t tokens = {
> @@ -361,6 +361,7 @@ static match_table_t tokens = {
>  	{Opt_check_integrity, "check_int"},
>  	{Opt_check_integrity_including_extent_data, "check_int_data"},
>  	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
> +	{Opt_max_compr_extent_kb, "max_compressed_extent_kb=%d"},
>  	{Opt_fatal_errors, "fatal_errors=%s"},
>  	{Opt_err, NULL},
>  };
> @@ -612,6 +613,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			ret = -EINVAL;
>  			goto out;
>  #endif
> +		case Opt_max_compr_extent_kb:
> +			intarg = 0;
> +			match_int(&args[0], &intarg);
> +			if ((intarg == 128) || (intarg == 512)) {
> +				info->max_compressed_extent_kb = intarg;
> +				printk(KERN_INFO "btrfs: "
> +				       "max compressed extent size %d KB\n",
> +				       info->max_compressed_extent_kb);
> +			} else {
> +				printk(KERN_INFO "btrfs: "
> +				       "Invalid compressed extent size,"
> +				       " using default.\n");
> +			}
> +			break;
>  		case Opt_fatal_errors:
>  			if (strcmp(args[0].from, "panic") == 0)
>  				btrfs_set_opt(info->mount_opt,
> @@ -951,6 +966,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  		seq_puts(seq, ",skip_balance");
>  	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
>  		seq_puts(seq, ",fatal_errors=panic");
> +	if (btrfs_test_opt(root, COMPR_EXTENT_SIZE))
> +		seq_printf(seq, ",max_compressed_extent_kb=%u",
> +			   info->max_compressed_extent_kb);
>  	return 0;
>  }
>  
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
