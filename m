Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59894 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756515AbdLVSuV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 13:50:21 -0500
Date: Fri, 22 Dec 2017 10:45:09 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs: add helper for em merge logic
Message-ID: <20171222184508.GA21643@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-2-bo.li.liu@oracle.com>
 <e6987bab-a88c-3e6a-13b5-c05f73e53b71@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6987bab-a88c-3e6a-13b5-c05f73e53b71@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 22, 2017 at 09:23:40AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.12.2017 00:42, Liu Bo wrote:
> > This is a prepare work for the following extent map selftest, which
> > runs tests against em merge logic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.h |   2 ++
> >  fs/btrfs/inode.c | 101 ++++++++++++++++++++++++++++++-------------------------
> >  2 files changed, 58 insertions(+), 45 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index b2e09fe..328f40f 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3148,6 +3148,8 @@ struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode,
> >  						    int delay_iput);
> >  void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
> >  
> > +int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
> > +			     struct extent_map **em_in, u64 start, u64 len);
> >  struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
> >  		struct page *page, size_t pg_offset, u64 start,
> >  		u64 len, int create);
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index e1a7f3c..527df6f 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6911,6 +6911,61 @@ static noinline int uncompress_inline(struct btrfs_path *path,
> >  	return ret;
> >  }
> >  
> > +int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
> > +			     struct extent_map **em_in, u64 start, u64 len)
> 
> How about adding the following comment above the function: 
> 
> /**                                                                             
>  * btrfs_add_extent_mapping - try to add given extent mapping                   
>  * @em_tree - the extent tree into which we want to add the mapping             
>  * @em_in - extent we are inserting                                             
>  * @start - the start of the logical range of the extent we are adding          
>  * @len - logical length of the extent                                          
>  *                                                                              
>  * Insert @em_in into @em_tree. In case there is an overlapping range, handle   
>  * the -EEXIST by either:                                                       
>  * a) Returning the existing extent in @em_in if there is a full overlap        
>  * b) Merge the extents if they are near each other.                            
>  *                                                                              
>  * Returns 0 on success or a negative error code                               
>  *                                                                              
>  */ 
> 

Appreciate your comments.

Sure, comments are always welcome.

> Also one thing which I'm not very clear is why do we need the start/len, aren't 
> those already set in em_in ?
>

[start, start+len) is within *em_in, ie.

|----*em_in--------|
   |------|
  start   start+len

What we really care about is [start, start+len), which is passed to
btrfs_get_extent().

For example, if a file extent item on disk is [0, 32k), given a tuple
(start=0, len=4k), reading [0, 4k) would end up with *em_in being
[0, 32k).

So if add_extent_mapping(*em_in) returns EEXIST, then we know the
'existing' em is overlapped with *em_in, then we need to check whether
it's overlapped with [start, start+len).

thanks,
-liubo

> 
> 
> > +{
> > +	int ret;
> > +	struct extent_map *em = *em_in;
> > +
> > +	ret = add_extent_mapping(em_tree, em, 0);
> > +	/* it is possible that someone inserted the extent into the tree
> > +	 * while we had the lock dropped.  It is also possible that
> > +	 * an overlapping map exists in the tree
> > +	 */
> > +	if (ret == -EEXIST) {
> > +		struct extent_map *existing;
> > +
> > +		ret = 0;
> > +
> > +		existing = search_extent_mapping(em_tree, start, len);
> > +
> > +		/*
> > +		 * existing will always be non-NULL, since there must be
> > +		 * extent causing the -EEXIST.
> > +		 */
> > +		if (existing->start == em->start &&
> > +		    extent_map_end(existing) >= extent_map_end(em) &&
> > +		    em->block_start == existing->block_start) {
> > +			/*
> > +			 * The existing extent map already encompasses the
> > +			 * entire extent map we tried to add.
> > +			 */
> > +			free_extent_map(em);
> > +			*em_in = existing;
> > +			ret = 0;
> > +		} else if (start >= extent_map_end(existing) ||
> > +		    start <= existing->start) {
> > +			/*
> > +			 * The existing extent map is the one nearest to
> > +			 * the [start, start + len) range which overlaps
> > +			 */
> > +			ret = merge_extent_mapping(em_tree, existing,
> > +						   em, start);
> > +			free_extent_map(existing);
> > +			if (ret) {
> > +				free_extent_map(em);
> > +				*em_in = NULL;
> > +			}
> > +		} else {
> > +			free_extent_map(em);
> > +			*em_in = existing;
> > +			ret = 0;
> > +		}
> > +	}
> > +	ASSERT(ret == 0 || ret == -EEXIST);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * a bit scary, this does extent mapping from logical file offset to the disk.
> >   * the ugly parts come from merging extents from the disk with the in-ram
> > @@ -7147,51 +7202,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> >  
> >  	err = 0;
> >  	write_lock(&em_tree->lock);
> > -	ret = add_extent_mapping(em_tree, em, 0);
> > -	/* it is possible that someone inserted the extent into the tree
> > -	 * while we had the lock dropped.  It is also possible that
> > -	 * an overlapping map exists in the tree
> > -	 */
> > -	if (ret == -EEXIST) {
> > -		struct extent_map *existing;
> > -
> > -		ret = 0;
> > -
> > -		existing = search_extent_mapping(em_tree, start, len);
> > -		/*
> > -		 * existing will always be non-NULL, since there must be
> > -		 * extent causing the -EEXIST.
> > -		 */
> > -		if (existing->start == em->start &&
> > -		    extent_map_end(existing) >= extent_map_end(em) &&
> > -		    em->block_start == existing->block_start) {
> > -			/*
> > -			 * The existing extent map already encompasses the
> > -			 * entire extent map we tried to add.
> > -			 */
> > -			free_extent_map(em);
> > -			em = existing;
> > -			err = 0;
> > -
> > -		} else if (start >= extent_map_end(existing) ||
> > -		    start <= existing->start) {
> > -			/*
> > -			 * The existing extent map is the one nearest to
> > -			 * the [start, start + len) range which overlaps
> > -			 */
> > -			err = merge_extent_mapping(em_tree, existing,
> > -						   em, start);
> > -			free_extent_map(existing);
> > -			if (err) {
> > -				free_extent_map(em);
> > -				em = NULL;
> > -			}
> > -		} else {
> > -			free_extent_map(em);
> > -			em = existing;
> > -			err = 0;
> > -		}
> > -	}
> > +	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
> >  	write_unlock(&em_tree->lock);
> >  out:
> >  
> > 
