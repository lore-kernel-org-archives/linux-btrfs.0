Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53558 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2GTDg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jul 2012 23:36:28 -0400
Date: Fri, 20 Jul 2012 05:36:10 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: David Sterba <dave@jikos.cz>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, JBacik@fusionio.com
Subject: Re: [PATCH v3] Btrfs: improve multi-thread buffer read
Message-ID: <20120720033610.GF17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120718115735.GI11226@twin.jikos.cz>
 <50075EAA.9030806@cn.fujitsu.com>
 <20120719020518.GE17430@twin.jikos.cz>
 <50077169.4070203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50077169.4070203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 10:31:05AM +0800, Liu Bo wrote:
> > 128 is too much, this would snip 128 * 8 = 1K off the stack.
> 
> That's why I give up 128. :)

It's good as a reference point, nobody says it should stay at 128.

> >> But as Chris suggested, my test is really a race case in practical use, half of improvement
> >> is somehow enough, so we turn to use pagevec struct because it is closer to how we solve
> >> similar problems in other parts of the kernel.
> > 
> > Yes it's an optimization, nice and simple one, but I don't see the
> > use of pagevec justified. By the other parts of kernel is probably meant
> > memory management, and pagevec's are used along with lookups to inode
> > mappings, plus there are other sideefects on pagecache (like calling
> > lru_add_drain() from pagevec_release, as can be seen in your code).
> > 
> > Filesystems can use pagevec_lookup instead of find_get_pages,
> > like ext4 does, but btrfs uses simple arrays of 16 pages, in
> > lock_delalloc_pages, end_compressed_writeback, __unlock_for_delalloc and
> > extent_clear_unlock_delalloc (in connection with find_get_pages).
> > 
> > I was specifically interested in benchmarking pagevec used as in V3
> > against simple array with 16 elements, but now that I looked around
> > while writing this mail, I think that pagevec is not the way to go.
> > 
> 
> Sorry, I see no difference between 16 pages array and pagevec(14 pages),

The difference is 2 pages, at least. Besides [quoting patch from the
first post for reference]

> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3557,7 +3557,10 @@ int extent_readpages(struct extent_io_tree *tree,
>         struct bio *bio = NULL;
>         unsigned page_idx;
>         unsigned long bio_flags = 0;
> +       struct pagevec pvec;
> +       int i = 0;
> 
> +       pagevec_init(&pvec, 0);
>         for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>                 struct page *page = list_entry(pages->prev, struct page, lru);
> 
> @@ -3565,11 +3568,22 @@ int extent_readpages(struct extent_io_tree *tree,
>                 list_del(&page->lru);
>                 if (!add_to_page_cache_lru(page, mapping,
>                                         page->index, GFP_NOFS)) {
> -                       __extent_read_full_page(tree, page, get_extent,
> +                       page_cache_get(page);
> +                       if (pagevec_add(&pvec, page) == 0) {
> +                               for (i = 0; i < pagevec_count(&pvec); i++)
> +                                       __extent_read_full_page(tree,
> +                                               pvec.pages[i], get_extent,
>                                                 &bio, 0, &bio_flags);
> +                               pagevec_release(&pvec);
                                  ^^^^^^^^^^^^^^^^^^^^^^
here

> +                       }
>                 }
>                 page_cache_release(page);
>         }
> +       for (i = 0; i < pagevec_count(&pvec); i++)
> +               __extent_read_full_page(tree, pvec.pages[i], get_extent,
> +                                       &bio, 0, &bio_flags);
> +       pagevec_release(&pvec);
          ^^^^^^^^^^^^^^^^^^^^^^
and here

> +
>         BUG_ON(!list_empty(pages));
>         if (bio)
>                 return submit_one_bio(READ, bio, 0, bio_flags);

you actually call pagevec_release. And I pointed out that this is not a
simple operation (like the other pagevec_* functions just doing some
arithmetics) -- it calls lru_add_drain(), this does lots of things with
pagecache and LRU lists, follow the call chain from there if you don't
believe me.

> and I have no idea why ext4 use 16 pages array(maybe historical
> reasons),

sigh, I didn't say that ext4 uses 16 pointer array, quite the opposite:

> > like ext4 does, but btrfs uses simple arrays of 16 pages, in
> > lock_delalloc_pages, end_compressed_writeback, __unlock_for_delalloc and
> > extent_clear_unlock_delalloc (in connection with find_get_pages).

> but IMO it is proper and natural to use pagevec to manage pages.

As you've benchmarked, the more pages one can batch here at once the
better and I don't see why we should miss the opportunity for 2 another
pages just because it's shorter/nicer to write it via pagevec's.


david
