Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:45278 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbeEKGvY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 02:51:24 -0400
Received: by mail-pg0-f68.google.com with SMTP id w3-v6so2028943pgv.12
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:51:24 -0700 (PDT)
Date: Thu, 10 May 2018 23:51:22 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 08/12] Btrfs: fix ENOSPC caused by orphan items
 reservations
Message-ID: <20180511065122.GB30748@vader>
References: <cover.1525997057.git.osandov@fb.com>
 <a0b43dd0428248dc1ff98e0986b142ad9eb418e4.1525997057.git.osandov@fb.com>
 <687716e4-9def-2990-b1f2-f757ccbc4ee9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <687716e4-9def-2990-b1f2-f757ccbc4ee9@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 09:38:15AM +0300, Nikolay Borisov wrote:
> 
> 
> On 11.05.2018 03:11, Omar Sandoval wrote:
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
> >  fs/btrfs/inode.c       | 142 ++++++++++++-----------------------------
> >  2 files changed, 50 insertions(+), 111 deletions(-)
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
> > index 348dc57920f5..b9a046b8c72c 100644
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
> > +	if (test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
> > +			     &inode->runtime_flags))
> > +		return 0;
> 
> How come this can return true? Shouldn't btrfs_orphan_add always be
> called for an inode which doesn't have an orphan item? Having this check
> seems to indicate there is some non-determinism in the lifetime of
> orphan items.

Another great point, this was needed when we also inserted orphan items
for truncate, but it's not needed anymore. I'll clean that up, too.

> > -	if (insert)
> > -		atomic_inc(&root->orphan_inodes);
> > -	spin_unlock(&root->orphan_lock);
> > +	atomic_inc(&root->orphan_inodes);
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
> > -
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
> 
> Similar comment as in btrfs_orphan_del. Shouldn't this always follow a
> successful btrfs_orphan_add, guaranteeing there is an item for this
> inode? Are there some "benign" races that could happen in the mean time
> which could trigger this check ?

Same thing here, and it's even easier to convince myself here that it's
unnecessary: btrfs_evict_inode() ignores errors if something magical did
happen, and we really expect the orphan item to be there for an
O_TMPFILE in btrfs_link().
