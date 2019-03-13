Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD9BC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F37421019
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 17:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfCMRZ7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:25:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:51532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfCMRZ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 13:25:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2445EAD6D
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 17:25:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C6726DA875; Wed, 13 Mar 2019 18:27:10 +0100 (CET)
Date:   Wed, 13 Mar 2019 18:27:10 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Exploit the fact pages passed to extent_readpages
 are always contiguous
Message-ID: <20190313172709.GD31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190311075538.19242-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311075538.19242-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 11, 2019 at 09:55:38AM +0200, Nikolay Borisov wrote:
> Currently extent_readpages (called from btrfs_redpages) will always call
> __extent_readpages which tries to create contiguous range of pages and
> call __do_contiguous_readpages when such contiguous range is created.
> 
> It turns out this is unnecessary due to the fact that generic VFS code
> always calls filesystem's ->readpages callback (btrfs_readpages in
> this case) with already contiguous pages. Armed with this knowledge it's
> possible to simplify extent_readpages by eliminating the call to
> __extent_readpages and directly calling contiguous_readpages. The only
> edge case that needs to be handled is when add_to_page_cache_lru
> fails. This is easy as all that is needed is to submit whatever is the
> number of pages successfully added to the lru.

I'd like to have more details why this is correct. Submitting what we
have so far seems ok, the reasons why add_to_page_cache_lru are unclear
and go back to xarray.

Possible error is EEXSIT, here it's clear that we don't need to read the
pages (already there). A sequence of such pages will make it wildly hop
from 1st for cycle iteration, to the if (nr) check and back.

Previously this looped still in the for-cycle, which was easier to
follow but otherwise not due to __extent_readpages. So I think it's an
improvement in the end, though a few comments would be good there.

Reviewed-by: David Sterba <dsterba@suse.com>

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> I've been running with this patch for the past 3 months and haven't encountered 
> any issues with it.
>  fs/btrfs/extent_io.c | 58 +++++++++++---------------------------------
>  1 file changed, 14 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b20700ad8752..551dd21d7351 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3066,7 +3066,7 @@ static int __do_readpage(struct extent_io_tree *tree,
>  	return ret;
>  }
>  
> -static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
> +static inline void contiguous_readpages(struct extent_io_tree *tree,
>  					     struct page *pages[], int nr_pages,
>  					     u64 start, u64 end,
>  					     struct extent_map **em_cached,
> @@ -3097,46 +3097,6 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
>  	}
>  }
>  
> -static void __extent_readpages(struct extent_io_tree *tree,
> -			       struct page *pages[],
> -			       int nr_pages,
> -			       struct extent_map **em_cached,
> -			       struct bio **bio, unsigned long *bio_flags,
> -			       u64 *prev_em_start)
> -{
> -	u64 start = 0;
> -	u64 end = 0;
> -	u64 page_start;
> -	int index;
> -	int first_index = 0;
> -
> -	for (index = 0; index < nr_pages; index++) {
> -		page_start = page_offset(pages[index]);
> -		if (!end) {
> -			start = page_start;
> -			end = start + PAGE_SIZE - 1;
> -			first_index = index;
> -		} else if (end + 1 == page_start) {
> -			end += PAGE_SIZE;
> -		} else {
> -			__do_contiguous_readpages(tree, &pages[first_index],
> -						  index - first_index, start,
> -						  end, em_cached,
> -						  bio, bio_flags,
> -						  prev_em_start);
> -			start = page_start;
> -			end = start + PAGE_SIZE - 1;
> -			first_index = index;
> -		}
> -	}
> -
> -	if (end)
> -		__do_contiguous_readpages(tree, &pages[first_index],
> -					  index - first_index, start,
> -					  end, em_cached, bio,
> -					  bio_flags, prev_em_start);
> -}
> -
>  static int __extent_read_full_page(struct extent_io_tree *tree,
>  				   struct page *page,
>  				   get_extent_t *get_extent,
> @@ -4098,6 +4058,8 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>  	u64 prev_em_start = (u64)-1;
>  
>  	while (!list_empty(pages)) {
> +		u64 contig_end = 0;
> +
>  		for (nr = 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
>  			struct page *page = lru_to_page(pages);
>  
> @@ -4106,14 +4068,22 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>  			if (add_to_page_cache_lru(page, mapping, page->index,
>  						readahead_gfp_mask(mapping))) {
>  				put_page(page);
> -				continue;
> +				break;
>  			}
>  
>  			pagepool[nr++] = page;
> +			contig_end = page_offset(page) + PAGE_SIZE - 1;
>  		}
>  
> -		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
> -				   &bio_flags, &prev_em_start);
> +		if (nr) {
> +			u64 contig_start = page_offset(pagepool[0]);
> +
> +			ASSERT(contig_start + (nr*PAGE_SIZE) - 1 == contig_end);
> +
> +			contiguous_readpages(tree, pagepool, nr, contig_start,
> +				     contig_end, &em_cached, &bio, &bio_flags,
> +				     &prev_em_start);
> +		}
>  	}
>  
>  	if (em_cached)
> -- 
> 2.17.1
