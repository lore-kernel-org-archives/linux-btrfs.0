Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbeILLpU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 07:45:20 -0400
Subject: Re: [PATCH] Btrfs: remove level==0 check in balance_level
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <33dc70cf-ab6d-18e4-6971-3d231cd726bd@suse.com>
Date: Wed, 12 Sep 2018 09:42:14 +0300
MIME-Version: 1.0
In-Reply-To: <1536703587-94565-4-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2018 01:06, Liu Bo wrote:
> btrfs_search_slot()
>    if (level != 0)
>       setup_nodes_for_search()
>           balance_level()
> 
> It is just impossible to have level=0 in balance_level.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

I concur with the analysis:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 8b31caa60b0a..858085490e23 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1778,9 +1778,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  	int orig_slot = path->slots[level];
>  	u64 orig_ptr;
>  
> -	if (level == 0)
> -		return 0;
> -
>  	mid = path->nodes[level];
>  
>  	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
> 
