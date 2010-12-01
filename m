From: Josef Bacik <josef@redhat.com>
Subject: Re: On Removing BUG_ON macros
Date: Wed, 1 Dec 2010 13:31:14 -0500
Message-ID: <20101201183113.GC7021@localhost.localdomain>
References: <AANLkTinQPUW3wRGU96mKA1DMHUoAQUrtKwqqQvvPoxB=@mail.gmail.com> <20101107145120.GF9728@dhcp231-156.rdu.redhat.com> <1289184847.3309.26.camel@localhost> <20101108124211.GA27816@dhcp231-156.rdu.redhat.com> <1289225174.3309.48.camel@localhost> <20101108141539.GD2515@localhost.localdomain> <1289228524.3309.51.camel@localhost> <1289449926.3078.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Yoshinori Sano <yoshinori.sano@gmail.com>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289449926.3078.9.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 11, 2010 at 12:32:06PM +0800, Ian Kent wrote:
> On Mon, 2010-11-08 at 23:02 +0800, Ian Kent wrote:
> > On Mon, 2010-11-08 at 09:15 -0500, Josef Bacik wrote:
> > > On Mon, Nov 08, 2010 at 10:06:13PM +0800, Ian Kent wrote:
> > > > On Mon, 2010-11-08 at 07:42 -0500, Josef Bacik wrote:
> > > > > On Mon, Nov 08, 2010 at 10:54:07AM +0800, Ian Kent wrote:
> > > > > > On Sun, 2010-11-07 at 09:51 -0500, Josef Bacik wrote:
> > > > > > > On Sun, Nov 07, 2010 at 04:16:47PM +0900, Yoshinori Sano wrote:
> > > > > > > > This is a question I've posted on the #btrfs IRC channel today.
> > > > > > > > hyperair adviced me to contact with Josef Bacik or Chris Mason.
> > > > > > > > So, I post my question to this maling list.
> > > > > > > > 
> > > > > > > > Here are my post on the IRC:
> > > > > > > > 
> > > > > > > > Actually, I want to remove BUG_ON(ret) around the Btrfs code.
> > > > > > > > The motivation is to make the Btrfs code more robust.
> > > > > > > > First of all, is this meaningless?
> > > > > > > > 
> > > > > > > > For example, there are code like the following:
> > > > > > > > 
> > > > > > > >     struct btrfs_path *path;
> > > > > > > >     path = btrfs_alloc_path();
> > > > > > > >     BUG_ON(!path);
> > > > > > > > 
> > > > > > > > This is a frequenty used pattern of current Btrfs code.
> > > > > > > > A btrfs_alloc_path()'s caller has to deal with the allocation failure
> > > > > > > > instead of using BUG_ON.  However, (this is what most interesting
> > > > > > > > thing for me) can the caller do any proper error handlings here?
> > > > > > > > I mean, is this a critical situation where we cannot recover from?
> > > > > > > >
> > > > > > > 
> > > > > > > No we're just lazy ;).  Tho making sure the caller can recover from getting
> > > > > > > -ENOMEM is very important, which is why in some of these paths we just do BUG_ON
> > > > > > > since fixing the callers is tricky.  A good strategy for things like this is to
> > > > > > > do something like
> > > > > > > 
> > > > > > > static int foo = 1;
> > > > > > > 
> > > > > > > path = btrfs_alloc_path();
> > > > > > > if (!path || !(foo % 1000))
> > > > > > > 	return -ENOMEM;
> > > > > > > foo++;
> > > > > > 
> > > > > > Hahaha, I love it.
> > > > > > 
> > > > > > So, return ENOMEM every 1000 times we call the containing function!
> > > > > > 
> > > > > > > 
> > > > > > > that way you can catch all the callers and make sure we're handling the error
> > > > > > > all the way up the chain properly.  Thanks,
> > > > > > 
> > > > > > Yeah, I suspect this approach will be a bit confusing though.
> > > > > > 
> > > > > > I believe that it will be more effective, although time consuming, to
> > > > > > work through the call tree function by function. Although, as I have
> > > > > > said, the problem is working out what needs to be done to recover,
> > > > > > rather than working out what the callers are. I'm not at all sure yet
> > > > > > but I also suspect that it may not be possible to recover in some cases,
> > > > > > which will likely lead to serious rework of some subsystems (but, hey,
> > > > > > who am I to say, I really don't have any clue yet).
> > > > > >
> > > > > 
> > > > > So we talked about this at plumbers.  First thing we need is a way to flip the
> > > > > filesystem read only, that way we can deal with the simple corruption cases.
> > > > 
> > > > Right, yes.
> > > > 
> > > > > And then we can start looking at these harder cases where it's really unclear
> > > > > about how to recover.
> > > > 
> > > > I have a way to go before I will even understand these cases.
> > > > 
> > > > > 
> > > > > Thankfully because we're COW we really shouldn't have any cases that we have to
> > > > > unwind anything, we just fail the operation and go on our happy merry way.  The
> > > > > only tricky thing is where we get ENOMEM when say inserting the metadata for
> > > > > data after writing out the data, since that will leave data just sitting around.
> > > > > Probably should look at what NFS does with dirty pages when the server hangs up.
> > > > 
> > > > OK, that's a though for me to focus on while I'm trying to work out
> > > > what's going on ... mmm.
> > > > 
> > > > Indeed, a large proportion of these are handling ENOMEM.
> > > > 
> > > > I somehow suspect your heavily focused on disk io itself when I'm still
> > > > back thinking about house keeping of operations, in the process of being
> > > > queued and those currently being processed, the later being the
> > > > difficult case. But I'll eventually get to worrying about io as part of
> > > > that process. It's also worth mentioning that my scope is also quite
> > > > narrow at this stage, focusing largely on the transaction subsystem,
> > > > although that tends to pull in a fair amount of other code too.
> > > > 
> > > 
> > > So the transaction stuff should be relatively simple since we shouldn't have too
> > > much to clean up if the transaction fails to allocate.  Maybe point out some
> > > places where you are having trouble and I can frame up what we'd want to do to
> > > give you an idea of where to go?  Thanks,
> > 
> > Thanks, I will when I have something to discuss or maybe I'll start with
> > the couple I have, when I get a chance to get back to it anyway.
> > 
> 
> How about we discuss this patch to start with?
> 
> The places where I have put "/* TODO: What to do here? */" are the
> places where I couldn't work out what to do or if some sort of recovery
> is needed or what effect a failure might have on continued operations.
> 
> btrfs - resolve bug_on()s in btrfs_record_root_in_trans()
> 
> From: Ian Kent <raven@themaw.net>
> 
> 
> ---
> 
>  fs/btrfs/ctree.c       |    3 ++-
>  fs/btrfs/disk-io.c     |    3 ++-
>  fs/btrfs/extent-tree.c |    4 +++-
>  fs/btrfs/inode.c       |    7 +++++--
>  fs/btrfs/ioctl.c       |    8 ++++++--
>  fs/btrfs/relocation.c  |   30 +++++++++++++++++++++++-------
>  fs/btrfs/root-tree.c   |    4 +++-
>  fs/btrfs/transaction.c |   15 ++++++++++++---
>  fs/btrfs/tree-log.c    |    1 +
>  9 files changed, 57 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 9ac1715..a1f46fa 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3832,7 +3832,8 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
>  	unsigned long ptr;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
>  	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
>  	if (!ret) {
>  		leaf = path->nodes[0];
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b40dfe4..066af87 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1105,7 +1105,8 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
>  		     root, fs_info, location->objectid);
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return ERR_PTR(-ENOMEM);
>  	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
>  	if (ret == 0) {
>  		l = path->nodes[0];
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a541bc8..d737cea6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7821,8 +7821,10 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
>  		}
>  
>  		mutex_lock(&extent_root->fs_info->trans_mutex);
> -		btrfs_record_root_in_trans(found_root);
> +		ret = btrfs_record_root_in_trans(found_root);
>  		mutex_unlock(&extent_root->fs_info->trans_mutex);
> +		if (ret < 0)
> +			goto out;
>  		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
>  			/*
>  			 * try to update data extent references while
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5132c9a..184b86a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6521,8 +6521,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	btrfs_set_trans_block_group(trans, new_dir);
>  
> -	if (dest != root)
> -		btrfs_record_root_in_trans(trans, dest);
> +	if (dest != root) {
> +		ret = btrfs_record_root_in_trans(trans, dest);
> +		if (ret)
> +			goto out_fail;
> +	}
>  
>  	ret = btrfs_set_inode_index(new_dir, &index);
>  	if (ret)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 463d91b..ba94d60 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -311,7 +311,9 @@ static noinline int create_subvol(struct btrfs_root *root,
>  	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
>  	BUG_ON(IS_ERR(new_root));
>  
> -	btrfs_record_root_in_trans(trans, new_root);
> +	ret = btrfs_record_root_in_trans(trans, new_root);
> +	if (ret)
> +		goto fail;
>  
>  	ret = btrfs_create_subvol_root(trans, new_root, new_dirid,
>  				       BTRFS_I(dir)->block_group);
> @@ -1442,7 +1444,9 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>  				dentry->d_name.len);
>  	BUG_ON(ret);
>  
> -	btrfs_record_root_in_trans(trans, dest);
> +	err = btrfs_record_root_in_trans(trans, dest);
> +	if (err)
> +		goto out_up_write;
>  
>  	memset(&dest->root_item.drop_progress, 0,
>  		sizeof(dest->root_item.drop_progress));
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 045c9c2..2e81b07 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1264,7 +1264,8 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
> -	BUG_ON(!root_item);
> +	if (!root_item)
> +		return ERR_PTR(-ENOMEM);
>  
>  	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
>  	root_key.type = BTRFS_ROOT_ITEM_KEY;
> @@ -1274,7 +1275,10 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
>  		/* called by btrfs_init_reloc_root */
>  		ret = btrfs_copy_root(trans, root, root->commit_root, &eb,
>  				      BTRFS_TREE_RELOC_OBJECTID);
> -		BUG_ON(ret);
> +		if (ret) {
> +			kfree(root_item);
> +			return ERR_PTR(ret);
> +		}
>  
>  		btrfs_set_root_last_snapshot(&root->root_item,
>  					     trans->transid - 1);
> @@ -1288,7 +1292,10 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
>  		 */
>  		ret = btrfs_copy_root(trans, root, root->node, &eb,
>  				      BTRFS_TREE_RELOC_OBJECTID);
> -		BUG_ON(ret);
> +		if (ret) {
> +			kfree(root_item);
> +			return ERR_PTR(ret);
> +		}
>  	}
>  
>  	memcpy(root_item, &root->root_item, sizeof(*root_item));
> @@ -1308,13 +1315,16 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
>  
>  	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
>  				&root_key, root_item);
> -	BUG_ON(ret);
> +	if (ret) {
> +		kfree(root_item);
> +		return ERR_PTR(ret);
> +	}
>  	kfree(root_item);
>  
>  	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
>  						 &root_key);
> -	BUG_ON(IS_ERR(reloc_root));
> -	reloc_root->last_trans = trans->transid;
> +	if (!IS_ERR(reloc_root))
> +		reloc_root->last_trans = trans->transid;
>  	return reloc_root;
>  }
>  
> @@ -1346,6 +1356,8 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
>  	reloc_root = create_reloc_root(trans, root, root->root_key.objectid);
>  	if (clear_rsv)
>  		trans->block_rsv = NULL;
> +	if (IS_ERR(reloc_root))
> +		return PTR_ERR(reloc_root);
>  
>  	__add_reloc_root(reloc_root);
>  	root->reloc_root = reloc_root;
> @@ -2275,10 +2287,12 @@ struct btrfs_root *select_reloc_root(struct btrfs_trans_handle *trans,
>  		BUG_ON(!root->ref_cows);
>  
>  		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
> +			/* TODO: what to do here? */
>  			record_reloc_root_in_trans(trans, root);
>  			break;
>  		}
>  
> +		/* TODO: what to do here? */
>  		btrfs_record_root_in_trans(trans, root);
>  		root = root->reloc_root;
>  

We should probably just check for a return value and pass it up the stack and
let the caller deal with it, there doesn't appear to be any cleanup stuff thats
needed.

> @@ -2715,7 +2729,9 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
>  		if (root->ref_cows) {
>  			BUG_ON(node->new_bytenr);
>  			BUG_ON(!list_empty(&node->list));
> -			btrfs_record_root_in_trans(trans, root);
> +			ret = btrfs_record_root_in_trans(trans, root);
> +			if (ret)
> +				goto out;
>  			root = root->reloc_root;
>  			node->new_bytenr = root->node->start;
>  			node->root = root;
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 6a1086e..045c924 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -140,7 +140,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  	unsigned long ptr;
>  
>  	path = btrfs_alloc_path();
> -	BUG_ON(!path);
> +	if (!path)
> +		return -ENOMEM;
> +
>  	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
>  	if (ret < 0)
>  		goto out;
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 1fffbc0..615264f 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -104,14 +104,18 @@ static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
>  					 struct btrfs_root *root)
>  {
>  	if (root->ref_cows && root->last_trans < trans->transid) {
> +		int ret;
> +
>  		WARN_ON(root == root->fs_info->extent_root);
>  		WARN_ON(root->commit_root != root->node);
>  
> +		/* TODO: cleanup tag set on error?  */
>  		radix_tree_tag_set(&root->fs_info->fs_roots_radix,
>  			   (unsigned long)root->root_key.objectid,
>  			   BTRFS_ROOT_TRANS_TAG);
>  		root->last_trans = trans->transid;
> -		btrfs_init_reloc_root(trans, root);
> +		ret = btrfs_init_reloc_root(trans, root);
> +		return ret;
>  	}
>  	return 0;
>  }

This is probably one of those cases where we want to flip read only, because
really we are screwed if we cannot setup a new root.  In this case we'd just
want to clear the radix tag and return the error and let the caller deal with
it.  This can be called by the snapshot stuff so it's not catastrophic if we
cant create a snapshot.  It's also called by the transaction stuff so all these
things should be able to return errors to userspace in a clean way.

> @@ -119,6 +123,8 @@ static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
>  int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root)
>  {
> +	int ret;
> +
>  	if (!root->ref_cows)
>  		return 0;
>  
> @@ -128,9 +134,9 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
>  		return 0;
>  	}
>  
> -	record_root_in_trans(trans, root);
> +	ret = record_root_in_trans(trans, root);
>  	mutex_unlock(&root->fs_info->trans_mutex);
> -	return 0;
> +	return ret;
>  }
>  
>  /* wait for commit against the current transaction to become unblocked
> @@ -227,6 +233,7 @@ again:
>  
>  	if (type != TRANS_JOIN_NOLOCK)
>  		mutex_lock(&root->fs_info->trans_mutex);
> +	/* TODO: what to do here? */
>  	record_root_in_trans(h, root);

Ok here we want to do something like

ret = record_root_in_trans(h, root);
if (ret) {
	if (type != TRANS_JOIN_NOLOCK)
		mutex_unlock(&root->fs_info->trans_mutex);
	btrfs_end_transaction(h, root);
	return ERR_PTR(ret);
}

>  	if (type != TRANS_JOIN_NOLOCK)
>  		mutex_unlock(&root->fs_info->trans_mutex);
> @@ -943,6 +950,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	dentry = pending->dentry;
>  	parent_inode = dentry->d_parent->d_inode;
>  	parent_root = BTRFS_I(parent_inode)->root;
> +	/* TODO: What to do here? */
>  	record_root_in_trans(trans, parent_root);
>  

Here we should be ok with

ret = record_root_in_trans(trans, parent_root);
if (ret) {
	pending->error = ret;
	goto fail;
}

>  	/*
> @@ -961,6 +969,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
>  	ret = btrfs_update_inode(trans, parent_root, parent_inode);
>  	BUG_ON(ret);
>  
> +	/* TODO: What to do here? */
>  	record_root_in_trans(trans, root);

This is a little trickier since we've created the dir item, so this

ret = record_root_in_trans(trans, root);
if (ret) {
	struct btrfs_dir_item *di;
	struct btrfs_path *path;

	pending->error = ret;
	path = btrfs_alloc_path();
	if (!path) {
		/*
		 * We're really screwed here, at this point we're just going to
		 * leave a dangling dir item that fsck will have to fix.
		 */
		pending->error = -ENOMEM;
		goto fail;
	}
	di = btrfs_lookup_dir_item(trans, parent_root, path,
				   parent_inode->i_ino, dentry->d_name.name,
				   dentry->d_name.len, -1);
	if (IS_ERR(di)) {
		pending->error = PTR_ERR(di);
		btrfs_free_path(path);
		goto fail;
	}
	ret = btrfs_delete_one_dir_name(trans, parent_root, path, di);
	btrfs_free_path(path);
	if (ret) {
		pending->error = PTR_ERR(ret);
		goto fail;
	}
	goto fail;
}

>  	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>  	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a29f193..bc25896 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3106,6 +3106,7 @@ again:
>  		BUG_ON(!wc.replay_dest);
>  
>  		wc.replay_dest->log_root = log;
> +		/* TODO: What to do here? */
>  		btrfs_record_root_in_trans(trans, wc.replay_dest);
>  		ret = walk_log_tree(trans, log, &wc);
>  		BUG_ON(ret);
> 
>

This would be bad because it means we can't recover the log.  What we would want
to do is make a fail: label at the end of the function right before the commit
transaction and just goto fail.  You'll want to move the btrfs_free_path() down
so that gets called too.  This is in case we managed to recover some things but
not all of them.  Returning an error from this function should mean the fs
doesn't get mounted.

I think thats all of them, HTH.  Thanks,

Josef
