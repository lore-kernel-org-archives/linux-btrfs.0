From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1301!
Date: Tue, 21 Jun 2011 02:08:54 +0200
Message-ID: <20110621000854.GJ12709@twin.jikos.cz>
References: <4DFB7C77.6010807@sandia.gov>
 <4DFF1CFA.7060201@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Schutt <jaschut@sandia.gov>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, ceph-devel@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFF1CFA.7060201@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2011 at 06:12:10PM +0800, Miao Xie wrote:
> >From 457f39393b2e3d475fbba029b90b6a4e17b94d43 Mon Sep 17 00:00:00 2001
> From: Miao Xie <miaox@cn.fujitsu.com>
> Date: Mon, 20 Jun 2011 17:21:51 +0800
> Subject: [PATCH] btrfs: fix inconsonant inode information
> 
> When iputting the inode, We may leave the delayed nodes if they have some
> delayed items that have not been dealt with. So when the inode is read again,
> we must look up the relative delayed node, and use the information in it to
> initialize the inode. Or we will get inconsonant inode information.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-inode.c |  104 +++++++++++++++++++++++++++++++++++-----------
>  fs/btrfs/delayed-inode.h |    1 +
>  fs/btrfs/inode.c         |   12 ++++-
>  3 files changed, 91 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index f1cbd02..280755e 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -82,19 +82,16 @@ static inline struct btrfs_delayed_root *btrfs_get_delayed_root(
>  	return root->fs_info->delayed_root;
>  }
>  
> -static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
> -							struct inode *inode)
> +static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
>  {
> -	struct btrfs_delayed_node *node;
>  	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
>  	struct btrfs_root *root = btrfs_inode->root;
>  	u64 ino = btrfs_ino(inode);
> -	int ret;
> +	struct btrfs_delayed_node *node;
>  
> -again:
>  	node = ACCESS_ONCE(btrfs_inode->delayed_node);

do you still need the volatile access here, after the again: label has
been removed? it does not break things if it's there, but it raises
questions ...

>  	if (node) {
> -		atomic_inc(&node->refs);	/* can be accessed */
> +		atomic_inc(&node->refs);
>  		return node;
>  	}
>  
> @@ -103,7 +100,9 @@ again:
>  	if (node) {
>  		if (btrfs_inode->delayed_node) {
>  			spin_unlock(&root->inode_lock);
> -			goto again;
> +			BUG_ON(btrfs_inode->delayed_node != node);
> +			atomic_inc(&node->refs);	/* can be accessed */
> +			return node;
>  		}
>  		btrfs_inode->delayed_node = node;
>  		atomic_inc(&node->refs);	/* can be accessed */
> @@ -113,6 +112,23 @@ again:
>  	}
>  	spin_unlock(&root->inode_lock);
>  
> +	return NULL;
> +}
> +
> +static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
> +							struct inode *inode)
> +{
> +	struct btrfs_delayed_node *node;
> +	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
> +	struct btrfs_root *root = btrfs_inode->root;
> +	u64 ino = btrfs_ino(inode);
> +	int ret;
> +
> +again:
> +	node = btrfs_get_delayed_node(inode);

... aha, it's been somehow moved here, which copies the original logic.
Now reading inode->delayed_node is inside a function and I do not think
that compiler could optimize reading value of btrfs_inode->delayed_node
that it would require ACCESS_ONCE.

And there is another ACCESS_ONCE in btrfs_remove_delayed_node. I wonder
what's the reason for that. Sorry to abuse this thread, but I'd like to
be sure about protection of the ->delayed_node members inside
btrfs_inode. Can you please comment on that?

If you recall one message from the original report:

[ 5447.554187] err add delayed dir index item(name: pglog_0.965_0)
into the insertion tree of the delayed node(root id:
262, inode id: 258, errno: -17)

(-17 == -EEXIST)

a printk after return from __btrfs_add_delayed_item (which is
able to return -EEXIST) in btrfs_insert_delayed_dir_index. I haven't
looked farther, but it seems that the item is being inserted (at least)
twice and I suspect missing locking or other type of protection.


thanks,
david

> +	if (node)
> +		return node;
> +
>  	node = kmem_cache_alloc(delayed_node_cache, GFP_NOFS);
>  	if (!node)
>  		return ERR_PTR(-ENOMEM);
> @@ -548,19 +564,6 @@ struct btrfs_delayed_item *__btrfs_next_delayed_item(
>  	return next;
>  }
>  
> -static inline struct btrfs_delayed_node *btrfs_get_delayed_node(
> -							struct inode *inode)
> -{
> -	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
> -	struct btrfs_delayed_node *delayed_node;
> -
> -	delayed_node = btrfs_inode->delayed_node;
> -	if (delayed_node)
> -		atomic_inc(&delayed_node->refs);
> -
> -	return delayed_node;
> -}
> -
>  static inline struct btrfs_root *btrfs_get_fs_root(struct btrfs_root *root,
>  						   u64 root_id)
>  {
> @@ -1404,8 +1407,7 @@ end:
>  
>  int btrfs_inode_delayed_dir_index_count(struct inode *inode)
>  {
> -	struct btrfs_delayed_node *delayed_node = BTRFS_I(inode)->delayed_node;
> -	int ret = 0;
> +	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
>  
>  	if (!delayed_node)
>  		return -ENOENT;
> @@ -1415,11 +1417,14 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode)
>  	 * a new directory index is added into the delayed node and index_cnt
>  	 * is updated now. So we needn't lock the delayed node.
>  	 */
> -	if (!delayed_node->index_cnt)
> +	if (!delayed_node->index_cnt) {
> +		btrfs_release_delayed_node(delayed_node);
>  		return -EINVAL;
> +	}
>  
>  	BTRFS_I(inode)->index_cnt = delayed_node->index_cnt;
> -	return ret;
> +	btrfs_release_delayed_node(delayed_node);
> +	return 0;
>  }
>  
>  void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
> @@ -1613,6 +1618,57 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
>  				      inode->i_ctime.tv_nsec);
>  }
>  
> +int btrfs_fill_inode(struct inode *inode, u32 *rdev)
> +{
> +	struct btrfs_delayed_node *delayed_node;
> +	struct btrfs_inode_item *inode_item;
> +	struct btrfs_timespec *tspec;
> +
> +	delayed_node = btrfs_get_delayed_node(inode);
> +	if (!delayed_node)
> +		return -ENOENT;
> +
> +	mutex_lock(&delayed_node->mutex);
> +	if (!delayed_node->inode_dirty) {
> +		mutex_unlock(&delayed_node->mutex);
> +		btrfs_release_delayed_node(delayed_node);
> +		return -ENOENT;
> +	}
> +
> +	inode_item = &delayed_node->inode_item;
> +
> +	inode->i_uid = btrfs_stack_inode_uid(inode_item);
> +	inode->i_gid = btrfs_stack_inode_gid(inode_item);
> +	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
> +	inode->i_mode = btrfs_stack_inode_mode(inode_item);
> +	inode->i_nlink = btrfs_stack_inode_nlink(inode_item);
> +	inode_set_bytes(inode, btrfs_stack_inode_nbytes(inode_item));
> +	BTRFS_I(inode)->generation = btrfs_stack_inode_generation(inode_item);
> +	BTRFS_I(inode)->sequence = btrfs_stack_inode_sequence(inode_item);
> +	inode->i_rdev = 0;
> +	*rdev = btrfs_stack_inode_rdev(inode_item);
> +	BTRFS_I(inode)->flags = btrfs_stack_inode_flags(inode_item);
> +
> +	tspec = btrfs_inode_atime(inode_item);
> +	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(tspec);
> +	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
> +
> +	tspec = btrfs_inode_mtime(inode_item);
> +	inode->i_mtime.tv_sec = btrfs_stack_timespec_sec(tspec);
> +	inode->i_mtime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
> +
> +	tspec = btrfs_inode_ctime(inode_item);
> +	inode->i_ctime.tv_sec = btrfs_stack_timespec_sec(tspec);
> +	inode->i_ctime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
> +
> +	inode->i_generation = BTRFS_I(inode)->generation;
> +	BTRFS_I(inode)->index_cnt = (u64)-1;
> +
> +	mutex_unlock(&delayed_node->mutex);
> +	btrfs_release_delayed_node(delayed_node);
> +	return 0;
> +}
> +
>  int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root, struct inode *inode)
>  {
> diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
> index d1a6a29..8d27af4 100644
> --- a/fs/btrfs/delayed-inode.h
> +++ b/fs/btrfs/delayed-inode.h
> @@ -119,6 +119,7 @@ void btrfs_kill_delayed_inode_items(struct inode *inode);
>  
>  int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root, struct inode *inode);
> +int btrfs_fill_inode(struct inode *inode, u32 *rdev);
>  
>  /* Used for drop dead root */
>  void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5813dec..1d25a04 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2509,6 +2509,11 @@ static void btrfs_read_locked_inode(struct inode *inode)
>  	int maybe_acls;
>  	u32 rdev;
>  	int ret;
> +	bool filled = false;
> +
> +	ret = btrfs_fill_inode(inode, &rdev);
> +	if (!ret)
> +		filled = true;
>  
>  	path = btrfs_alloc_path();
>  	BUG_ON(!path);
> @@ -2520,6 +2525,10 @@ static void btrfs_read_locked_inode(struct inode *inode)
>  		goto make_bad;
>  
>  	leaf = path->nodes[0];
> +
> +	if (filled)
> +		goto cache_acl;
> +
>  	inode_item = btrfs_item_ptr(leaf, path->slots[0],
>  				    struct btrfs_inode_item);
>  	if (!leaf->map_token)
> @@ -2556,7 +2565,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
>  
>  	BTRFS_I(inode)->index_cnt = (u64)-1;
>  	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
> -
> +cache_acl:
>  	/*
>  	 * try to precache a NULL acl entry for files that don't have
>  	 * any xattrs or acls
> @@ -2572,7 +2581,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
>  	}
>  
>  	btrfs_free_path(path);
> -	inode_item = NULL;
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFREG:
> -- 
> 1.7.4
> 

