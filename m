Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:55119 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab2GFO5a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 10:57:30 -0400
Message-ID: <4FF6FCD9.907@jan-o-sch.net>
Date: Fri, 06 Jul 2012 16:57:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1337636781-12575-4-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2012 at 23:46 (+0200), Mark Fasheh wrote:
> From: Mark Fasheh <mfasheh@suse.com>
> 
> The iterate_irefs in backref.c is used to build path components from inode
> refs. This patch adds code to iterate extended refs as well.
> 
> I had modify the callback function signature to abstract out some of the
> differences between ref structures. iref_to_path() also needed similar
> changes.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/backref.c |  144 +++++++++++++++++++++++++++++++++++++++++++---------
>  fs/btrfs/backref.h |    2 -
>  2 files changed, 119 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index c97240a..d88fa49 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -22,6 +22,7 @@
>  #include "ulist.h"
>  #include "transaction.h"
>  #include "delayed-ref.h"
> +#include "locking.h"

This + line tells me it's not based on top of linux-3.4 or newer. I see that the
changes made in between are now included in your patch set. It might have been
better to rebase it before sending them. Anyway, that only makes review a bit
harder, should affect applying the patches.

>  
>  /*
>   * this structure records all encountered refs on the way up to the root
> @@ -940,34 +941,35 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
>   * value will be smaller than dest. callers must check this!
>   */
>  static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> -				struct btrfs_inode_ref *iref,
> -				struct extent_buffer *eb_in, u64 parent,
> -				char *dest, u32 size)
> +			  u32 name_len, unsigned long name_off,
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
>  		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
>  		if (ret > 0)
>  			ret = -ENOENT;
>  		if (ret)
>  			break;
> +
>  		next_inum = found_key.offset;
>  
>  		/* regular exit ahead */
> @@ -980,8 +982,11 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>  		if (eb != eb_in)
>  			atomic_inc(&eb->refs);
>  		btrfs_release_path(path);
> -
>  		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> +
> +		name_len = btrfs_inode_ref_name_len(eb, iref);
> +		name_off = (unsigned long)(iref + 1);
> +
>  		parent = next_inum;
>  		--bytes_left;
>  		if (bytes_left >= 0)
> @@ -1294,9 +1299,12 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> -static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> -				struct btrfs_path *path,
> -				iterate_irefs_t *iterate, void *ctx)
> +typedef int (iterate_irefs_t)(u64 parent, u32 name_len, unsigned long name_off,
> +			      struct extent_buffer *eb, void *ctx);
> +
> +static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
> +			      struct btrfs_path *path,
> +			      iterate_irefs_t *iterate, void *ctx)
>  {
>  	int ret;
>  	int slot;
> @@ -1312,7 +1320,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  
>  	while (1) {
>  		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
> -					&found_key);
> +				     &found_key);
>  		if (ret < 0)
>  			break;
>  		if (ret) {
> @@ -1326,8 +1334,11 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  		eb = path->nodes[0];
>  		/* make sure we can use eb after releasing the path */
>  		atomic_inc(&eb->refs);
> +		btrfs_tree_read_lock(eb);
> +		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>  		btrfs_release_path(path);
>  
> +

I realized you like adding new lines, but we really don't need two of them here.

>  		item = btrfs_item_nr(eb, slot);
>  		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
>  
> @@ -1338,15 +1349,81 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  				 "tree %llu\n", cur,
>  				 (unsigned long long)found_key.objectid,
>  				 (unsigned long long)fs_root->objectid);
> -			ret = iterate(parent, iref, eb, ctx);
> -			if (ret) {
> -				free_extent_buffer(eb);
> +			ret = iterate(parent, name_len,
> +				      (unsigned long)(iref + 1),eb, ctx);

There's a space missing before "eb".

> +			if (ret)
>  				break;
> -			}
>  			len = sizeof(*iref) + name_len;
>  			iref = (struct btrfs_inode_ref *)((char *)iref + len);
>  		}
> +		btrfs_tree_read_unlock_blocking(eb);
> +		free_extent_buffer(eb);
> +	}
> +
> +	btrfs_release_path(path);
> +
> +	return ret;
> +}
> +
> +static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
> +				 struct btrfs_path *path,
> +				 iterate_irefs_t *iterate, void *ctx)
> +{
> +	int ret;
> +	int slot;
> +	u64 offset = 0;
> +	u64 parent;
> +	int found = 0;
> +	struct extent_buffer *eb;
> +	struct btrfs_inode_extref *extref;
> +	struct extent_buffer *leaf;
> +	u32 item_size;
> +	u32 cur_offset;
> +	unsigned long ptr;
> +
> +	while (1) {
> +		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
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
> +
> +		btrfs_tree_read_lock(eb);
> +		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> +		btrfs_release_path(path);
> +
> +		leaf = path->nodes[0];
> +		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> +		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> +		cur_offset = 0;
> +
> +		while (cur_offset < item_size) {
> +			u32 name_len;
> +
> +			extref = (struct btrfs_inode_extref *)(ptr + cur_offset);
> +			parent = btrfs_inode_extref_parent(eb, extref);
> +			name_len = btrfs_inode_extref_name_len(eb, extref);
> +			ret = iterate(parent, name_len,
> +				      (unsigned long)&extref->name, eb, ctx);
> +			if (ret)
> +				break;
> +
> +			cur_offset += btrfs_inode_extref_name_len(leaf, extref);
> +			cur_offset += sizeof(*extref);
> +		}
> +		btrfs_tree_read_unlock_blocking(eb);
>  		free_extent_buffer(eb);
> +
> +		offset++;
>  	}
>  
>  	btrfs_release_path(path);
> @@ -1354,12 +1431,32 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
>  	return ret;
>  }
>  
> +static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> +			 struct btrfs_path *path, iterate_irefs_t *iterate,
> +			 void *ctx)
> +{
> +	int ret;
> +	int found_refs = 0;
> +
> +	ret = iterate_inode_refs(inum, fs_root, path, iterate, ctx);
> +	if (!ret)
> +		++found_refs;
> +	else if (ret != -ENOENT)
> +		return ret;
> +
> +	ret = iterate_inode_extrefs(inum, fs_root, path, iterate, ctx);
> +	if (ret == -ENOENT && found_refs)
> +		return 0;
> +
> +	return ret;
> +}
> +
>  /*
>   * returns 0 if the path could be dumped (probably truncated)
>   * returns <0 in case of an error
>   */
> -static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
> -				struct extent_buffer *eb, void *ctx)
> +static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
> +			 struct extent_buffer *eb, void *ctx)
>  {
>  	struct inode_fs_paths *ipath = ctx;
>  	char *fspath;
> @@ -1372,20 +1469,17 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
>  					ipath->fspath->bytes_left - s_ptr : 0;
>  
>  	fspath_min = (char *)ipath->fspath->val + (i + 1) * s_ptr;
> -	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, iref, eb,
> -				inum, fspath_min, bytes_left);
> +	fspath = iref_to_path(ipath->fs_root, ipath->btrfs_path, name_len,
> +			      name_off, eb, inum, fspath_min,
> +			      bytes_left);
>  	if (IS_ERR(fspath))
>  		return PTR_ERR(fspath);
>  
>  	if (fspath > fspath_min) {
> -		pr_debug("path resolved: %s\n", fspath);
>  		ipath->fspath->val[i] = (u64)(unsigned long)fspath;
>  		++ipath->fspath->elem_cnt;
>  		ipath->fspath->bytes_left = fspath - fspath_min;
>  	} else {
> -		pr_debug("missed path, not enough space. missing bytes: %lu, "
> -			 "constructed so far: %s\n",
> -			 (unsigned long)(fspath_min - fspath), fspath_min);
>  		++ipath->fspath->elem_missed;
>  		ipath->fspath->bytes_missing += fspath_min - fspath;
>  		ipath->fspath->bytes_left = 0;
> @@ -1407,7 +1501,7 @@ static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
>  int paths_from_inode(u64 inum, struct inode_fs_paths *ipath)
>  {
>  	return iterate_irefs(inum, ipath->fs_root, ipath->btrfs_path,
> -				inode_to_path, ipath);
> +			     inode_to_path, ipath);
>  }
>  
>  /*
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index 8586d1b..649a220 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -30,8 +30,6 @@ struct inode_fs_paths {
>  
>  typedef int (iterate_extent_inodes_t)(u64 inum, u64 offset, u64 root,
>  		void *ctx);
> -typedef int (iterate_irefs_t)(u64 parent, struct btrfs_inode_ref *iref,
> -				struct extent_buffer *eb, void *ctx);
>  
>  int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>  			struct btrfs_path *path);

Almost ready for a reviewed-by tag :-)
-Jan
