Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbeINLnk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 07:43:40 -0400
Subject: Re: [PATCH v2] Btrfs: skip set_page_dirty if eb is dirty
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-1-git-send-email-bo.liu@linux.alibaba.com>
 <1536860682-41012-1-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <11d89311-a1a3-7bc6-d5d6-19567a386cbd@suse.com>
Date: Fri, 14 Sep 2018 09:30:38 +0300
MIME-Version: 1.0
In-Reply-To: <1536860682-41012-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 20:44, Liu Bo wrote:
> As long as @eb is marked with EXTENT_BUFFER_DIRTY, all of its pages
> are dirty, so no need to set pages dirty again.
> 
> Ftrace showed that the loop took 10us on my dev box, so removing this
> can save us at least 10us if eb is already dirty.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v2: Update the patch's description.
> 
>  fs/btrfs/extent_io.c | 11 +++++++----
>  fs/btrfs/extent_io.h |  2 +-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 628f1aef34b0..fb2bf50134a1 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5165,11 +5165,11 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
>  	WARN_ON(atomic_read(&eb->refs) == 0);
>  }
>  
> -int set_extent_buffer_dirty(struct extent_buffer *eb)
> +bool set_extent_buffer_dirty(struct extent_buffer *eb)
>  {
>  	int i;
>  	int num_pages;
> -	int was_dirty = 0;
> +	bool was_dirty;
>  
>  	check_buffer_tree_ref(eb);
>  
> @@ -5179,8 +5179,11 @@ int set_extent_buffer_dirty(struct extent_buffer *eb)
>  	WARN_ON(atomic_read(&eb->refs) == 0);
>  	WARN_ON(!test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
>  
> -	for (i = 0; i < num_pages; i++)
> -		set_page_dirty(eb->pages[i]);
> +	if (!was_dirty) {
> +		for (i = 0; i < num_pages; i++)
> +			set_page_dirty(eb->pages[i]);
> +	}
> +
>  	return was_dirty;
>  }
>  
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index b4d03e677e1d..f2ab42d57f02 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -479,7 +479,7 @@ void extent_buffer_bitmap_set(struct extent_buffer *eb, unsigned long start,
>  void extent_buffer_bitmap_clear(struct extent_buffer *eb, unsigned long start,
>  				unsigned long pos, unsigned long len);
>  void clear_extent_buffer_dirty(struct extent_buffer *eb);
> -int set_extent_buffer_dirty(struct extent_buffer *eb);
> +bool set_extent_buffer_dirty(struct extent_buffer *eb);
>  void set_extent_buffer_uptodate(struct extent_buffer *eb);
>  void clear_extent_buffer_uptodate(struct extent_buffer *eb);
>  int extent_buffer_under_io(struct extent_buffer *eb);
> 
