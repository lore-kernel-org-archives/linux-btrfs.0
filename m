Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31401 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdBJWrj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 17:47:39 -0500
Date: Fri, 10 Feb 2017 14:46:09 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Pat Erley <pat-lkml@erley.org>,
        kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: fix btrfs_decompress_buf2page()
Message-ID: <20170210224609.GB30334@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <ab6419ce15ddcbc487db81f2ea40072091bd855d.1486757496.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ab6419ce15ddcbc487db81f2ea40072091bd855d.1486757496.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 12:15:11PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> If btrfs_decompress_buf2page() is handed a bio with its page in the
> middle of the working buffer, then we adjust the offset into the working
> buffer. After we copy into the bio, we advance the iterator by the
> number of bytes we copied. Then, we have some logic to handle the case
> of discontiguous pages and adjust the offset into the working buffer
> again. However, if we didn't advance the bio to a new page, we may enter
> this case in error, essentially repeating the adjustment that we already
> made when we entered the function. The end result is bogus data in the
> bio.
> 
> Previously, we only checked for this case when we advanced to a new
> page, but the conversion to bio iterators changed that. This restores
> the old, correct behavior.

The fix looks good to me, just one comment below.

> 
> Fixes: 974b1adc3b10 ("btrfs: use bio iterators for the decompression handlers")
> Reported-by: Pat Erley <pat-lkml@erley.org>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> A case I saw when testing with zlib was:
> 
>     buf_start = 42769
>     total_out = 46865
>     working_bytes = total_out - buf_start = 4096
>     start_byte = 45056
> 
> 
> The condition (total_out > start_byte && buf_start < start_byte) is
> true, so we adjust the offset:
> 
>     buf_offset = start_byte - buf_start = 2287
>     working_bytes -= buf_offset = 1809
>     current_buf_start = buf_start = 42769
> 
> Then, we copy
> 
>     bytes = min(bvec.bv_len, PAGE_SIZE - buf_offset, working_bytes) = 1809
>     buf_offset += bytes = 4096
>     working_bytes -= bytes = 0
>     current_buf_start += bytes = 44578
> 
> After bio_advance(), we are still in the same page, so start_byte is the
> same. Then, we check (total_out > start_byte && current_buf_start < start_byte),
> which is true! So, we adjust the values again:
> 
>     buf_offset = start_byte - buf_start = 2287
>     working_bytes = total_out - start_byte = 1809
>     current_buf_start = buf_start + buf_offset = 45056
> 
> But note that working_bytes was already zero before this, so we should
> have stopped copying.
> 
>  fs/btrfs/compression.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 7f390849343b..f9f22976d77d 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1072,25 +1072,27 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
>  			return 0;
>  		bvec = bio_iter_iovec(bio, bio->bi_iter);
>  
> -		start_byte = page_offset(bvec.bv_page) - disk_start;
> +		if (bvec.bv_offset == 0) {
> +			start_byte = page_offset(bvec.bv_page) - disk_start;

I'm not fully convinced that the next bvec's bv_offset is always
zero, since the pages are all locked, can we keep a orig_page and
check if (orig_page == bvec.bv_page)?

Thanks,

-liubo
>  
> -		/*
> -		 * make sure our new page is covered by this
> -		 * working buffer
> -		 */
> -		if (total_out <= start_byte)
> -			return 1;
> +			/*
> +			 * make sure our new page is covered by this
> +			 * working buffer
> +			 */
> +			if (total_out <= start_byte)
> +				return 1;
>  
> -		/*
> -		 * the next page in the biovec might not be adjacent
> -		 * to the last page, but it might still be found
> -		 * inside this working buffer. bump our offset pointer
> -		 */
> -		if (total_out > start_byte &&
> -		    current_buf_start < start_byte) {
> -			buf_offset = start_byte - buf_start;
> -			working_bytes = total_out - start_byte;
> -			current_buf_start = buf_start + buf_offset;
> +			/*
> +			 * the next page in the biovec might not be adjacent
> +			 * to the last page, but it might still be found
> +			 * inside this working buffer. bump our offset pointer
> +			 */
> +			if (total_out > start_byte &&
> +			    current_buf_start < start_byte) {
> +				buf_offset = start_byte - buf_start;
> +				working_bytes = total_out - start_byte;
> +				current_buf_start = buf_start + buf_offset;
> +			}
>  		}
>  	}
>  
> -- 
> 2.11.1
> 
