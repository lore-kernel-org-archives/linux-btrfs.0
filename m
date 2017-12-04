Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752907AbdLDUtr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 15:49:47 -0500
Date: Mon, 4 Dec 2017 21:47:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: heuristic replace heap sort with radix sort
Message-ID: <20171204204748.GE3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171203213033.28258-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171203213033.28258-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 12:30:33AM +0300, Timofey Titovets wrote:
> Slowest part of heuristic for now is kernel heap sort()
> It's can take up to 55% of runtime on sorting bucket items.
> 
> As sorting will always call on most data sets to get correctly
> byte_core_set_size, the only way to speed up heuristic, is to
> speed up sort on bucket.
> 
> Add a general radix_sort function.
> Radix sort require 2 buffers, one full size of input array
> and one for store counters (jump addresses).
> 
> That increase usage per heuristic workspace +1KiB
> 8KiB + 1KiB -> 8KiB + 2KiB
> 
> That is LSD Radix, i use 4 bit as a base for calculating,
> to make counters array acceptable small (16 elements * 8 byte).
> 
> That Radix sort implementation have several points to adjust,
> I added him to make radix sort general usable in kernel,
> like heap sort, if needed.
> 
> Performance tested in userspace copy of heuristic code,
> throughput:
>     - average <-> random data: ~3500 MiB/s - heap  sort
>     - average <-> random data: ~6000 MiB/s - radix sort
> 
> Changes:
>   v1 -> v2:
>     - Tested on Big Endian
>     - Drop most of multiply operations
>     - Separately allocate sort buffer
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/compression.c | 147 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 140 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ae016699d13e..19b52982deda 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -33,7 +33,6 @@
>  #include <linux/bit_spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/sched/mm.h>
> -#include <linux/sort.h>
>  #include <linux/log2.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -752,6 +751,8 @@ struct heuristic_ws {
>  	u32 sample_size;
>  	/* Buckets store counters for each byte value */
>  	struct bucket_item *bucket;
> +	/* Sorting buffer */
> +	struct bucket_item *bucket_b;
>  	struct list_head list;
>  };
>  
> @@ -763,6 +764,7 @@ static void free_heuristic_ws(struct list_head *ws)
>  
>  	kvfree(workspace->sample);
>  	kfree(workspace->bucket);
> +	kfree(workspace->bucket_b);
>  	kfree(workspace);
>  }
>  
> @@ -782,6 +784,10 @@ static struct list_head *alloc_heuristic_ws(void)
>  	if (!ws->bucket)
>  		goto fail;
>  
> +	ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), GFP_KERNEL);
> +	if (!ws->bucket_b)
> +		goto fail;
> +
>  	INIT_LIST_HEAD(&ws->list);
>  	return &ws->list;
>  fail:
> @@ -1278,13 +1284,136 @@ static u32 shannon_entropy(struct heuristic_ws *ws)
>  	return entropy_sum * 100 / entropy_max;
>  }
>  
> -/* Compare buckets by size, ascending */
> -static int bucket_comp_rev(const void *lv, const void *rv)
> +#define RADIX_BASE 4
> +#define COUNTERS_SIZE (1 << RADIX_BASE)
> +
> +static inline uint8_t get4bits(uint64_t num, int shift) {
> +	uint8_t low4bits;
> +	num = num >> shift;
> +	/* Reverse order */
> +	low4bits = (COUNTERS_SIZE - 1) - (num % COUNTERS_SIZE);
> +	return low4bits;
> +}
> +
> +static inline void copy_cell(void *dst, int dest_i, void *src, int src_i)
>  {
> -	const struct bucket_item *l = (const struct bucket_item *)lv;
> -	const struct bucket_item *r = (const struct bucket_item *)rv;
> +	struct bucket_item *dstv = (struct bucket_item *) dst;
> +	struct bucket_item *srcv = (struct bucket_item *) src;
> +	dstv[dest_i] = srcv[src_i];
> +}
>  
> -	return r->count - l->count;
> +static inline uint64_t get_num(const void *a, int i)
> +{
> +	struct bucket_item *av = (struct bucket_item *) a;
> +	return av[i].count;
> +}
> +
> +/*
> + * Use 4 bits as radix base
> + * Use 16 uint64_t counters for calculating new possition in buf array
> + *
> + * @array     - array that will be sorted
> + * @array_buf - buffer array to store sorting results
> + *              must be equal in size to @array
> + * @num       - array size
> + * @max_cell  - Link to element with maximum possible value
> + *              that can be used to cap radix sort iterations
> + *              if we know maximum value before call sort
> + * @get_num   - function to extract number from array
> + * @copy_cell - function to copy data from array to array_buf
> + *              and vise versa
> + * @get4bits  - function to get 4 bits from number at specified offset
> + */
> +
> +static void radix_sort(void *array, void *array_buf,
> +		       int num,
> +		       const void *max_cell,
> +		       uint64_t (*get_num)(const void *, int i),
> +		       void (*copy_cell)(void *dest, int dest_i,
> +					 void* src, int src_i),
> +		       uint8_t (*get4bits)(uint64_t num, int shift))

Do you have plans to use this function further? If not, passing the
callbacks (copy_cell and get4bits) is not necessary and can be
opencoded.
