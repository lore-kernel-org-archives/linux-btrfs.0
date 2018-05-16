Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37359 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752733AbeEPHuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 03:50:03 -0400
Subject: Re: [PATCH v2 3/3] btrfs: balance: add kernel log for end or paused
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c0243500-16af-76a5-92bf-01220e9ce209@suse.com>
Date: Wed, 16 May 2018 10:50:01 +0300
MIME-Version: 1.0
In-Reply-To: <20180516025128.9899-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.05.2018 05:51, Anand Jain wrote:
> Add a kernel log when the balance ends, either for cancel or completed
> or if it is paused.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v1->v2: Moved from 2/3 to 3/3
> 
>  fs/btrfs/volumes.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ce68c4f42f94..a4e243a29f5c 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4053,6 +4053,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>  	ret = __btrfs_balance(fs_info);
>  
>  	mutex_lock(&fs_info->balance_mutex);
> +	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
> +		btrfs_info(fs_info, "balance: paused");
> +	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
> +		btrfs_info(fs_info, "balance: canceled");
> +	else
> +		btrfs_info(fs_info, "balance: ended with status: %d", ret);
> +
>  	clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>  
>  	if (bargs) {
> 
