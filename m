Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46929 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761949AbcLVGVy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 01:21:54 -0500
Date: Wed, 21 Dec 2016 22:20:44 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-kernel@vger.kernel.org, fdmanana@suse.com, naota@elisp.net
Subject: Re: [PATCH] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20161222062044.GC11373@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481870510-44290-1-git-send-email-takafumi.kubota1012@sslab.ics.keio.ac.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 03:41:50PM +0900, Takafumi Kubota wrote:
> This is actually inspired by Filipe's patch(55e3bd2e0c2e1).
> 
> When submit_extent_page() in __extent_writepage_io() fails,
> Btrfs misses clearing a writeback bit of the failed page.
> This causes the false under-writeback page.
> Then, another sync task hangs in filemap_fdatawait_range(),
> because it waits the false under-writeback page.
> 
> CPU0                            CPU1
> 
> __extent_writepage_io()
>   ret = submit_extent_page() // fail
> 
>   if (ret)
>     SetPageError(page)
>     // miss clearing the writeback bit
> 
>                                 sync()
>                                   ...
>                                   filemap_fdatawait_range()
>                                     wait_on_page_writeback(page);
>                                     // wait the false under-writeback page
> 
> Signed-off-by: Takafumi Kubota <takafumi.kubota1012@sslab.ics.keio.ac.jp>
> ---
>  fs/btrfs/extent_io.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1e67723..ef9793b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3443,8 +3443,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  					 bdev, &epd->bio, max_nr,
>  					 end_bio_extent_writepage,
>  					 0, 0, 0, false);
> -		if (ret)
> +		if (ret) {
>  			SetPageError(page);
> +			end_page_writeback(page);
> +		}

OK...this could be complex as we don't know which part in
submit_extent_page gets the error, if the page has been added into bio
and bio_end would call end_page_writepage(page) as well, so whichever
comes later, the BUG() in end_page_writeback() would complain.

Looks like commit 55e3bd2e0c2e1 also has the same problem although I
gave it my reviewed-by.

Thanks,

-liubo

>  
>  		cur = cur + iosize;
>  		pg_offset += iosize;
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
