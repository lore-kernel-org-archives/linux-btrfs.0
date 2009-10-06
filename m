From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH] Btrfs: fix possible softlockup in the allocator
Date: Tue, 6 Oct 2009 08:14:55 +0200
Message-ID: <200910060814.55559.johannes.hirte@fem.tu-ilmenau.de>
References: <20091005193039.GA2308@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091005193039.GA2308@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag 05 Oktober 2009 21:30:39 schrieb Josef Bacik:
> Like the cluster allocating stuff, we can lockup the box with the normal
> allocation path.  This happens when we
> 
> 1) Start to cache a block group that is severely fragmented, but has a
>  decent amount of free space.
> 2) Start to commit a transaction
> 3) Have the commit try and empty out some of the delalloc inodes with
>  extents that are relatively large.
> 
> The inodes will not be able to make the allocations because they will ask
>  for allocations larger than a contiguous area in the free space cache.  So
>  we will wait for more progress to be made on the block group, but since
>  we're in a commit the caching kthread won't make any more progress and it
>  already has enough free space that wait_block_group_cache_progress will
>  just return.  So, if we wait and fail to make the allocation the next time
>  around, just loop and go to the next block group.  This keeps us from
>  getting stuck in a softlockup. Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
> ---
>  fs/btrfs/extent-tree.c |   23 +++++++++++++++++------
>  1 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b259db3..e46b0b9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3816,6 +3816,7 @@ static noinline int find_free_extent(struct
>  btrfs_trans_handle *trans, int loop = 0;
>  	bool found_uncached_bg = false;
>  	bool failed_cluster_refill = false;
> +	bool failed_alloc = false;
> 
>  	WARN_ON(num_bytes < root->sectorsize);
>  	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
> @@ -4020,14 +4021,23 @@ refill_cluster:
> 
>  		offset = btrfs_find_space_for_alloc(block_group, search_start,
>  						    num_bytes, empty_size);
> -		if (!offset && (cached || (!cached &&
> -					   loop == LOOP_CACHING_NOWAIT))) {
> -			goto loop;
> -		} else if (!offset && (!cached &&
> -				       loop > LOOP_CACHING_NOWAIT)) {
> +		/*
> +		 * If we didn't find a chunk, and we haven't failed on this
> +		 * block group before, and this block group is in the middle of
> +		 * caching and we are ok with waiting, then go ahead and wait
> +		 * for progress to be made, and set failed_alloc to true.
> +		 *
> +		 * If failed_alloc is true then we've already waited on this
> +		 * block group once and should move on to the next block group.
> +		 */
> +		if (!offset && !failed_alloc && !cached &&
> +		    loop > LOOP_CACHING_NOWAIT) {
>  			wait_block_group_cache_progress(block_group,
> -					num_bytes + empty_size);
> +						num_bytes + empty_size);
> +			failed_alloc = true;
>  			goto have_block_group;
> +		} else if (!offset) {
> +			goto loop;
>  		}
>  checks:
>  		search_start = stripe_align(root, offset);
> @@ -4075,6 +4085,7 @@ checks:
>  		break;
>  loop:
>  		failed_cluster_refill = false;
> +		failed_alloc = false;
>  		btrfs_put_block_group(block_group);
>  	}
>  	up_read(&space_info->groups_sem);
> 

My box survived 6h of dbench with this patch whereas without it hangs within 
the first thwo minutes.

Johannes
