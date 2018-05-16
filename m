Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751859AbeEPGnN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 02:43:13 -0400
Subject: Re: [PATCH 2/6] Btrfs: use more straightforward
 extent_buffer_uptodate
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526406728-109055-3-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cd21247d-06b9-6154-c151-be37e0d9a1da@suse.com>
Date: Wed, 16 May 2018 09:43:10 +0300
MIME-Version: 1.0
In-Reply-To: <1526406728-109055-3-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 20:52, Liu Bo wrote:
> In read_block_for_search(), it's straightforward to use
> extent_buffer_uptodate() instead since 0 is passed as parent transid to

"instead of the more heavyweight btrfs_buffer_update"

> btrfs_buffer_uptodate(), which means the check for parent transid is not
> needed.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Codewise LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/ctree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 9fa3d77c98d4..a96d308c51b8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2445,7 +2445,7 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
>  		 * and give up so that our caller doesn't loop forever
>  		 * on our EAGAINs.
>  		 */
> -		if (!btrfs_buffer_uptodate(tmp, 0, 0))
> +		if (!extent_buffer_uptodate(tmp))
>  			ret = -EIO;
>  		free_extent_buffer(tmp);
>  	} else {
> 
