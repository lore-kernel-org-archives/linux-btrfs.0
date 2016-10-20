Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40674 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754445AbcJTBEg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 21:04:36 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: fsck: Add support to clear v1 free space
 cache.
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
 <20161019151342.GV11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2e89c014-bf97-e43e-9d7e-500a8ecdeadf@cn.fujitsu.com>
Date: Thu, 20 Oct 2016 09:04:23 +0800
MIME-Version: 1.0
In-Reply-To: <20161019151342.GV11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/19/2016 11:13 PM, David Sterba wrote:
> On Thu, Oct 13, 2016 at 05:22:26PM +0800, Qu Wenruo wrote:
>> Kernel clear_cache mount option will only rebuilt free space cache if
>> used space of that chunk has changed.
>>
>> So it won't ensure any corrupted free space cache get cleared.
>>
>> So add a new option "--clear-space-cache v1|v2" to btrfsck, to
>> completely wipe out free space cache.
>> So kernel won't complain again.
>>
>> Reported-by: Ivan P <chrnosphered@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  Documentation/btrfs-check.asciidoc |   9 +++
>>  cmds-check.c                       |  63 ++++++++++++++++++-
>>  free-space-cache.c                 | 124 +++++++++++++++++++++++++++++++++++++
>>  free-space-cache.h                 |   2 +
>>  4 files changed, 197 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
>> index a32e1c7..ef1e464 100644
>> --- a/Documentation/btrfs-check.asciidoc
>> +++ b/Documentation/btrfs-check.asciidoc
>> @@ -78,6 +78,15 @@ respective superblock offset is within the device size
>>  This can be used to use a different starting point if some of the primary
>>  superblock is damaged.
>>
>> +--clear-space-cache v1|v2::
>> +completely wipe out all free space cache.
>> +Only v1(file based) free space cache is supported yet.
>> ++
>> +NOTE: Kernel mount option 'clear_cache' is only designed to rebuild free space cache
>> +which is modified during the lifetime of that mount option.
>> +It doesn't rebuild all free space cache, nor clear them out.
>> +
>> +
>>  DANGEROUS OPTIONS
>>  -----------------
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index 670ccd1..f62fc62 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -11206,6 +11206,36 @@ out:
>>  	return bad_roots;
>>  }
>>
>> +static int clear_free_space_cache(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_block_group_cache *bg_cache;
>> +	u64 current = 0;
>> +	int ret = 0;
>> +
>> +	/* Clear all free space cache inodes and its extent data */
>> +	while (1) {
>> +		bg_cache = btrfs_lookup_first_block_group(fs_info, current);
>> +		if (!bg_cache)
>> +			break;
>> +		ret = btrfs_clear_free_space_cache(fs_info, bg_cache);
>
> The function can fail for a lot of reasons, what would be the filesystem
> state when we exit here? Some of the inodes could be cleared completely,
> the last one partially.  The function copes with a missing inode item
> but I don't know how many other intermediate states could be left.

If we exit here, no damage for the filesystem will be done, since we are 
protected by transaction.

As you can find, in btrfs_clear_free_space_cache(),
it will only commit transaction if we fully cleaned the whole inode and 
its free space header.

So we're quite safe here, free space header and inode are cleaned 
atomically.

PS: We really need btrfs_abort_transaction(), or when we exit abnormally 
we will get a lot of backtrace/warning on uncommitted transaction.

Thanks,
Qu

>
>> +		if (ret < 0)
>> +			return ret;
>> +		current = bg_cache->key.objectid + bg_cache->key.offset;
>> +	}
>> +
>> +	/* Don't forget to set cache_generation to -1 */
>> +	trans = btrfs_start_transaction(fs_info->tree_root, 0);
>> +	if (IS_ERR(trans)) {
>> +		error("failed to update super block cache generation");
>> +		return PTR_ERR(trans);
>> +	}
>> +	btrfs_set_super_cache_generation(fs_info->super_copy, (u64)-1);
>> +	btrfs_commit_transaction(trans, fs_info->tree_root);
>> +
>> +	return ret;
>> +}
>> +
>>  const char * const cmd_check_usage[] = {
>>  	"btrfs check [options] <device>",
>>  	"Check structural integrity of a filesystem (unmounted).",
>> @@ -11233,6 +11263,9 @@ const char * const cmd_check_usage[] = {
>>  	"-r|--tree-root <bytenr>     use the given bytenr for the tree root",
>>  	"--chunk-root <bytenr>       use the given bytenr for the chunk tree root",
>>  	"-p|--progress               indicate progress",
>> +	"--clear-space-cache v1|v2   clear space cache for v1(file based) or ",
>> +	"                            v2(tree based).",
>> +	"                            Only support v1 yet",
>>  	NULL
>>  };
>>
>> @@ -11250,6 +11283,7 @@ int cmd_check(int argc, char **argv)
>>  	u64 num;
>>  	int init_csum_tree = 0;
>>  	int readonly = 0;
>> +	int clear_space_cache = 0;
>>  	int qgroup_report = 0;
>>  	int qgroups_repaired = 0;
>>  	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
>> @@ -11259,7 +11293,7 @@ int cmd_check(int argc, char **argv)
>>  		enum { GETOPT_VAL_REPAIR = 257, GETOPT_VAL_INIT_CSUM,
>>  			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
>>  			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
>> -			GETOPT_VAL_MODE };
>> +			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE };
>>  		static const struct option long_options[] = {
>>  			{ "super", required_argument, NULL, 's' },
>>  			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
>> @@ -11279,6 +11313,8 @@ int cmd_check(int argc, char **argv)
>>  			{ "progress", no_argument, NULL, 'p' },
>>  			{ "mode", required_argument, NULL,
>>  				GETOPT_VAL_MODE },
>> +			{ "clear-space-cache", required_argument, NULL,
>> +				GETOPT_VAL_CLEAR_SPACE_CACHE},
>>  			{ NULL, 0, NULL, 0}
>>  		};
>>
>> @@ -11350,6 +11386,14 @@ int cmd_check(int argc, char **argv)
>>  					exit(1);
>>  				}
>>  				break;
>> +			case GETOPT_VAL_CLEAR_SPACE_CACHE:
>> +				if (strcmp(optarg, "v1")) {
>> +					error("only support to clear 'v1' space cache");
>> +					exit(1);
>> +				}
>> +				clear_space_cache = 1;
>> +				ctree_flags |= OPEN_CTREE_WRITES;
>> +				break;
>>  		}
>>  	}
>>
>> @@ -11401,6 +11445,23 @@ int cmd_check(int argc, char **argv)
>>
>>  	global_info = info;
>>  	root = info->fs_root;
>> +	if (clear_space_cache) {
>> +		if (btrfs_fs_compat_ro(info,
>> +				BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
>> +			error("doesn't support free space cache v2(tree based) yet");
>> +			ret = 1;
>> +			goto close_out;
>> +		}
>> +		printf("Clearing free space cache\n");
>> +		ret = clear_free_space_cache(info);
>> +		if (ret) {
>> +			error("failed to clear free space cache");
>> +			ret = 1;
>> +		} else {
>> +			printf("Free space cache cleared\n");
>> +		}
>> +		goto close_out;
>> +	}
>>
>>  	/*
>>  	 * repair mode will force us to commit transaction which
>> diff --git a/free-space-cache.c b/free-space-cache.c
>> index 1919d90..88a1013 100644
>> --- a/free-space-cache.c
>> +++ b/free-space-cache.c
>> @@ -25,6 +25,7 @@
>>  #include "crc32c.h"
>>  #include "bitops.h"
>>  #include "internal.h"
>> +#include "utils.h"
>>
>>  /*
>>   * Kernel always uses PAGE_CACHE_SIZE for sectorsize, but we don't have
>> @@ -877,3 +878,126 @@ next:
>>  		prev = e;
>>  	}
>>  }
>> +
>> +int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
>> +				 struct btrfs_block_group_cache *bg)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	struct btrfs_root *tree_root = fs_info->tree_root;
>> +	struct btrfs_path path;
>> +	struct btrfs_key key;
>> +	struct btrfs_disk_key location;
>> +	struct btrfs_free_space_header *sc_header;
>> +	struct extent_buffer *node;
>> +	u64 ino;
>> +	int slot;
>> +	int ret;
>> +
>> +	trans = btrfs_start_transaction(tree_root, 1);
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +
>> +	btrfs_init_path(&path);
>> +
>> +	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
>> +	key.type = 0;
>> +	key.offset = bg->key.objectid;
>> +
>> +	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
>> +	if (ret > 0) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	node = path.nodes[0];
>> +	slot = path.slots[0];
>> +	sc_header = btrfs_item_ptr(node, slot, struct btrfs_free_space_header);
>> +	btrfs_free_space_key(node, sc_header, &location);
>> +	ino = location.objectid;
>> +
>> +	/* Delete the free space header, as we have the ino to continue */
>> +	ret = btrfs_del_item(trans, tree_root, &path);
>> +	if (ret < 0) {
>> +		error("failed to remove free space header for block group %llu",
>> +		      bg->key.objectid);
>> +		goto out;
>> +	}
>> +	btrfs_release_path(&path);
>> +
>> +	/* Iterate from the end of the free space cache inode */
>> +	key.objectid = ino;
>> +	key.type = BTRFS_EXTENT_DATA_KEY;
>> +	key.offset = (u64)-1;
>> +	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
>> +	if (ret < 0) {
>> +		error("failed to locate free space cache extent for block group %llu",
>> +		      bg->key.objectid);
>> +		goto out;
>> +	}
>> +	while (1) {
>> +		struct btrfs_file_extent_item *fi;
>> +		u64 disk_bytenr;
>> +		u64 disk_num_bytes;
>> +
>> +
>> +		ret = btrfs_previous_item(tree_root, &path, ino,
>> +					  BTRFS_EXTENT_DATA_KEY);
>> +		if (ret > 0) {
>> +			ret = 0;
>> +			break;
>> +		}
>> +		if (ret < 0) {
>> +			error("failed to locate free space cache extent for block group %llu",
>> +			      bg->key.objectid);
>> +			goto out;
>> +		}
>> +		node = path.nodes[0];
>> +		slot = path.slots[0];
>> +		btrfs_item_key_to_cpu(node, &key, slot);
>> +		fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
>> +		disk_bytenr = btrfs_file_extent_disk_bytenr(node, fi);
>> +		disk_num_bytes = btrfs_file_extent_disk_num_bytes(node, fi);
>> +
>> +		ret = btrfs_free_extent(trans, tree_root, disk_bytenr,
>> +					disk_num_bytes, 0, tree_root->objectid,
>> +					ino, key.offset);
>> +		if (ret < 0) {
>> +			error("failed to remove backref for disk bytenr %llu",
>> +			      disk_bytenr);
>> +			goto out;
>> +		}
>> +		ret = btrfs_del_item(trans, tree_root, &path);
>> +		if (ret < 0) {
>> +			error("failed to remove free space extent data for ino %llu offset %llu",
>> +			      ino, key.offset);
>> +			goto out;
>> +		}
>> +	}
>> +	btrfs_release_path(&path);
>> +
>> +	/* Now delete free space cache inode item */
>> +	key.objectid = ino;
>> +	key.type = BTRFS_INODE_ITEM_KEY;
>> +	key.offset = 0;
>> +
>> +	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
>> +	if (ret > 0)
>> +		warning("free space inode %llu not found, ignore", ino);
>> +	if (ret < 0) {
>> +		error("failed to locate free space cache inode %llu for block group %llu",
>> +		      ino, bg->key.objectid);
>> +		goto out;
>> +	}
>> +	ret = btrfs_del_item(trans, tree_root, &path);
>> +	if (ret < 0) {
>> +		error("failed to delete free space cache inode %llu for block group %llu",
>> +		      ino, bg->key.objectid);
>> +	}
>> +out:
>> +	btrfs_release_path(&path);
>> +	if (!ret)
>> +		btrfs_commit_transaction(trans, tree_root);
>> +	return ret;
>> +}
>
>


