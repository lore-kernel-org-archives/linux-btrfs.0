Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757522AbdJMIjS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 04:39:18 -0400
Subject: Re: [PATCH 01/21] Btrfs: rework outstanding_extents
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-2-git-send-email-jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <704b1207-5219-89dd-6ddd-582ed74f759f@suse.com>
Date: Fri, 13 Oct 2017 11:39:15 +0300
MIME-Version: 1.0
In-Reply-To: <1506714245-23072-2-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.09.2017 22:43, Josef Bacik wrote:
>  
> +static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
> +						 int mod)
> +{
> +	ASSERT(spin_is_locked(&inode->lock));
> +	inode->outstanding_extents += mod;
> +	if (btrfs_is_free_space_inode(inode))
> +		return;
> +}
> +
> +static inline void btrfs_mod_reserved_extents(struct btrfs_inode *inode,
> +					      int mod)
> +{
> +	ASSERT(spin_is_locked(&inode->lock));

lockdep_assert_held(&inode->lock); for both functions. I've spoken with
Peterz and he said any other way of checking whether a lock is held, I
quote, "must die"

> +	inode->reserved_extents += mod;
> +	if (btrfs_is_free_space_inode(inode))
> +		return;
> +}
> +
>  static inline int btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
>  {
>  	int ret = 0;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a7f68c304b4c..1262612fbf78 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2742,6 +2742,8 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
>  				     u64 *qgroup_reserved, bool use_global_rsv);
>  void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
>  				      struct btrfs_block_rsv *rsv);
> +void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
> +
>  int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
>  void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes);
>  int btrfs_delalloc_reserve_space(struct inode *inode,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 1a6aced00a19..aa0f5c8953b0 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5971,42 +5971,31 @@ void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
>  }
>  
>  /**
> - * drop_outstanding_extent - drop an outstanding extent
> + * drop_over_reserved_extents - drop our extra extent reservations
>   * @inode: the inode we're dropping the extent for
> - * @num_bytes: the number of bytes we're releasing.
>   *
> - * This is called when we are freeing up an outstanding extent, either called
> - * after an error or after an extent is written.  This will return the number of
> - * reserved extents that need to be freed.  This must be called with
> - * BTRFS_I(inode)->lock held.
> + * We reserve extents we may use, but they may have been merged with other
> + * extents and we may not need the extra reservation.
> + *
> + * We also call this when we've completed io to an extent or had an error and
> + * cleared the outstanding extent, in either case we no longer need our
> + * reservation and can drop the excess.
>   */
> -static unsigned drop_outstanding_extent(struct btrfs_inode *inode,
> -		u64 num_bytes)
> +static unsigned drop_over_reserved_extents(struct btrfs_inode *inode)
>  {
> -	unsigned drop_inode_space = 0;
> -	unsigned dropped_extents = 0;
> -	unsigned num_extents;
> +	unsigned num_extents = 0;
>  
> -	num_extents = count_max_extents(num_bytes);
> -	ASSERT(num_extents);
> -	ASSERT(inode->outstanding_extents >= num_extents);
> -	inode->outstanding_extents -= num_extents;
> +	if (inode->reserved_extents > inode->outstanding_extents) {
> +		num_extents = inode->reserved_extents -
> +			inode->outstanding_extents;
> +		btrfs_mod_reserved_extents(inode, -num_extents);
> +	}
>  
>  	if (inode->outstanding_extents == 0 &&
>  	    test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
>  			       &inode->runtime_flags))
> -		drop_inode_space = 1;
> -
> -	/*
> -	 * If we have more or the same amount of outstanding extents than we have
> -	 * reserved then we need to leave the reserved extents count alone.
> -	 */
> -	if (inode->outstanding_extents >= inode->reserved_extents)
> -		return drop_inode_space;
> -
> -	dropped_extents = inode->reserved_extents - inode->outstanding_extents;
> -	inode->reserved_extents -= dropped_extents;
> -	return dropped_extents + drop_inode_space;
> +		num_extents++;
> +	return num_extents;

Something bugs me around the handling of this. In
btrfs_delalloc_reserve_metadata we do add the additional bytes necessary
for updating the inode. However outstanding_extents is modified with the
number of extent items necessary to cover the requires byte range but we
don't account the extra inode item as being an extent. Then why do we
have to actually increment the num_extents here? Doesn't this lead to
underflow?

To illustrate: A write comes for 1 mb, we count this as 1 outstanding
extent in delalloc_reserve_metadata:

nr_extents = count_max_extents(num_bytes);
inode->outstanding_extents += nr_extents;

We do account the extra inode item but only when calculating the bytes
to reserve:

to_reserve = btrfs_calc_trans_metadata_size(fs_info, nr_extents + 1);
And we of course set : test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,

Now, when the time comes to free the outstanding extent and call :
drop_over_reserved_extents we do account the extra inode item as an
extent being freed. Is this correct? In any case it's not something
which is introduced by your patch but something which has been there
since time immemorial, just wondering?

>  }
>  
>  /**
> @@ -6061,13 +6050,15 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  	struct btrfs_block_rsv *block_rsv = &fs_info->delalloc_block_rsv;
>  	u64 to_reserve = 0;
>  	u64 csum_bytes;
> -	unsigned nr_extents;
> +	unsigned nr_extents, reserve_extents;
>  	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
>  	int ret = 0;
>  	bool delalloc_lock = true;
>  	u64 to_free = 0;
>  	unsigned dropped;
>  	bool release_extra = false;
> +	bool underflow = false;
> +	bool did_retry = false;
>  
>  	/* If we are a free space inode we need to not flush since we will be in
>  	 * the middle of a transaction commit.  We also don't need the delalloc
> @@ -6092,18 +6083,31 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  		mutex_lock(&inode->delalloc_mutex);
>  
>  	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
> -
> +retry:
>  	spin_lock(&inode->lock);
> -	nr_extents = count_max_extents(num_bytes);
> -	inode->outstanding_extents += nr_extents;
> +	reserve_extents = nr_extents = count_max_extents(num_bytes);
> +	btrfs_mod_outstanding_extents(inode, nr_extents);
>  
> -	nr_extents = 0;
> -	if (inode->outstanding_extents > inode->reserved_extents)
> -		nr_extents += inode->outstanding_extents -
> +	/*
> +	 * Because we add an outstanding extent for ordered before we clear
> +	 * delalloc we will double count our outstanding extents slightly.  This
> +	 * could mean that we transiently over-reserve, which could result in an
> +	 * early ENOSPC if our timing is unlucky.  Keep track of the case that
> +	 * we had a reservation underflow so we can retry if we fail.
> +	 *
> +	 * Keep in mind we can legitimately have more outstanding extents than
> +	 * reserved because of fragmentation, so only allow a retry once.
> +	 */
> +	if (inode->outstanding_extents >
> +	    inode->reserved_extents + nr_extents) {
> +		reserve_extents = inode->outstanding_extents -
>  			inode->reserved_extents;
> +		underflow = true;
> +	}
>  
>  	/* We always want to reserve a slot for updating the inode. */
> -	to_reserve = btrfs_calc_trans_metadata_size(fs_info, nr_extents + 1);
> +	to_reserve = btrfs_calc_trans_metadata_size(fs_info,
> +						    reserve_extents + 1);
>  	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
>  	csum_bytes = inode->csum_bytes;
>  	spin_unlock(&inode->lock);
> @@ -6128,7 +6132,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  		to_reserve -= btrfs_calc_trans_metadata_size(fs_info, 1);
>  		release_extra = true;
>  	}
> -	inode->reserved_extents += nr_extents;
> +	btrfs_mod_reserved_extents(inode, reserve_extents);
>  	spin_unlock(&inode->lock);
>  
>  	if (delalloc_lock)
> @@ -6144,7 +6148,10 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  
>  out_fail:
>  	spin_lock(&inode->lock);
> -	dropped = drop_outstanding_extent(inode, num_bytes);
> +	nr_extents = count_max_extents(num_bytes);

nr_extent isn't changed, so re-calculating it is redundant.

> +	btrfs_mod_outstanding_extents(inode, -nr_extents);
> +
> +	dropped = drop_over_reserved_extents(inode);
>  	/*
>  	 * If the inodes csum_bytes is the same as the original
>  	 * csum_bytes then we know we haven't raced with any free()ers
> @@ -6201,6 +6208,11 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  		trace_btrfs_space_reservation(fs_info, "delalloc",
>  					      btrfs_ino(inode), to_free, 0);
>  	}
> +	if (underflow && !did_retry) {
> +		did_retry = true;
> +		underflow = false;
> +		goto retry;
> +	}
>  	if (delalloc_lock)
>  		mutex_unlock(&inode->delalloc_mutex);
>  	return ret;
> @@ -6208,12 +6220,12 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  
>  /**
>   * btrfs_delalloc_release_metadata - release a metadata reservation for an inode
> - * @inode: the inode to release the reservation for
> - * @num_bytes: the number of bytes we're releasing
> + * @inode: the inode to release the reservation for.
> + * @num_bytes: the number of bytes we are releasing.
>   *
>   * This will release the metadata reservation for an inode.  This can be called
>   * once we complete IO for a given set of bytes to release their metadata
> - * reservations.
> + * reservations, or on error for the same reason.
>   */
>  void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  {
> @@ -6223,8 +6235,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  
>  	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
>  	spin_lock(&inode->lock);
> -	dropped = drop_outstanding_extent(inode, num_bytes);
> -
> +	dropped = drop_over_reserved_extents(inode);
>  	if (num_bytes)
>  		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
>  	spin_unlock(&inode->lock);
> @@ -6241,6 +6252,42 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
>  }
>  
>  /**
> + * btrfs_delalloc_release_extents - release our outstanding_extents
> + * @inode: the inode to balance the reservation for.
> + * @num_bytes: the number of bytes we originally reserved with
> + *
> + * When we reserve space we increase outstanding_extents for the extents we may
> + * add.  Once we've set the range as delalloc or created our ordered extents we
> + * have outstanding_extents to track the real usage, so we use this to free our
> + * temporarily tracked outstanding_extents.  This _must_ be used in conjunction
> + * with btrfs_delalloc_reserve_metadata.
> + */
> +void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
> +	unsigned num_extents;
> +	u64 to_free;
> +	unsigned dropped;
> +
> +	spin_lock(&inode->lock);
> +	num_extents = count_max_extents(num_bytes);
> +	btrfs_mod_outstanding_extents(inode, -num_extents);
> +	dropped = drop_over_reserved_extents(inode);
> +	spin_unlock(&inode->lock);
> +
> +	if (!dropped)
> +		return;
> +
> +	if (btrfs_is_testing(fs_info))
> +		return;
> +
> +	to_free = btrfs_calc_trans_metadata_size(fs_info, dropped);

So what's really happening here is that drop_over_reserved_extents
reallu returns the number of items (which can consists of extent items +
1 inode item). So perhaps the function should be renamed to
drop_over_reserved_items?

> +	trace_btrfs_space_reservation(fs_info, "delalloc", btrfs_ino(inode),
> +				      to_free, 0);
> +	btrfs_block_rsv_release(fs_info, &fs_info->delalloc_block_rsv, to_free);
> +}
> +
> +/**
>   * btrfs_delalloc_reserve_space - reserve data and metadata space for
>   * delalloc
>   * @inode: inode we're writing to
> @@ -6284,10 +6331,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
>   * @inode: inode we're releasing space for
>   * @start: start position of the space already reserved
>   * @len: the len of the space already reserved
> - *
> - * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
> - * called in the case that we don't need the metadata AND data reservations
> - * anymore.  So if there is an error or we insert an inline extent.
> + * @release_bytes: the len of the space we consumed or didn't use
>   *
>   * This function will release the metadata space that was not used and will
>   * decrement ->delalloc_bytes and remove it from the fs_info delalloc_inodes
> @@ -6295,7 +6339,8 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
>   * Also it will handle the qgroup reserved space.
>   */
>  void btrfs_delalloc_release_space(struct inode *inode,
> -			struct extent_changeset *reserved, u64 start, u64 len)
> +				  struct extent_changeset *reserved,
> +				  u64 start, u64 len)
>  {
>  	btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
>  	btrfs_free_reserved_data_space(inode, reserved, start, len);


<omitted for brevity>
