Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:37131 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756331AbdGXOz2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:55:28 -0400
Received: by mail-qt0-f194.google.com with SMTP id d10so517635qtb.4
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 07:55:28 -0700 (PDT)
Date: Mon, 24 Jul 2017 10:55:26 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] Btrfs: heuristic add simple sampling logic
Message-ID: <20170724145526.GD9406@destiny>
References: <20170724113708.18088-1-nefelim4ag@gmail.com>
 <20170724113708.18088-2-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170724113708.18088-2-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:37:06PM +0300, Timofey Titovets wrote:
> Get small sample from input data
> and calculate byte type count for that sample
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 24 ++++++++++++++++++++++--
>  fs/btrfs/compression.h | 11 +++++++++++
>  2 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 63f54bd2d5bb..1501d4fe90cc 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -1068,15 +1068,35 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
>  	u64 index = start >> PAGE_SHIFT;
>  	u64 end_index = end >> PAGE_SHIFT;
>  	struct page *page;
> -	int ret = 1;
> +	struct heuristic_bucket_item *bucket;
> +	int a, b, ret;
> +	u8 symbol, *input_data;
> +
> +	ret = 1;
> +
> +	bucket = kcalloc(BTRFS_HEURISTIC_BUCKET_SIZE,
> +		sizeof(struct heuristic_bucket_item), GFP_NOFS);
> +
> +	if (!bucket)
> +		goto out;
>  
>  	while (index <= end_index) {
>  		page = find_get_page(inode->i_mapping, index);
> -		kmap(page);
> +		input_data = kmap(page);
> +		a = 0;
> +		while (a < PAGE_SIZE) {
> +			for (b = 0; b < BTRFS_HEURISTIC_READ_SIZE; b++) {
> +				symbol = input_data[a+b];
> +				bucket[symbol].count++;
> +			}
> +			a += BTRFS_HEURISTIC_ITERATOR_OFFSET;
> +		}
>  		kunmap(page);
>  		put_page(page);
>  		index++;
>  	}
>  
> +out:
> +	kfree(bucket);
>  	return ret;
>  }
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index d1f4eee2d0af..984943e5e1ae 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -129,6 +129,17 @@ struct btrfs_compress_op {
>  extern const struct btrfs_compress_op btrfs_zlib_compress;
>  extern const struct btrfs_compress_op btrfs_lzo_compress;
>  
> +struct heuristic_bucket_item {
> +       u8  padding;
> +       u8  symbol;
> +       u16 count;
> +};
> +
> +#define BTRFS_HEURISTIC_READ_SIZE 16
> +#define BTRFS_HEURISTIC_READS_PER_PAGE 8*PAGE_SIZE/4096

I hate magic numbers, why is this 8*PAGE_SIZE/4096?  If you want to check every
512 bytes why not just set BTRFS_HEURISTIC_ITERATOR_OFFSET to 512?  That makes
it easier to understand what you are trying to accomplish.  Thanks,

Josef
