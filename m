From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
Date: Thu, 12 Apr 2012 19:59:36 +0200
Message-ID: <4F871808.3050309@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-4-git-send-email-mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333656543-4843-4-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.04.2012 22:09, Mark Fasheh wrote:
> The iterate_irefs in backref.c is used to build path components from inode
> refs. I had to add a 2nd iterate function callback to handle extended refs.
> 
> Both iterate callbacks eventually converge upon iref_to_path() which I was
> able to keep as one function with some small code to abstract away
> differences in the two disk structures.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/backref.c |  200 ++++++++++++++++++++++++++++++++++++++++++----------
>  fs/btrfs/backref.h |    4 +-
>  2 files changed, 165 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 0436c12..f2b8952 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -22,6 +22,7 @@
>  #include "ulist.h"
>  #include "transaction.h"
>  #include "delayed-ref.h"
> +#include "tree-log.h"

I mentioned that in the 2/3 review mail. I'd rather get rid of this
#include here.

>  
>  /*
>   * this structure records all encountered refs on the way up to the root
> @@ -858,62 +859,75 @@ static int inode_ref_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  }
>  
>  /*
> - * this iterates to turn a btrfs_inode_ref into a full filesystem path. elements
> - * of the path are separated by '/' and the path is guaranteed to be
> - * 0-terminated. the path is only given within the current file system.
> - * Therefore, it never starts with a '/'. the caller is responsible to provide
> - * "size" bytes in "dest". the dest buffer will be filled backwards. finally,
> - * the start point of the resulting string is returned. this pointer is within
> - * dest, normally.
> - * in case the path buffer would overflow, the pointer is decremented further
> - * as if output was written to the buffer, though no more output is actually
> - * generated. that way, the caller can determine how much space would be
> - * required for the path to fit into the buffer. in that case, the returned
> - * value will be smaller than dest. callers must check this!
> + * Given the parent objectid and name/name_len pairs of an inode ref
> + * (any version) this iterates to turn that information into a
> + * full filesystem path. elements of the path are separated by '/' and
> + * the path is guaranteed to be 0-terminated. the path is only given
> + * within the current file system.  Therefore, it never starts with a
> + * '/'. the caller is responsible to provide "size" bytes in
> + * "dest". the dest buffer will be filled backwards. finally, the
> + * start point of the resulting string is returned. this pointer is
> + * within dest, normally.  in case the path buffer would overflow, the
> + * pointer is decremented further as if output was written to the
> + * buffer, though no more output is actually generated. that way, the
> + * caller can determine how much space would be required for the path
> + * to fit into the buffer. in that case, the returned value will be
> + * smaller than dest. callers must check this!

It would reduce patch sets if you can extend comments in a compatible
way, you make reviewers happy if you don't realign text (or, later,
function parameters) where it's not required.

>   */
>  static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> -				struct btrfs_inode_ref *iref,
> -				struct extent_buffer *eb_in, u64 parent,
> -				char *dest, u32 size)
> +			  int name_len, unsigned long name_off,

name_len should be u32

> +			  struct extent_buffer *eb_in, u64 parent,
> +			  char *dest, u32 size)
>  {
> -	u32 len;
>  	int slot;
>  	u64 next_inum;
>  	int ret;
>  	s64 bytes_left = size - 1;
>  	struct extent_buffer *eb = eb_in;
>  	struct btrfs_key found_key;
> +	struct btrfs_inode_ref *iref;
> +	struct btrfs_inode_extref *iref2;

iextref

>  
>  	if (bytes_left >= 0)
>  		dest[bytes_left] = '\0';
>  
>  	while (1) {
> -		len = btrfs_inode_ref_name_len(eb, iref);
> -		bytes_left -= len;
> +		bytes_left -= name_len;
>  		if (bytes_left >= 0)
>  			read_extent_buffer(eb, dest + bytes_left,
> -						(unsigned long)(iref + 1), len);
> +					   name_off, name_len);
>  		if (eb != eb_in)
>  			free_extent_buffer(eb);
> +
> +		/* Ok, we have enough to find any refs to the parent inode. */
>  		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
> -		if (ret > 0)
> -			ret = -ENOENT;
> -		if (ret)
> -			break;
>  		next_inum = found_key.offset;
> +		if (ret == 0) {
> +			slot = path->slots[0];
> +			eb = path->nodes[0];
> +			/* make sure we can use eb after releasing the path */
> +			if (eb != eb_in)
> +				atomic_inc(&eb->refs);
> +			btrfs_release_path(path);
> +			iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> +
> +			name_len = btrfs_inode_ref_name_len(eb, iref);
> +			name_off = (unsigned long)(iref + 1);
> +		} else {
> +			ret = btrfs_find_one_extref(fs_root, parent, 0, path,
> +						    &iref2, NULL);
> +			if (ret)
> +				break;
> +
> +			next_inum = btrfs_inode_extref_parent(eb, iref2);
> +			name_off = (unsigned long)&iref2->name;
> +			name_len = btrfs_inode_extref_name_len(eb, iref2);
> +		}
>  
>  		/* regular exit ahead */
>  		if (parent == next_inum)
>  			break;

These regular exit lines must go before the block you inserted.
Otherwise we leak a reference on eb if it's != eb_in.

Whereas I think we don't need this if-else-construct at all. We do need
the changes you made as to passing name_len and name_off, I agree.
However, the rest of the function should stay as it was, because the
parent of each object must be a directory and a directory won't have
hard links. Thus, we'll never meet INODE_EXTREFs when walking up the
path. Or did I miss something?

>  
> -		slot = path->slots[0];
> -		eb = path->nodes[0];
> -		/* make sure we can use eb after releasing the path */
> -		if (eb != eb_in)
> -			atomic_inc(&eb->refs);
> -		btrfs_release_path(path);
> -
> -		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
>  		parent = next_inum;
>  		--bytes_left;
>  		if (bytes_left >= 0)
> @@ -1226,9 +1240,9 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> -static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> -				struct btrfs_path *path,
> -				iterate_irefs_t *iterate, void *ctx)
> +static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
> +			      struct btrfs_path *path,
> +			      iterate_irefs_t *iterate, void *ctx)

This function must not call free_extent_buffer(eb) in line 1306 after
applying your patch set (immediately before the break). Second, I think
we'd better add a blocking read lock on eb after incrementing it's
refcount, because we need the current content to stay as it is. Both
isn't part of your patches, but it might be easier if you make that
bugfix change as a 3/4 patch within your set and turn this one into 4/4.
If you don't like that, I'll send a separate patch for it. Don't miss
the unlock if you do it ;-)

>  {
>  	int ret;
>  	int slot;
> @@ -1244,7 +1258,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  
>  	while (1) {
>  		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
> -					&found_key);
> +				     &found_key);
>  		if (ret < 0)
>  			break;
>  		if (ret) {
> @@ -1286,6 +1300,76 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  	return ret;
>  }
>  
> +static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
> +				 struct btrfs_path *path,
> +				 iterate_extrefs_t *iterate, void *ctx)
> +{
> +	int ret;
> +	int slot;
> +	u64 offset = 0;
> +	u64 parent;
> +	int found = 0;
> +	struct extent_buffer *eb;
> +	struct btrfs_item *item;
> +	struct btrfs_inode_extref *iref2;

iextref

> +
> +	while (1) {
> +		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &iref2,
> +					    &offset);
> +		if (ret < 0)
> +			break;
> +		if (ret) {
> +			ret = found ? 0 : -ENOENT;
> +			break;
> +		}
> +		++found;
> +
> +		slot = path->slots[0];
> +		eb = path->nodes[0];
> +		/* make sure we can use eb after releasing the path */
> +		atomic_inc(&eb->refs);

You need a blocking read lock here, too. Grab it before releasing the path.

> +		btrfs_release_path(path);
> +
> +		item = btrfs_item_nr(eb, slot);

You don't need item.

> +		iref2 = btrfs_item_ptr(eb, slot, struct btrfs_inode_extref);
> +
> +		parent = btrfs_inode_extref_parent(eb, iref2);
> +		ret = iterate(parent, iref2, eb, ctx);

The caller shouldn't have to deal with two different types of callbacks.
Please just build a dummy struct btrfs_inode_ref object here and pass it
to iterate. Alternatively, you can extract the information the caller
will need, here, and pass that instead of a struct btrfs_inode_ref. This
way, we can use the same type for both iterate() functions.

> +		if (ret) {
> +			free_extent_buffer(eb);
> +			break;
> +		}
> +
> +		free_extent_buffer(eb);

Call free_extent_buffer(eb) before the if (ret), drop it from the if
block, add an unlock before the if block.

> +		offset++;

Another caller not expecting btrfs_find_one_extref to return offset
incremented. The offset++ should stay here and btrfs_find_one_extref
should just return the plain offset.

> +	}
> +
> +	btrfs_release_path(path);
> +
> +	return ret;
> +}
> +
> +static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> +			 struct btrfs_path *path,
> +			 iterate_irefs_t *iterate,
> +			 iterate_extrefs_t *iterate2, void *ctx)

As mentioned above, I'd like to see only be a single iterate function at
this level.

> +{
> +	int ret, found_refs = 0;

split

> +
> +	ret = iterate_inode_refs(inum, fs_root, path, iterate, ctx);
> +	if (ret && ret != -ENOENT)
> +		return ret;
> +
> +	if (ret != -ENOENT)
> +		++found_refs;

I'd make those 2 if statements:

if (!ret)
	++found_refs;
else if (ret != -ENOENT)
	return ret;

> +
> +	ret = iterate_inode_extrefs(inum, fs_root, path, iterate2, ctx);
> +	if (ret == -ENOENT && found_refs)
> +		return 0;
> +
> +	return ret;
> +}
> +
>  /*
>   * returns 0 if the path could be dumped (probably truncated)
>   * returns <0 in case of an error
> @@ -1299,13 +1383,53 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
>  	int i = ipath->fspath->elem_cnt;
>  	const int s_ptr = sizeof(char *);
>  	u32 bytes_left;
> +	u32 name_len = btrfs_inode_ref_name_len(eb, iref);
> +
> +	bytes_left = ipath->fspath->bytes_left > s_ptr ?
> +					ipath->fspath->bytes_left - s_ptr : 0;
> +
> +	fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
> +	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
> +			      (unsigned long)(iref + 1), eb, inum, fspath_min,
> +			      bytes_left);
> +	if (IS_ERR(fspath))
> +		return PTR_ERR(fspath);
> +
> +	if (fspath > fspath_min) {
> +		ipath->fspath->val[i] = (u64)(unsigned long)fspath;
> +		++ipath->fspath->elem_cnt;
> +		ipath->fspath->bytes_left = fspath - fspath_min;
> +	} else {
> +		++ipath->fspath->elem_missed;
> +		ipath->fspath->bytes_missing += fspath_min - fspath;
> +		ipath->fspath->bytes_left = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * returns 0 if the path could be dumped (probably truncated)
> + * returns <0 in case of an error
> + */
> +static int inode_to_path2(u64 inum, struct btrfs_inode_extref *iref2,
> +			  struct extent_buffer *eb, void *ctx)

We'll get rid of a second inode_to_path, too, if my suggestion works out.

> +{
> +	struct inode_fs_paths *ipath = ctx;
> +	char *fspath;
> +	char *fspath_min;
> +	int i = ipath->fspath->elem_cnt;
> +	const int s_ptr = sizeof(char *);
> +	u32 bytes_left;
> +	u32 name_len = btrfs_inode_extref_name_len(eb, iref2);
>  
>  	bytes_left = ipath->fspath->bytes_left > s_ptr ?
>  					ipath->fspath->bytes_left - s_ptr : 0;
>  
>  	fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
> -	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, iref, eb,
> -				inum, fspath_min, bytes_left);
> +	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
> +			      (unsigned long)&iref2->name, eb, inum,
> +			      fspath_min, bytes_left);
>  	if (IS_ERR(fspath))
>  		return PTR_ERR(fspath);
>  
> @@ -1339,7 +1463,7 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
>  int paths_from_inode(u64 inum, struct inode_fs_paths *ipath)
>  {
>  	return iterate_irefs(inum, ipath->fs_root, ipath->btrfs_path,
> -				inode_to_path, ipath);
> +			     inode_to_path, inode_to_path2, ipath);
>  }
>  
>  /*
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index d00dfa9..4634ed7 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -31,7 +31,9 @@ struct inode_fs_paths {
>  typedef int (iterate_extent_inodes_t)(u64 inum, u64 offset, u64 root,
>  		void *ctx);
>  typedef int (iterate_irefs_t)(u64 parent, struct btrfs_inode_ref *iref,
> -				struct extent_buffer *eb, void *ctx);
> +				 struct extent_buffer *eb, void *ctx);
> +typedef int (iterate_extrefs_t)(u64 parent, struct btrfs_inode_extref *iref,
> +				 struct extent_buffer *eb, void *ctx);
>  
>  int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  			struct btrfs_path *path);

Thanks!
-Jan
