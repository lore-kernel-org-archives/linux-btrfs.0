From: Edward Shishkin <edward@redhat.com>
Subject: Re: Balancing leaves when walking from top to down (was Btrfs:...)
Date: Tue, 22 Jun 2010 16:12:57 +0200
Message-ID: <4C20C4E9.60203@redhat.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <20100618155653.GC10919@shareable.org> <4C1BC924.30604@redhat.com> <20100618193555.GV27466@think> <4C1BED56.9010300@redhat.com> <20100621131528.GA17979@think> <20100621180013.GD17979@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Edward Shishkin <edward@redhat.com>,
	Jamie Lokier <jamie@shareable.org>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Mat <jackdachef@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100621180013.GD17979@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Jun 21, 2010 at 09:15:28AM -0400, Chris Mason wrote:
>   
>> I'll reproduce from your test case and provide a fix.  mount -o
>> max_inline=1500 would give us 50% usage in the worst case

This is a very strange statement: how did you calculate this lower bound?

>>  (minus the
>> balancing bug you hit).
>>     
>
> Ok, the balancing bug was interesting.  What happens is we create all
> the inodes and directory items nicely packed into the leaves.
>
> Then delayed allocation kicks in and starts inserting the big fat inline
> extents.  This often forces the balancing code to split a leaf twice in
> order to make room for the new inline extent.  The double split code
> wasn't balancing the bits that were left over on either side of our
> desired slot.
>
> The patch below fixes the problem for me, reducing the number of leaves
> that have more than 2K of free space down from 6% of the total to about
> 74 leaves.  It could be zero, but the balancing code doesn't push
> items around if our leaf is in the first or last slot of the parent
> node (complexity vs benefit tradeoff).
>   

Nevertheless, I see leaves, which are not in the first or last slot,
but mergeable with their neighbors (test case is the same):

leaf 269557760 items 22 free space 2323 generation 25 owner 2
fs uuid 614fb921-cfa9-403d-9feb-940021e72382
chunk uuid b1674882-a445-45f9-b250-0985e483d231

leaf 280027136 items 18 free space 2627 generation 25 owner 2
fs uuid 614fb921-cfa9-403d-9feb-940021e72382
chunk uuid b1674882-a445-45f9-b250-0985e483d231

node 269549568 level 1 items 60 free 61 generation 25 owner 2
fs uuid 614fb921-cfa9-403d-9feb-940021e72382
chunk uuid b1674882-a445-45f9-b250-0985e483d231
        key (175812608 EXTENT_ITEM 4096) block 175828992 (42927) gen 15
        key (176025600 EXTENT_ITEM 4096) block 176111616 (42996) gen 15
        key (176238592 EXTENT_ITEM 4096) block 176300032 (43042) gen 15
        key (176451584 EXTENT_ITEM 4096) block 216248320 (52795) gen 17
        key (176672768 EXTENT_ITEM 4096) block 216236032 (52792) gen 17
        key (176783360 EXTENT_ITEM 4096) block 216252416 (52796) gen 17
        key (176955392 EXTENT_ITEM 4096) block 138854400 (33900) gen 25
        key (177131520 EXTENT_ITEM 4096) block 280289280 (68430) gen 25
        key (177348608 EXTENT_ITEM 4096) block 280285184 (68429) gen 25
        key (177561600 EXTENT_ITEM 4096) block 269557760 (65810) gen 25
        key (177795072 EXTENT_ITEM 4096) block 280027136 (68366) gen 25
        key (178008064 EXTENT_ITEM 4096) block 280064000 (68375) gen 25
        key (178233344 EXTENT_ITEM 4096) block 285061120 (69595) gen 25
        key (178442240 EXTENT_ITEM 4096) block 178442240 (43565) gen 16
        key (178655232 EXTENT_ITEM 4096) block 178655232 (43617) gen 16
        key (178868224 EXTENT_ITEM 4096) block 178868224 (43669) gen 16
[...]

> With the patch, I'm able to create 106894 files (2K each) on a 1GB FS.
> That doesn't sound like a huge improvement, but the default from
> mkfs.btrfs is to duplicate metadata.  After duplication, that's about
> 417MB or about 40% of the overall space.
>
> When you factor in the space that we reserve to avoid exploding on
> enospc and the space that we have allocated for data extents, that's not
> a very surprising number.
>
> I'm still putting this patch through more testing, the double split code
> is used in some difficult corners and I need to make sure I've tried
> all of them.
>   

Chris, for the further code review we need documents, which reflect
the original ideas of the balancing, etc. Could you please provide them?
Obviously, I can not do it instead of you, as I don't know those ideas.

Thanks,
Edward.

> -chris
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 0d1d966..1f393b0 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2304,12 +2304,17 @@ noinline int btrfs_leaf_free_space(struct btrfs_root *root,
>  	return ret;
>  }
>  
> +/*
> + * min slot controls the lowest index we're willing to push to the
> + * right.  We'll push up to and including min_slot, but no lower
> + */
>  static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
>  				      struct btrfs_root *root,
>  				      struct btrfs_path *path,
>  				      int data_size, int empty,
>  				      struct extent_buffer *right,
> -				      int free_space, u32 left_nritems)
> +				      int free_space, u32 left_nritems,
> +				      u32 min_slot)
>  {
>  	struct extent_buffer *left = path->nodes[0];
>  	struct extent_buffer *upper = path->nodes[1];
> @@ -2327,7 +2332,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
>  	if (empty)
>  		nr = 0;
>  	else
> -		nr = 1;
> +		nr = max_t(u32, 1, min_slot);
>  
>  	if (path->slots[0] >= left_nritems)
>  		push_space += data_size;
> @@ -2469,10 +2474,13 @@ out_unlock:
>   *
>   * returns 1 if the push failed because the other node didn't have enough
>   * room, 0 if everything worked out and < 0 if there were major errors.
> + *
> + * this will push starting from min_slot to the end of the leaf.  It won't
> + * push any slot lower than min_slot
>   */
>  static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>  			   *root, struct btrfs_path *path, int data_size,
> -			   int empty)
> +			   int empty, u32 min_slot)
>  {
>  	struct extent_buffer *left = path->nodes[0];
>  	struct extent_buffer *right;
> @@ -2515,7 +2523,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>  		goto out_unlock;
>  
>  	return __push_leaf_right(trans, root, path, data_size, empty,
> -				right, free_space, left_nritems);
> +				right, free_space, left_nritems, min_slot);
>  out_unlock:
>  	btrfs_tree_unlock(right);
>  	free_extent_buffer(right);
> @@ -2525,12 +2533,17 @@ out_unlock:
>  /*
>   * push some data in the path leaf to the left, trying to free up at
>   * least data_size bytes.  returns zero if the push worked, nonzero otherwise
> + *
> + * max_slot can put a limit on how far into the leaf we'll push items.  The
> + * item at 'max_slot' won't be touched.  Use (u32)-1 to make us do all the
> + * items
>   */
>  static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
>  				     struct btrfs_root *root,
>  				     struct btrfs_path *path, int data_size,
>  				     int empty, struct extent_buffer *left,
> -				     int free_space, int right_nritems)
> +				     int free_space, u32 right_nritems,
> +				     u32 max_slot)
>  {
>  	struct btrfs_disk_key disk_key;
>  	struct extent_buffer *right = path->nodes[0];
> @@ -2549,9 +2562,9 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
>  	slot = path->slots[1];
>  
>  	if (empty)
> -		nr = right_nritems;
> +		nr = min(right_nritems, max_slot);
>  	else
> -		nr = right_nritems - 1;
> +		nr = min(right_nritems - 1, max_slot);
>  
>  	for (i = 0; i < nr; i++) {
>  		item = btrfs_item_nr(right, i);
> @@ -2712,10 +2725,14 @@ out:
>  /*
>   * push some data in the path leaf to the left, trying to free up at
>   * least data_size bytes.  returns zero if the push worked, nonzero otherwise
> + *
> + * max_slot can put a limit on how far into the leaf we'll push items.  The
> + * item at 'max_slot' won't be touched.  Use (u32)-1 to make us push all the
> + * items
>   */
>  static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>  			  *root, struct btrfs_path *path, int data_size,
> -			  int empty)
> +			  int empty, u32 max_slot)
>  {
>  	struct extent_buffer *right = path->nodes[0];
>  	struct extent_buffer *left;
> @@ -2762,7 +2779,8 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>  	}
>  
>  	return __push_leaf_left(trans, root, path, data_size,
> -			       empty, left, free_space, right_nritems);
> +			       empty, left, free_space, right_nritems,
> +			       max_slot);
>  out:
>  	btrfs_tree_unlock(left);
>  	free_extent_buffer(left);
> @@ -2855,6 +2873,59 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
>  }
>  
>  /*
> + * double splits happen when we need to insert a big item in the middle
> + * of a leaf.  A double split can leave us with 3 mostly empty leaves:
> + * leaf: [ slots 0 - N] [ our target ] [ N + 1 - total in leaf ]
> + *          A                 B                 C
> + *
> + * We avoid this by trying to push the items on either side of our target
> + * into the adjacent leaves.  If all goes well we can avoid the double split
> + * completely.
> + */
> +static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
> +					  struct btrfs_root *root,
> +					  struct btrfs_path *path)
> +{
> +	int ret;
> +	int progress = 0;
> +	int slot;
> +
> +	slot = path->slots[0];
> +
> +	/*
> +	 * try to push all the items after our slot into the
> +	 * right leaf
> +	 */
> +	ret = push_leaf_right(trans, root, path, 1, 0, slot);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 0)
> +		progress++;
> +
> +	/*
> +	 * our goal is to get our slot at the start or end of a leaf.  If
> +	 * we've done so we're done
> +	 */
> +	if (path->slots[0] == 0 ||
> +	    path->slots[0] == btrfs_header_nritems(path->nodes[0]))
> +		return 0;
> +
> +	/* try to push all the items before our slot into the next leaf */
> +	slot = path->slots[0];
> +	ret = push_leaf_left(trans, root, path, 1, 0, slot);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == 0)
> +		progress++;
> +
> +	if (progress)
> +		return 0;
> +	return 1;
> +}
> +
> +/*
>   * split the path's leaf in two, making sure there is at least data_size
>   * available for the resulting leaf level of the path.
>   *
> @@ -2876,6 +2947,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>  	int wret;
>  	int split;
>  	int num_doubles = 0;
> +	int tried_avoid_double = 0;
>  
>  	l = path->nodes[0];
>  	slot = path->slots[0];
> @@ -2884,12 +2956,13 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
>  		return -EOVERFLOW;
>  
>  	/* first try to make some room by pushing left and right */
> -	if (data_size && ins_key->type != BTRFS_DIR_ITEM_KEY) {
> -		wret = push_leaf_right(trans, root, path, data_size, 0);
> +	if (data_size) {
> +		wret = push_leaf_right(trans, root, path, data_size, 0, 0);
>  		if (wret < 0)
>  			return wret;
>  		if (wret) {
> -			wret = push_leaf_left(trans, root, path, data_size, 0);
> +			wret = push_leaf_left(trans, root, path,
> +					      data_size, 0, (u32)-1);
>  			if (wret < 0)
>  				return wret;
>  		}
> @@ -2923,6 +2996,12 @@ again:
>  				if (mid != nritems &&
>  				    leaf_space_used(l, mid, nritems - mid) +
>  				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
> +					if (!tried_avoid_double) {
> +						push_for_double_split(trans,
> +							      root, path);
> +						tried_avoid_double = 1;
> +						goto again;
> +					}
>  					split = 2;
>  				}
>  			}
> @@ -2939,6 +3018,12 @@ again:
>  				if (mid != nritems &&
>  				    leaf_space_used(l, mid, nritems - mid) +
>  				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
> +					if (!tried_avoid_double) {
> +						push_for_double_split(trans,
> +							      root, path);
> +						tried_avoid_double = 1;
> +						goto again;
> +					}
>  					split = 2 ;
>  				}
>  			}
> @@ -3915,13 +4000,14 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  			extent_buffer_get(leaf);
>  
>  			btrfs_set_path_blocking(path);
> -			wret = push_leaf_left(trans, root, path, 1, 1);
> +			wret = push_leaf_left(trans, root, path, 1, 1, (u32)-1);
>  			if (wret < 0 && wret != -ENOSPC)
>  				ret = wret;
>  
>  			if (path->nodes[0] == leaf &&
>  			    btrfs_header_nritems(leaf)) {
> -				wret = push_leaf_right(trans, root, path, 1, 1);
> +				wret = push_leaf_right(trans, root, path,
> +						       1, 1, 0);
>  				if (wret < 0 && wret != -ENOSPC)
>  					ret = wret;
>  			}
>   


-- 
Edward O. Shishkin
Principal Software Engineer
Red Hat Czech

