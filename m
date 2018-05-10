Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35375 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeEJXZL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 19:25:11 -0400
Received: by mail-pf0-f196.google.com with SMTP id x9-v6so1790651pfm.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 16:25:11 -0700 (PDT)
Date: Thu, 10 May 2018 16:25:09 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 08/10] Btrfs: fix ENOSPC caused by orphan items
 reservations
Message-ID: <20180510232509.GD820@vader>
References: <cover.1525932796.git.osandov@fb.com>
 <b2925b4bab87132d86ef9fd90b3053604e575a42.1525932796.git.osandov@fb.com>
 <d8a190d6-530d-ad1f-2ef6-9d14aa1b1691@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d8a190d6-530d-ad1f-2ef6-9d14aa1b1691@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 11:50:11AM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.05.2018 09:21, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Currently, we keep space reserved for all inode orphan items until the
> > inode is evicted (i.e., all references to it are dropped). We hit an
> > issue where an application would keep a bunch of deleted files open (by
> > design) and thus keep a large amount of space reserved, causing ENOSPC
> > errors when other operations tried to reserve space. This long-standing
> > reservation isn't absolutely necessary for a couple of reasons:
> > 
> > - We can almost always make the reservation we need or steal from the
> >   global reserve for the orphan item
> > - If we can't, it's not the end of the world if we drop the orphan item
> >   on the floor and let the next mount clean it up
> > 
> > So, get rid of persistent reservation and just reserve space in
> > btrfs_evict_inode().
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/btrfs/btrfs_inode.h |  19 +++---
> >  fs/btrfs/inode.c       | 140 ++++++++++++-----------------------------
> >  2 files changed, 48 insertions(+), 111 deletions(-)
> > 
> > diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> > index 234bae55b85d..2f466cf55790 100644
> > --- a/fs/btrfs/btrfs_inode.h
> > +++ b/fs/btrfs/btrfs_inode.h
> > @@ -20,16 +20,15 @@
> >   * new data the application may have written before commit.
> >   */
> >  #define BTRFS_INODE_ORDERED_DATA_CLOSE		0
> > -#define BTRFS_INODE_ORPHAN_META_RESERVED	1
> > -#define BTRFS_INODE_DUMMY			2
> > -#define BTRFS_INODE_IN_DEFRAG			3
> > -#define BTRFS_INODE_HAS_ORPHAN_ITEM		4
> > -#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
> > -#define BTRFS_INODE_NEEDS_FULL_SYNC		6
> > -#define BTRFS_INODE_COPY_EVERYTHING		7
> > -#define BTRFS_INODE_IN_DELALLOC_LIST		8
> > -#define BTRFS_INODE_READDIO_NEED_LOCK		9
> > -#define BTRFS_INODE_HAS_PROPS		        10
> > +#define BTRFS_INODE_DUMMY			1
> > +#define BTRFS_INODE_IN_DEFRAG			2
> > +#define BTRFS_INODE_HAS_ORPHAN_ITEM		3
> > +#define BTRFS_INODE_HAS_ASYNC_EXTENT		4
> > +#define BTRFS_INODE_NEEDS_FULL_SYNC		5
> > +#define BTRFS_INODE_COPY_EVERYTHING		6
> > +#define BTRFS_INODE_IN_DELALLOC_LIST		7
> > +#define BTRFS_INODE_READDIO_NEED_LOCK		8
> > +#define BTRFS_INODE_HAS_PROPS		        9
> >  
> >  /* in memory btrfs inode */
> >  struct btrfs_inode {
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 348dc57920f5..cf7ad82dd262 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -3343,88 +3343,25 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
> >  /*
> >   * This creates an orphan entry for the given inode in case something goes wrong
> >   * in the middle of an unlink.
> > - *
> > - * NOTE: caller of this function should reserve 5 units of metadata for
> > - *	 this function.
> >   */
> >  int btrfs_orphan_add(struct btrfs_trans_handle *trans,
> >  		struct btrfs_inode *inode)
> >  {
> > -	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
> >  	struct btrfs_root *root = inode->root;
> > -	struct btrfs_block_rsv *block_rsv = NULL;
> > -	int reserve = 0;
> > -	bool insert = false;
> >  	int ret;
> >  
> > -	if (!root->orphan_block_rsv) {
> > -		block_rsv = btrfs_alloc_block_rsv(fs_info,
> > -						  BTRFS_BLOCK_RSV_TEMP);
> > -		if (!block_rsv)
> > -			return -ENOMEM;
> > -	}
> > -
> > -	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > -			      &inode->runtime_flags))
> > -		insert = true;
> > -
> > -	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
> > -			      &inode->runtime_flags))
> > -		reserve = 1;
> > -
> > -	spin_lock(&root->orphan_lock);
> > -	/* If someone has created ->orphan_block_rsv, be happy to use it. */
> > -	if (!root->orphan_block_rsv) {
> > -		root->orphan_block_rsv = block_rsv;
> > -	} else if (block_rsv) {
> > -		btrfs_free_block_rsv(fs_info, block_rsv);
> > -		block_rsv = NULL;
> > -	}
> > -
> > -	if (insert)
> > -		atomic_inc(&root->orphan_inodes);
> > -	spin_unlock(&root->orphan_lock);
> > +	if (test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > +			     &inode->runtime_flags))
> > +		return 0;
> >  
> > -	/* grab metadata reservation from transaction handle */
> > -	if (reserve) {
> > -		ret = btrfs_orphan_reserve_metadata(trans, inode);
> > -		ASSERT(!ret);
> > -		if (ret) {
> > -			/*
> > -			 * dec doesn't need spin_lock as ->orphan_block_rsv
> > -			 * would be released only if ->orphan_inodes is
> > -			 * zero.
> > -			 */
> > -			atomic_dec(&root->orphan_inodes);
> > -			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
> > -				  &inode->runtime_flags);
> > -			if (insert)
> > -				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > -					  &inode->runtime_flags);
> > -			return ret;
> > -		}
> > -	}
> > +	atomic_inc(&root->orphan_inodes);
> >  
> > -	/* insert an orphan item to track this unlinked file */
> > -	if (insert) {
> > -		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
> > -		if (ret && ret != -EEXIST) {
> > -			if (reserve) {
> > -				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
> > -					  &inode->runtime_flags);
> > -				btrfs_orphan_release_metadata(inode);
> > -			}
> > -			/*
> > -			 * btrfs_orphan_commit_root may race with us and set
> > -			 * ->orphan_block_rsv to zero, in order to avoid that,
> > -			 * decrease ->orphan_inodes after everything is done.
> > -			 */
> > -			atomic_dec(&root->orphan_inodes);
> > -			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > -				  &inode->runtime_flags);
> > -			btrfs_abort_transaction(trans, ret);
> > -			return ret;
> > -		}
> > +	ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
> > +	if (ret && ret != -EEXIST) {
> > +		atomic_dec(&root->orphan_inodes);
> But if we hit an EEXIST this means we would have incremented
> orphan_inodes without actually increasing the overall count of orphan
> items. Shouldn't root->orphan_inodes be incremented only when
> insert_orphan_items succeeds? Since we can only ever have 1 unique
> orphan item per inode, the count should follow the actual number of
> orphan items, no ?

We will only get EEXIST if a previous btrfs_orphan_del() for an inode
with the same number failed, in which case we can pretend we were the
ones that inserted it and carry on as usual.

The counter is "how many inodes in memory have an orphan item associated
with them". This was basically a refcount on the orphan_block_rsv. Now
it's only used for keeping track of whether we can delete an orphan item
in the tree root for the subvolume, which I'm noticing now we never
insert in the first place. In fact, that's the dead code I got rid of in
0a0d4415e338 ("Btrfs: delete dead code in btrfs_orphan_add()"). So
that's even more code we can get rid of, thanks for pointing it out :)

> > +		clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM, &inode->runtime_flags);
> > +		btrfs_abort_transaction(trans, ret);
> > +		return ret;
> >  	}
> >  
> >  	return 0;
> > @@ -3438,27 +3375,16 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
> >  			    struct btrfs_inode *inode)
> >  {
> >  	struct btrfs_root *root = inode->root;
> > -	int delete_item = 0;
> >  	int ret = 0;
> >  
> > -	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > -			       &inode->runtime_flags))
> > -		delete_item = 1;
> > +	if (!test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > +				&inode->runtime_flags))
> > +		return 0;
> >  
> > -	if (delete_item && trans)
> > +	if (trans)
> >  		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
> >  
> > -	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
> > -			       &inode->runtime_flags))
> > -		btrfs_orphan_release_metadata(inode);
> > -
> > -	/*
> > -	 * btrfs_orphan_commit_root may race with us and set ->orphan_block_rsv
> > -	 * to zero, in order to avoid that, decrease ->orphan_inodes after
> > -	 * everything is done.
> > -	 */
> > -	if (delete_item)
> > -		atomic_dec(&root->orphan_inodes);
> > +	atomic_dec(&root->orphan_inodes);
> 
> 
> So in the case of of btrfs_orphan_del called with NULL trans handle
> (which happens from evict_inode and btrfs_orphan_cleanup ) this function
> is really reduced to a counter modification, this is rather obscure and
> ties with my previous question.

Yeah, that's poor naming that dates back to 7b1287662304 ("Btrfs: Create
orphan inode records to prevent lost files after a crash"). I think that
after I get rid of root->orphan_inodes these can just be turned into
clear_bit().

Thanks for taking a look!

> >  
> >  	return ret;
> >  }
