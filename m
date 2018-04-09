Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752831AbeDIPXB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 11:23:01 -0400
Subject: Re: [PATCH 16/16] btrfs: open code set_balance_control
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <fda7ab82f7fb52c213c72220ac965a66786eed1d.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <22b4d4af-5fc9-6b81-468c-34d2113fa89f@oracle.com>
Date: Mon, 9 Apr 2018 23:24:59 +0800
MIME-Version: 1.0
In-Reply-To: <fda7ab82f7fb52c213c72220ac965a66786eed1d.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The helper is quite simple and I'd like to see the locking in the
> caller.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

For the version at:
  git://github.com/kdave/btrfs-devel dev/remove-volume-mutex

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>   fs/btrfs/volumes.c | 20 ++++----------------
>   1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e93c7ba44d06..db9f72c6af85 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3178,21 +3178,6 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
>   	}
>   }
>   
> -/*
> - * Should be called with balance mutex held to protect against checking the
> - * balance status or progress. Same goes for reset_balance_state.
> - */
> -static void set_balance_control(struct btrfs_balance_control *bctl)
> -{
> -	struct btrfs_fs_info *fs_info = bctl->fs_info;
> -
> -	BUG_ON(fs_info->balance_ctl);
> -
> -	spin_lock(&fs_info->balance_lock);
> -	fs_info->balance_ctl = bctl;
> -	spin_unlock(&fs_info->balance_lock);
> -}
> -
>   /*
>    * Clear the balance status in fs_info and delete the balance item from disk.
>    */
> @@ -3878,7 +3863,10 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>   
>   	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
>   		BUG_ON(ret == -EEXIST);
> -		set_balance_control(bctl);
> +		BUG_ON(fs_info->balance_ctl);
> +		spin_lock(&fs_info->balance_lock);
> +		fs_info->balance_ctl = bctl;
> +		spin_unlock(&fs_info->balance_lock);
>   	} else {
>   		BUG_ON(ret != -EEXIST);
>   		spin_lock(&fs_info->balance_lock);
> 
