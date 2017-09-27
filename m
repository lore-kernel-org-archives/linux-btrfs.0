Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752967AbdI0NkW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 09:40:22 -0400
Date: Wed, 27 Sep 2017 15:38:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 3/6] Btrfs: implement heuristic sampling logic
Message-ID: <20170927133847.GC31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
 <20170825091845.4120-4-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825091845.4120-4-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 12:18:42PM +0300, Timofey Titovets wrote:
> Copy sample data from input data range to sample buffer
> then calculate byte type count for that sample into bucket.
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/heuristic.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
> index e3924c87af08..5192e51ab81e 100644
> --- a/fs/btrfs/heuristic.c
> +++ b/fs/btrfs/heuristic.c
> @@ -69,8 +69,20 @@ static struct list_head *heuristic_alloc_workspace(void)
>  static int heuristic(struct list_head *ws, struct inode *inode,
>  		     u64 start, u64 end)
>  {
> +	struct workspace *workspace = list_entry(ws, struct workspace, list);
>  	struct page *page;
>  	u64 index, index_end;
> +	u32 a, b;

Please use more descriptive variable names. Using 'i' for simple
iteration is ok.

> +	u8 *in_data, *sample = workspace->sample;
> +	u8 byte;
> +
> +	/*
> +	 * Compression only handle first 128kb of input range
> +	 * And just shift over range in loop for compressing it.
> +	 * Let's do the same.
> +	*/
> +	if (end - start > BTRFS_MAX_UNCOMPRESSED)
> +		end = start + BTRFS_MAX_UNCOMPRESSED;
> 
>  	index = start >> PAGE_SHIFT;
>  	index_end = end >> PAGE_SHIFT;
> @@ -79,13 +91,37 @@ static int heuristic(struct list_head *ws, struct inode *inode,
>  	if (!IS_ALIGNED(end, PAGE_SIZE))
>  		index_end++;
> 
> +	b = 0;
>  	for (; index < index_end; index++) {
>  		page = find_get_page(inode->i_mapping, index);
> -		kmap(page);
> +		in_data = kmap(page);
> +		/* Handle case where start unaligned to PAGE_SIZE */
> +		a = start%PAGE_SIZE;

		a = start % PAGE_SIZE;

> +		while (a < PAGE_SIZE - READ_SIZE) {
> +			/* Prevent sample overflow */
> +			if (b >= MAX_SAMPLE_SIZE)
> +				break;
> +			/* Don't sample mem trash from last page */
> +			if (start > end - READ_SIZE)
> +				break;

I think you can merge the two conditions into one, if you calculate
beforehand where b would overflow 'end -> READ_SIZE'.

> +			memcpy(&sample[b], &in_data[a], READ_SIZE);
> +			a += ITER_SHIFT;
> +			start += ITER_SHIFT;
> +			b += READ_SIZE;
> +		}
>  		kunmap(page);
>  		put_page(page);
>  	}
> 
> +	workspace->sample_size = b;
> +
> +	memset(workspace->bucket, 0, sizeof(*workspace->bucket)*BUCKET_SIZE);
> +
> +	for (a = 0; a < workspace->sample_size; a++) {
> +		byte = sample[a];
> +		workspace->bucket[byte].count++;
> +	}
> +
>  	return 1;
>  }
> 
> --
> 2.14.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
