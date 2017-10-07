Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21430 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdJGAPk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 20:15:40 -0400
Date: Fri, 6 Oct 2017 17:11:38 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: rename page offset parameter in
 submit_extent_page
Message-ID: <20171007001138.GE19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1507292872.git.dsterba@suse.com>
 <80af91917eb8f96c17af38deccbd9c96687841ca.1507292872.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <80af91917eb8f96c17af38deccbd9c96687841ca.1507292872.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 02:29:58PM +0200, David Sterba wrote:
> We're going to remove sector_t and will use 'offset', so this patch
> frees the name.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 12ab19a4b93e..ea9ab934794b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2762,7 +2762,7 @@ static int merge_bio(struct extent_io_tree *tree, struct page *page,
>  static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
>  			      struct writeback_control *wbc,
>  			      struct page *page, sector_t sector,
> -			      size_t size, unsigned long offset,
> +			      size_t size, unsigned long pg_offset,
>  			      struct block_device *bdev,
>  			      struct bio **bio_ret,
>  			      bio_end_io_t end_io_func,
> @@ -2786,8 +2786,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
>  
>  		if (prev_bio_flags != bio_flags || !contig ||
>  		    force_bio_submit ||
> -		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
> -		    bio_add_page(bio, page, page_size, offset) < page_size) {
> +		    merge_bio(tree, page, pg_offset, page_size, bio, bio_flags) ||
> +		    bio_add_page(bio, page, page_size, pg_offset) < page_size) {
>  			ret = submit_one_bio(bio, mirror_num, prev_bio_flags);
>  			if (ret < 0) {
>  				*bio_ret = NULL;
> @@ -2802,7 +2802,7 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
>  	}
>  
>  	bio = btrfs_bio_alloc(bdev, sector << 9);
> -	bio_add_page(bio, page, page_size, offset);
> +	bio_add_page(bio, page, page_size, pg_offset);
>  	bio->bi_end_io = end_io_func;
>  	bio->bi_private = tree;
>  	bio->bi_write_hint = page->mapping->host->i_write_hint;

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
