Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726955AbeINLh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 07:37:28 -0400
Subject: Re: [PATCH v2] Btrfs: assert page dirty bit
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
 <1536860768-42604-1-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3fe92c76-f4f6-66b3-b235-e89b9f023c59@suse.com>
Date: Fri, 14 Sep 2018 09:24:28 +0300
MIME-Version: 1.0
In-Reply-To: <1536860768-42604-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 20:46, Liu Bo wrote:
> Just in case that someone breaks the rule that pages are dirty as long
> as eb is dirty.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v2: fix typo of CONFIG_BTRFS_DEBUG
> 
>  fs/btrfs/extent_io.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index fb2bf50134a1..f88231171009 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5184,6 +5184,11 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
>  			set_page_dirty(eb->pages[i]);
>  	}
>  
> +#ifdef CONFIG_BTRFS_DEBUG
> +	for (i = 0; i < num_pages; i++)
> +		ASSERT(PageDirty(eb->pages[i]));
> +#endif
> +
>  	return was_dirty;
>  }
>  
> 
