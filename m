Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751751AbeCNITs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:19:48 -0400
Subject: Re: [PATCH 1/2] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180313184700.30173-1-fdmanana@kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c2202ca5-086d-125f-866e-f08c8080a8c5@suse.com>
Date: Wed, 14 Mar 2018 10:19:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180313184700.30173-1-fdmanana@kernel.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.03.2018 20:47, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Under some cases the filesystem checker reports an error when it finds
> checksum items for an extent that is referenced by an inode as a prealloc
> extent. Such cases are not an error when the extent is actually shared
> (was cloned/reflinked) with other inodes and was written through one of
> those other inodes.
> 
> Example:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ touch /mnt/foo
>   $ xfs_io -c "falloc 0 256K" /mnt/foo
>   $ sync
> 
>   $ xfs_io -c "pwrite -S 0xab -b 0 256K" /mnt/foo
>   $ touch /mnt/bar
>   $ xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>   $ xfs_io -c "fsync" /mnt/bar
> 
>   <power fail>
>   $ mount /dev/sdb /mnt
>   $ umount /mnt
> 
>   $ btrfs check /dev/sdc
>   Checking filesystem on /dev/sdb
>   UUID: 52d3006e-ee3b-40eb-aa21-e56253a03d39
>   checking extents
>   checking free space cache
>   checking fs roots
>   root 5 inode 257 errors 800, odd csum item
>   ERROR: errors found in fs roots
>   found 688128 bytes used, error(s) found
>   total csum bytes: 256
>   total tree bytes: 163840
>   total fs tree bytes: 65536
>   total extent tree bytes: 16384
>   btree space waste bytes: 138819
>   file data blocks allocated: 10747904
>    referenced 10747904
>   $ echo $?
>   1
> 
> So tech check to not report such cases as errors by checking if the
> extent is shared with other inodes and if so, consider it an error the
> existence of checksum items only if all those other inodes are referencing
> the extent as a prealloc extent.
> This case can be hit often when running the generic/475 testcase from
> fstests.
> 
> A test case will follow in a separate patch.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  check/main.c | 270 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 268 insertions(+), 2 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 392195ca..bb816311 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1424,6 +1424,264 @@ static int process_inode_extref(struct extent_buffer *eb,
>  
>  }
>  
> +/*
> + * Check if the inode referenced by the given data reference uses the extent
> + * at disk_bytenr as a non-prealloc extent.
> + *
> + * Returns 1 if true, 0 if false and < 0 on error.
> + */
> +static int check_prealloc_data_ref(struct btrfs_fs_info *fs_info,
> +				   u64 ino,
> +				   u64 disk_bytenr,
> +				   struct btrfs_extent_data_ref *dref,
> +				   struct extent_buffer *eb)
> +{
> +	u64 rootid = btrfs_extent_data_ref_root(eb, dref);
> +	u64 objectid = btrfs_extent_data_ref_objectid(eb, dref);

nit: Shouldn't this ino be equal to the ino passed to the function? If
so objectid can be removed and when setting up the key for the second
search you just assigne ino to its objectid

> +	u64 offset = btrfs_extent_data_ref_offset(eb, dref);
> +	struct btrfs_root *root;
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	int ret;
> +
> +	if (objectid == ino)
> +		return 0;
> +
> +	btrfs_init_path(&path);
> +	key.objectid = rootid;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = (u64)-1;
> +	root = btrfs_read_fs_root(fs_info, &key);
> +	if (IS_ERR(root)) {
> +		ret = PTR_ERR(root);
> +		goto out;
> +	}
> +
> +	key.objectid = objectid;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +	key.offset = offset;
> +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> +	if (ret > 0) {
> +		fprintf(stderr,
> +			"Missing file extent item for inode %llu, root %llu, offset %llu",
> +			objectid, rootid, offset);
> +		ret = -ENOENT;
> +	}
> +	if (ret < 0)
> +		goto out;
> +
> +	while (true) {
> +		struct btrfs_file_extent_item *fi;
> +		int extent_type;
> +
> +		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
> +			ret = btrfs_next_leaf(fs_info->extent_root, &path);
> +			if (ret < 0)
> +				goto out;
> +			if (ret > 0)
> +				break;
> +		}
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.objectid != objectid ||
> +		    key.type != BTRFS_EXTENT_DATA_KEY)
> +			break;
> +
> +		fi = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type = btrfs_file_extent_type(path.nodes[0], fi);
> +		if (extent_type != BTRFS_FILE_EXTENT_REG &&
> +		    extent_type != BTRFS_FILE_EXTENT_PREALLOC)
> +			goto next;
> +
> +		if (btrfs_file_extent_disk_bytenr(path.nodes[0], fi) !=
> +		    disk_bytenr)
> +			break;
> +
> +		if (extent_type == BTRFS_FILE_EXTENT_REG) {
> +			ret = 1;
> +			goto out;
> +		}
> +next:
> +		path.slots[0]++;
> +	}
> +	ret = 0;
> + out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
> +/*
> + * Check if a shared data reference points to a node that has a file extent item
> + * pointing to the extent at disk_bytenr that is not of type prealloc and is
> + * associated to an inode with a number different from ino.
> + *
> + * Returns 1 if true, 0 if false and < 0 on error.
> + */
> +static int check_prealloc_shared_data_ref(struct btrfs_fs_info *fs_info,
> +					  u64 ino,
> +					  u64 parent,
> +					  u64 disk_bytenr)
> +{
> +	struct extent_buffer *eb;
> +	u32 nr;
> +	int i;
> +	int ret = 0;
> +
> +	eb = read_tree_block(fs_info, parent, 0);
> +	if (!extent_buffer_uptodate(eb)) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	nr = btrfs_header_nritems(eb);
> +	for (i = 0; i < nr; i++) {
> +		struct btrfs_key key;
> +		struct btrfs_file_extent_item *fi;
> +		int extent_type;
> +
> +		btrfs_item_key_to_cpu(eb, &key, i);
> +		if (key.type != BTRFS_EXTENT_DATA_KEY)
> +			continue;
> +		if (key.objectid == ino)
> +			continue;
> +
> +		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
> +
> +		extent_type = btrfs_file_extent_type(eb, fi);
> +		if (extent_type != BTRFS_FILE_EXTENT_REG &&
> +		    extent_type != BTRFS_FILE_EXTENT_PREALLOC)
> +			continue;
> +
> +		if (btrfs_file_extent_disk_bytenr(eb, fi) == disk_bytenr &&
> +		    extent_type == BTRFS_FILE_EXTENT_REG) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> + out:
> +	free_extent_buffer(eb);
> +	return ret;
> +}
> +
> +/*
> + * Check if a prealloc extent is shared by other inodes and if any inode has
> + * already written to that extent. This is to avoid emitting invalid warnings
> + * about odd csum items (a inode has an extent entirely marked as prealloc
> + * but another inode shares it and has already written to it).
> + *
> + * Returns 0 if the prealloc extent was not written yet by any inode, 1 if
> + * at least one other inode has written to it, and < 0 on error.
> + */
> +static int check_prealloc_extent_written(struct btrfs_fs_info *fs_info,
> +					 u64 ino,
> +					 u64 disk_bytenr,
> +					 u64 num_bytes)
> +{
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	int ret;
> +	struct btrfs_extent_item *ei;
> +	u32 item_size;
> +	unsigned long ptr;
> +	unsigned long end;
> +
> +	key.objectid = disk_bytenr;
> +	key.type = BTRFS_EXTENT_ITEM_KEY;
> +	key.offset = num_bytes;
> +
> +	btrfs_init_path(&path);
> +	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, &path, 0, 0);
> +	if (ret > 0) {
> +		fprintf(stderr,
> +			"Missing extent item in extent tree for disk_bytenr %llu, num_bytes %llu\n",
> +			disk_bytenr, num_bytes);
> +		ret = -ENOENT;
> +	}
> +	if (ret < 0)
> +		goto out;
> +
> +	/* First check all inline refs. */
> +	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +			    struct btrfs_extent_item);
> +	item_size = btrfs_item_size_nr(path.nodes[0], path.slots[0]);
> +	ptr = (unsigned long)(ei + 1);
> +	end = (unsigned long)ei + item_size;
> +	while (ptr < end) {
> +		struct btrfs_extent_inline_ref *iref;
> +		int type;
> +
> +		iref = (struct btrfs_extent_inline_ref *)ptr;
> +		type = btrfs_extent_inline_ref_type(path.nodes[0], iref);
> +		ASSERT(type == BTRFS_EXTENT_DATA_REF_KEY ||
> +		       type == BTRFS_SHARED_DATA_REF_KEY);
> +
> +		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
> +			struct btrfs_extent_data_ref *dref;
> +
> +			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
> +			ret = check_prealloc_data_ref(fs_info, ino, disk_bytenr,
> +						      dref, path.nodes[0]);
> +			if (ret != 0)
> +				goto out;
> +		} else if (type == BTRFS_SHARED_DATA_REF_KEY) {
> +			u64 parent;
> +
> +			parent = btrfs_extent_inline_ref_offset(path.nodes[0],
> +								iref);
> +			ret = check_prealloc_shared_data_ref(fs_info,
> +							     ino,
> +							     parent,
> +							     disk_bytenr);
> +			if (ret != 0)
> +				goto out;
> +		}
> +
> +		ptr += btrfs_extent_inline_ref_size(type);
> +	}
> +
> +	/* Now check if there are any non-inlined refs. */
> +	path.slots[0]++;
> +	while (true) {
> +		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
> +			ret = btrfs_next_leaf(fs_info->extent_root, &path);
> +			if (ret < 0)
> +				goto out;
> +			if (ret > 0) {
> +				ret = 0;
> +				break;
> +			}
> +		}
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.objectid != disk_bytenr)
> +			break;
> +
> +		if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
> +			struct btrfs_extent_data_ref *dref;
> +
> +			dref = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +					      struct btrfs_extent_data_ref);
> +			ret = check_prealloc_data_ref(fs_info, ino, disk_bytenr,
> +						      dref, path.nodes[0]);
> +			if (ret != 0)
> +				goto out;
> +		} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
> +			ret = check_prealloc_shared_data_ref(fs_info,
> +							     ino,
> +							     key.offset,
> +							     disk_bytenr);
> +			if (ret != 0)
> +				goto out;
> +		}
> +
> +		path.slots[0]++;
> +	}
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
> +
>  static int process_file_extent(struct btrfs_root *root,
>  				struct extent_buffer *eb,
>  				int slot, struct btrfs_key *key,
> @@ -1515,8 +1773,16 @@ static int process_file_extent(struct btrfs_root *root,
>  			if (found < num_bytes)
>  				rec->some_csum_missing = 1;
>  		} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> -			if (found > 0)
> -				rec->errors |= I_ERR_ODD_CSUM_ITEM;
> +			if (found > 0) {
> +				ret = check_prealloc_extent_written(root->fs_info,
> +								    rec->ino,
> +								    disk_bytenr,
> +								    num_bytes);
> +				if (ret < 0)
> +					return ret;
> +				if (ret == 0)
> +					rec->errors |= I_ERR_ODD_CSUM_ITEM;
> +			}
>  		}
>  	}
>  	return 0;
> 
