Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753077AbeDPTEi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:04:38 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69F54AF31
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 19:04:37 +0000 (UTC)
Date: Mon, 16 Apr 2018 21:02:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
Message-ID: <20180416190207.GX21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180416020227.18528-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180416020227.18528-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 16, 2018 at 10:02:27AM +0800, Qu Wenruo wrote:
> There are already 2 reports about strangely corrupted super blocks,
> where csum type and incompat flags get some obvious garbage, but csum
> still matches and all other vitals are correct.
> 
> This normally means some kernel memory corruption happens, although the
> cause is unknown, at least detect it and prevent further corruption.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 23803102aa0d..10d814f03f13 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -68,7 +68,8 @@
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
>  static void free_fs_root(struct btrfs_root *root);
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> +				   struct btrfs_super_block *sb);
>  static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
>  static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>  				      struct btrfs_fs_info *fs_info);
> @@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
>  
>  	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
>  
> -	ret = btrfs_check_super_valid(fs_info);
> +	ret = btrfs_check_super_valid(fs_info, fs_info->super_copy);
>  	if (ret) {
>  		btrfs_err(fs_info, "superblock contains fatal errors");
>  		err = -EINVAL;
> @@ -3575,6 +3576,21 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  	sb = fs_info->super_for_commit;
>  	dev_item = &sb->dev_item;
>  
> +	/* Do extra check on the sb to be written */
> +	ret = btrfs_check_super_valid(fs_info, sb);
> +	if (ret) {
> +		btrfs_err(fs_info, "fatal superblock corrupted detected");
> +		return -EUCLEAN;
> +	}
> +	/*
> +	 * Unknown incompat flags can't be mounted, so newly developed flags
> +	 * means corruption
> +	 */
> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> +		btrfs_err(fs_info, "fatal superblock corrupted detected");

The error messages could state that the corruption is detected at the
pre-commit time. Otherwise it's a good idea to do the checks, they're
lighweight.

> +		return -EUCLEAN;
> +	}
> +
>  	mutex_lock(&fs_info->fs_devices->device_list_mutex);
>  	head = &fs_info->fs_devices->devices;
>  	max_errors = btrfs_super_num_devices(fs_info->super_copy) - 1;
> @@ -3985,9 +4001,9 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
>  					      level, first_key);
>  }
>  
> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
> +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
> +				   struct btrfs_super_block *sb)
>  {
> -	struct btrfs_super_block *sb = fs_info->super_copy;
>  	u64 nodesize = btrfs_super_nodesize(sb);
>  	u64 sectorsize = btrfs_super_sectorsize(sb);
>  	int ret = 0;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
