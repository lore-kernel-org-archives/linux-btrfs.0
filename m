Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbeGLHVS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 03:21:18 -0400
Subject: Re: [PATCH 1/3] btrfs: warn for num_devices below 0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180710182241.23754-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8a7b78aa-1a7f-9edd-e30b-d97d15a35331@suse.com>
Date: Thu, 12 Jul 2018 10:13:01 +0300
MIME-Version: 1.0
In-Reply-To: <20180710182241.23754-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 21:22, Anand Jain wrote:
> In preparation to de-duplicate a section of code where we deduce the
> num_devices, use warn instead of bug.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index eb78bb8d1108..ce6faeb8bcf8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3813,7 +3813,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>  	num_devices = fs_info->fs_devices->num_devices;
>  	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>  	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> -		BUG_ON(num_devices < 1);
> +		WARN_ON(num_devices < 1);

Isn't dev_replace_is_ongoing && num_devices < 1 indeed a logical bug
situation? Under what condition can it happen that you deem "non
critical" ?

>  		num_devices--;
>  	}
>  	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> 
