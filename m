Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6008 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750748AbdCGGB0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 01:01:26 -0500
Subject: Re: [PATCH] Btrfs: fix regression in lock_delalloc_pages
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1488853256-10867-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <da692faa-b89c-9740-b599-2d0f7284cc1c@cn.fujitsu.com>
Date: Tue, 7 Mar 2017 13:54:31 +0800
MIME-Version: 1.0
In-Reply-To: <1488853256-10867-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/07/2017 10:20 AM, Liu Bo wrote:
> The bug is a regression after commit
> (da2c7009f6ca "btrfs: teach __process_pages_contig about PAGE_LOCK operation")
> and commit
> (76c0021db8fd "Btrfs: use helper to simplify lock/unlock pages").
>
> So if the dirty pages which are under writeback got truncated partially
> before we lock the dirty pages, we couldn't find all pages mapping to the
> delalloc range, and the bug didn't return an error so it kept going on and
> found that the delalloc range got truncated and got to unlock the dirty
> pages, and then the ASSERT could caught the error, and showed
>
> -----------------------------------------------------------------------------
> assertion failed: page_ops & PAGE_LOCK, file: fs/btrfs/extent_io.c, line: 1716
> -----------------------------------------------------------------------------

We also triggered such bug when running xfstests btrfs/070, although 
possibility is somewhat low.

However since it's more about possibility, any fsstress may trigger it 
though.

Thanks,
Qu

>
> This fixes the bug by returning the proper -EAGAIN.
>
> Cc: David Sterba <dsterba@suse.com>
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 28e8192..8df7974 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1714,7 +1714,8 @@ static int __process_pages_contig(struct address_space *mapping,
>  			 * can we find nothing at @index.
>  			 */
>  			ASSERT(page_ops & PAGE_LOCK);
> -			return ret;
> +			err = -EAGAIN;
> +			goto out;
>  		}
>
>  		for (i = 0; i < ret; i++) {
>


