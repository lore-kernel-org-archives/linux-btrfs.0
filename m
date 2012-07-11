Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34061 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2GKRVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 13:21:25 -0400
Date: Wed, 11 Jul 2012 13:21:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] Btrfs: improve multi-thread buffer read
Message-ID: <20120711172122.GI7529@localhost.localdomain>
References: <1341919679-13792-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341919679-13792-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2012 at 05:27:59AM -0600, Liu Bo wrote:
> While testing with my buffer read fio jobs[1], I find that btrfs does not
> perform well enough.
> 
> Here is a scenario in fio jobs:
> 
> We have 4 threads, "t1 t2 t3 t4", starting to buffer read a same file,
> and all of them will race on add_to_page_cache_lru(), and if one thread
> successfully puts its page into the page cache, it takes the responsibility
> to read the page's data.
> 
> And what's more, reading a page needs a period of time to finish, in which
> other threads can slide in and process rest pages:
> 
>      t1          t2          t3          t4
>    add Page1
>    read Page1  add Page2
>      |         read Page2  add Page3
>      |            |        read Page3  add Page4
>      |            |           |        read Page4
> -----|------------|-----------|-----------|--------
>      v            v           v           v
>     bio          bio         bio         bio
> 
> Now we have four bios, each of which holds only one page since we need to
> maintain consecutive pages in bio.  Thus, we can end up with far more bios
> than we need.
> 
> Here we're going to
> a) delay the real read-page section and
> b) try to put more pages into page cache.
> 
> With that said, we can make each bio hold more pages and reduce the number
> of bios we need.
> 
> Here is some numbers taken from fio results:
>          w/o patch                 w patch
>        -------------  --------  ---------------
> READ:    745MB/s        +32%       987MB/s
> 
> [1]:
> [global]
> group_reporting
> thread
> numjobs=4
> bs=32k
> rw=read
> ioengine=sync
> directory=/mnt/btrfs/
> 
> [READ]
> filename=foobar
> size=2000M
> invalidate=1
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/extent_io.c |   37 +++++++++++++++++++++++++++++++++++--
>  1 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 01c21b6..8f9c18d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3549,6 +3549,11 @@ int extent_writepages(struct extent_io_tree *tree,
>  	return ret;
>  }
>  
> +struct pagelst {
> +	struct page *page;
> +	struct list_head lst;
> +};
> +
>  int extent_readpages(struct extent_io_tree *tree,
>  		     struct address_space *mapping,
>  		     struct list_head *pages, unsigned nr_pages,
> @@ -3557,19 +3562,47 @@ int extent_readpages(struct extent_io_tree *tree,
>  	struct bio *bio = NULL;
>  	unsigned page_idx;
>  	unsigned long bio_flags = 0;
> +	LIST_HEAD(page_pool);
> +	struct pagelst *pagelst = NULL;
>  
>  	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
>  		struct page *page = list_entry(pages->prev, struct page, lru);
>  
>  		prefetchw(&page->flags);
>  		list_del(&page->lru);
> +
> +		if (!pagelst)
> +			pagelst = kmalloc(sizeof(*pagelst), GFP_NOFS);
> +
> +		if (!pagelst) {
> +			page_cache_release(page);
> +			continue;
> +		}

I'd rather not fail here if we can't make an allocation, since it's just a
optimization, just continue on like we normally would.  Thanks,

Josef
