From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 2/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 15:08:35 +0200
Message-ID: <4F86D3D3.9030909@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-3-git-send-email-mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333656543-4843-3-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.04.2012 22:09, Mark Fasheh wrote:
> Teach tree-log.c about extended inode refs. In particular, we have to adjust
> the behavior of inode ref replay as well as log tree recovery to account for
> the existence of extended refs.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/tree-log.c |  320 +++++++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/tree-log.h |    4 +
>  2 files changed, 266 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 966cc74..d69b07a 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -23,6 +23,7 @@
>  #include "disk-io.h"
>  #include "locking.h"
>  #include "print-tree.h"
> +#include "backref.h"

So now tree-log.c includes backref.h and backref.c includes tree-log.h,
this is not a problem by itself, but I'd try to avoid such dependencies.
I'd put find_one_extref over to backref.c to solve this, also because
there it would be closer to inode_ref_info (which does the same for
INODE_REFs.

>  #include "compat.h"
>  #include "tree-log.h"
>  
> @@ -748,6 +749,7 @@ static noinline int backref_in_log(struct btrfs_root *log,
>  {
>  	struct btrfs_path *path;
>  	struct btrfs_inode_ref *ref;
> +	struct btrfs_inode_extref *extref;
                                   ^^^^^^
:-)

>  	unsigned long ptr;
>  	unsigned long ptr_end;
>  	unsigned long name_ptr;
> @@ -764,8 +766,24 @@ static noinline int backref_in_log(struct btrfs_root *log,
>  	if (ret != 0)
>  		goto out;
>  
> -	item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
>  	ptr = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
> +
> +	if (key->type == BTRFS_INODE_EXTREF_KEY) {
> +		extref = (struct btrfs_inode_extref *)ptr;
> +
> +		found_name_len = btrfs_inode_extref_name_len(path->nodes[0],
> +							     extref);
> +		if (found_name_len == namelen) {
> +			name_ptr = (unsigned long)&extref->name;
> +			ret = memcmp_extent_buffer(path->nodes[0], name,
> +						   name_ptr, namelen);
> +			if (ret == 0)
> +				match = 1;
> +		}
> +		goto out;
> +	}
> +
> +	item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
>  	ptr_end = ptr + item_size;
>  	while (ptr < ptr_end) {
>  		ref = (struct btrfs_inode_ref *)ptr;
> @@ -786,7 +804,6 @@ out:
>  	return match;
>  }
>  
> -
>  /*
>   * replay one inode back reference item found in the log tree.
>   * eb, slot and key refer to the buffer and key found in the log tree.
> @@ -801,15 +818,20 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  				  struct btrfs_key *key)
>  {
>  	struct btrfs_inode_ref *ref;
> +	struct btrfs_inode_extref *extref;
>  	struct btrfs_dir_item *di;
> +	struct btrfs_key search_key;

You don't need search_key, just use key from the parameter list as the
code did previously.

>  	struct inode *dir;
>  	struct inode *inode;
>  	unsigned long ref_ptr;
>  	unsigned long ref_end;
> -	char *name;
> -	int namelen;
> +	char *name, *victim_name;
> +	int namelen, victim_name_len;

split

>  	int ret;
>  	int search_done = 0;
> +	int log_ref_ver = 0;
> +	u64 parent_objectid, inode_objectid, ref_index;

split

> +	struct extent_buffer *leaf;
>  
>  	/*
>  	 * it is possible that we didn't log all the parent directories
> @@ -817,32 +839,56 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  	 * copy the back ref in.  The link count fixup code will take
>  	 * care of the rest
>  	 */
> -	dir = read_one_inode(root, key->offset);
> +
> +	if (key->type == BTRFS_INODE_EXTREF_KEY) {
> +		log_ref_ver = 1;
                ^^^^^^^^^^^^^^^
Assigned but never used.

> +
> +		ref_ptr = btrfs_item_ptr_offset(eb, slot);
> +
> +		/* So that we don't loop back looking for old style log refs. */
> +		ref_end = ref_ptr;
> +
> +		extref = (struct btrfs_inode_extref *) btrfs_item_ptr_offset(eb, slot);
> +		namelen = btrfs_inode_extref_name_len(eb, extref);
> +		name = kmalloc(namelen, GFP_NOFS);

kmalloc may fail.

> +
> +		read_extent_buffer(eb, name, (unsigned long)&extref->name,
> +				   namelen);
> +
> +		ref_index = btrfs_inode_extref_index(eb, extref);
> +		parent_objectid = btrfs_inode_extref_parent(eb, extref);
> +	} else {
> +		parent_objectid = key->offset;
> +
> +		ref_ptr = btrfs_item_ptr_offset(eb, slot);
> +		ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
> +
> +		ref = (struct btrfs_inode_ref *)ref_ptr;
> +		namelen = btrfs_inode_ref_name_len(eb, ref);
> +		name = kmalloc(namelen, GFP_NOFS);
> +		BUG_ON(!name);
> +
> +		read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
> +
> +		ref_index = btrfs_inode_ref_index(eb, ref);

The way you put it, you had to copy all the code from the else block
down before the "goto again" case. Code duplication is error prone.

Maybe you can manage to put everything between "again:" and "goto again"
into a separate function that can be called multiple times. For the old
INODE_REF items that could be done in a loop then. This would also split
an overly long function into more readable units.

> +	}
> +
> +	inode_objectid = key->objectid;
> +
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
> @@ -857,19 +903,23 @@ again:
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
> @@ -889,7 +939,7 @@ again:
>  					   (unsigned long)(victim_ref + 1),
>  					   victim_name_len);
>  
> -			if (!backref_in_log(log, key, victim_name,
> +			if (!backref_in_log(log, &search_key, victim_name,
>  					    victim_name_len)) {
>  				btrfs_inc_nlink(inode);
>  				btrfs_release_path(path);
> @@ -902,19 +952,44 @@ again:
>  			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
>  		}
>  		BUG_ON(ret);
> -
> -		/*
> -		 * NOTE: we have searched root tree and checked the
> -		 * coresponding ref, it does not need to check again.
> -		 */
> -		search_done = 1;
>  	}
>  	btrfs_release_path(path);
>  
> +	/* Same search but for extended refs */
> +	extref = btrfs_lookup_inode_extref(NULL, root, path, name, namelen,
> +					   inode_objectid, parent_objectid, 0,
> +					   0);
> +	if (extref && !IS_ERR(extref)) {

if (!IS_ERR_OR_NULL(extref))

> +		victim_name_len = btrfs_inode_extref_name_len(eb, extref);
> +		victim_name = kmalloc(namelen, GFP_NOFS);
> +		leaf = path->nodes[0];
> +		read_extent_buffer(eb, name, (unsigned long)&extref->name, namelen);
> +
> +		search_key.objectid = inode_objectid;
> +		search_key.type = BTRFS_INODE_EXTREF_KEY;
> +		search_key.offset = btrfs_extref_key_off(parent_objectid, name, namelen);
> +		if (!backref_in_log(log, &search_key, victim_name,
> +				    victim_name_len)) {
> +			btrfs_inc_nlink(inode);
> +			btrfs_release_path(path);
> +
> +			ret = btrfs_unlink_inode(trans, root, dir,
> +						 inode, victim_name,
> +						 victim_name_len);
> +		}
> +		kfree(victim_name);
> +		BUG_ON(ret);
> +	}
> +
> +	/*
> +	 * NOTE: we have searched root tree and checked the
> +	 * coresponding refs, it does not need to be checked again.
> +	 */
> +	search_done = 1;

You moved this comment and assignment out of the "if (ret == 0)" case.
I'm not sure if this is still doing exactly the same now (?).
Previously, we were executing another btrfs_search_slot,
btrfs_lookup_dir_index_item, ... after the "goto again" case, which
would be skipped with this patch.

> +
>  	/* look for a conflicting sequence number */
>  	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
> -					 btrfs_inode_ref_index(eb, ref),
> -					 name, namelen, 0);
> +					 ref_index, name, namelen, 0);
>  	if (di && !IS_ERR(di)) {
>  		ret = drop_one_dir_item(trans, root, path, dir, di);
>  		BUG_ON(ret);
> @@ -932,17 +1007,25 @@ again:
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
> +	ref_ptr = (unsigned long)(ref_ptr + sizeof(struct btrfs_inode_ref)) + namelen;
>  	kfree(name);
> -	if (ref_ptr < ref_end)
> +	if (ref_ptr < ref_end) {
> +		ref = (struct btrfs_inode_ref *)ref_ptr;
> +		namelen = btrfs_inode_ref_name_len(eb, ref);
> +		name = kmalloc(namelen, GFP_NOFS);
> +		BUG_ON(!name);
> +
> +		read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
> +
> +		ref_index = btrfs_inode_ref_index(eb, ref);

This is the duplicated code mentioned above.

>  		goto again;
> +	}
>  
>  	/* finally write the back reference in the inode */
>  	ret = overwrite_item(trans, root, path, eb, slot, key);
> @@ -965,25 +1048,103 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> +int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> +			  u64 start_off, struct btrfs_path *path,
> +			  struct btrfs_inode_extref **ret_ref, u64 *found_off)

ret_extref

> +{
> +	int ret, slot;
> +	struct btrfs_key key, found_key;

split

> +	struct btrfs_inode_extref *ref;
> +	struct extent_buffer *leaf;
> +	struct btrfs_item *item;
> +	unsigned long ptr;
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

[side note: this is really strange patch alignment. my git is doing it
the same way.]

> +	key.objectid = inode_objectid;
> +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
> +	key.offset = start_off;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;

Just return here and drop the out label.

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

This large block (and its comment) can be replaced by
btrfs_search_slot_for_read with find_higher = 1, return_any = 0. This
also avoids the "continue" and we even git rid of the whole while (1)
loop here.

> +			continue;
> +		}
> +
> +		item = btrfs_item_nr(leaf, slot);
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
> +		ref = (struct btrfs_inode_extref *)ptr;
> +		*ret_ref = ref;
> +		if (found_off)
> +			*found_off = found_key.offset + 1;
> +		break;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +static int count_inode_extrefs(struct btrfs_root *root,
> +			       struct inode *inode, struct btrfs_path *path)
> +{
> +	int ret;
> +	unsigned int nlink = 0;
> +	u64 inode_objectid = btrfs_ino(inode);
> +	u64 offset = 0;
> +	struct btrfs_inode_extref *ref;
> +
> +	while (1) {
> +		ret = btrfs_find_one_extref(root, inode_objectid, offset, path,
> +					    &ref, &offset);
> +		if (ret)
> +			break;

Assume the first call to btrfs_find_ione_extref returns -EIO. Do we
really want count_inode_extrefs return 0 here? I agree that the previous
code suffers from the same problem, but still: it's a problem.

> +
> +		nlink++;
> +		offset++;
> +	}
> +
> +	return nlink;
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
> @@ -993,10 +1154,6 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
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
> @@ -1030,6 +1187,48 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
>  		btrfs_release_path(path);
>  	}
>  	btrfs_release_path(path);
> +	btrfs_free_path(path);

In general, you must not free a path when you don't allocate it.

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
> +	btrfs_release_path(path);

Either count_inode_refs should alloc it's private path, or it should
return the path in a released state. The caller should not be
responsible to pass a clean path and release it afterwards, as
count_inode_refs does not return anything through the path.

> +	if (ret < 0)
> +		goto out;
> +
> +	nlink = ret;
> +
> +	ret = count_inode_extrefs(root, inode, path);
> +	btrfs_release_path(path);

Same here. I'd just put the btrfs_release_path into count_inode_(ext)refs.

> +	if (ret < 0)
> +		goto out;
> +
> +	nlink += ret;
> +
>  	if (nlink != inode->i_nlink) {
>  		set_nlink(inode, nlink);
>  		btrfs_update_inode(trans, root, inode);
> @@ -1045,9 +1244,10 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
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
> @@ -1689,6 +1889,10 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
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
> diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
> index 2270ac5..fd40ad5 100644
> --- a/fs/btrfs/tree-log.h
> +++ b/fs/btrfs/tree-log.h
> @@ -49,4 +49,8 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
>  int btrfs_log_new_name(struct btrfs_trans_handle *trans,
>  			struct inode *inode, struct inode *old_dir,
>  			struct dentry *parent);
> +int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> +			  u64 start_off, struct btrfs_path *path,
> +			  struct btrfs_inode_extref **ret_ref, u64 *found_off);
> +
>  #endif

-Jan
