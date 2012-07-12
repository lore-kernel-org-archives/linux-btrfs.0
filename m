Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44557 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab2GLSEG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 14:04:06 -0400
Date: Thu, 12 Jul 2012 14:04:02 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH v2] Btrfs: improve multi-thread buffer read
Message-ID: <20120712180402.GA30128@shiny>
References: <1342059231-20301-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1342059231-20301-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2012 at 08:13:51PM -0600, Liu Bo wrote:
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
> v1->v2: if we fail to make a allocation, just fall back to the old way to
>         read page.
>  fs/btrfs/extent_io.c |   41 +++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 01c21b6..5c8ab6c 100644
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

I like this patch, its a  big improvement for just a little timing
change.  Instead of doing the kmalloc of this struct, can you please
change it to put a pagevec on the stack.

The model would be:

add a page to the pagevec array
if pagevec full
	launch all the readpages

This lets you avoid the kmalloc, and it is closer to how we solve
similar problems in other parts of the kernel.

Thanks!

-chris
