Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933455AbeBMHSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 02:18:53 -0500
Subject: Re: [PATCH] btrfs: extent_buffer_uptodate() make it static and inline
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180213043544.25225-1-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c83c3abd-b9e7-17cf-4ad2-f9666aa63750@suse.com>
Date: Tue, 13 Feb 2018 09:18:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180213043544.25225-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.02.2018 06:35, Anand Jain wrote:
> extent_buffer_uptodate() is a trivial wrapper around test_bit()
> and nothing else. So make it static and inline, save on code
> space and call indirection.
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
> 1131257	  82898	  18992	1233147	 12d0fb	fs/btrfs/btrfs.ko
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
> 1131090	  82898	  18992	1232980	 12d054	fs/btrfs/btrfs.ko
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com> although there is one
nit below

> ---
>  fs/btrfs/extent_io.c | 5 -----
>  fs/btrfs/extent_io.h | 5 ++++-
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index bae57b408901..f300edae044b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5229,11 +5229,6 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
>  	}
>  }
>  
> -int extent_buffer_uptodate(struct extent_buffer *eb)
> -{
> -	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> -}
> -
>  int read_extent_buffer_pages(struct extent_io_tree *tree,
>  			     struct extent_buffer *eb, int wait, int mirror_num)
>  {
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 72e5af2965a8..953d94662b8e 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -489,7 +489,10 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb);
>  int set_extent_buffer_dirty(struct extent_buffer *eb);
>  void set_extent_buffer_uptodate(struct extent_buffer *eb);
>  void clear_extent_buffer_uptodate(struct extent_buffer *eb);
> -int extent_buffer_uptodate(struct extent_buffer *eb);
> +static inline int extent_buffer_uptodate(struct extent_buffer *eb)
> +{
> +	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> +}

nit: It just doesn't look good to have a static inline function
definition among a list of function declarations. A quick look at
extent_io.h shows that this function could have been put below the
inline def of extent_buffer_get.


>  int extent_buffer_under_io(struct extent_buffer *eb);
>  int map_private_extent_buffer(const struct extent_buffer *eb,
>  			      unsigned long offset, unsigned long min_len,
> 
