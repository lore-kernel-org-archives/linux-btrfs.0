Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726693AbeGLGgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 02:36:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9000DAD7E
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2018 06:27:55 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Introduce compile time structure size check
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180712061907.24783-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e2042691-363d-875b-61a2-d59e47840c49@suse.com>
Date: Thu, 12 Jul 2018 09:27:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180712061907.24783-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.07.2018 09:19, Qu Wenruo wrote:
> Introduce a new macro based compile time check for ioctl structures.
> 
> The new macro is BTRFS_ASSERT_SIZE(), which is mostly copied from
> VMMDEV_ASSERT_SIZE().
> 
> Such check is only added to structure pended to power of 2.
> And exposed one structure, btrfs_ioctl_get_dev_stats() is not aligned
> well.
> The misalign is introduced by commit b27f7c0c150f ("btrfs: join DEV_STATS
> ioctls to one").

So what's the negative effect if a structure is not aligned to a power of 2?

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  include/uapi/linux/btrfs.h | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 5ca1d21fc4a7..be1213c10080 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -22,6 +22,14 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  
> +/*
> + * Compile time check on structure size, same method as
> + * VMMDEV_ASSERT_SIZE() from linux/vbox_vmmdev_types.h, to trigger a negative
> + * array size at compile time if size doesn't match.
> + */
> +#define BTRFS_ASSERT_SIZE(type, size) \
> +	typedef char type ## _asrt_size[1 - 2 * !!(sizeof(struct type) != (size))]
> +
>  #define BTRFS_IOCTL_MAGIC 0x94
>  #define BTRFS_VOL_NAME_MAX 255
>  #define BTRFS_LABEL_SIZE 256
> @@ -32,6 +40,7 @@ struct btrfs_ioctl_vol_args {
>  	__s64 fd;
>  	char name[BTRFS_PATH_NAME_MAX + 1];
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_vol_args, 4096);
>  
>  #define BTRFS_DEVICE_PATH_NAME_MAX	1024
>  #define BTRFS_SUBVOL_NAME_MAX 		4039
> @@ -171,6 +180,7 @@ struct btrfs_ioctl_scrub_args {
>  	/* pad to 1k */
>  	__u64 unused[(1024-32-sizeof(struct btrfs_scrub_progress))/8];
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_scrub_args, 1024);
>  
>  #define BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_ALWAYS	0
>  #define BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID	1
> @@ -223,6 +233,7 @@ struct btrfs_ioctl_dev_info_args {
>  	__u64 unused[379];			/* pad to 4k */
>  	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_dev_info_args, 4096);
>  
>  struct btrfs_ioctl_fs_info_args {
>  	__u64 max_id;				/* out */
> @@ -234,6 +245,7 @@ struct btrfs_ioctl_fs_info_args {
>  	__u32 reserved32;
>  	__u64 reserved[122];			/* pad to 1k */
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_fs_info_args, 1024);
>  
>  /*
>   * feature flags
> @@ -414,6 +426,7 @@ struct btrfs_ioctl_balance_args {
>  
>  	__u64 unused[72];			/* pad to 1k */
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_balance_args, 1024);
>  
>  #define BTRFS_INO_LOOKUP_PATH_MAX 4080
>  struct btrfs_ioctl_ino_lookup_args {
> @@ -421,6 +434,7 @@ struct btrfs_ioctl_ino_lookup_args {
>  	__u64 objectid;
>  	char name[BTRFS_INO_LOOKUP_PATH_MAX];
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_ino_lookup_args, 4096);
>  
>  #define BTRFS_INO_LOOKUP_USER_PATH_MAX (4080 - BTRFS_VOL_NAME_MAX - 1)
>  struct btrfs_ioctl_ino_lookup_user_args {
> @@ -436,6 +450,7 @@ struct btrfs_ioctl_ino_lookup_user_args {
>  	 */
>  	char path[BTRFS_INO_LOOKUP_USER_PATH_MAX];
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_ino_lookup_args, 4096);
>  
>  /* Search criteria for the btrfs SEARCH ioctl family. */
>  struct btrfs_ioctl_search_key {
> @@ -664,8 +679,9 @@ struct btrfs_ioctl_get_dev_stats {
>  	/* out values: */
>  	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
>  
> -	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
> +	__u64 unused[128 - 3 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
>  };
> +BTRFS_ASSERT_SIZE(btrfs_ioctl_get_dev_stats, 1024);
>  
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
> 
