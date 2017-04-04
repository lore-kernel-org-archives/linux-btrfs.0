Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28234 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754009AbdDDRoJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 13:44:09 -0400
Date: Tue, 4 Apr 2017 10:43:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: cleanup submit_one_bio
Message-ID: <20170404174307.GA28932@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1491252347-3827-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491252347-3827-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 01:45:47PM -0700, Liu Bo wrote:
> @bio_offset is passed into submit_bio_hook and is used at
> btrfs_wq_submit_bio(), but only dio code makes use of @bio_offset, so
> remove other dead code.
>

Please ignore this one.

Thanks,

-liubo
> Cc: David Sterba <dsterba@suse.cz>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 7b5139d..79f38e6a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2746,19 +2746,14 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
>  				       unsigned long bio_flags)
>  {
>  	int ret = 0;
> -	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> -	struct page *page = bvec->bv_page;
>  	struct extent_io_tree *tree = bio->bi_private;
> -	u64 start;
> -
> -	start = page_offset(page) + bvec->bv_offset;
>  
>  	bio->bi_private = NULL;
>  	bio_get(bio);
>  
>  	if (tree->ops)
>  		ret = tree->ops->submit_bio_hook(page->mapping->host, bio,
> -					   mirror_num, bio_flags, start);
> +					   mirror_num, bio_flags, 0);
>  	else
>  		btrfsic_submit_bio(bio);
>  
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
