Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42596 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754051AbcHXXME (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 19:12:04 -0400
Date: Wed, 24 Aug 2016 16:15:50 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix memory leak in reading btree blocks
Message-ID: <20160824231549.GA27943@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1470252781-9455-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470252781-9455-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Wed, Aug 03, 2016 at 12:33:01PM -0700, Liu Bo wrote:
> So we can read a btree block via readahead or intentional read,
> and we can end up with a memory leak when something happens as
> follows,
> 1) readahead starts to read block A but does not wait for read
>    completion,
> 2) btree_readpage_end_io_hook finds that block A is corrupted,
>    and it needs to clear all block A's pages' uptodate bit.
> 3) meanwhile an intentional read kicks in and checks block A's
>    pages' uptodate to decide which page needs to be read.
> 4) when some pages have the uptodate bit during 3)'s check so
>    3) doesn't count them for eb->io_pages, but they are later
>    cleared by 2) so we has to readpage on the page, we get
>    the wrong eb->io_pages which results in a memory leak of
>    this block.
> 
> This fixes the problem by firstly getting all pages's locking and
> then checking pages' uptodate bit.

   t1(readahead)                              t2(readahead endio)                                       t3(the following read)
read_extent_buffer_pages                    end_bio_extent_readpage                                  
  for pg in eb:                                for page 0,1,2 in eb:
      if pg is uptodate:                           btree_readpage_end_io_hook(pg)
          num_reads++                              if uptodate:                                                
  eb->io_pages = num_reads                             SetPageUptodate(pg)              _______________
  for pg in eb:                                for page 3 in eb:                                     read_extent_buffer_pages   
       if pg is NOT uptodate:                      btree_readpage_end_io_hook(pg)                       for pg in eb:
           __extent_read_full_page(pg)                 sanity check reports something wrong                 if pg is uptodate:
                                                       clear_extent_buffer_uptodate(eb)                         num_reads++
                                                           for pg in eb:                                eb->io_pages = num_reads
                                                               ClearPageUptodate(page)  _______________
                                                                                                        for pg in eb:
                                                                                                            if pg is NOT uptodate:
                                                                                                                __extent_read_full_page(pg)

So t3's eb->io_pages is not consistent with the number of pages it's reading, and during endio(), atomic_dec_and_test(&eb->io_pages) will get a negative number so that we're not able to free the eb.

Thanks,

-liubo

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index bd29b9b..a77050e 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5215,11 +5215,20 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
>  			lock_page(page);
>  		}
>  		locked_pages++;
> +	}
> +	/*
> +	 * We need to firstly lock all pages to make sure that
> +	 * the uptodate bit of our pages won't be affected by
> +	 * clear_extent_buffer_uptodate().
> +	 */
> +	for (i = start_i; i < num_pages; i++) {
> +		page = eb->pages[i];
>  		if (!PageUptodate(page)) {
>  			num_reads++;
>  			all_uptodate = 0;
>  		}
>  	}
> +
>  	if (all_uptodate) {
>  		if (start_i == 0)
>  			set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
