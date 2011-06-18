From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v1 1/6] added helper functions to iterate backrefs
Date: Sat, 18 Jun 2011 13:25:28 +0200
Message-ID: <4DFC8B28.3050607@jan-o-sch.net>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net> <c7bb3e82b7404167d3880a86200bb73b767a38e4.1307991539.git.list.btrfs@jan-o-sch.net> <20110616212440.GA12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110616212440.GA12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Lots of quotation removed. All removed comments accepted.

On 16.06.2011 23:24, David Sterba wrote:
> On Mon, Jun 13, 2011 at 09:10:34PM +0200, Jan Schmidt wrote:
>> +/*
>> + * this iterates to turn a btrfs_inode_ref into a full filesystem path. elements
>> + * of the path are separated by '/' and the path is guaranteed to be
>> + * 0-terminated. the path is only given within the current file system.
>> + * Therefore, it never starts with a '/'. the caller is responsible to provide
>> + * "size" bytes in "dest". the dest buffer will be filled backwards! the idea is
>> + * that in case of an overflow, the lower part in the hierarchie is most
>> + * important to the user. finally, the start point of resulting the string is
>                                                                  ^^^
>> + * returned. in case the path would overflow, "..." is added at the front of
>> + * the string and iteration stops regularly.
>> + */
>> +static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>> +				struct btrfs_inode_ref *iref,
>> +				struct extent_buffer *eb, u64 parent,
>> +				char *dest, u32 size)
>> +{
>> +	u32 len;
>> +	int slot;
>> +	u64 inum;
>> +	int ret;
>> +	u32 left = size - 1;
> 
> this confused me first, 'left' may be ambiguous, something like 'bytes_left'
> would be better
> 
>> +
>> +	dest[left] = '\0';
>> +
>> +	while (1) {
>> +		len = btrfs_inode_ref_name_len(eb, iref);
>> +		if (len > left) {
>> +			if (size < 4)
>> +				return dest+left;
> 
>                                 break;
> 
>> +			if (left > 3)
>> +				dest += left - 3;
>> +			memcpy(dest, "...", 3);
>> +			return dest;
> 
> i'd rather see this consistent with other return points,
> 
> if (left > 3)
> 	left -= 3;
> else
> 	left = 0;
> memcpy(dest + left, "...", 3);
> break;
> 
>> +		}
>> +		left -= len;
>> +		read_extent_buffer(eb, dest+left,
>> +					(unsigned long)(iref + 1), len);
>> +
>> +		ret = inode_item_info(parent, 0, fs_root, path);
>> +		if (ret)
>> +			return ERR_PTR(ret);
>> +		eb = path->nodes[0];
>> +		btrfs_release_path(path);
>> +
>> +		ret = inode_ref_info(parent, 0, fs_root, path, 0,
>> +					&inum, NULL, &slot);
>> +		if (ret)
>> +			return ERR_PTR(ret);
>> +
>> +		if (parent == inum)   /* regular exit ahead */ {
>> +			return dest+left;
>                         break;
> 
> and please put the comment before the if and remove { }

Damn. Braces where a debugging leftover. I wonder if I missed something
from checkpatch.pl.

>> +		}
>> +
>> +		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
>> +		parent = inum;
>> +		if (left > 0) {
>> +			dest[left-1] = '/';
>> +			--left;
> 
> swap the lines and remove "-1" :)
> 
>> +		}
>> +	}
>        
>         return dest + left;

Took suggested modifications and it looks prettier with a return at the end.

>> +}
>> +
>> +/*
>> + * this makes the path point to (logical EXTENT_ITEM *)
>> + * returns 0 for data blocks, 1 for tree blocks and <0 on error
>> + */
>> +int data_extent_from_logical(struct btrfs_root *root, u64 logical,
>> +				struct btrfs_path *path,
>> +				struct btrfs_key *found_key)
>> +{
>> +	int ret;
>> +	u64 flags;
>> +	u32 item_size;
>> +	struct extent_buffer *eb;
>> +	struct btrfs_extent_item *ei;
>> +	struct btrfs_key key;
>> +	struct btrfs_key f;
> 
>                          tmpkey;
> 
>> +	struct btrfs_key *fk = found_key ? found_key : &f;
> 
> transform this to
> 
>         if (!found_key)
> 		found_key = &tmpkey;
> 
> and use found_key along
> 	
> still, will you ever pass NULL found_key?

You are right, I probably won't. I'll take out those lines completely.

>> +
>> +	key.type = BTRFS_EXTENT_ITEM_KEY;
>> +	key.objectid = logical;
>> +	key.offset = (u64)-1;
>> +
>> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = btrfs_previous_item(root->fs_info->extent_root, path,
>> +					0, BTRFS_EXTENT_ITEM_KEY);
>> +	if (ret < 0)
>> +		return ret;
>> +	btrfs_item_key_to_cpu(path->nodes[0], fk, path->slots[0]);
>> +	if (fk->type != BTRFS_EXTENT_ITEM_KEY || fk->objectid > logical ||
>> +	    fk->objectid + fk->offset <= logical)
>> +		return -1;
> 
> this is -EPERM, confusing. eg btrfs_previous_item a few lines above may return
> variety of error codes from the whole function, EPERM just does not fit.  does
> this check mean some serious error? inconsistency or corruption?

It doesn't. -ENOENT seems appropriate.

>> +
>> +	eb = path->nodes[0];
>> +	item_size = btrfs_item_size_nr(eb, path->slots[0]);
>> +	BUG_ON(item_size < sizeof(*ei));
>> +
>> +	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
>> +	flags = btrfs_extent_flags(eb, ei);
>> +
>> +	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * helper function to iterate extent backrefs. ptr must point to a 0 value for
>> + * the first call and may be modified. it is used to track state.
>> + * if more backrefs exist, 0 is returned and the next call to _get_extent_ref
>> + * must pass the modified ptr parameter to get to the next backref.
>> + * after the last backref was processed, 1 is returned.
>> + * returns <0 on error
>> + */
>> +static int _get_extent_ref(int flags_wanted, int type_wanted,
>            __get_extent_ref
> single score function prefixes are not used
> 
> flags_wanted is compared to extent_flags of u64 type

Alongside, I changed type_wanted from int to u8.

>> +				unsigned long *ptr, struct extent_buffer *eb,
>> +				struct btrfs_extent_item *ei, u32 item_size,
>> +				struct btrfs_extent_inline_ref **eiref)
>> +{
>> +	int type;
>> +	int again = 0;
>> +	unsigned long end;
>> +	u64 flags;
>> +	struct btrfs_tree_block_info *info;
>> +
>> +	if (!*ptr) {
>> +		/* first call */
>> +		flags = btrfs_extent_flags(eb, ei);
>> +		if (!(flags & flags_wanted))
>> +			return -1;
> 
> again, better errorcode, EINVAL seems to be the right choice
> 
>> +		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>> +			info = (struct btrfs_tree_block_info *)(ei + 1);
>> +			*eiref = (struct btrfs_extent_inline_ref *)(info + 1);
>> +		} else {
>> +			*eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
> 
> style: remove { } around single if/else statement

That would look horribly unbalanced because the if part needs braces.

>> +		}
> 
>> +		*ptr = (unsigned long)*eiref;
>> +	}
>> +
>> +	end = (unsigned long)ei + item_size;
>> +
>> +again:
>> +	again = 0;
> 
> excessive use of goto detected:
> 
> 	do {
>> +
>> +	*eiref = (struct btrfs_extent_inline_ref *)*ptr;
>> +	type = btrfs_extent_inline_ref_type(eb, *eiref);
>> +
>> +	if (type != type_wanted)
>> +		again = 1;
>> +
>> +	*ptr += btrfs_extent_inline_ref_size(type);
>> +
>> +	WARN_ON(*ptr > end);
>> +	if (*ptr == end)
>> +		return 1; /* last */
>> +
>> +	if (again)
>> +		goto again;
> 	
> 	} while (type != type_wanted);
> 
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * reads the tree block backref for an extent. tree level and root are returned
>> + * through dest_level and dest_root. ptr must point to a 0 value for the first
>> + * call and may be modified (see _get_extent_ref comment).
>> + * returns 0 on success, <0 on error. note: in contrast to _get_extent_ref this
>> + * one never returns 1!
>> + */
>> +int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
>> +				struct btrfs_extent_item *ei, u32 item_size,
>> +				u64 *dest_root, u64 *dest_level)
> 
> there's not a formal "rule" or something, but i've seen outgoing parameters
> named with 'out_'
> 
> dest_level can be just an int, levels fit in one byte anyway
> 
>> +{
>> +	int ret;
>> +	struct btrfs_tree_block_info *info;
>> +	struct btrfs_extent_inline_ref *eiref;
>> +
>> +	ret = _get_extent_ref(BTRFS_EXTENT_FLAG_TREE_BLOCK,
>> +				BTRFS_TREE_BLOCK_REF_KEY, ptr, eb, ei,
>> +				item_size, &eiref);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	WARN_ON(!ret); /* multiple tree backrefs for this extent */
> 
> as we will probably have CONFIG_DEBUG, the comment makes a good candidate for a
> printk message

I'll prepare that with a if (!ret) and WARN_ON(1) with printk.

>> +
>> +	info = (struct btrfs_tree_block_info *)(ei + 1);
>> +	*dest_root = btrfs_extent_inline_ref_offset(eb, eiref);
>> +	*dest_level = btrfs_tree_block_level(eb, info);
>> +
>> +	return 0;
>> +}
>> +
>> +static int data_inode_for_extent(unsigned long *ptr, struct extent_buffer *eb,
>> +					struct btrfs_extent_item *ei,
>> +					u32 item_size, u64 *dest_inum,
>> +					u64 *dest_ioff)
>> +{
>> +	int ret;
>> +	struct btrfs_extent_inline_ref *eiref;
>> +	struct btrfs_extent_data_ref *dref;
>> +
>> +	ret = _get_extent_ref(BTRFS_EXTENT_FLAG_DATA, BTRFS_EXTENT_DATA_REF_KEY,
>> +				ptr, eb, ei, item_size, &eiref);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	dref = (struct btrfs_extent_data_ref *)(&eiref->offset);
>> +	if (btrfs_extent_data_ref_root(eb, dref) != BTRFS_FS_TREE_OBJECTID) {
>> +		WARN_ON(1);
>> +		return -1;
> 
> needs better error code
> 
>> +	}
>> +
>> +	*dest_inum = btrfs_extent_data_ref_objectid(eb, dref);
>> +	*dest_ioff = btrfs_extent_data_ref_offset(eb, dref);
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * calls iterate() for every inode that references the extent identified by
>> + * the given parameters.
>> + * when the iterator function returns a non-zero value, iteration stops.
>> + */
>> +int iterate_extent_inodes(struct extent_buffer *eb,
>> +				struct btrfs_extent_item *ei,
>> +				loff_t extent_item_offset, u32 item_size,
>> +				iterate_extent_inodes_t *iterate, void *ctx)
>> +{
>> +	int last;
>> +	u64 inum;
>> +	unsigned long ptr = 0;
>> +	loff_t extent_data_item_offset;
>> +	int ret;
>> +
>> +	do {
>> +		last = data_inode_for_extent(&ptr, eb, ei, item_size, &inum,
>> +						&extent_data_item_offset);
>> +		if (last < 0)
>> +			return last;
>> +
>> +		ret = iterate(inum, extent_item_offset+extent_data_item_offset,
>> +				ctx);
>> +		if (ret)
>> +			return ret;
>> +
>> +	} while (!last);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * just a convenience function combining data_extent_from_logical and
>> + * iterate_extent_inodes.
>> + */
> 
> a better comment please or none

Opt for the latter. Didn't feel that would need a comment, anyway.

>> +int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
>> +				struct btrfs_path *path,
>> +				iterate_extent_inodes_t *iterate, void *ctx)
>> +{
>> +	int ret;
>> +	u32 item_size;
>> +	struct extent_buffer *l;
>> +	struct btrfs_extent_item *extent;
>> +	loff_t offset;
>> +	struct btrfs_key found_key;
>> +
>> +	ret = data_extent_from_logical(fs_info->extent_root, logical, path,
>> +					&found_key);
>> +	if (ret)
>> +		return ret;
> 
> this can ret < 0 in case of error, and 1 for the tree block. not sure if this
> shouldn't be handled separately

Well, that's fine I think. We can't proceed either way here.

>> +
>> +	offset = logical - found_key.objectid;
>> +	l = path->nodes[0];
>> +	extent = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
>> +	item_size = btrfs_item_size_nr(l, path->slots[0]);
>> +	btrfs_release_path(path);
>> +
>> +	ret = iterate_extent_inodes(l, extent, offset, item_size, iterate, ctx);
>> +
>> +	return ret;
>> +}
>> +
>> +static int iterate_irefs(u64 inum, struct extent_buffer *eb_i,
>> +				struct btrfs_root *fs_root,
>> +				struct btrfs_path *path,
>> +				iterate_irefs_t *iterate, void *ctx)
>> +{
>> +	int ret;
>> +	int slot;
>> +	u32 cur;
>> +	u32 len;
>> +	u32 name_len;
>> +	u64 parent = 0;
>> +	struct extent_buffer *eb_ir;
>> +	struct btrfs_item *item;
>> +	struct btrfs_inode_ref *iref;
>> +
>> +	while (1) {
>> +		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
>> +					1, &parent, &eb_ir, &slot);
>> +		if (ret < 0)
>> +			return ret;
>> +		if (ret)
>> +			break;
>> +
>> +		item = btrfs_item_nr(eb_i, slot);
>> +		iref = btrfs_item_ptr(eb_i, slot, struct btrfs_inode_ref);
>> +
>> +		for (cur = 0; cur < btrfs_item_size(eb_i, item); cur += len) {
>> +			name_len = btrfs_inode_ref_name_len(eb_i, iref);
>> +			ret = iterate(parent, iref, eb_ir, slot, ctx);
>> +			if (ret)
>> +				return ret;
>> +			len = sizeof(*iref) + name_len;
>> +			iref = (struct btrfs_inode_ref *)((char *)iref + len);
>> +		}
>> +	}
> 
> can you estimate how long this loop may take? (eg. number of iterations per
> call) there may be a need for cond_resched()

Number of iterations is limited by the number of backrefs an inode can
have, which is limited by the number of backrefs that fit into one leaf.
As leaves are only 4kb (maybe 8kb soon), I don't think that requires a
cond_resched(). More input on this appreciated :-)

>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * returns 0 if the path could be dumped (probably truncated)
>> + * returns <0 in case of an error
>> + */
>> +static int inode_to_path(u64 inum, struct btrfs_inode_ref *iref,
>> +				struct extent_buffer *eb_ir, int slot,
>> +				void *ctx)
>> +{
>> +	struct inode_fs_paths *ipath = ctx;
>> +	struct extent_buffer *eb_i = ipath->eb_i;
>> +	u32 path_len;
>> +	char *fs_path;
>> +
>> +	if (ipath->left < 2)
>> +		return -EOVERFLOW;
>> +
>> +	*ipath->dest++ = ' ';
>> +	--ipath->left;
>> +
>> +	fs_path = iref_to_path(ipath->fs_root, ipath->path, iref, eb_i,
>> +				inum, ipath->scratch_buf, ipath->left);
> 
> fs_path will be never NULL, either an IS_ERR or ipath->scratch_buf + some
> offset

You are right, that changed while developing, I'll remove the check. In
this implementation ...

>> +	if (!fs_path || IS_ERR(fs_path))
>> +		return PTR_ERR(fs_path);
> 
> this could return PTR_ERR(0), confusing with 'return 0' for the calle

... that comment is void then.

>> +	path_len = ipath->scratch_buf + ipath->left - fs_path - 1;
>> +	if (path_len+1 > ipath->left)
>> +		return -EOVERFLOW;
>> +	memcpy(ipath->dest, fs_path, path_len+1);
>> +	ipath->left -= path_len;
>> +	ipath->dest += path_len;
>> +
>> +	return 0;
>> +}
>> +
>> +int paths_from_inode(u64 inum, struct inode_fs_paths *ipath)
>> +{
>> +	return iterate_irefs(inum, ipath->eb_i, ipath->fs_root, ipath->path,
>> +				inode_to_path, ipath);
>> +}
>> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
>> new file mode 100644
>> index 0000000..6b7e856
>> --- /dev/null
>> +++ b/fs/btrfs/backref.h
>> @@ -0,0 +1,59 @@
>> +/*
>> + * Copyright (C) 2011 STRATO.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +
>> +#ifndef __BTRFS_BACKREF__
>> +#define __BTRFS_BACKREF__
>> +
>> +struct inode_fs_paths {
>> +	int			left;
> 
> as suggested above, rename this
> 
>> +	char			*dest;
>> +	struct btrfs_path	*path;
>> +	char			*scratch_buf;
>> +	struct btrfs_root	*fs_root;
>> +	int			scratch_bufsize;
>> +	struct extent_buffer	*eb_i;
>> +};
>> +
>> +typedef int (iterate_extent_inodes_t)(u64 inum, loff_t offset, void *ctx);
>> +typedef int (iterate_irefs_t)(u64 parent, struct btrfs_inode_ref *iref,
>> +				struct extent_buffer *eb_ir,
>> +				int slot, void *ctx);
>> +
>> +int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
>> +			struct btrfs_path *path);
>> +
>> +int data_extent_from_logical(struct btrfs_root *root, u64 logical,
>> +				struct btrfs_path *path,
>> +				struct btrfs_key *found_key);
>> +
>> +int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
>> +				struct btrfs_extent_item *ei, u32 item_size,
>> +				u64 *dest_root, u64 *dest_level);
>> +
>> +int iterate_extent_inodes(struct extent_buffer *eb,
>> +				struct btrfs_extent_item *ei,
>> +				loff_t extent_item_offset, u32 item_size,
>> +				iterate_extent_inodes_t *iterate, void *ctx);
>> +
>> +int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
>> +				struct btrfs_path *path,
>> +				iterate_extent_inodes_t *iterate, void *ctx);
>> +
>> +int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
> 
> every function from the .c file not listed here should be static

I agree on that. Double checked and didn't find any that isn't.

Thanks!
Jan
