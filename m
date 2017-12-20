Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754104AbdLTITQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 03:19:16 -0500
Subject: Re: [PATCH] btrfs: optimize code converge mutex unlock
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171220064226.4317-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fdc6d2aa-12ee-c6ff-c997-a68232aac37b@suse.com>
Date: Wed, 20 Dec 2017 10:19:14 +0200
MIME-Version: 1.0
In-Reply-To: <20171220064226.4317-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.12.2017 08:42, Anand Jain wrote:
> No functional change rearrange the mutex_unlock.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/transaction.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 6348573e26a7..04f07144b45c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2265,16 +2265,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  	}
>  
>  	ret = write_all_supers(fs_info, 0);
> -	if (ret) {
> -		mutex_unlock(&fs_info->tree_log_mutex);
> -		goto scrub_continue;
> -	}
> -
>  	/*
>  	 * the super is written, we can safely allow the tree-loggers
>  	 * to go about their business
>  	 */
>  	mutex_unlock(&fs_info->tree_log_mutex);
> +	if (ret)
> +		goto scrub_continue;
>  
>  	btrfs_finish_extent_commit(trans, fs_info);
>  
> 
