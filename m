Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44263 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdJUFpf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 01:45:35 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L5jYsH009666
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 05:45:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9L5jXYY005334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 05:45:34 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9L5jX7X020439
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 05:45:33 GMT
Date: Fri, 20 Oct 2017 22:41:22 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid deadlock in btrfs_async_run_delayed_root
Message-ID: <20171021054122.GA1696@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171020234012.9929-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171020234012.9929-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Please ignore this patch, I misunderstood the lock order.

thanks,

-liubo

On Fri, Oct 20, 2017 at 05:40:12PM -0600, Liu Bo wrote:
> Here %path is set with ->leave_spinning=1, thus it'll hold the rwlock
> after btrfs_search_slot(), however, when processing delayed items in
> __btrfs_commit_inode_delayed_items(), it goes to acquire node->mutex
> which might sleep, that is, it may sleep under spin_lock.
> 
> Given node->mutex is necessary to avoid race between async works, this
> remove the ->leave_spining setting.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/delayed-inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 19e4ad2..a857a2f 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1331,7 +1331,6 @@ static void btrfs_async_run_delayed_root(struct btrfs_work *work)
>  	if (!delayed_node)
>  		goto free_path;
>  
> -	path->leave_spinning = 1;
>  	root = delayed_node->root;
>  
>  	trans = btrfs_join_transaction(root);
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
