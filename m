Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756291AbdLVMKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 07:10:47 -0500
Subject: Re: [PATCH 07/10] Btrfs: fix unexpected EEXIST from btrfs_get_extent
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-8-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a75a5e50-c65a-93e5-5914-b9442051f463@suse.com>
Date: Fri, 22 Dec 2017 14:10:45 +0200
MIME-Version: 1.0
In-Reply-To: <20171221224256.18196-8-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.12.2017 00:42, Liu Bo wrote:
> This fixes a corner case that is caused by a race of dio write vs dio
> read/write.
> 
> dio write:
> [0, 32k) -> [0, 8k) + [8k, 32k)
> 
> dio read/write:
> 
> While get_extent() with [0, 4k), [0, 8k) is found as existing em, even
> though start == existing->start, em is [0, 32k),
> extent_map_end(em) > extent_map_end(existing),
> then it goes thru merge_extent_mapping() which tries to add a [8k, 8k)
> (with a length 0), and get_extent ends up returning -EEXIST, and dio
> read/write will get -EEXIST which is confusing applications.

I think this paragraph should be expanded a bit since you've crammed a
lot of information in few words.

In the below graphs em should be extent we'd like to insert, no? So
given that it always encompasses the existing (0, 8k given the above
description) then em should be 0, 32k ?

> 
> Here I concluded all the possible situations,
> 1) start < existing->start
> 
>             +-----------+em+-----------+
> +--prev---+ |     +-------------+      |
> |         | |     |             |      |
> +---------+ +     +---+existing++      ++
>                 +
>                 |
>                 +
>              start
> 
> 2) start == existing->start
> 
>       +------------em------------+
>       |     +-------------+      |
>       |     |             |      |
>       +     +----existing-+      +
>             |
>             |
>             +
>          start
> 
> 3) start > existing->start && start < (existing->start + existing->len)
> 
>       +------------em------------+
>       |     +-------------+      |
>       |     |             |      |
>       +     +----existing-+      +
>                |
>                |
>                +
>              start
> 
> 4) start >= (existing->start + existing->len)
> 
> +-----------+em+-----------+
> |     +-------------+      | +--next---+
> |     |             |      | |         |
> +     +---+existing++      + +---------+
>                       +
>                       |
>                       +
>                    start
> 
> After going thru the above case by case, it turns out that if start is
> within existing em (front inclusive), then the existing em should be
> returned, otherwise, we try our best to merge candidate em with
> sibling ems to form a larger em.
> 
> Reported-by: David Vallender <david.vallender@landmark.co.uk>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_map.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6653b08..d386cfb 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -483,7 +483,7 @@ static struct extent_map *prev_extent_map(struct extent_map *em)
>  static int merge_extent_mapping(struct extent_map_tree *em_tree,
>  				struct extent_map *existing,
>  				struct extent_map *em,
> -				u64 map_start)
> +				u64 map_start, u64 map_len)
>  {
>  	struct extent_map *prev;
>  	struct extent_map *next;
> @@ -496,9 +496,13 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
>  	if (existing->start > map_start) {
>  		next = existing;
>  		prev = prev_extent_map(next);
> +		if (prev)
> +			ASSERT(extent_map_end(prev) <= map_start);
>  	} else {
>  		prev = existing;
>  		next = next_extent_map(prev);
> +		if (next)
> +			ASSERT(map_start + map_len <= next->start);
>  	}
>  
>  	start = prev ? extent_map_end(prev) : em->start;
> @@ -540,35 +544,26 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
>  		 * existing will always be non-NULL, since there must be
>  		 * extent causing the -EEXIST.
>  		 */
> -		if (existing->start == em->start &&
> -		    extent_map_end(existing) >= extent_map_end(em) &&
> -		    em->block_start == existing->block_start) {
> -			/*
> -			 * The existing extent map already encompasses the
> -			 * entire extent map we tried to add.
> -			 */
> +		if (start >= existing->start &&
> +		    start < extent_map_end(existing)) {
>  			free_extent_map(em);
>  			*em_in = existing;
>  			ret = 0;
> -		} else if (start >= extent_map_end(existing) ||
> -		    start <= existing->start) {
> +		} else {
>  			/*
>  			 * The existing extent map is the one nearest to
>  			 * the [start, start + len) range which overlaps
>  			 */
>  			ret = merge_extent_mapping(em_tree, existing,
> -						   em, start);
> +						   em, start, len);
>  			free_extent_map(existing);
>  			if (ret) {
>  				free_extent_map(em);
>  				*em_in = NULL;
>  			}
> -		} else {
> -			free_extent_map(em);
> -			*em_in = existing;
> -			ret = 0;
>  		}
>  	}
> +
>  	ASSERT(ret == 0 || ret == -EEXIST);
>  	return ret;
>  }
> 
