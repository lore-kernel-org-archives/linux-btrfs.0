Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50012 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcABLkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jan 2016 06:40:52 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Sanidhya Solanki <jpage.lkml@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds the files and options needed for Hybrid Storage
Date: Sat, 02 Jan 2016 12:40:46 +0100
Message-ID: <3527511.yiKDscxFVa@merkaba>
In-Reply-To: <1451704112-25463-1-git-send-email-jpage.lkml@gmail.com>
References: <1451704112-25463-1-git-send-email-jpage.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am Freitag, 1. Januar 2016, 22:08:32 CET schrieb Sanidhya Solanki:
> This patch adds the file required for Hybrid Storage. It contains
> the memory, time and size limits for the cache and the statistics that
> will be provided while the cache is operating.
> It also adds the Makefile changes needed to add the Hybrid Storage.

Is this about what I think it is – using flash as cache for a BTRFS filesystem 
on rotational disk? I ask cause the last time I saw patched regarding they 
consisted of patches to add hot data tracking to VFS and BTRFS to support 
setting up an SSD to use for hot data.

Or is this something different?

Happy New Year and thanks,
Martin

> Signed-off-by: Sanidhya Solanki <jpage.lkml@gmail.com>
> ---
>  fs/btrfs/Makefile |  2 +-
>  fs/btrfs/cache.c  | 58
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++ 2 files changed, 59
> insertions(+), 1 deletion(-)
>  create mode 100644 fs/btrfs/cache.c
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index 6d1d0b9..dc56ae4 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o
> root-tree.o dir-item.o \ export.o tree-log.o free-space-cache.o zlib.o
> lzo.o \
>  	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
>  	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
> -	   uuid-tree.o props.o hash.o
> +	   uuid-tree.o props.o hash.o cache.o
> 
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
> diff --git a/fs/btrfs/cache.c b/fs/btrfs/cache.c
> new file mode 100644
> index 0000000..0ece7a1
> --- /dev/null
> +++ b/fs/btrfs/cache.c
> @@ -0,0 +1,58 @@
> +/*
> + * (c) Sanidhya Solanki, 2016
> + *
> + * Licensed under the FSF's GNU Public License v2 or later.
> + */
> +#include <linux/types.h>
> +
> +/* Cache size configuration )in MiB).*/
> +#define MAX_CACHE_SIZE = 10000
> +#define MIN_CACHE_SIZE = 10
> +
> +/* Time (in seconds)before retrying to increase the cache size.*/
> +#define CACHE_RETRY = 10
> +
> +/* Space required to be free (in MiB) before increasing the size of the
> + * cache. If cache size is less than cache_grow_limit, a block will be
> freed + * from the cache to allow the cache to continue growning.
> + */
> +#define CACHE_GROW_LIMIT = 100
> +
> +/* Size required to be free (in MiB) after we shrink the cache, so that it
> + * does not grow in size immediately.
> + */
> +#define CACHE_SHRINK_FREE_SPACE_LIMIT = 100
> +
> +/* Age (in seconds) of oldest and newest block in the cache.*/
> +#define MAX_AGE_LIMIT = 300	/* Five Minute Rule recommendation,
> +				 * optimum size depends on size of data
> +				 * blocks.
> +				 */
> +#define MIN_AGE_LIMIT = 15	/* In case of cache stampede.*/
> +
> +/* Memory constraints (in percentage) before we stop caching.*/
> +#define MIN_MEM_FREE = 10
> +
> +/* Cache statistics. */
> +struct cache_stats {
> +	u64		cache_size;
> +	u64		maximum_cache_size_attained;
> +	int		cache_hit_rate;
> +	int		cache_miss_rate;
> +	u64		cache_evicted;
> +	u64		duplicate_read;
> +	u64		duplicate_write;
> +	int		stats_update_interval;
> +};
> +
> +#define cache_size	CACHE_SIZE /* Current cache size.*/
> +#define max_cache_size	MAX_SIZE /* Max cache limit. */
> +#define min_cache_size	MIN_SIZE /* Min cache limit.*/
> +#define cache_time	MAX_TIME /* Maximum time to keep data in cache.*/
> +#define evicted_csum	EVICTED_CSUM	/* Checksum of the evited data
> +					 * (to avoid repeatedly caching
> +					 * data that was just evicted.
> +					 */
> +#define read_csum	READ_CSUM /* Checksum of the read data.*/
> +#define write_csum	WRITE_CSUM /* Checksum of the written data.*/
> +#define evict_interval	EVICT_INTERVAL /* Time to keep data before
> eviction.*/


-- 
Martin
