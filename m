Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbeEPGkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 02:40:22 -0400
Subject: Re: [PATCH 1/6] Btrfs: remove superfluous free_extent_buffer
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-2-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <10141fa9-4e25-b775-6ac6-698bd46d36c0@suse.com>
Date: Wed, 16 May 2018 09:40:19 +0300
MIME-Version: 1.0
In-Reply-To: <1526406728-109055-2-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 20:52, Liu Bo wrote:
> @tmp must be NULL at this point, free_extent_buffer is not needed at all.

You need to explain that this code is executed only if
find_extent_buffer didn't return anything, meaning tmp is null,
otherwise it's hard to review this change without looking at the code.

Codewise it's correct:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/ctree.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b3f6f300e492..9fa3d77c98d4 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2432,7 +2432,6 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
>  	btrfs_unlock_up_safe(p, level + 1);
>  	btrfs_set_path_blocking(p);
>  
> -	free_extent_buffer(tmp);
>  	if (p->reada != READA_NONE)
>  		reada_for_search(fs_info, p, level, slot, key->objectid);
>  
> 
