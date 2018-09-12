Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725910AbeILLlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 07:41:55 -0400
Subject: Re: [PATCH] Btrfs: assert page dirty bit
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <65915dec-83d5-d79b-c848-d1f4efce8bb8@suse.com>
Date: Wed, 12 Sep 2018 09:38:49 +0300
MIME-Version: 1.0
In-Reply-To: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2018 01:06, Liu Bo wrote:
> Just in case that someone breaks the rule that pages are dirty as long
> as eb is dirty.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/extent_io.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index fb2bf50134a1..99895f196ecb 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5184,6 +5184,11 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
>  			set_page_dirty(eb->pages[i]);
>  	}
>  
> +#ifdef BTRFS_DEBUG

And this will never be compiled since the actual ifdef name is
"CONFIG_BTRFS_DEBUG"

> +	for (i = 0; i < num_pages; i++)
> +		ASSERT(PageDirty(eb->pages[i]));
> +#endif
> +
>  	return was_dirty;
>  }
>  
> 
