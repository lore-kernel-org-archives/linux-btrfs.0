From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 15:08:27 +0200
Message-ID: <4F86D3CB.1010505@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-2-git-send-email-mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333656543-4843-2-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.04.2012 22:09, Mark Fasheh wrote:
> This patch adds basic support for extended inode refs. This includes support
> for link and unlink of the refs, which basically gets us support for rename
> as well.
> 
> Inode creation does not need changing - extended refs are only added after
> the ref array is full.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/ctree.h      |   50 +++++++++--
>  fs/btrfs/inode-item.c |  244 +++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/inode.c      |   20 ++--
>  3 files changed, 288 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 80b6486..5fc77ee 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -143,6 +143,13 @@ struct btrfs_ordered_sum;
>   */
>  #define BTRFS_NAME_LEN 255
>  
> +/*
> + * Theoretical limit is larger, but we keep this down to a sane
> + * value. That should limit greatly the possibility of collisions on
> + * inode ref items.
> + */
> +#define BTRFS_LINK_MAX 65535U

Do we really want an artificial limit like that?

> +
>  /* 32 bytes in various csum fields */
>  #define BTRFS_CSUM_SIZE 32
>  
> @@ -462,13 +469,16 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
>  #define BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO	(1ULL << 3)
>  
> +#define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
> +
>  #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
>  #define BTRFS_FEATURE_INCOMPAT_SUPP			\
>  	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
>  	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
>  	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
> -	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)
> +	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
> +	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
>  
>  /*
>   * A leaf is full of items. offset and size tell us where to find
> @@ -615,6 +625,14 @@ struct btrfs_inode_ref {
>  	/* name goes here */
>  } __attribute__ ((__packed__));
>  
> +struct btrfs_inode_extref {
> +	__le64 parent_objectid;
> +	__le64 index;
> +	__le16 name_len;
> +	__u8   name[0];
> +	/* name goes here */
> +} __attribute__ ((__packed__));
> +
>  struct btrfs_timespec {
>  	__le64 sec;
>  	__le32 nsec;
> @@ -1400,6 +1418,7 @@ struct btrfs_ioctl_defrag_range_args {
>   */
>  #define BTRFS_INODE_ITEM_KEY		1
>  #define BTRFS_INODE_REF_KEY		12
> +#define BTRFS_INODE_EXTREF_KEY		13
>  #define BTRFS_XATTR_ITEM_KEY		24
>  #define BTRFS_ORPHAN_ITEM_KEY		48
>  /* reserve 2-15 close to the inode for later flexibility */
> @@ -1701,6 +1720,13 @@ BTRFS_SETGET_STACK_FUNCS(block_group_flags,
>  BTRFS_SETGET_FUNCS(inode_ref_name_len, struct btrfs_inode_ref, name_len, 16);
>  BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
>  
> +/* struct btrfs_inode_extref */
> +BTRFS_SETGET_FUNCS(inode_extref_parent, struct btrfs_inode_extref,
> +		   parent_objectid, 64);
> +BTRFS_SETGET_FUNCS(inode_extref_name_len, struct btrfs_inode_extref,
> +		   name_len, 16);
> +BTRFS_SETGET_FUNCS(inode_extref_index, struct btrfs_inode_extref, index, 64);
> +
>  /* struct btrfs_inode_item */
>  BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
>  BTRFS_SETGET_FUNCS(inode_sequence, struct btrfs_inode_item, sequence, 64);
> @@ -2791,12 +2817,12 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   const char *name, int name_len,
>  			   u64 inode_objectid, u64 ref_objectid, u64 *index);
> -struct btrfs_inode_ref *
> -btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
> -			struct btrfs_root *root,
> -			struct btrfs_path *path,
> -			const char *name, int name_len,
> -			u64 inode_objectid, u64 ref_objectid, int mod);
> +int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
> +			      struct btrfs_root *root,
> +			      struct btrfs_path *path,
> +			      const char *name, int name_len,
> +			      u64 inode_objectid, u64 ref_objectid, int mod,
> +			      u64 *ret_index);
>  int btrfs_insert_empty_inode(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root,
>  			     struct btrfs_path *path, u64 objectid);
> @@ -2804,6 +2830,16 @@ int btrfs_lookup_inode(struct btrfs_trans_handle *trans, struct btrfs_root
>  		       *root, struct btrfs_path *path,
>  		       struct btrfs_key *location, int mod);
>  
> +struct btrfs_inode_extref *
> +btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
> +			  struct btrfs_root *root,
> +			  struct btrfs_path *path,
> +			  const char *name, int name_len,
> +			  u64 inode_objectid, u64 ref_objectid, int ins_len,
> +			  int cow);
> +
> +u64 btrfs_extref_key_off(u64 parent_objectid, const char *name, int name_len);
> +
>  /* file-item.c */
>  int btrfs_del_csums(struct btrfs_trans_handle *trans,
>  		    struct btrfs_root *root, u64 bytenr, u64 len);
> diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
> index baa74f3..cc5e854 100644
> --- a/fs/btrfs/inode-item.c
> +++ b/fs/btrfs/inode-item.c
> @@ -16,6 +16,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> +#include <linux/crc32c.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -49,18 +50,56 @@ static int find_name_in_backref(struct btrfs_path *path, const char *name,
>  	return 0;
>  }
>  
> -struct btrfs_inode_ref *
> +static int find_name_in_ext_backref(struct btrfs_path *path, const char *name,
> +				   int name_len, struct btrfs_inode_extref **ref_ret)
> +{
> +	struct extent_buffer *leaf;
> +	struct btrfs_inode_extref *ref;
> +	unsigned long ptr;
> +	unsigned long name_ptr;
> +	u32 item_size;
> +
> +	leaf = path->nodes[0];
> +	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +	ref = (struct btrfs_inode_extref *)ptr;
> +
> +	/*
> +	 * There isn't actually anything to "search" in an extended
> +	 * backref - one name is directly attached to each
> +	 * item. Instead what we're really doing here is some sort of
> +	 * sanity check - does the name exist where it should have
> +	 * been found. If all is well, we'll return success and the
> +	 * inode ref object.
> +	 */

In that case, the name is not a good choice. However, if we change how
we deal with hash collisions, the name might be right and the comment
might go away as we really look through more than one item. If we leave
it like this, please rename that function.

> +	name_ptr = (unsigned long)(&ref->name);
> +	if (btrfs_inode_extref_name_len(leaf, ref) == name_len
> +	    && (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
> +		*ref_ret = ref;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Figure the key offset of an extended inode ref
> + */
> +u64 btrfs_extref_key_off(u64 parent_objectid, const char *name, int name_len)

I'd suggest to call this one btrfs_extref_hash and move it to
fs/btrfs/hash.h. That way, we can also drop the include for
<linux/crc32c.h> above.

> +{
> +	return (u64) crc32c(parent_objectid, name, name_len);
> +}
> +
> +static struct btrfs_inode_ref *
>  btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
> -			struct btrfs_root *root,
> -			struct btrfs_path *path,
> -			const char *name, int name_len,
> -			u64 inode_objectid, u64 ref_objectid, int mod)
> +		       struct btrfs_root *root,
> +		       struct btrfs_path *path,
> +		       const char *name, int name_len,
> +		       u64 inode_objectid, u64 ref_objectid, int ins_len,
> +		       int cow)
>  {
> +	int ret;
>  	struct btrfs_key key;
>  	struct btrfs_inode_ref *ref;
> -	int ins_len = mod < 0 ? -1 : 0;
> -	int cow = mod != 0;
> -	int ret;
>  
>  	key.objectid = inode_objectid;
>  	key.type = BTRFS_INODE_REF_KEY;
> @@ -76,20 +115,137 @@ btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
>  	return ref;
>  }
>  
> -int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
> +struct btrfs_inode_extref *
> +btrfs_lookup_inode_extref(struct btrfs_trans_handle *trans,
> +			  struct btrfs_root *root,
> +			  struct btrfs_path *path,
> +			  const char *name, int name_len,
> +			  u64 inode_objectid, u64 ref_objectid, int ins_len,
> +			  int cow)
> +{
> +	int ret;
> +	struct btrfs_key key;
> +	struct btrfs_inode_extref *ref;
                                   ^^^
Please use some other identifier than the one we use for struct
btrfs_inode_ref. Suggestion: extref or eref.

> +
> +	key.objectid = inode_objectid;
> +	key.type = BTRFS_INODE_EXTREF_KEY;
> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
                     ^^^^^^^^^^^^^^^^^^^^
Get's clearer when that is called btrfs_extref_hash.

> +
> +	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +	if (ret > 0)
> +		return NULL;
> +	if (!find_name_in_ext_backref(path, name, name_len, &ref))
> +		return NULL;
> +	return ref;
> +}
> +
> +int btrfs_get_inode_ref_index(struct btrfs_trans_handle *trans,
> +			      struct btrfs_root *root,
> +			      struct btrfs_path *path,
> +			      const char *name, int name_len,
> +			      u64 inode_objectid, u64 ref_objectid, int mod,
> +			      u64 *ret_index)
> +{
> +	struct btrfs_inode_ref *ref1;
> +	struct btrfs_inode_extref *ref2;
                                   ^^^^
Please, use "ref" and ("eref" or "extref").

> +	int ins_len = mod < 0 ? -1 : 0;
> +	int cow = mod != 0;
> +
> +	ref1 = btrfs_lookup_inode_ref(trans, root, path, name, name_len,
> +				      inode_objectid, ref_objectid, ins_len,
> +				      cow);
> +	if (IS_ERR(ref1))
> +		return PTR_ERR(ref1);
> +
> +	if (ref1 != NULL) {
> +		*ret_index = btrfs_inode_ref_index(path->nodes[0], ref1);
> +		return 0;
> +	}
> +
> +	btrfs_release_path(path);
> +
> +	ref2 = btrfs_lookup_inode_extref(trans, root, path, name,
> +					 name_len, inode_objectid,
> +					 ref_objectid, ins_len, cow);
> +	if (IS_ERR(ref2))
> +		return PTR_ERR(ref2);
> +
> +	if (ref2) {
> +		*ret_index = btrfs_inode_extref_index(path->nodes[0], ref2);
> +		return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   const char *name, int name_len,
>  			   u64 inode_objectid, u64 ref_objectid, u64 *index)
>  {
>  	struct btrfs_path *path;
>  	struct btrfs_key key;
> +	struct btrfs_inode_extref *ref2;
                                   ^^^^

> +	struct extent_buffer *leaf;
> +	int ret;
> +
> +	key.objectid = inode_objectid;
> +	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	path->leave_spinning = 1;
> +
> +	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
> +	if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	} else if (ret < 0) {
> +		goto out;
> +	}

Clearer (to me):

if (ret > 0)
	ret = -ENOENT;
if (ret < 0)
	goto out;

> +
> +	/*
> +	 * Sanity check - did we find the right item for this name?
> +	 * This should always succeed so error here will make the FS
> +	 * readonly.
> +	 */
> +	if (!find_name_in_ext_backref(path, name, name_len, &ref2)) {
> +		btrfs_std_error(root->fs_info, -ENOENT);
> +		ret = -EROFS;

Simply returning -EROFS doesn't make the fs read-only, does it? I'd
suggest to return -EIO and drop the comment above.

> +		goto out;
> +	}
> +
> +	leaf = path->nodes[0];
> +	if (index)
> +		*index = btrfs_inode_extref_index(leaf, ref2);
> +
> +	ret = btrfs_del_item(trans, root, path);
> +
> +out:
> +	btrfs_free_path(path);
> +
> +	return ret;
> +}
> +
> +int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
> +			struct btrfs_root *root,
> +			const char *name, int name_len,
> +			u64 inode_objectid, u64 ref_objectid, u64 *index)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
>  	struct btrfs_inode_ref *ref;
>  	struct extent_buffer *leaf;
>  	unsigned long ptr;
>  	unsigned long item_start;
>  	u32 item_size;
>  	u32 sub_item_len;
> -	int ret;
> +	int ret, search_ext_refs = 0;
               ^^^^^^^^^^^^^^^^^^^^^
Documentation/CodingStyle:
--
To this end, use just one data declaration per line (no commas for
multiple data declarations).
--

You do this multiple times in your whole patch set.

>  	int del_len = name_len + sizeof(*ref);
>  
>  	key.objectid = inode_objectid;
> @@ -105,12 +261,14 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>  	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>  	if (ret > 0) {
>  		ret = -ENOENT;
> +		search_ext_refs = 1;
>  		goto out;
>  	} else if (ret < 0) {
>  		goto out;
>  	}
>  	if (!find_name_in_backref(path, name, name_len, &ref)) {
>  		ret = -ENOENT;
> +		search_ext_refs = 1;
>  		goto out;
>  	}
>  	leaf = path->nodes[0];
> @@ -132,6 +290,59 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>  				  item_size - sub_item_len, 1);
>  out:
>  	btrfs_free_path(path);
> +
> +	if (search_ext_refs) {

As far as I see it, you can drop search_ext_refs and simply go this way
on ret == -ENOENT.

> +		/* 
                  ^
Catched by accident: trailing whitespace.

> +		 * No refs were found, or we could not find the
> +		 * name in our ref array. Find and remove the extended
> +		 * inode ref then.
> +		 */
> +		return btrfs_del_inode_extref(trans, root, name, name_len,
> +					      inode_objectid, ref_objectid, index);
> +	}
> +
> +	return ret;
> +}
> +
> +static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
> +				     struct btrfs_root *root,
> +				     const char *name, int name_len,
> +				     u64 inode_objectid, u64 ref_objectid, u64 index)

Are we missing a check against BTRFS_LINK_MAX in this function?

> +{
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct btrfs_inode_extref *ref;
extref

> +	unsigned long ptr;
> +	int ret;
> +	int ins_len = name_len + sizeof(*ref);
> +
> +	key.objectid = inode_objectid;
> +	key.type = BTRFS_INODE_EXTREF_KEY;
> +	key.offset = btrfs_extref_key_off(ref_objectid, name, name_len);
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	path->leave_spinning = 1;
> +	ret = btrfs_insert_empty_item(trans, root, path, &key,
> +				      ins_len);
> +	if (ret < 0)
> +		goto out;
> +
> +	ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			     struct btrfs_inode_extref);
> +
> +	btrfs_set_inode_extref_name_len(path->nodes[0], ref, name_len);
> +	btrfs_set_inode_extref_index(path->nodes[0], ref, index);
> +	btrfs_set_inode_extref_parent(path->nodes[0], ref, ref_objectid);
> +
> +	ptr = (unsigned long)&ref->name;
> +	write_extent_buffer(path->nodes[0], name, ptr, name_len);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +
> +out:
> +	btrfs_free_path(path);
>  	return ret;
>  }
>  
> @@ -189,6 +400,19 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
>  
>  out:
>  	btrfs_free_path(path);
> +
> +	if (ret == -EMLINK) {
> +		struct btrfs_super_block *disk_super = root->fs_info->super_copy;
> +		/* We ran out of space in the ref array. Need to
> +		 * add an extended ref. */
> +		if (btrfs_super_incompat_flags(disk_super)
> +		    & BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
> +			ret = btrfs_insert_inode_extref(trans, root, name,
> +							name_len,
> +							inode_objectid,
> +							ref_objectid, index);
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 892b347..0ca525d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2689,7 +2689,6 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	struct btrfs_path *path;
> -	struct btrfs_inode_ref *ref;
>  	struct btrfs_dir_item *di;
>  	struct inode *inode = dentry->d_inode;
>  	u64 index;
> @@ -2803,17 +2802,16 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
>  	}
>  	btrfs_release_path(path);
>  
> -	ref = btrfs_lookup_inode_ref(trans, root, path,
> -				dentry->d_name.name, dentry->d_name.len,
> -				ino, dir_ino, 0);
> -	if (IS_ERR(ref)) {
> -		err = PTR_ERR(ref);
> +	ret = btrfs_get_inode_ref_index(trans, root, path, dentry->d_name.name,
> +					dentry->d_name.len, ino, dir_ino, 0, &index);

This line is >80 chars. Please use scripts/checkpatch.pl to catch those.

> +	if (ret) {
> +		err = ret;
>  		goto out;
>  	}
> -	BUG_ON(!ref);
> +
>  	if (check_path_shared(root, path))
>  		goto out;
> -	index = btrfs_inode_ref_index(path->nodes[0], ref);
> +
>  	btrfs_release_path(path);
>  
>  	/*
> @@ -4484,6 +4482,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
>  	key[0].offset = 0;
>  
> +	/*
> +	 * Start new inodes with a V1 ref. This is slightly more
> +	 * efficient for small numbers of hard links.
> +	 */

I'd drop that comment. extref is no "V2" kind of ref. But you can leave
it in if you feel it helps anyone later.

>  	key[1].objectid = objectid;
>  	btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
>  	key[1].offset = ref_objectid;
> @@ -4777,7 +4779,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
>  	if (root->objectid != BTRFS_I(inode)->root->objectid)
>  		return -EXDEV;
>  
> -	if (inode->i_nlink == ~0U)
> +	if (inode->i_nlink >= BTRFS_LINK_MAX)
>  		return -EMLINK;
>  
>  	err = btrfs_set_inode_index(dir, &index);

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

-Jan
