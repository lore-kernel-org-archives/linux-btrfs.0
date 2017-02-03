Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50125 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbdBCSfO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 13:35:14 -0500
Date: Fri, 3 Feb 2017 10:33:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/24] btrfs: Convert to separately allocated bdi
Message-ID: <20170203183332.GB30842@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170202173422.3240-1-jack@suse.cz>
 <20170202173422.3240-9-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170202173422.3240-9-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 06:34:06PM +0100, Jan Kara wrote:
> Allocate struct backing_dev_info separately instead of embedding it
> inside superblock. This unifies handling of bdi among users.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> CC: Chris Mason <clm@fb.com>
> CC: Josef Bacik <jbacik@fb.com>
> CC: David Sterba <dsterba@suse.com>
> CC: linux-btrfs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/btrfs/ctree.h   |  1 -
>  fs/btrfs/disk-io.c | 36 +++++++-----------------------------
>  fs/btrfs/super.c   |  7 +++++++
>  3 files changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6a823719b6c5..1dc06f66dfcf 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -801,7 +801,6 @@ struct btrfs_fs_info {
>  	struct btrfs_super_block *super_for_commit;
>  	struct super_block *sb;
>  	struct inode *btree_inode;
> -	struct backing_dev_info bdi;
>  	struct mutex tree_log_mutex;
>  	struct mutex transaction_kthread_mutex;
>  	struct mutex cleaner_mutex;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 37a31b12bb0c..b25723e729c0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1810,21 +1810,6 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
>  	return ret;
>  }
>  
> -static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
> -{
> -	int err;
> -
> -	err = bdi_setup_and_register(bdi, "btrfs");
> -	if (err)
> -		return err;
> -
> -	bdi->ra_pages = VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
> -	bdi->congested_fn	= btrfs_congested_fn;
> -	bdi->congested_data	= info;
> -	bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
> -	return 0;
> -}
> -
>  /*
>   * called by the kthread helper functions to finally call the bio end_io
>   * functions.  This is where read checksum verification actually happens
> @@ -2598,16 +2583,10 @@ int open_ctree(struct super_block *sb,
>  		goto fail;
>  	}
>  
> -	ret = setup_bdi(fs_info, &fs_info->bdi);
> -	if (ret) {
> -		err = ret;
> -		goto fail_srcu;
> -	}
> -
>  	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
>  	if (ret) {
>  		err = ret;
> -		goto fail_bdi;
> +		goto fail_srcu;
>  	}
>  	fs_info->dirty_metadata_batch = PAGE_SIZE *
>  					(1 + ilog2(nr_cpu_ids));
> @@ -2715,7 +2694,6 @@ int open_ctree(struct super_block *sb,
>  
>  	sb->s_blocksize = 4096;
>  	sb->s_blocksize_bits = blksize_bits(4096);
> -	sb->s_bdi = &fs_info->bdi;
>  
>  	btrfs_init_btree_inode(fs_info);
>  
> @@ -2912,9 +2890,12 @@ int open_ctree(struct super_block *sb,
>  		goto fail_sb_buffer;
>  	}
>  
> -	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
> -	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> -				    SZ_4M / PAGE_SIZE);
> +	sb->s_bdi->congested_fn = btrfs_congested_fn;
> +	sb->s_bdi->congested_data = fs_info;
> +	sb->s_bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
> +	sb->s_bdi->ra_pages = VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
> +	sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
> +	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
>  
>  	sb->s_blocksize = sectorsize;
>  	sb->s_blocksize_bits = blksize_bits(sectorsize);
> @@ -3282,8 +3263,6 @@ int open_ctree(struct super_block *sb,
>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>  fail_dirty_metadata_bytes:
>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
> -fail_bdi:
> -	bdi_destroy(&fs_info->bdi);
>  fail_srcu:
>  	cleanup_srcu_struct(&fs_info->subvol_srcu);
>  fail:
> @@ -4010,7 +3989,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>  	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
>  	percpu_counter_destroy(&fs_info->delalloc_bytes);
>  	percpu_counter_destroy(&fs_info->bio_counter);
> -	bdi_destroy(&fs_info->bdi);
>  	cleanup_srcu_struct(&fs_info->subvol_srcu);
>  
>  	btrfs_free_stripe_hash_table(fs_info);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b5ae7d3d1896..08ef08b63132 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1133,6 +1133,13 @@ static int btrfs_fill_super(struct super_block *sb,
>  #endif
>  	sb->s_flags |= MS_I_VERSION;
>  	sb->s_iflags |= SB_I_CGROUPWB;
> +
> +	err = super_setup_bdi(sb);
> +	if (err) {
> +		btrfs_err(fs_info, "super_setup_bdi failed");
> +		return err;
> +	}
> +
>  	err = open_ctree(sb, fs_devices, (char *)data);
>  	if (err) {
>  		btrfs_err(fs_info, "open_ctree failed");
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
