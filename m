Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47811 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750722AbeASGmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 01:42:07 -0500
Subject: Re: [PATCH 08/16] btrfs-progs: check: Move count_csum_range function
 to check/common.c
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20180119053731.10795-1-wqu@suse.com>
 <20180119053731.10795-9-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <fbef0de0-950a-012d-01d2-1710d47a7893@cn.fujitsu.com>
Date: Fri, 19 Jan 2018 14:46:38 +0800
MIME-Version: 1.0
In-Reply-To: <20180119053731.10795-9-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 01/19/2018 01:37 PM, Qu Wenruo wrote:
> Despite of moving it to check/common.c, also:
> 
> 1) Add extra comment of the function
> 2) Change @root paramter to @fs_info

'paramter' may be misspelled - perhaps 'parameter'?

Thanks,
Su
>     Since @root is never used, csum_root is picked from fs_info anyway.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   Makefile       |   2 +-
>   check/common.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   check/common.h |   3 ++
>   check/main.c   |  77 ++-----------------------------------------
>   4 files changed, 108 insertions(+), 75 deletions(-)
>   create mode 100644 check/common.c
> 
> diff --git a/Makefile b/Makefile
> index c4e2dc5b68a9..a00a982a18df 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -113,7 +113,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>   	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
>   	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
>   	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
> -	       mkfs/common.o
> +	       mkfs/common.o check/common.o
>   libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
>   		   kernel-lib/crc32c.o messages.o \
>   		   uuid-tree.o utils-lib.o rbtree-utils.o
> diff --git a/check/common.c b/check/common.c
> new file mode 100644
> index 000000000000..ed4f2a40bac2
> --- /dev/null
> +++ b/check/common.c
> @@ -0,0 +1,101 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#include "ctree.h"
> +#include "internal.h"
> +#include "check/common.h"
> +
> +/*
> + * Search in csum tree to find how many bytes of range [@start, @start + @len)
> + * has the corresponding csum item.
> + *
> + * @start:	range start
> + * @len:	range length
> + * @found:	return value of found csum bytes
> + *		unit is BYTE.
> + */
> +int count_csum_range(struct btrfs_fs_info *fs_info, u64 start,
> +		     u64 len, u64 *found)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct extent_buffer *leaf;
> +	int ret;
> +	size_t size;
> +	*found = 0;
> +	u64 csum_end;
> +	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> +
> +	btrfs_init_path(&path);
> +
> +	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> +	key.offset = start;
> +	key.type = BTRFS_EXTENT_CSUM_KEY;
> +
> +	ret = btrfs_search_slot(NULL, fs_info->csum_root,
> +				&key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0 && path.slots[0] > 0) {
> +		leaf = path.nodes[0];
> +		btrfs_item_key_to_cpu(leaf, &key, path.slots[0] - 1);
> +		if (key.objectid == BTRFS_EXTENT_CSUM_OBJECTID &&
> +		    key.type == BTRFS_EXTENT_CSUM_KEY)
> +			path.slots[0]--;
> +	}
> +
> +	while (len > 0) {
> +		leaf = path.nodes[0];
> +		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
> +			ret = btrfs_next_leaf(fs_info->csum_root, &path);
> +			if (ret > 0)
> +				break;
> +			else if (ret < 0)
> +				goto out;
> +			leaf = path.nodes[0];
> +		}
> +
> +		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
> +		if (key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
> +		    key.type != BTRFS_EXTENT_CSUM_KEY)
> +			break;
> +
> +		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
> +		if (key.offset >= start + len)
> +			break;
> +
> +		if (key.offset > start)
> +			start = key.offset;
> +
> +		size = btrfs_item_size_nr(leaf, path.slots[0]);
> +		csum_end = key.offset + (size / csum_size) *
> +			   fs_info->sectorsize;
> +		if (csum_end > start) {
> +			size = min(csum_end - start, len);
> +			len -= size;
> +			start += size;
> +			*found += size;
> +		}
> +
> +		path.slots[0]++;
> +	}
> +out:
> +	btrfs_release_path(&path);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> diff --git a/check/common.h b/check/common.h
> index 77a0ab54166f..cd64798f4804 100644
> --- a/check/common.h
> +++ b/check/common.h
> @@ -80,4 +80,7 @@ static inline int fs_root_objectid(u64 objectid)
>   	return is_fstree(objectid);
>   }
>   
> +int count_csum_range(struct btrfs_fs_info *fs_info, u64 start,
> +		     u64 len, u64 *found);
> +
>   #endif
> diff --git a/check/main.c b/check/main.c
> index 9ecbac8f19c3..b891f4815d30 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1423,78 +1423,6 @@ static int process_inode_extref(struct extent_buffer *eb,
>   
>   }
>   
> -static int count_csum_range(struct btrfs_root *root, u64 start,
> -			    u64 len, u64 *found)
> -{
> -	struct btrfs_key key;
> -	struct btrfs_path path;
> -	struct extent_buffer *leaf;
> -	int ret;
> -	size_t size;
> -	*found = 0;
> -	u64 csum_end;
> -	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> -
> -	btrfs_init_path(&path);
> -
> -	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> -	key.offset = start;
> -	key.type = BTRFS_EXTENT_CSUM_KEY;
> -
> -	ret = btrfs_search_slot(NULL, root->fs_info->csum_root,
> -				&key, &path, 0, 0);
> -	if (ret < 0)
> -		goto out;
> -	if (ret > 0 && path.slots[0] > 0) {
> -		leaf = path.nodes[0];
> -		btrfs_item_key_to_cpu(leaf, &key, path.slots[0] - 1);
> -		if (key.objectid == BTRFS_EXTENT_CSUM_OBJECTID &&
> -		    key.type == BTRFS_EXTENT_CSUM_KEY)
> -			path.slots[0]--;
> -	}
> -
> -	while (len > 0) {
> -		leaf = path.nodes[0];
> -		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
> -			ret = btrfs_next_leaf(root->fs_info->csum_root, &path);
> -			if (ret > 0)
> -				break;
> -			else if (ret < 0)
> -				goto out;
> -			leaf = path.nodes[0];
> -		}
> -
> -		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
> -		if (key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
> -		    key.type != BTRFS_EXTENT_CSUM_KEY)
> -			break;
> -
> -		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
> -		if (key.offset >= start + len)
> -			break;
> -
> -		if (key.offset > start)
> -			start = key.offset;
> -
> -		size = btrfs_item_size_nr(leaf, path.slots[0]);
> -		csum_end = key.offset + (size / csum_size) *
> -			   root->fs_info->sectorsize;
> -		if (csum_end > start) {
> -			size = min(csum_end - start, len);
> -			len -= size;
> -			start += size;
> -			*found += size;
> -		}
> -
> -		path.slots[0]++;
> -	}
> -out:
> -	btrfs_release_path(&path);
> -	if (ret < 0)
> -		return ret;
> -	return 0;
> -}
> -
>   static int process_file_extent(struct btrfs_root *root,
>   				struct extent_buffer *eb,
>   				int slot, struct btrfs_key *key,
> @@ -1574,7 +1502,8 @@ static int process_file_extent(struct btrfs_root *root,
>   		else
>   			disk_bytenr += extent_offset;
>   
> -		ret = count_csum_range(root, disk_bytenr, num_bytes, &found);
> +		ret = count_csum_range(root->fs_info, disk_bytenr, num_bytes,
> +				       &found);
>   		if (ret < 0)
>   			return ret;
>   		if (extent_type == BTRFS_FILE_EXTENT_REG) {
> @@ -5508,7 +5437,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>   		search_start = disk_bytenr;
>   		search_len = disk_num_bytes;
>   	}
> -	ret = count_csum_range(root, search_start, search_len, &csum_found);
> +	ret = count_csum_range(root->fs_info, search_start, search_len, &csum_found);
>   	if (csum_found > 0 && nodatasum) {
>   		err |= ODD_CSUM_ITEM;
>   		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
> 


