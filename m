Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52120 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753597AbeDTHdP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 03:33:15 -0400
Subject: Re: [PATCH v2 06/16] btrfs: move clearing of EXCL_OP out of
 __cancel_balance
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <c5cb79f4b8f36ce894e9e58903029d3a92722d5c.1524146555.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ca39b4fe-3e6c-8cfa-260f-02808f472cf3@oracle.com>
Date: Fri, 20 Apr 2018 15:35:23 +0800
MIME-Version: 1.0
In-Reply-To: <c5cb79f4b8f36ce894e9e58903029d3a92722d5c.1524146555.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> Make the clearning visible in the callers so we can pair it with the
> test_and_set part.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
>   fs/btrfs/ioctl.c   |  2 +-
>   fs/btrfs/volumes.c | 13 +++++++------
>   2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b93dea445802..582bde5b7eda 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4656,7 +4656,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>   	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP
>   	 * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
>   	 * or, if restriper was paused all the way until unmount, in
> -	 * free_fs_info.  The flag is cleared in __cancel_balance.
> +	 * free_fs_info.  The flag should be cleared after __cancel_balance.
>   	 */
>   	need_unlock = false;
>   
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e0bd181dc9e0..5c83ebc8e199 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3760,8 +3760,6 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
>   	ret = del_balance_item(fs_info);
>   	if (ret)
>   		btrfs_handle_fs_error(fs_info, ret, NULL);
> -
> -	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>   }
>   
>   /* Non-zero return value signifies invalidity */
> @@ -3919,6 +3917,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
>   	    balance_need_close(fs_info)) {
>   		__cancel_balance(fs_info);
> +		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>   	}
>   
>   	wake_up(&fs_info->balance_wait_q);
> @@ -3927,10 +3926,10 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   out:
>   	if (bctl->flags & BTRFS_BALANCE_RESUME)
>   		__cancel_balance(fs_info);
> -	else {
> +	else
>   		kfree(bctl);
> -		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> -	}
> +	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> +
>   	return ret;
>   }
>   
> @@ -4089,8 +4088,10 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   		mutex_lock(&fs_info->volume_mutex);
>   		mutex_lock(&fs_info->balance_mutex);
>   
> -		if (fs_info->balance_ctl)
> +		if (fs_info->balance_ctl) {
>   			__cancel_balance(fs_info);
> +			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
> +		}
>   
>   		mutex_unlock(&fs_info->volume_mutex);
>   	}
> 
