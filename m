Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16855 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdBOVbJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:31:09 -0500
Date: Wed, 15 Feb 2017 13:30:12 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 20/29] btrfs: remove unused parameter from
 init_first_rw_device
Message-ID: <20170215213012.GK19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <39fee9c2119a4075d840eecc930330b400ae4e0b.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <39fee9c2119a4075d840eecc930330b400ae4e0b.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:22AM +0100, David Sterba wrote:
> The 'device' used to be added in that function, but now it's done by the
> caller.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/volumes.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d234625e4e02..1fac98728814 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -134,8 +134,7 @@ const int btrfs_raid_mindev_error[BTRFS_NR_RAID_TYPES] = {
>  };
>  
>  static int init_first_rw_device(struct btrfs_trans_handle *trans,
> -				struct btrfs_fs_info *fs_info,
> -				struct btrfs_device *device);
> +				struct btrfs_fs_info *fs_info);
>  static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
>  static void __btrfs_reset_dev_stats(struct btrfs_device *dev);
>  static void btrfs_dev_stat_print_on_error(struct btrfs_device *dev);
> @@ -2440,7 +2439,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
>  
>  	if (seeding_dev) {
>  		mutex_lock(&fs_info->chunk_mutex);
> -		ret = init_first_rw_device(trans, fs_info, device);
> +		ret = init_first_rw_device(trans, fs_info);
>  		mutex_unlock(&fs_info->chunk_mutex);
>  		if (ret) {
>  			btrfs_abort_transaction(trans, ret);
> @@ -5012,8 +5011,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  }
>  
>  static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
> -					 struct btrfs_fs_info *fs_info,
> -					 struct btrfs_device *device)
> +					 struct btrfs_fs_info *fs_info)
>  {
>  	struct btrfs_root *extent_root = fs_info->extent_root;
>  	u64 chunk_offset;
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
