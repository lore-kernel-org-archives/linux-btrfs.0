Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754093AbeDZUha (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 16:37:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D090AAE21
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 20:37:28 +0000 (UTC)
Subject: Re: [PATCH 2/3] btrfs: qgroups, remove unnecessary memset before
 btrfs_init_work
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-2-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1688fb87-dc31-4f99-1af4-31bc1b79ed19@suse.com>
Date: Thu, 26 Apr 2018 23:37:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180426192351.473-2-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.04.2018 22:23, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> btrfs_init_work clears the work struct except for ->wq, so the memset
> before calling btrfs_init_work in qgroup_rescan_init is unnecessary.
> 
> We'll also initialize ->wq in btrfs_init_work so that it's obvious.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/async-thread.c | 1 +
>  fs/btrfs/qgroup.c       | 2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index d5540749f0e5..c614fb7b9b9d 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -354,6 +354,7 @@ void btrfs_init_work(struct btrfs_work *work, btrfs_work_func_t uniq_func,
>  	INIT_WORK(&work->normal_work, uniq_func);
>  	INIT_LIST_HEAD(&work->ordered_list);
>  	work->flags = 0;
> +	work->wq = NULL;
>  }
>  
>  static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index be491b6c020a..8de423a0c7e3 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2740,8 +2740,6 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
>  	spin_unlock(&fs_info->qgroup_lock);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
>  
> -	memset(&fs_info->qgroup_rescan_work, 0,
> -	       sizeof(fs_info->qgroup_rescan_work));
>  	btrfs_init_work(&fs_info->qgroup_rescan_work,
>  			btrfs_qgroup_rescan_helper,
>  			btrfs_qgroup_rescan_worker, NULL, NULL);
> 
