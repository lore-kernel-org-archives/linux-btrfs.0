Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753393AbeDZUjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 16:39:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2199AE21
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Apr 2018 20:39:52 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs: qgroup, don't try to insert status item after
 ENOMEM in rescan worker
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-3-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
Date: Thu, 26 Apr 2018 23:39:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180426192351.473-3-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26.04.2018 22:23, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If we fail to allocate memory for a path, don't bother trying to
> insert the qgroup status item.  We haven't done anything yet and it'll
> fail also.  Just print an error and be done with it.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

nit: So the code is correct however, having the out label there is
really ugly. What about on path alloc failure just have the print in the
if branch do goto done?


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8de423a0c7e3..4c0978bce5b9 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2648,7 +2648,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>  			btrfs_end_transaction(trans);
>  	}
>  
> -out:
>  	btrfs_free_path(path);
>  
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
> @@ -2688,6 +2687,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>  		btrfs_info(fs_info, "qgroup scan completed%s",
>  			err > 0 ? " (inconsistency flag cleared)" : "");
>  	} else {
> +out:
>  		btrfs_err(fs_info, "qgroup scan failed with %d", err);
>  	}
>  
> 
