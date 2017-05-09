Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31888 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbdEIQ5b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 12:57:31 -0400
Date: Tue, 9 May 2017 09:55:52 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Colin King <colin.king@canonical.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove redundant assignment and check on variable
 ret
Message-ID: <20170509165552.GA15294@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170506220105.13206-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170506220105.13206-1-colin.king@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 06, 2017 at 11:01:05PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable ret is assigned to zero and is always zero throughout the
> function.  Thus the check for ret being less than zero is always
> false and so mapping_set_error always has an -EIO error passed to
> it.  Hence we can remove the redundant assignment and check on ret.
> 
> Detected by CoverityScan, CID#1414312 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/btrfs/extent_io.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d8da3edf2ac3..7922cd34ba82 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2447,7 +2447,6 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>  {
>  	int uptodate = (err == 0);
>  	struct extent_io_tree *tree;
> -	int ret = 0;
>  
>  	tree = &BTRFS_I(page->mapping->host)->io_tree;
>  
> @@ -2458,8 +2457,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
>  	if (!uptodate) {
>  		ClearPageUptodate(page);
>  		SetPageError(page);
> -		ret = ret < 0 ? ret : -EIO;
> -		mapping_set_error(page->mapping, ret);
> +		mapping_set_error(page->mapping, -EIO);

The passed 'err' should be used as what ret did, ie.
ret = err < 0 ? err : -EIO;

Thanks,

-liubo
>  	}
>  }
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
