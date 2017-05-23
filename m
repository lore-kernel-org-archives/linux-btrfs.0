Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43641 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1762459AbdEWJGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 05:06:43 -0400
Subject: Re: [PATCH] Btrfs: skip commit transaction if we don't have enough
 pinned bytes
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170519173915.29846-1-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2d7827f3-9e67-d2e7-fbe0-8c9c2a921350@suse.com>
Date: Tue, 23 May 2017 12:06:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170519173915.29846-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.05.2017 20:39, Liu Bo wrote:
> We commit transaction in order to reclaim space from pinned bytes because
> it could process delayed refs, and in may_commit_transaction(), we check
> first if pinned bytes are enough for the required space, we then check if
> that plus bytes reserved for delayed insert are enough for the required
> space.
> 
> This changes the code to the above logic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Please add:
Fixes: b150a4f10d87 ("Btrfs: use a percpu to keep track of possibly
pinned bytes")

> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e390451c72e6..bded1ddd1bb6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  
>  	spin_lock(&delayed_rsv->lock);
>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> -				   bytes - delayed_rsv->size) >= 0) {
> +				   bytes - delayed_rsv->size) < 0) {
>  		spin_unlock(&delayed_rsv->lock);
>  		return -ENOSPC;
>  	}
> 

With the minor nit above:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
