Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43923 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934640AbdIYMMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 08:12:39 -0400
Subject: Re: [PATCH] Btrfs: send, apply asynchronous page cache readahead to
 enhance page read
To: peterh <peterh@synology.com>, linux-btrfs@vger.kernel.org
References: <1505465265-9764-1-git-send-email-peterh@synology.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <915d8979-3255-d4e9-3960-a051372f23da@suse.com>
Date: Mon, 25 Sep 2017 15:12:36 +0300
MIME-Version: 1.0
In-Reply-To: <1505465265-9764-1-git-send-email-peterh@synology.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.09.2017 11:47, peterh wrote:
> From: Kuanling Huang <peterh@synology.com>
> 
> By analyzing the perf on btrfs send, we found it take large
> amount of cpu time on page_cache_sync_readahead. This effort
> can be reduced after switching to asynchronous one. Overall
> performance gain on HDD and SSD were 9 and 15 percent if
> simply send a large file.
> 
> Signed-off-by: Kuanling Huang <peterh@synology.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/send.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 63a6152..7a5eb66 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4475,16 +4475,27 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
>  	/* initial readahead */
>  	memset(&sctx->ra, 0, sizeof(struct file_ra_state));
>  	file_ra_state_init(&sctx->ra, inode->i_mapping);
> -	btrfs_force_ra(inode->i_mapping, &sctx->ra, NULL, index,
> -		       last_index - index + 1);
>  
>  	while (index <= last_index) {
>  		unsigned cur_len = min_t(unsigned, len,
>  					 PAGE_CACHE_SIZE - pg_offset);
> -		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> +		page = find_lock_page(inode->i_mapping, index);
>  		if (!page) {
> -			ret = -ENOMEM;
> -			break;
> +			page_cache_sync_readahead(inode->i_mapping,
> +				&sctx->ra, NULL, index,
> +				last_index + 1 - index);
> +
> +			page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
> +			if (!page) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +		}
> +
> +		if (PageReadahead(page)) {
> +			page_cache_async_readahead(inode->i_mapping,
> +				&sctx->ra, NULL, page, index,
> +				last_index + 1 - index);
>  		}
>  
>  		if (!PageUptodate(page)) {
> 
