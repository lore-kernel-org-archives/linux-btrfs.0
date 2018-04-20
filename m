Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754193AbeDTJKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:10:54 -0400
Subject: Re: [PATCH v2 13/16] btrfs: move and comment read-only check in
 btrfs_cancel_balance
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <d1db2691059cb458d2b44cae473b1cf2ea73ed78.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <189a5404-4bf9-5907-40d2-ad670b5889d1@oracle.com>
Date: Fri, 20 Apr 2018 17:13:02 +0800
MIME-Version: 1.0
In-Reply-To: <d1db2691059cb458d2b44cae473b1cf2ea73ed78.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> Balance cannot be started on a read-only filesystem and will have to
> finish/exit before eg. going to read-only via remount.

  It can be paused as well.
    btrfs balance pause /btrfs && mount -o remount,ro /dev/sdb /btrfs


> @@ -4053,15 +4053,20 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>   
>   int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>   {
> -	if (sb_rdonly(fs_info->sb))
> -		return -EROFS;
> -
>   	mutex_lock(&fs_info->balance_mutex);
>   	if (!fs_info->balance_ctl) {
>   		mutex_unlock(&fs_info->balance_mutex);
>   		return -ENOTCONN;
>   	}
>   
> +	/*
> +	 * A paused balance with the item stored on disk can be resumed at
> +	 * mount time if the mount is read-write. Otherwise it's still paused
> +	 * and we must not allow cancelling as it deletes the item.
> +	 */
> +	if (sb_rdonly(fs_info->sb))
> +		return -EROFS;
> +

   mutex_unlock(&fs_info->balance_mutex); ?

Thanks, Anand

