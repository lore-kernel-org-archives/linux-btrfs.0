Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbeDIHVe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 03:21:34 -0400
Subject: Re: [PATCH 08/16] btrfs: add sanity check when resuming balance after
 mount
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <a5729260c2f8b50912bf975b30081ab1dbd8c8fd.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <945b97c0-b431-a679-8d2a-83315e33b8e8@oracle.com>
Date: Mon, 9 Apr 2018 15:23:32 +0800
MIME-Version: 1.0
In-Reply-To: <a5729260c2f8b50912bf975b30081ab1dbd8c8fd.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> Replace a WARN_ON with a proper check and message in case something goes
> really wrong and resumed balance cannot set up its exclusive status.
> The check is a user friendly assertion, I don't expect to ever happen
> under normal circumstances.
> 
> Also document that the paused balance starts here and owns the exclusive
> op status.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index eb78c1d0ce2b..843982a2cbdb 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3982,6 +3982,20 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
>   	struct btrfs_key key;
>   	int ret;
>   
> +	/*
> +	 * This should never happen, as the paused balance state is recovered
> +	 * during mount without any chance of other exclusive ops to collide.
> +	 * Let it fail early and do not continue mount.
> +	 *
> +	 * Otherwise, this gives the exclusive op status to balance and keeps
> +	 * in paused state until user intervention (cancel or umount).
> +	 */
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
> +		btrfs_err(fs_info,
> +			"cannot set exclusive op status to resume balance");
> +		return -EINVAL;
> +	}
> +


  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


>   	path = btrfs_alloc_path();
>   	if (!path)
>   		return -ENOMEM;
> @@ -4018,8 +4032,6 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
>   	btrfs_balance_sys(leaf, item, &disk_bargs);
>   	btrfs_disk_balance_args_to_cpu(&bctl->sys, &disk_bargs);
>   
> -	WARN_ON(test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags));
> -
>   	mutex_lock(&fs_info->volume_mutex);
>   	mutex_lock(&fs_info->balance_mutex);
>   
> 
