Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45632 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753057AbdI0N6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 09:58:10 -0400
Date: Wed, 27 Sep 2017 15:56:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 6/6] Btrfs: heuristic add byte core set calculation
Message-ID: <20170927135636.GG31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825091845.4120-1-nefelim4ag@gmail.com>
 <20170825091845.4120-7-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825091845.4120-7-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 12:18:45PM +0300, Timofey Titovets wrote:
> Calculate byte core set for data sample:
> Sort bucket's numbers in decreasing order
> Count how many numbers use 90% of sample
> If core set are low (<=25%), data are easily compressible
> If core set high (>=80%), data are not compressible
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/heuristic.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/heuristic.c b/fs/btrfs/heuristic.c
> index ef723e991576..df0cefa42857 100644
> --- a/fs/btrfs/heuristic.c
> +++ b/fs/btrfs/heuristic.c
> @@ -18,6 +18,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/string.h>
>  #include <linux/bio.h>
> +#include <linux/sort.h>
>  #include "compression.h"
> 
>  #define READ_SIZE 16
> @@ -25,6 +26,8 @@
>  #define BUCKET_SIZE 256
>  #define MAX_SAMPLE_SIZE (BTRFS_MAX_UNCOMPRESSED*READ_SIZE/ITER_SHIFT)
>  #define BYTE_SET_THRESHOLD 64
> +#define BYTE_CORE_SET_LOW  BYTE_SET_THRESHOLD
> +#define BYTE_CORE_SET_HIGH 200 // ~80%
> 
>  struct bucket_item {
>  	u32 count;
> @@ -67,6 +70,45 @@ static struct list_head *heuristic_alloc_workspace(void)
>  	return ERR_PTR(-ENOMEM);
>  }
> 
> +/* For bucket sorting */
> +static inline int bucket_compare(const void *lv, const void *rv)
> +{
> +	struct bucket_item *l = (struct bucket_item *)(lv);
> +	struct bucket_item *r = (struct bucket_item *)(rv);
> +
> +	return r->count - l->count;
> +}
> +
> +/*
> + * Byte Core set size
> + * How many bytes use 90% of sample
> + */
> +static int byte_core_set_size(struct workspace *ws)
> +{
> +	u32 a = 0;
> +	u32 coreset_sum = 0;
> +	u32 core_set_threshold = ws->sample_size*90/100;
> +	struct bucket_item *bucket = ws->bucket;
> +
> +	/* Sort in reverse order */
> +	sort(bucket, BUCKET_SIZE, sizeof(*bucket),
> +	     &bucket_compare, NULL);
> +
> +	for (; a < BYTE_CORE_SET_LOW; a++)
> +		coreset_sum += bucket[a].count;
> +
> +	if (coreset_sum > core_set_threshold)
> +		return a;
> +
> +	for (; a < BYTE_CORE_SET_HIGH && bucket[a].count > 0; a++) {
> +		coreset_sum += bucket[a].count;
> +		if (coreset_sum > core_set_threshold)
> +			break;
> +	}
> +
> +	return a;
> +}
> +
>  static u32 byte_set_size(const struct workspace *ws)
>  {
>  	u32 a = 0;
> @@ -164,7 +206,14 @@ static int heuristic(struct list_head *ws, struct inode *inode,
>  	if (a > BYTE_SET_THRESHOLD)
>  		return 2;
> 
> -	return 1;
> +	a = byte_core_set_size(workspace);
> +	if (a <= BYTE_CORE_SET_LOW)
> +		return 3;
> +
> +	if (a >= BYTE_CORE_SET_HIGH)
> +		return 0;
> +
> +	return 4;

So the return value determines guessed compressibility, this could use
some human readable enums or defines.
