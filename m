Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52615 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbcG3BGc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 21:06:32 -0400
Subject: Re: btrfs: relocation: Fix leaking qgroups numbers on data extents
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160614092622.15560-1-quwenruo@cn.fujitsu.com>
 <20160729184235.GA3535@merlin.lan>
Cc: mfasheh@suse.de, linux-btrfs@vger.kernel.org, fdmanana@gmail.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <01f5daa5-779b-954b-0d8c-1f4bd54c10fe@gmx.com>
Date: Sat, 30 Jul 2016 09:06:15 +0800
MIME-Version: 1.0
In-Reply-To: <20160729184235.GA3535@merlin.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Goldwyn,

This patch is replaced by the following patchset:
https://patchwork.kernel.org/patch/9213915/
https://patchwork.kernel.org/patch/9213913/

Would you mind testing the new patch?

Thanks,
Qu


On 07/30/2016 02:42 AM, Goldwyn Rodrigues wrote:
> On Tue, Jun 14, 2016 at 05:26:22PM +0800, Qu Wenruo wrote:
>> When balancing data extents, qgroup will leak all its numbers for
>> balanced data extents.
>>
>> The root cause is the non-standard extent reference update used in
>> balance code.
>>
>> The problem happens in the following steps:
>> (Use 4M as original data extent size, and 257 as src root objectid)
>>
>> 1) Balance create new data extents and increase its refs
>>
>> Balance will alloc new data extent and create new EXTENT_DATA in data
>> reloc tree, while its refernece is increased with 2 different
>> referencer: 257 and data reloc tree.
>>
>> While at that time, file tree is still referring to old extents.
>>
>> Extent bytenr   |    Real referencer    |     backrefs     |
>> ------------------------------------------------------------
>> New             | Data reloc            | Data reloc + 257 | << Mismatch
>> Old             | 257                   | 257              |
>>
>> Qgroup number: 4M + metadata
>>
>> 2) Commit trans before merging reloc tree
>> Then we goes to prepare_to_merge(), which will commit transacation.
>>
>> In the qgroup update codes inside commit_transaction, although backref
>> walk codes find the new data extents has 2 backref, but file tree
>> backref can't find referencer(file tree is still referring to old
>> extents), and data reloc doesn't count as file tree.
>>
>> Extent bytenr   | nr_old_roots | nr_new_roots | qgroup change |
>> --------------------------------------------------------------|
>> New             | 0            | 0            | 0             |
>> Old             | 1            | 1            | 0             |
>>
>> Qgroup number: 4M + metadata +-0 = 4M + metadata
>>
>> 3) Swap tree blocks and free old tree blocks
>> Then we goes to merge_reloc_roots(), which swaps the tree blocks
>> directly, and free the old tree blocks.
>> Freeing tree blocks will also free its data extents, this goes through
>> normal routine, and qgroup handles it well, decreasing the numbers.
>>
>> And since new data extent is not updated here (updated in step 1), so
>> qgroup won't scan new data extent.
>>
>> Extent bytenr   | nr_old_roots | nr_new_roots | qgroup change |
>> --------------------------------------------------------------|
>> New             |-No modification, doesn't go through qgroup--|
>> Old             | 1            | 0            | -4M           |
>>
>> Qgroup number: 4M + metadata -4M = metadata
>>
>> This patch will fix it by re-dirtying new extent at step 3), so backref
>> walk and qgroup can get correct result.
>>
>> And thanks to the new qgroup framework, we don't need to check whether
>> it is needed to dirty some file extents. Even some unrelated extents are
>> re-dirtied, qgroup can handle it quite well.
>>
>> So we only need to ensure we don't miss some extents.
>>
>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>> Reported-by: Filipe Manana <fdmanana@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
>
>> ---
>>  fs/btrfs/relocation.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 94 insertions(+)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 0477dca..f1d696d 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -31,6 +31,7 @@
>>  #include "async-thread.h"
>>  #include "free-space-cache.h"
>>  #include "inode-map.h"
>> +#include "qgroup.h"
>>
>>  /*
>>   * backref_node, mapping_node and tree_block start with this
>> @@ -1750,6 +1751,78 @@ int memcmp_node_keys(struct extent_buffer *eb, int slot,
>>  }
>>
>>  /*
>> + * Helper function to fixup screwed qgroups caused by increased extent ref,
>> + * which doesn't follow normal extent ref update behavior.
>> + * (Correct behavior is, increase extent ref and modify source root in
>> + *  one trans)
>> + * No better solution as long as we're doing swapping trick to do balance.
>> + */
>> +static int qgroup_redirty_data_extents(struct btrfs_trans_handle *trans,
>> +				       struct btrfs_root *root, u64 bytenr,
>> +				       u64 gen)
>> +{
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	struct extent_buffer *leaf;
>> +	struct btrfs_delayed_ref_root *delayed_refs;
>> +	int slot;
>> +	int ret = 0;
>> +
>> +	if (!fs_info->quota_enabled || !is_fstree(root->objectid))
>> +		return 0;
>> +	if (WARN_ON(!trans))
>> +		return -EINVAL;
>> +
>> +	delayed_refs = &trans->transaction->delayed_refs;
>> +
>> +	leaf = read_tree_block(root, bytenr, gen);
>> +	if (IS_ERR(leaf)) {
>> +		return PTR_ERR(leaf);
>> +	} else if (!extent_buffer_uptodate(leaf)) {
>> +		ret = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	/* We only care leaf, which may contains EXTENT_DATA */
>> +	if (btrfs_header_level(leaf) != 0)
>> +		goto out;
>> +
>> +	for (slot = 0; slot < btrfs_header_nritems(leaf); slot++) {
>> +		struct btrfs_key key;
>> +		struct btrfs_file_extent_item *fi;
>> +		struct btrfs_qgroup_extent_record *record;
>> +		struct btrfs_qgroup_extent_record *exist;
>> +
>> +		btrfs_item_key_to_cpu(leaf, &key, slot);
>> +		if (key.type != BTRFS_EXTENT_DATA_KEY)
>> +			continue;
>> +		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>> +		if (btrfs_file_extent_type(leaf, fi) ==
>> +		    BTRFS_FILE_EXTENT_INLINE ||
>> +		    btrfs_file_extent_disk_bytenr(leaf, fi) == 0)
>> +			continue;
>> +
>> +		record = kmalloc(sizeof(*record), GFP_NOFS);
>> +		if (!record) {
>> +			ret = -ENOMEM;
>> +			break;
>> +		}
>> +		record->bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
>> +		record->num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
>> +		record->old_roots = NULL;
>> +
>> +		spin_lock(&delayed_refs->lock);
>> +		exist = btrfs_qgroup_insert_dirty_extent(delayed_refs, record);
>> +		spin_unlock(&delayed_refs->lock);
>> +		if (exist)
>> +			kfree(record);
>> +	}
>> +out:
>> +	free_extent_buffer(leaf);
>> +	return ret;
>> +
>> +}
>> +
>> +/*
>>   * try to replace tree blocks in fs tree with the new blocks
>>   * in reloc tree. tree blocks haven't been modified since the
>>   * reloc tree was create can be replaced.
>> @@ -1919,7 +1992,28 @@ again:
>>  					0);
>>  		BUG_ON(ret);
>>
>> +		/*
>> +		 * Fix up the screwed up qgroups
>> +		 *
>> +		 * For tree blocks with extent data, new data extent's
>> +		 * backref is already increased with both file tree and data
>> +		 * reloc tree.
>> +		 * While trans is committed before we modify file tree.
>> +		 *
>> +		 * This makes qgroup can't account new data extents well,
>> +		 * as the file tree is still referring to old extents, not
>> +		 * new extents, backref walk will find the new extent only
>> +		 * referred by data reloc tree.
>> +		 * So qgroup is screwed up and didn't increase its ref/excl.
>> +		 *
>> +		 * Fix it up by re-dirtying qgroup record for data extents in
>> +		 * new tree blocks
>> +		 */
>> +		ret = qgroup_redirty_data_extents(trans, dest, new_bytenr,
>> +						  new_ptr_gen);
>>  		btrfs_unlock_up_safe(path, 0);
>> +		if (ret < 0)
>> +			break;
>>
>>  		ret = level;
>>  		break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
