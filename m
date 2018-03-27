Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbeC0MVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 08:21:20 -0400
Subject: Re: [PATCH 7/8] btrfs: verify checksum for all devices in mount
 context
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-8-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <63df7a25-7b4b-bb7e-6b85-383c3dcdc54e@suse.com>
Date: Tue, 27 Mar 2018 15:21:18 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-8-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.03.2018 11:27, Anand Jain wrote:
> During mount context, we aren't verifying the superblock checksum
> for all the devices, instead, we verify it only for the
> struct btrfs_fs_device::latest_bdev. This patch fixes it
> by moving the checksum verification code from the function open_ctree()
> into the function btrfs_read_dev_one_super().
> 
> By doing this now we are verifying the superblock checksum
> in the mount-context, device-replace and, device-delete context.

Which call chain provides the device-replace and device-delete contexts?
I think it is worth it documenting them in the changelog.

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6299ab18da5f..3cc50041c0b9 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2565,24 +2565,6 @@ int open_ctree(struct super_block *sb,
>  	}
>  
>  	/*
> -	 * We want to check superblock checksum, the type is stored inside.
> -	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
> -	 */
> -	err = btrfs_check_super_csum(bh->b_data);
> -	if (err) {
> -		if (err == -EINVAL)
> -			pr_err("BTRFS error (device %pg): "\
> -				"unsupported checksum algorithm",
> -				fs_devices->latest_bdev);
> -		else
> -			pr_err("BTRFS error (device %pg): "\
> -				"superblock checksum mismatch",
> -				fs_devices->latest_bdev);
> -		brelse(bh);
> -		goto fail_alloc;
> -	}
> -
> -	/*
>  	 * super_copy is zeroed at allocation time and we never touch the
>  	 * following bytes up to INFO_SIZE, the checksum is calculated from
>  	 * the whole block of INFO_SIZE
> @@ -3128,6 +3110,7 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  	struct buffer_head *bh;
>  	struct btrfs_super_block *super;
>  	u64 bytenr;
> +	int err;
>  
>  	bytenr = btrfs_sb_offset(copy_num);
>  	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
> @@ -3148,6 +3131,22 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Check the superblock checksum, the type is stored inside.
> +	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
> +	 */
> +	err = btrfs_check_super_csum(bh->b_data);
> +	if (err) {
> +		if (err == -EINVAL)
> +			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
> +				bdev);
> +		else if (err == -EUCLEAN)
> +			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
> +				bdev);
> +		brelse(bh);
> +		return err;
> +	}
> +
>  	*bh_ret = bh;
>  	return 0;
>  }
> 
