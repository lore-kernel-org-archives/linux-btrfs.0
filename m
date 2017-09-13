Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35732 "EHLO
        emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdIMJjK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 05:39:10 -0400
Date: Wed, 13 Sep 2017 12:33:06 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: peterh <peterh@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: incremental send, apply asynchronous page cache
 readahead
Message-ID: <20170913093306.GJ4090@reaktio.net>
References: <1505284729-11844-1-git-send-email-peterh@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505284729-11844-1-git-send-email-peterh@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Sep 13, 2017 at 02:38:49PM +0800, peterh wrote:
> From: Kuanling Huang <peterh@synology.com>
> 
> By analyzing the perf on btrfs send, we found it take large
> amount of cpu time on page_cache_sync_readahead. This effort
> can be reduced after switching to asynchronous one. Overall
> performance gain on HDD and SSD were 9 and 15 respectively if
> simply send a large file.
>

hmm, 9 and 15 what?


-- Pasi
 
> Signed-off-by: Kuanling Huang <peterh@synology.com>
> ---
>  fs/btrfs/send.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 63a6152..ac67ff6 100644
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
> +			page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
> +			if (unlikely(!page)) {
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
> -- 
> 1.9.1
> 
