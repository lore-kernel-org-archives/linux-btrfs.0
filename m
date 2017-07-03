Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48123 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755627AbdGCRbx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Jul 2017 13:31:53 -0400
Date: Mon, 3 Jul 2017 19:30:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/2] Btrfs: add heuristic method for make decision
 compress or not compress
Message-ID: <20170703173040.GB2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170701165602.31189-1-nefelim4ag@gmail.com>
 <20170701165602.31189-3-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170701165602.31189-3-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 01, 2017 at 07:56:02PM +0300, Timofey Titovets wrote:
> Add a heuristic computation before compression,
> for avoiding load resource heavy compression workspace,
> if data are probably can't be compressed
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> --- /dev/null
> +++ b/fs/btrfs/heuristic.c

For the new heuristic-related code, please use the compression.h and .c
files and don't add a new one. When we're going to add the clever
heuristics, that could go to a separate file.

> @@ -0,0 +1,336 @@
> +enum compression_advice btrfs_compress_heuristic(struct inode *inode,

This returns enum but the caller treats it as a bool, this should be
synced up.

> +	u64 start, u64 end)
> +{
> +	enum compression_advice ret = COMPRESS_COST_UNKNOWN;
> +	u64 input_size = end - start;
> +	u64 index = start >> PAGE_SHIFT;
> +	u64 end_index = end >> PAGE_SHIFT;
> +	struct page *page;
> +	u32 a, b, c;
> +	u32 offset_count, shift, sample_size;
> +	u8 *sample;
> +	u8 *input_data;
> +
> +	/*
> +	 * In data: 128K  64K   32K   4K
> +	 * Sample:  4096b 3072b 2048b 1024b
> +	 * Avoid allocating array bigger then 4kb
> +	 */
> +	if (input_size >= 96*1024)
> +		offset_count = 256;
> +	else
> +		offset_count = 64 + input_size/512;
> +
> +	shift = input_size/offset_count;
> +	sample_size = offset_count*READ_SIZE;
> +
> +	/*
> +	 * speedup by copy data to sample array +30%
> +	 * I think it's because of memcpy optimizations and
> +	 * cpu cache hits
> +	 */
> +	sample = kmalloc(sample_size, GFP_NOFS);
> +	if (!sample)
> +		goto out;
> +
> +	/* Read small subset of data 1024b-4096b */
> +	a = 0; b = 0;
> +	while (index <= end_index) {
> +		page = find_get_page(inode->i_mapping, index);
> +		input_data = kmap(page);
> +		c = 0;
> +		while (c < PAGE_SIZE - READ_SIZE) {
> +			if (a >= input_size  - READ_SIZE)
> +				break;
> +			if (b >= sample_size - READ_SIZE)
> +				break;
> +			memcpy(&sample[b], &input_data[c], READ_SIZE);
> +			c += shift;
> +			a += shift;
> +			b += READ_SIZE;
> +		}
> +		kunmap(page);
> +		put_page(page);
> +		index++;
> +	}

As mentioned in the previous mail, we'll add the skeleton code only for
now, which means this loop, that simply calls find_get_page, kunmap and
put_page.

> +
> +	ret = ___btrfs_compress_heuristic(sample, sample_size);
> +
> +out:
> +	kfree(sample);
> +	return ret;
> +}
> diff --git a/fs/btrfs/heuristic.h b/fs/btrfs/heuristic.h
> new file mode 100644
> index 000000000000..3565a6219b2a
> --- /dev/null
> +++ b/fs/btrfs/heuristic.h
> @@ -0,0 +1,14 @@
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/fs.h>
> +
> +enum compression_advice {
> +	COMPRESS_NONE,
> +	COMPRESS_COST_UNKNOWN,
> +	COMPRESS_COST_EASY,
> +	COMPRESS_COST_MEDIUM,
> +	COMPRESS_COST_HARD

I don't find the naming good, as the cost is not easy or hard, but
rather low/medium/high. Or you can rename the whole prefix if you find a
better naming scheme.

> +};
> +
> +enum compression_advice btrfs_compress_heuristic(struct inode *inode,
> +	u64 start, u64 end);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ef3c98c527c1..19654a83da36 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -60,6 +60,7 @@
>  #include "props.h"
>  #include "qgroup.h"
>  #include "dedupe.h"
> +#include "heuristic.h"
> 
>  struct btrfs_iget_args {
>  	struct btrfs_key *location;
> @@ -458,16 +459,16 @@ static noinline void compress_file_range(struct inode *inode,
>  	unsigned long total_compressed = 0;
>  	unsigned long total_in = 0;
>  	int i;
> -	int will_compress;
> +	bool will_compress;

Please remove this change.

>  	int compress_type = fs_info->compress_type;
> -	int redirty = 0;
> +	bool redirty = false;

And this.

>  	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
>  			SZ_16K);
> 
>  	actual_end = min_t(u64, isize, end + 1);
>  again:
> -	will_compress = 0;
> +	will_compress = false;
>  	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
>  	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
>  	nr_pages = min_t(unsigned long, nr_pages,
> @@ -510,15 +511,6 @@ static noinline void compress_file_range(struct inode *inode,
>  	 */
>  	if (inode_need_compress(inode)) {
>  		WARN_ON(pages);
> -		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> -		if (!pages) {
> -			/* just bail out to the uncompressed code */
> -			goto cont;
> -		}
> -
> -		if (BTRFS_I(inode)->force_compress)
> -			compress_type = BTRFS_I(inode)->force_compress;
> -
>  		/*
>  		 * we need to call clear_page_dirty_for_io on each
>  		 * page in the range.  Otherwise applications with the file
> @@ -529,7 +521,23 @@ static noinline void compress_file_range(struct inode *inode,
>  		 * dirty again later on.
>  		 */
>  		extent_range_clear_dirty_for_io(inode, start, end);
> -		redirty = 1;
> +		redirty = true;
> +
> +		ret = btrfs_compress_heuristic(inode, start, end);
> +
> +		/* Heuristic say: dont try compress that */
> +		if (!ret)
> +			goto cont;
> +
> +		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> +		if (!pages) {
> +			/* just bail out to the uncompressed code */
> +			goto cont;
> +		}
> +
> +		if (BTRFS_I(inode)->force_compress)
> +			compress_type = BTRFS_I(inode)->force_compress;
> +
>  		ret = btrfs_compress_pages(compress_type,
>  					   inode->i_mapping, start,
>  					   pages,
> @@ -552,7 +560,7 @@ static noinline void compress_file_range(struct inode *inode,
>  				       PAGE_SIZE - offset);
>  				kunmap_atomic(kaddr);
>  			}
> -			will_compress = 1;
> +			will_compress = true;
>  		}
>  	}
