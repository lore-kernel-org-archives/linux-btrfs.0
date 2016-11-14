Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:35588 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcKNQkT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 11:40:19 -0500
Received: by mail-pg0-f45.google.com with SMTP id p66so55822409pga.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 08:40:19 -0800 (PST)
Date: Mon, 14 Nov 2016 08:33:51 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/6] btrfs-progs: add btrfs_clear_free_space_tree() from
 the kernel
Message-ID: <20161114163351.GA26794@vader>
References: <cover.1479064970.git.osandov@fb.com>
 <7e976947939c42bec9756dd02b705d3b2bc387fc.1479064970.git.osandov@fb.com>
 <33ac5417-0e5d-af0d-6b8e-c6603795d429@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <33ac5417-0e5d-af0d-6b8e-c6603795d429@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 09:38:19AM +0800, Qu Wenruo wrote:
> 
> 
> At 11/14/2016 03:35 AM, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> Only small nits about the BUG_ON() and return value.
> Despite that, feel free to add my reviewed-by:
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > ---
> >  ctree.h           |  6 ++++
> >  extent-tree.c     | 10 +++++++
> >  free-space-tree.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  free-space-tree.h |  1 +
> >  root-tree.c       | 22 ++++++++++++++
> >  5 files changed, 126 insertions(+)
> > 
> > diff --git a/ctree.h b/ctree.h
> > index d67b852..90193ad 100644
> > --- a/ctree.h
> > +++ b/ctree.h
> > @@ -2504,6 +2504,10 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  		  struct extent_buffer *buf, int record_parent);
> >  int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  		  struct extent_buffer *buf, int record_parent);
> > +void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
> > +			   struct btrfs_root *root,
> > +			   struct extent_buffer *buf,
> > +			   u64 parent, int last_ref);
> >  int btrfs_free_extent(struct btrfs_trans_handle *trans,
> >  		      struct btrfs_root *root,
> >  		      u64 bytenr, u64 num_bytes, u64 parent,
> > @@ -2664,6 +2668,8 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
> >  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
> >  		      *root, struct btrfs_key *key, struct btrfs_root_item
> >  		      *item);
> > +int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> > +		   struct btrfs_key *key);
> >  int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
> >  		      *root, struct btrfs_key *key, struct btrfs_root_item
> >  		      *item);
> > diff --git a/extent-tree.c b/extent-tree.c
> > index 3b1577e..d445723 100644
> > --- a/extent-tree.c
> > +++ b/extent-tree.c
> > @@ -2467,6 +2467,16 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
> >  	return err;
> >  }
> > 
> > +
> > +void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
> > +			   struct btrfs_root *root,
> > +			   struct extent_buffer *buf,
> > +			   u64 parent, int last_ref)
> > +{
> > +	btrfs_free_extent(trans, root, buf->start, buf->len, parent,
> > +			  root->root_key.objectid, btrfs_header_level(buf), 0);
> > +}
> 
> btrfs_free_extent() will return int.
> 
> Better return it.

Will fix.

> > +
> >  /*
> >   * remove an extent from the root, returns 0 on success
> >   */
> > diff --git a/free-space-tree.c b/free-space-tree.c
> > index 3c7a246..d972f26 100644
> > --- a/free-space-tree.c
> > +++ b/free-space-tree.c
> > @@ -20,6 +20,7 @@
> >  #include "disk-io.h"
> >  #include "free-space-cache.h"
> >  #include "free-space-tree.h"
> > +#include "transaction.h"
> > 
> >  static struct btrfs_free_space_info *
> >  search_free_space_info(struct btrfs_trans_handle *trans,
> > @@ -67,6 +68,92 @@ static int free_space_test_bit(struct btrfs_block_group_cache *block_group,
> >  	return !!extent_buffer_test_bit(leaf, ptr, i);
> >  }
> > 
> > +static int clear_free_space_tree(struct btrfs_trans_handle *trans,
> > +				 struct btrfs_root *root)
> > +{
> > +	struct btrfs_path *path;
> > +	struct btrfs_key key;
> > +	int nr;
> > +	int ret;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	key.objectid = 0;
> > +	key.type = 0;
> > +	key.offset = 0;
> > +
> > +	while (1) {
> > +		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> > +		if (ret < 0)
> > +			goto out;
> > +
> > +		nr = btrfs_header_nritems(path->nodes[0]);
> > +		if (!nr)
> > +			break;
> > +
> > +		path->slots[0] = 0;
> > +		ret = btrfs_del_items(trans, root, path, 0, nr);
> > +		if (ret)
> > +			goto out;
> > +
> > +		btrfs_release_path(path);
> > +	}
> > +
> > +	ret = 0;
> > +out:
> > +	btrfs_free_path(path);
> > +	return ret;
> > +}
> > +
> > +int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_root *tree_root = fs_info->tree_root;
> > +	struct btrfs_root *free_space_root = fs_info->free_space_root;
> > +	int ret;
> > +	u64 features;
> > +
> > +	trans = btrfs_start_transaction(tree_root, 0);
> > +	if (IS_ERR(trans))
> > +		return PTR_ERR(trans);
> > +
> > +
> > +	features = btrfs_super_compat_ro_flags(fs_info->super_copy);
> > +	features &= ~(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID |
> > +		      BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE);
> > +	btrfs_set_super_compat_ro_flags(fs_info->super_copy, features);
> > +	fs_info->free_space_root = NULL;
> > +
> > +	ret = clear_free_space_tree(trans, free_space_root);
> > +	if (ret)
> > +		goto abort;
> > +
> > +	ret = btrfs_del_root(trans, tree_root, &free_space_root->root_key);
> > +	if (ret)
> > +		goto abort;
> > +
> > +	list_del(&free_space_root->dirty_list);
> > +
> > +	clean_tree_block(trans, tree_root, free_space_root->node);
> 
> Better catch the return value.
> 
> > +	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,
> > +			      0, 1);
> 
> Here too.

Oh yeah these two return void in the kernel, but I'll fix it here.

> > +
> > +	free_extent_buffer(free_space_root->node);
> > +	free_extent_buffer(free_space_root->commit_root);
> > +	kfree(free_space_root);
> > +
> > +	ret = btrfs_commit_transaction(trans, tree_root);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +
> > +abort:
> 
> This reminds me again that we really need a btrfs_abort_transaction() in
> btrfs-progs.
> (And I always forget to implement it)
> 
> > +	return ret;
> > +}
> > +
> >  static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
> >  				   struct btrfs_block_group_cache *block_group,
> >  				   struct btrfs_path *path,
> > diff --git a/free-space-tree.h b/free-space-tree.h
> > index 7529a46..4845f13 100644
> > --- a/free-space-tree.h
> > +++ b/free-space-tree.h
> > @@ -19,6 +19,7 @@
> >  #ifndef __BTRFS_FREE_SPACE_TREE_H__
> >  #define __BTRFS_FREE_SPACE_TREE_H__
> > 
> > +int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info);
> >  int load_free_space_tree(struct btrfs_fs_info *fs_info,
> >  			 struct btrfs_block_group_cache *block_group);
> > 
> > diff --git a/root-tree.c b/root-tree.c
> > index cca424e..c660447 100644
> > --- a/root-tree.c
> > +++ b/root-tree.c
> > @@ -143,6 +143,28 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
> >  	return ret;
> >  }
> > 
> > +/* drop the root item for 'key' from 'root' */
> > +int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> > +		   struct btrfs_key *key)
> > +{
> > +	struct btrfs_path *path;
> > +	int ret;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	BUG_ON(ret != 0);
> 
> Better to avoid BUG_ON().
> 
> Return -ENOENT seems good enough.

Copied this straight from the kernel, but you're right, no reason to
crash progs.

Thanks for the review!

> Thanks,
> Qu
> 
> > +
> > +	ret = btrfs_del_item(trans, root, path);
> > +out:
> > +	btrfs_free_path(path);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * add a btrfs_root_ref item.  type is either BTRFS_ROOT_REF_KEY
> >   * or BTRFS_ROOT_BACKREF_KEY.
> > 
> 
> 

-- 
Omar
