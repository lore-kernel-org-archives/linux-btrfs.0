Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:57736 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2HOPEv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 11:04:51 -0400
Message-ID: <502BBA90.90403@jan-o-sch.net>
Date: Wed, 15 Aug 2012 17:04:48 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 2/3] btrfs: extended inode refs
References: <1344452147-19409-1-git-send-email-mfasheh@suse.de> <1344452147-19409-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1344452147-19409-3-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When applying this patch I get:

warning: 2 lines add whitespace errors.

More comments inline.

On Wed, August 08, 2012 at 20:55 (+0200), Mark Fasheh wrote:
> Teach tree-log.c about extended inode refs. In particular, we have to adjust
> the behavior of inode ref replay as well as log tree recovery to account for
> the existence of extended refs.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/backref.c  |   68 ++++++++++++
>  fs/btrfs/backref.h  |    5 +
>  fs/btrfs/tree-log.c |  297 ++++++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 319 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index a383c18..658e09c 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1111,6 +1111,74 @@ static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  				found_key);
>  }
>  
> +int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> +			  u64 start_off, struct btrfs_path *path,
> +			  struct btrfs_inode_extref **ret_extref,
> +			  u64 *found_off)
> +{
> +	int ret, slot;
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +	struct btrfs_inode_extref *extref;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +
> +	key.objectid = inode_objectid;
> +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
> +	key.offset = start_off;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	while (1) {
> +		leaf = path->nodes[0];
> +		slot = path->slots[0];
> +		if (slot >= btrfs_header_nritems(leaf)) {
> +			/*
> +			 * If the item at offset is not found,
> +			 * btrfs_search_slot will point us to the slot
> +			 * where it should be inserted. In our case
> +			 * that will be the slot directly before the
> +			 * next INODE_REF_KEY_V2 item. In the case
> +			 * that we're pointing to the last slot in a
> +			 * leaf, we must move one leaf over.
> +			 */
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret) {
> +				if (ret >= 1)
> +					ret = -ENOENT;
> +				break;
> +			}

We can finally replace this with btrfs_search_slot_for_read, according to my
first suggestion. It's merged now. Saves that long comment and the whole
while-1-continue construct, which is quite cumbersome to read.

> +			continue;
> +		}
> +
> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> +
> +		/*
> +		 * Check that we're still looking at an extended ref key for
> +		 * this particular objectid. If we have different
> +		 * objectid or type then there are no more to be found
> +		 * in the tree and we can exit.
> +		 */
> +		ret = -ENOENT;
> +		if (found_key.objectid != inode_objectid)
> +			break;
> +		if (btrfs_key_type(&found_key) != BTRFS_INODE_EXTREF_KEY)
> +			break;
> +
> +		ret = 0;
> +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +		extref = (struct btrfs_inode_extref *)ptr;
> +		*ret_extref = extref;
> +		if (found_off)
> +			*found_off = found_key.offset;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * this iterates to turn a btrfs_inode_ref into a full filesystem path. elements
>   * of the path are separated by '/' and the path is guaranteed to be
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index c18d8ac..9f3e251 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -66,4 +66,9 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
>  					struct btrfs_path *path);
>  void free_ipath(struct inode_fs_paths *ipath);
>  
> +int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> +			  u64 start_off, struct btrfs_path *path,
> +			  struct btrfs_inode_extref **ret_extref,
> +			  u64 *found_off);
> +
>  #endif
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 8abeae4..e5ba0a4 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -23,8 +23,10 @@
>  #include "disk-io.h"
>  #include "locking.h"
>  #include "print-tree.h"
> +#include "backref.h"
>  #include "compat.h"
>  #include "tree-log.h"
> +#include "hash.h"
>  
>  /* magic values for the inode_only field in btrfs_log_inode:
>   *
> @@ -764,8 +766,16 @@ static noinline int backref_in_log(struct btrfs_root *log,
>  	if (ret != 0)
>  		goto out;
>  
> -	item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
>  	ptr = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
> +
> +	if (key->type == BTRFS_INODE_EXTREF_KEY) {
> +		if (btrfs_find_name_in_ext_backref(path, name, namelen, NULL))
> +			match = 1;
> +
> +		goto out;
> +	}
> +
> +	item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
>  	ptr_end = ptr + item_size;
>  	while (ptr < ptr_end) {
>  		ref = (struct btrfs_inode_ref *)ptr;
> @@ -786,6 +796,47 @@ out:
>  	return match;
>  }
>  
> +static int extref_get_fields(struct extent_buffer *eb, int slot,
> +			     u32 *namelen, char **name, u64 *index,
> +			     u64 *parent_objectid)
> +{
> +	struct btrfs_inode_extref *extref;
> +
> +	extref = (struct btrfs_inode_extref *)btrfs_item_ptr_offset(eb, slot);
> +
> +	*namelen = btrfs_inode_extref_name_len(eb, extref);
> +	*name = kmalloc(*namelen, GFP_NOFS);
> +	if (*name == NULL)
> +		return -ENOMEM;
> +
> +	read_extent_buffer(eb, *name, (unsigned long)&extref->name,
> +			   *namelen);
> +
> +	*index = btrfs_inode_extref_index(eb, extref);
> +	if (parent_objectid)
> +		*parent_objectid = btrfs_inode_extref_parent(eb, extref);
> +
> +	return 0;
> +}
> +
> +static int ref_get_fields(struct extent_buffer *eb, int slot, u32 *namelen,
> +			  char **name, u64 *index)
> +{
> +	struct btrfs_inode_ref *ref;
> +
> +	ref = (struct btrfs_inode_ref *)btrfs_item_ptr_offset(eb, slot);
> +
> +	*namelen = btrfs_inode_ref_name_len(eb, ref);
> +	*name = kmalloc(*namelen, GFP_NOFS);	
> +	if (*name == NULL)
> +		return -ENOMEM;
> +
> +	read_extent_buffer(eb, *name, (unsigned long)(ref + 1), *namelen);
> +
> +	*index = btrfs_inode_ref_index(eb, ref);
> +
> +	return 0;
> +}
>  
>  /*
>   * replay one inode back reference item found in the log tree.
> @@ -801,15 +852,50 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  				  struct btrfs_key *key)

Control flow in this function is horrible. I finally failed to understand it.
That's why I made a patch that replaces most gotos by if blocks and uses a sub
function (see the end of this email). I hope that it's getting easier to extend
that patched version. Cannot comment on changes to code I don't understand, sorry.

If you find my patch helps understanding that function and makes patching
easier, you can include that patch in your patch set as patch 2/4 and then do
your extension afterwards.

>  {
>  	struct btrfs_inode_ref *ref;
> +	struct btrfs_inode_extref *extref;
>  	struct btrfs_dir_item *di;
> +	struct btrfs_key search_key;
>  	struct inode *dir;
>  	struct inode *inode;
>  	unsigned long ref_ptr;
>  	unsigned long ref_end;
>  	char *name;
> +	char *victim_name;
>  	int namelen;
> +	int victim_name_len;
>  	int ret;
>  	int search_done = 0;
> +	int log_ref_ver = 0;
> +	u64 parent_objectid;
> +	u64 inode_objectid;
> +	u64 ref_index;
> +	struct extent_buffer *leaf;
> +	int ref_struct_size;
> +
> +
> +	ref_ptr = btrfs_item_ptr_offset(eb, slot);
> +	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
> +
> +	if (key->type == BTRFS_INODE_EXTREF_KEY) {	
> +		ref_struct_size = sizeof(*extref);
> +		log_ref_ver = 1;
> +
> +		ret = extref_get_fields(eb, slot, &namelen, &name, &ref_index,
> +					&parent_objectid);
> +		if (ret)
> +			return ret;
> +	} else {
> +		ref_struct_size = sizeof(*ref);
> +
> +		ret = ref_get_fields(eb, slot, &namelen, &name, &ref_index);
> +		if (ret)
> +			return ret;
> +
> +
> +		parent_objectid = key->offset;
> +	}
> +
> +	inode_objectid = key->objectid;
>  
>  	/*
>  	 * it is possible that we didn't log all the parent directories
> @@ -817,32 +903,20 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  	 * copy the back ref in.  The link count fixup code will take
>  	 * care of the rest
>  	 */
> -	dir = read_one_inode(root, key->offset);
> +	dir = read_one_inode(root, parent_objectid);
>  	if (!dir)
>  		return -ENOENT;
>  
> -	inode = read_one_inode(root, key->objectid);
> +	inode = read_one_inode(root, inode_objectid);
>  	if (!inode) {
>  		iput(dir);
>  		return -EIO;
>  	}
>  
> -	ref_ptr = btrfs_item_ptr_offset(eb, slot);
> -	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
> -
>  again:
> -	ref = (struct btrfs_inode_ref *)ref_ptr;
> -
> -	namelen = btrfs_inode_ref_name_len(eb, ref);
> -	name = kmalloc(namelen, GFP_NOFS);
> -	BUG_ON(!name);
> -
> -	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
> -
>  	/* if we already have a perfect match, we're done */
>  	if (inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
> -			 btrfs_inode_ref_index(eb, ref),
> -			 name, namelen)) {
> +			 ref_index, name, namelen)) {
>  		goto out;
>  	}
>  
> @@ -857,19 +931,23 @@ again:
>  	if (search_done)
>  		goto insert;
>  
> -	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
> +	/* Search old style refs */
> +	search_key.objectid = inode_objectid;
> +	search_key.type = BTRFS_INODE_REF_KEY;
> +	search_key.offset = parent_objectid;
> +
> +	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
>  	if (ret == 0) {
> -		char *victim_name;
> -		int victim_name_len;
>  		struct btrfs_inode_ref *victim_ref;
>  		unsigned long ptr;
>  		unsigned long ptr_end;
> -		struct extent_buffer *leaf = path->nodes[0];
> +
> +		leaf = path->nodes[0];
>  
>  		/* are we trying to overwrite a back ref for the root directory
>  		 * if so, just jump out, we're done
>  		 */
> -		if (key->objectid == key->offset)
> +		if (search_key.objectid == search_key.offset)
>  			goto out_nowrite;
>  
>  		/* check all the names in this back reference to see
> @@ -889,7 +967,7 @@ again:
>  					   (unsigned long)(victim_ref + 1),
>  					   victim_name_len);
>  
> -			if (!backref_in_log(log, key, victim_name,
> +			if (!backref_in_log(log, &search_key, victim_name,
>  					    victim_name_len)) {
>  				btrfs_inc_nlink(inode);
>  				btrfs_release_path(path);
> @@ -903,19 +981,61 @@ again:
>  			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
>  		}
>  		BUG_ON(ret);
> -
>  		/*
>  		 * NOTE: we have searched root tree and checked the
> -		 * coresponding ref, it does not need to check again.
> +		 * coresponding refs, it does not need to be checked again.
>  		 */
>  		search_done = 1;
>  	}
>  	btrfs_release_path(path);
>  
> +	/* Same search but for extended refs */
> +	extref = btrfs_lookup_inode_extref(NULL, root, path, name, namelen,
> +					   inode_objectid, parent_objectid, 0,
> +					   0);
> +	if (!IS_ERR_OR_NULL(extref)) {

Okay, one obvious comment at least: You don't execute this block on
IS_ERR(extref), but you don't act on that situation either. Is that on purpose?

> +		u32 item_size;
> +		u32 cur_offset = 0;
> +		unsigned long base;
> +
> +		leaf = path->nodes[0];
> +
> +		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> +		base = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +		while (cur_offset < item_size) {
> +			extref = (struct btrfs_inode_extref *)base + cur_offset;
> +
> +			victim_name_len = btrfs_inode_extref_name_len(eb, extref);
> +			victim_name = kmalloc(namelen, GFP_NOFS);
> +			leaf = path->nodes[0];
> +			read_extent_buffer(eb, name, (unsigned long)&extref->name, namelen);
> +
> +			search_key.objectid = inode_objectid;
> +			search_key.type = BTRFS_INODE_EXTREF_KEY;
> +			search_key.offset = btrfs_extref_hash(parent_objectid,
> +							      name, namelen);
> +			if (!backref_in_log(log, &search_key, victim_name,
> +					    victim_name_len)) {
> +				btrfs_inc_nlink(inode);
> +				btrfs_release_path(path);
> +
> +				ret = btrfs_unlink_inode(trans, root, dir,
> +							 inode, victim_name,
> +							 victim_name_len);
> +			}
> +			kfree(victim_name);
> +			BUG_ON(ret);
> +
> +			cur_offset += victim_name_len + sizeof(*extref);
> +		}
> +		search_done = 1;
> +	}
> +
> +
>  	/* look for a conflicting sequence number */
>  	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
> -					 btrfs_inode_ref_index(eb, ref),
> -					 name, namelen, 0);
> +					 ref_index, name, namelen, 0);
>  	if (di && !IS_ERR(di)) {
>  		ret = drop_one_dir_item(trans, root, path, dir, di);
>  		BUG_ON(ret);
> @@ -933,17 +1053,25 @@ again:
>  
>  insert:
>  	/* insert our name */
> -	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
> -			     btrfs_inode_ref_index(eb, ref));
> +	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0, ref_index);
>  	BUG_ON(ret);
>  
>  	btrfs_update_inode(trans, root, inode);
>  
>  out:
> -	ref_ptr = (unsigned long)(ref + 1) + namelen;
> +	ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
>  	kfree(name);
> -	if (ref_ptr < ref_end)
> +	if (ref_ptr < ref_end) {
> +		if (log_ref_ver) {
> +			ret = extref_get_fields(eb, slot, &namelen, &name,
> +						&ref_index, NULL);
> +		} else {
> +			ret = ref_get_fields(eb, slot, &namelen, &name,
> +					     &ref_index);
> +		}
> +		BUG_ON(ret);
>  		goto again;
> +	}
>  
>  	/* finally write the back reference in the inode */
>  	ret = overwrite_item(trans, root, path, eb, slot, key);
> @@ -966,25 +1094,52 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +static int count_inode_extrefs(struct btrfs_root *root,
> +			       struct inode *inode, struct btrfs_path *path)
> +{
> +	int ret = 0;
> +	int name_len;
> +	unsigned int nlink = 0;
> +	u32 item_size;
> +	u32 cur_offset = 0;
> +	u64 inode_objectid = btrfs_ino(inode);
> +	u64 offset = 0;
> +	unsigned long ptr;
> +	struct btrfs_inode_extref *extref;
> +	struct extent_buffer *leaf;
> +
> +	while (1) {
> +		ret = btrfs_find_one_extref(root, inode_objectid, offset, path,
> +					    &extref, &offset);
> +		if (ret)
> +			break;
>  
> -/*
> - * There are a few corners where the link count of the file can't
> - * be properly maintained during replay.  So, instead of adding
> - * lots of complexity to the log code, we just scan the backrefs
> - * for any file that has been through replay.
> - *
> - * The scan will update the link count on the inode to reflect the
> - * number of back refs found.  If it goes down to zero, the iput
> - * will free the inode.
> - */
> -static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
> -					   struct btrfs_root *root,
> -					   struct inode *inode)
> +		leaf = path->nodes[0];
> +		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +
> +		while (cur_offset < item_size) {
> +			extref = (struct btrfs_inode_extref *) (ptr + cur_offset);
> +			name_len = btrfs_inode_extref_name_len(leaf, extref);
> +
> +			nlink++;
> +
> +			cur_offset += name_len + sizeof(*extref);
> +		}
> +
> +		offset++;
> +	}
> +	btrfs_release_path(path);
> +
> +	return (ret == 0) ? nlink : ret;

You depend on btrfs_find_one_extref never returning >0 here. I'd make that ...

 if (ret < 0)
 	return ret;
 return nlink;

This ignores ret > 0 explicitly, which is in my opinion better than a spurious
link count.

> +}
> +
> +static int count_inode_refs(struct btrfs_root *root,
> +			       struct inode *inode, struct btrfs_path *path)
>  {
> -	struct btrfs_path *path;
>  	int ret;
>  	struct btrfs_key key;
> -	u64 nlink = 0;
> +	unsigned int nlink = 0;
>  	unsigned long ptr;
>  	unsigned long ptr_end;
>  	int name_len;
> @@ -994,10 +1149,6 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
>  	key.type = BTRFS_INODE_REF_KEY;
>  	key.offset = (u64)-1;
>  
> -	path = btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> -
>  	while (1) {
>  		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  		if (ret < 0)
> @@ -1031,6 +1182,45 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
>  		btrfs_release_path(path);
>  	}
>  	btrfs_release_path(path);
> +
> +	return nlink;
> +}
> +
> +/*
> + * There are a few corners where the link count of the file can't
> + * be properly maintained during replay.  So, instead of adding
> + * lots of complexity to the log code, we just scan the backrefs
> + * for any file that has been through replay.
> + *
> + * The scan will update the link count on the inode to reflect the
> + * number of back refs found.  If it goes down to zero, the iput
> + * will free the inode.
> + */
> +static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
> +					   struct btrfs_root *root,
> +					   struct inode *inode)
> +{
> +	struct btrfs_path *path;
> +	int ret;
> +	u64 nlink = 0;
> +	u64 ino = btrfs_ino(inode);
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = count_inode_refs(root, inode, path);
> +	if (ret < 0)
> +		goto out;
> +
> +	nlink = ret;
> +
> +	ret = count_inode_extrefs(root, inode, path);
> +	if (ret < 0)
> +		goto out;
> +
> +	nlink += ret;
> +
>  	if (nlink != inode->i_nlink) {
>  		set_nlink(inode, nlink);
>  		btrfs_update_inode(trans, root, inode);
> @@ -1046,9 +1236,10 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
>  		ret = insert_orphan_item(trans, root, ino);
>  		BUG_ON(ret);
>  	}
> -	btrfs_free_path(path);
>  
> -	return 0;
> +out:
> +	btrfs_free_path(path);
> +	return ret;
>  }
>  
>  static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
> @@ -1695,6 +1886,10 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
>  			ret = add_inode_ref(wc->trans, root, log, path,
>  					    eb, i, &key);
>  			BUG_ON(ret && ret != -ENOENT);
> +		} else if (key.type == BTRFS_INODE_EXTREF_KEY) {
> +			ret = add_inode_ref(wc->trans, root, log, path,
> +					    eb, i, &key);
> +			BUG_ON(ret && ret != -ENOENT);
>  		} else if (key.type == BTRFS_EXTENT_DATA_KEY) {
>  			ret = replay_one_extent(wc->trans, root, path,
>  						eb, i, &key);

That's it for this round, here comes the promised patch. Should apply with "git
am --scissors".

Can you please add a version to the subject before sending the revised patches?
Like "git format-patch --subject-prefix v4".

Thanks,
-Jan

-- >8 --
Subject: [PATCH] Btrfs: improved readablity for add_inode_ref

Moved part of the code into a sub function and replaced most of the gotos
by ifs, hoping that it will be easier to read now.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/tree-log.c |  178 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 97 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c86670f..59f3071 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -786,76 +786,18 @@ out:
 	return match;
 }

-
-/*
- * replay one inode back reference item found in the log tree.
- * eb, slot and key refer to the buffer and key found in the log tree.
- * root is the destination we are replaying into, and path is for temp
- * use by this function.  (it should be released on return).
- */
-static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
+static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  struct btrfs_root *log,
 				  struct btrfs_path *path,
-				  struct extent_buffer *eb, int slot,
-				  struct btrfs_key *key)
+				  struct btrfs_root *log_root,
+				  struct inode *dir, struct inode *inode,
+				  struct btrfs_key *key,
+				  struct extent_buffer *eb,
+				  struct btrfs_inode_ref *ref,
+				  char *name, int namelen, int *search_done)
 {
-	struct btrfs_inode_ref *ref;
-	struct btrfs_dir_item *di;
-	struct inode *dir;
-	struct inode *inode;
-	unsigned long ref_ptr;
-	unsigned long ref_end;
-	char *name;
-	int namelen;
 	int ret;
-	int search_done = 0;
-
-	/*
-	 * it is possible that we didn't log all the parent directories
-	 * for a given inode.  If we don't find the dir, just don't
-	 * copy the back ref in.  The link count fixup code will take
-	 * care of the rest
-	 */
-	dir = read_one_inode(root, key->offset);
-	if (!dir)
-		return -ENOENT;
-
-	inode = read_one_inode(root, key->objectid);
-	if (!inode) {
-		iput(dir);
-		return -EIO;
-	}
-
-	ref_ptr = btrfs_item_ptr_offset(eb, slot);
-	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
-
-again:
-	ref = (struct btrfs_inode_ref *)ref_ptr;
-
-	namelen = btrfs_inode_ref_name_len(eb, ref);
-	name = kmalloc(namelen, GFP_NOFS);
-	BUG_ON(!name);
-
-	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
-
-	/* if we already have a perfect match, we're done */
-	if (inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
-			 btrfs_inode_ref_index(eb, ref),
-			 name, namelen)) {
-		goto out;
-	}
-
-	/*
-	 * look for a conflicting back reference in the metadata.
-	 * if we find one we have to unlink that name of the file
-	 * before we add our new link.  Later on, we overwrite any
-	 * existing back reference, and we don't want to create
-	 * dangling pointers in the directory.
-	 */
-
-	if (search_done)
-		goto insert;
+	struct btrfs_dir_item *di;

 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
 	if (ret == 0) {
@@ -870,7 +812,7 @@ again:
 		 * if so, just jump out, we're done
 		 */
 		if (key->objectid == key->offset)
-			goto out_nowrite;
+			return 1;

 		/* check all the names in this back reference to see
 		 * if they are in the log.  if so, we allow them to stay
@@ -889,7 +831,7 @@ again:
 					   (unsigned long)(victim_ref + 1),
 					   victim_name_len);

-			if (!backref_in_log(log, key, victim_name,
+			if (!backref_in_log(log_root, key, victim_name,
 					    victim_name_len)) {
 				btrfs_inc_nlink(inode);
 				btrfs_release_path(path);
@@ -908,7 +850,7 @@ again:
 		 * NOTE: we have searched root tree and checked the
 		 * coresponding ref, it does not need to check again.
 		 */
-		search_done = 1;
+		*search_done = 1;
 	}
 	btrfs_release_path(path);

@@ -931,25 +873,99 @@ again:
 	}
 	btrfs_release_path(path);

-insert:
-	/* insert our name */
-	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
-			     btrfs_inode_ref_index(eb, ref));
-	BUG_ON(ret);
+	return 0;
+}
+
+/*
+ * replay one inode back reference item found in the log tree.
+ * eb, slot and key refer to the buffer and key found in the log tree.
+ * root is the destination we are replaying into, and path is for temp
+ * use by this function.  (it should be released on return).
+ */
+static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_root *log,
+				  struct btrfs_path *path,
+				  struct extent_buffer *eb, int slot,
+				  struct btrfs_key *key)
+{
+	struct btrfs_inode_ref *ref;
+	struct inode *dir;
+	struct inode *inode;
+	unsigned long ref_ptr;
+	unsigned long ref_end;
+	char *name;
+	int namelen;
+	int ret;
+	int search_done = 0;
+
+	/*
+	 * it is possible that we didn't log all the parent directories
+	 * for a given inode.  If we don't find the dir, just don't
+	 * copy the back ref in.  The link count fixup code will take
+	 * care of the rest
+	 */
+	dir = read_one_inode(root, key->offset);
+	if (!dir)
+		return -ENOENT;

-	btrfs_update_inode(trans, root, inode);
+	inode = read_one_inode(root, key->objectid);
+	if (!inode) {
+		iput(dir);
+		return -EIO;
+	}

-out:
-	ref_ptr = (unsigned long)(ref + 1) + namelen;
-	kfree(name);
-	if (ref_ptr < ref_end)
-		goto again;
+	ref_ptr = btrfs_item_ptr_offset(eb, slot);
+	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
+
+	while (ref_ptr < ref_end) {
+		ref = (struct btrfs_inode_ref *)ref_ptr;
+
+		namelen = btrfs_inode_ref_name_len(eb, ref);
+		name = kmalloc(namelen, GFP_NOFS);
+		BUG_ON(!name);
+
+		read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
+
+		/* if we already have a perfect match, we're done */
+		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
+				  btrfs_inode_ref_index(eb, ref),
+				  name, namelen)) {
+			/*
+			 * look for a conflicting back reference in the
+			 * metadata. if we find one we have to unlink that name
+			 * of the file before we add our new link.  Later on, we
+			 * overwrite any existing back reference, and we don't
+			 * want to create dangling pointers in the directory.
+			 */
+
+			if (!search_done) {
+				ret = __add_inode_ref(trans, root, path, log,
+						      dir, inode, key, eb, ref,
+						      name, namelen,
+						      &search_done);
+				if (ret == 1)
+					goto out;
+				BUG_ON(ret);
+			}
+
+			/* insert our name */
+			ret = btrfs_add_link(trans, dir, inode, name, namelen,
+					     0, btrfs_inode_ref_index(eb, ref));
+			BUG_ON(ret);
+
+			btrfs_update_inode(trans, root, inode);
+		}
+
+		ref_ptr = (unsigned long)(ref + 1) + namelen;
+		kfree(name);
+	}

 	/* finally write the back reference in the inode */
 	ret = overwrite_item(trans, root, path, eb, slot, key);
 	BUG_ON(ret);

-out_nowrite:
+out:
 	btrfs_release_path(path);
 	iput(dir);
 	iput(inode);
-- 
1.7.1
