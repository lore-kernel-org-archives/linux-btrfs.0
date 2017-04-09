Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34277 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752350AbdDIRII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 13:08:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id x75so5984549wma.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Apr 2017 10:08:07 -0700 (PDT)
Subject: Re: [PATCH] Btrfs: fix segment fault when doing dio read
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1491595870-9633-1-git-send-email-bo.li.liu@oracle.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <5afa50b0-2e6c-d3fa-4dd8-dedbdf1af8b4@gmail.com>
Date: Sun, 9 Apr 2017 20:08:05 +0300
MIME-Version: 1.0
In-Reply-To: <1491595870-9633-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.04.2017 23:11, Liu Bo wrote:
> Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> introduced this bug during iterating bio pages in dio read's endio hook,
> and it could end up with segment fault of the dio reading task.
> 
> So the reason is 'if (nr_sectors--)', and it makes the code assume that
> there is one more block in the same page, so page offset is increased and
> the bio which is created to repair the bad block then has an incorrect
> bvec.bv_offset, and a later access of the page content would throw a
> segment fault.
> 
> This also adds ASSERT to check page offset against page size.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c875e68..5e71f1e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7972,8 +7972,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
>  
>  		start += sectorsize;
>  
> -		if (nr_sectors--) {
> +		nr_sectors--;
Why not if(--nr_sectors)? I know it's more of a style issue but it will
reduce the size of the diff ?
> +		if (nr_sectors) {
>  			pgoff += sectorsize;
> +			ASSERT(pgoff < PAGE_SIZE);
>  			goto next_block_or_try_again;
>  		}
>  	}
> @@ -8074,8 +8076,10 @@ static int __btrfs_subio_endio_read(struct inode *inode,
>  
>  		ASSERT(nr_sectors);
>  
> -		if (--nr_sectors) {
> +		nr_sectors--;
> +		if (nr_sectors) {
>  			pgoff += sectorsize;
> +			ASSERT(pgoff < PAGE_SIZE);
>  			goto next_block;
>  		}
>  	}
> 
