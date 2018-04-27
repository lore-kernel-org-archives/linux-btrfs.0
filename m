Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbeD0CAD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 22:00:03 -0400
Subject: Re: [PATCH v2.1 13/16] btrfs: move and comment read-only check in
 btrfs_cancel_balance
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <d1db2691059cb458d2b44cae473b1cf2ea73ed78.1524146556.git.dsterba@suse.com>
 <189a5404-4bf9-5907-40d2-ad670b5889d1@oracle.com>
 <20180420120604.GO21272@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5d281ac8-9eba-0648-e9ea-a0217486a273@oracle.com>
Date: Fri, 27 Apr 2018 10:02:13 +0800
MIME-Version: 1.0
In-Reply-To: <20180420120604.GO21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 08:06 PM, David Sterba wrote:
> Balance cannot be started on a read-only filesystem and will have to
> finish/exit before eg. going to read-only via remount.
> 
> In case the filesystem is forcibly set to read-only after an error,
> balance will finish anyway and if the cancel call is too fast it will
> just wait for that to happen.
> 
> The last case is when the balance is paused after mount but it's
> read-only and cancelling would want to delete the item. The test is
> moved after the check if balance is running at all, as it looks more
> logical to report "no balance running" instead of "read-only
> filesystem".
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
> 
> - Add missing unlock
> 
>   fs/btrfs/volumes.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a766d2f988c1..9176d77e02ee 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4053,15 +4053,22 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
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
> +	if (sb_rdonly(fs_info->sb)) {
> +		mutex_unlock(&fs_info->balance_mutex);
> +		return -EROFS;
> +	}
> +
>   	atomic_inc(&fs_info->balance_cancel_req);
>   	/*
>   	 * if we are running just wait and return, balance item is
> 
