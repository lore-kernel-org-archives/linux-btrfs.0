Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20528 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbdBNTL0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:11:26 -0500
Date: Tue, 14 Feb 2017 11:10:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/29] btrfs: remove unused parameter from
 submit_extent_page
Message-ID: <20170214191031.GC31091@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <ac49126de7d3f5dbdea72584f46befd549d084f4.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac49126de7d3f5dbdea72584f46befd549d084f4.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:04AM +0100, David Sterba wrote:
> This used to hold number of maximum pages to allocate, but this is now
> limited by BIO_MAX_PAGES.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9df6ed30de00..00f3be5c4f2d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2759,7 +2759,6 @@ static int submit_extent_page(int op, int op_flags, struct extent_io_tree *tree,
>  			      size_t size, unsigned long offset,
>  			      struct block_device *bdev,
>  			      struct bio **bio_ret,
> -			      unsigned long max_pages,
>  			      bio_end_io_t end_io_func,
>  			      int mirror_num,
>  			      unsigned long prev_bio_flags,
> @@ -3063,7 +3062,7 @@ static int __do_readpage(struct extent_io_tree *tree,
>  		pnr -= page->index;
>  		ret = submit_extent_page(REQ_OP_READ, read_flags, tree, NULL,
>  					 page, sector, disk_io_size, pg_offset,
> -					 bdev, bio, pnr,
> +					 bdev, bio,
>  					 end_bio_extent_readpage, mirror_num,
>  					 *bio_flags,
>  					 this_bio_flag,

@pnr is only used here, it can be removed, too.

> @@ -3434,7 +3433,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
>  
>  		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
>  					 page, sector, iosize, pg_offset,
> -					 bdev, &epd->bio, max_nr,
> +					 bdev, &epd->bio,
>  					 end_bio_extent_writepage,
>  					 0, 0, 0, false);
>  		if (ret) {

So does @max_nr.

With removing those two,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> @@ -3751,7 +3750,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>  		set_page_writeback(p);
>  		ret = submit_extent_page(REQ_OP_WRITE, write_flags, tree, wbc,
>  					 p, offset >> 9, PAGE_SIZE, 0, bdev,
> -					 &epd->bio, -1,
> +					 &epd->bio,
>  					 end_bio_extent_buffer_writepage,
>  					 0, epd->bio_flags, bio_flags, false);
>  		epd->bio_flags = bio_flags;
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
