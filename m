Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750863AbdGZHAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 03:00:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CB44AB9B
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 07:00:06 +0000 (UTC)
Subject: Re: [PATCH 3/7] btrfs-progs: extent-cache: actually cache extent
 buffers
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-3-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <cea9bb4c-d1f8-521e-d649-550da4892169@suse.com>
Date: Wed, 26 Jul 2017 10:00:03 +0300
MIME-Version: 1.0
In-Reply-To: <20170725205138.28376-3-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.07.2017 23:51, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> We have the infrastructure to cache extent buffers but we don't actually
> do the caching.  As soon as the last reference is dropped, the buffer
> is dropped.  This patch keeps the extent buffers around until the max
> cache size is reached (defaults to 25% of memory) and then it drops
> the last 10% of the LRU to free up cache space for reallocation.  The
> cache size is configurable (for use by e.g. lowmem) when the cache is
> initialized.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  extent_io.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
>  extent_io.h |  4 ++++
>  utils.c     | 12 ++++++++++
>  utils.h     |  3 +++
>  4 files changed, 80 insertions(+), 13 deletions(-)
> 
> diff --git a/extent_io.c b/extent_io.c
> index 915c6ed..937ff90 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -27,6 +27,7 @@
>  #include "list.h"
>  #include "ctree.h"
>  #include "volumes.h"
> +#include "utils.h"
>  #include "internal.h"
>  
>  void extent_io_tree_init(struct extent_io_tree *tree)
> @@ -35,6 +36,14 @@ void extent_io_tree_init(struct extent_io_tree *tree)
>  	cache_tree_init(&tree->cache);
>  	INIT_LIST_HEAD(&tree->lru);
>  	tree->cache_size = 0;
> +	tree->max_cache_size = (u64)(total_memory() * 1024) / 4;
> +}
> +
> +void extent_io_tree_init_cache_max(struct extent_io_tree *tree,
> +				   u64 max_cache_size)
> +{
> +	extent_io_tree_init(tree);
> +	tree->max_cache_size = max_cache_size;
>  }
>  
>  static struct extent_state *alloc_extent_state(void)
> @@ -67,16 +76,20 @@ static void free_extent_state_func(struct cache_extent *cache)
>  	btrfs_free_extent_state(es);
>  }
>  
> +static void free_extent_buffer_final(struct extent_buffer *eb);
>  void extent_io_tree_cleanup(struct extent_io_tree *tree)
>  {
>  	struct extent_buffer *eb;
>  
>  	while(!list_empty(&tree->lru)) {
>  		eb = list_entry(tree->lru.next, struct extent_buffer, lru);
> -		fprintf(stderr, "extent buffer leak: "
> -			"start %llu len %u\n",
> -			(unsigned long long)eb->start, eb->len);
> -		free_extent_buffer(eb);
> +		if (eb->refs) {
> +			fprintf(stderr, "extent buffer leak: "
> +				"start %llu len %u\n",
> +				(unsigned long long)eb->start, eb->len);
> +			free_extent_buffer_nocache(eb);
> +		} else
> +			free_extent_buffer_final(eb);
>  	}
>  
>  	cache_tree_free_extents(&tree->state, free_extent_state_func);
> @@ -567,7 +580,21 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  	return new;
>  }
>  
> -void free_extent_buffer(struct extent_buffer *eb)
> +static void free_extent_buffer_final(struct extent_buffer *eb)
> +{
> +	struct extent_io_tree *tree = eb->tree;
> +
> +	BUG_ON(eb->refs);
> +	BUG_ON(tree->cache_size < eb->len);
> +	list_del_init(&eb->lru);
> +	if (!(eb->flags & EXTENT_BUFFER_DUMMY)) {
> +		remove_cache_extent(&tree->cache, &eb->cache_node);
> +		tree->cache_size -= eb->len;
> +	}
> +	free(eb);
> +}
> +
> +static void free_extent_buffer_internal(struct extent_buffer *eb, int free_now)

nit: free_ow -> boolean

>  {
>  	if (!eb || IS_ERR(eb))
>  		return;
> @@ -575,19 +602,23 @@ void free_extent_buffer(struct extent_buffer *eb)
>  	eb->refs--;
>  	BUG_ON(eb->refs < 0);
>  	if (eb->refs == 0) {
> -		struct extent_io_tree *tree = eb->tree;
>  		BUG_ON(eb->flags & EXTENT_DIRTY);
> -		list_del_init(&eb->lru);
>  		list_del_init(&eb->recow);
> -		if (!(eb->flags & EXTENT_BUFFER_DUMMY)) {
> -			BUG_ON(tree->cache_size < eb->len);
> -			remove_cache_extent(&tree->cache, &eb->cache_node);
> -			tree->cache_size -= eb->len;
> -		}
> -		free(eb);
> +		if (eb->flags & EXTENT_BUFFER_DUMMY || free_now)
> +			free_extent_buffer_final(eb);
>  	}
>  }
>  
> +void free_extent_buffer(struct extent_buffer *eb)
> +{
> +	free_extent_buffer_internal(eb, 0);
> +}
> +
> +void free_extent_buffer_nocache(struct extent_buffer *eb)
> +{
> +	free_extent_buffer_internal(eb, 1);
> +}
> +
>  struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
>  					 u64 bytenr, u32 blocksize)
>  {
> @@ -619,6 +650,21 @@ struct extent_buffer *find_first_extent_buffer(struct extent_io_tree *tree,
>  	return eb;
>  }
>  
> +static void
> +trim_extent_buffer_cache(struct extent_io_tree *tree)
> +{
> +	struct extent_buffer *eb, *tmp;
> +	u64 count = 0;

count seems to be a leftover from something, so you could remove it

> +	list_for_each_entry_safe(eb, tmp, &tree->lru, lru) {
> +		if (eb->refs == 0) {
> +			free_extent_buffer_final(eb);
> +			count++;
> +		}
> +		if (tree->cache_size <= ((tree->max_cache_size * 9) / 10))
> +			break;
> +	}
> +}
> +
>  struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
>  					  u64 bytenr, u32 blocksize)
>  {
> @@ -649,6 +695,8 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
>  		}
>  		list_add_tail(&eb->lru, &tree->lru);
>  		tree->cache_size += blocksize;
> +		if (tree->cache_size >= tree->max_cache_size)
> +			trim_extent_buffer_cache(tree);
>  	}
>  	return eb;
>  }
> diff --git a/extent_io.h b/extent_io.h
> index e617489..17a4a82 100644
> --- a/extent_io.h
> +++ b/extent_io.h
> @@ -75,6 +75,7 @@ struct extent_io_tree {
>  	struct cache_tree cache;
>  	struct list_head lru;
>  	u64 cache_size;
> +	u64 max_cache_size;
>  };
>  
>  struct extent_state {
> @@ -106,6 +107,8 @@ static inline void extent_buffer_get(struct extent_buffer *eb)
>  }
>  
>  void extent_io_tree_init(struct extent_io_tree *tree);
> +void extent_io_tree_init_cache_max(struct extent_io_tree *tree,
> +				   u64 max_cache_size);
>  void extent_io_tree_cleanup(struct extent_io_tree *tree);
>  int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits);
>  int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits);
> @@ -146,6 +149,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
>  					  u64 bytenr, u32 blocksize);
>  struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
>  void free_extent_buffer(struct extent_buffer *eb);
> +void free_extent_buffer_nocache(struct extent_buffer *eb);
>  int read_extent_from_disk(struct extent_buffer *eb,
>  			  unsigned long offset, unsigned long len);
>  int write_extent_to_disk(struct extent_buffer *eb);
> diff --git a/utils.c b/utils.c
> index d2489e7..c565e08 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -24,6 +24,7 @@
>  #include <sys/mount.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <sys/sysinfo.h>
>  #include <uuid/uuid.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> @@ -2521,3 +2522,14 @@ u8 rand_u8(void)
>  void btrfs_config_init(void)
>  {
>  }
> +
> +unsigned long total_memory(void)

perhaps rename to total_memory_bytes and return the memory size in
bytes. Returning them in kilobytes seems rather arbitrary. That way
you'd save the constant *1024 to turn the kbs in bytes in the callers
(currently only in extent_io_tree_init())

> +{
> +        struct sysinfo  si;
> +
> +        if (sysinfo(&si) < 0) {
> +                error("can't determine memory size");
> +                return -1UL;
> +        }
> +        return (si.totalram >> 10) * si.mem_unit;       /* kilobytes */
> +}
> diff --git a/utils.h b/utils.h
> index 24d0a20..6be0d6f 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -148,6 +148,9 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
>  int string_is_numerical(const char *str);
>  int prefixcmp(const char *str, const char *prefix);
>  
> +/* Returns total size of main memory in KiB units. -1ULL if error. */
> +unsigned long total_memory(void);
> +
>  /*
>   * Global program state, configurable by command line and available to
>   * functions without extra context passing.
> 
