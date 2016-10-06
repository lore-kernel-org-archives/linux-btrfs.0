Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29601 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752521AbcJFHHe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Oct 2016 03:07:34 -0400
Subject: Re: [PATCH v3.1 2/3] btrfs: relocation: Fix leaking qgroups numbers
 on data extents
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, <linux-btrfs@vger.kernel.org>
References: <20160815023652.5348-1-quwenruo@cn.fujitsu.com>
 <20160815023652.5348-3-quwenruo@cn.fujitsu.com>
 <aebd67df-3249-2f31-41cf-6d356975d061@suse.de>
CC: <fdmanana@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a5eea45c-88f9-e9f6-e1c5-4e3ea73e24d5@cn.fujitsu.com>
Date: Thu, 6 Oct 2016 15:06:48 +0800
MIME-Version: 1.0
In-Reply-To: <aebd67df-3249-2f31-41cf-6d356975d061@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/05/2016 09:53 AM, Goldwyn Rodrigues wrote:
>
>
> On 08/14/2016 09:36 PM, Qu Wenruo wrote:
>> This patch fixes a REGRESSION introduced in 4.2, caused by the big quota
>> rework.
>>
>> When balancing data extents, qgroup will leak all its numbers for
>> relocated data extents.
>>
>> The relocation is done in the following steps for data extents:
>> 1) Create data reloc tree and inode
>> 2) Copy all data extents to data reloc tree
>>    And commit transaction
>> 3) Create tree reloc tree(special snapshot) for any related subvolumes
>> 4) Replace file extent in tree reloc tree with new extents in data reloc
>>    tree
>>    And commit transaction
>> 5) Merge tree reloc tree with original fs, by swapping tree blocks
>>
>> For 1)~4), since tree reloc tree and data reloc tree doesn't count to
>> qgroup, everything is OK.
>>
>> But for 5), the swapping of tree blocks will only info qgroup to track
>> metadata extents.
>>
>> If metadata extents contain file extents, qgroup number for file extents
>> will get lost, leading to corrupted qgroup accounting.
>>
>> The fix is, before commit transaction of step 5), manually info qgroup to
>> track all file extents in data reloc tree.
>> Since at commit transaction time, the tree swapping is done, and qgroup
>> will account these data extents correctly.
>>
>> Cc: Mark Fasheh <mfasheh@suse.de>
>> Reported-by: Mark Fasheh <mfasheh@suse.de>
>> Reported-by: Filipe Manana <fdmanana@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  fs/btrfs/relocation.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 103 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index b26a5ae..27480ef 100644
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
>> @@ -3916,6 +3917,90 @@ int prepare_to_relocate(struct reloc_control *rc)
>>  	return 0;
>>  }
>>
>> +/*
>> + * Qgroup fixer for data chunk relocation.
>> + * The data relocation is done in the following steps
>> + * 1) Copy data extents into data reloc tree
>> + * 2) Create tree reloc tree(special snapshot) for related subvolumes
>> + * 3) Modify file extents in tree reloc tree
>> + * 4) Merge tree reloc tree with original fs tree, by swapping tree blocks
>> + *
>> + * The problem is, data and tree reloc tree are not accounted to qgroup,
>> + * and 4) will only info qgroup to track tree blocks change, not file extents
>> + * in the tree blocks.
>> + *
>> + * The good news is, related data extents are all in data reloc tree, so we
>> + * only need to info qgroup to track all file extents in data reloc tree
>> + * before commit trans.
>> + */
>> +static int qgroup_fix_relocated_data_extents(struct btrfs_trans_handle *trans,
>> +					     struct reloc_control *rc)
>> +{
>> +	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
>> +	struct inode *inode = rc->data_inode;
>> +	struct btrfs_root *data_reloc_root = BTRFS_I(inode)->root;
>> +	struct btrfs_path *path;
>> +	struct btrfs_key key;
>> +	int ret = 0;
>> +
>> +	if (!fs_info->quota_enabled)
>> +		return 0;
>> +
>> +	/*
>> +	 * Only for stage where we update data pointers the qgroup fix is
>> +	 * valid.
>> +	 * For MOVING_DATA stage, we will miss the timing of swapping tree
>> +	 * blocks, and won't fix it.
>> +	 */
>> +	if (!(rc->stage == UPDATE_DATA_PTRS && rc->extents_found))
>> +		return 0;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +	key.objectid = btrfs_ino(inode);
>> +	key.type = BTRFS_EXTENT_DATA_KEY;
>> +	key.offset = 0;
>> +
>> +	ret = btrfs_search_slot(NULL, data_reloc_root, &key, path, 0, 0);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	lock_extent(&BTRFS_I(inode)->io_tree, 0, (u64)-1);
>> +	while (1) {
>> +		struct btrfs_file_extent_item *fi;
>> +
>> +		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +		if (key.objectid > btrfs_ino(inode))
>> +			break;
>> +		if (key.type != BTRFS_EXTENT_DATA_KEY)
>> +			goto next;
>> +		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +				    struct btrfs_file_extent_item);
>> +		if (btrfs_file_extent_type(path->nodes[0], fi) !=
>> +				BTRFS_FILE_EXTENT_REG)
>> +			goto next;
>> +		ret = btrfs_qgroup_insert_dirty_extent(trans, fs_info,
>> +			btrfs_file_extent_disk_bytenr(path->nodes[0], fi),
>> +			btrfs_file_extent_disk_num_bytes(path->nodes[0], fi),
>> +			GFP_NOFS);
>> +		if (ret < 0)
>> +			break;
>> +next:
>> +		ret = btrfs_next_item(data_reloc_root, path);
>> +		if (ret < 0)
>> +			break;
>> +		if (ret > 0) {
>> +			ret = 0;
>> +			break;
>> +		}
>> +	}
>> +	unlock_extent(&BTRFS_I(inode)->io_tree, 0 , (u64)-1);
>> +out:
>> +	btrfs_free_path(path);
>> +	return ret;
>> +}
>> +
>>  static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
>>  {
>>  	struct rb_root blocks = RB_ROOT;
>> @@ -4102,10 +4187,16 @@ restart:
>>
>>  	/* get rid of pinned extents */
>>  	trans = btrfs_join_transaction(rc->extent_root);
>> -	if (IS_ERR(trans))
>> +	if (IS_ERR(trans)) {
>>  		err = PTR_ERR(trans);
>> -	else
>> -		btrfs_commit_transaction(trans, rc->extent_root);
>> +		goto out_free;
>> +	}
>> +	err = qgroup_fix_relocated_data_extents(trans, rc);
>> +	if (err < 0) {
>> +		btrfs_abort_transaction(trans, err);
>> +		goto out_free;
>> +	}
>> +	btrfs_commit_transaction(trans, rc->extent_root);
>>  out_free:
>>  	btrfs_free_block_rsv(rc->extent_root, rc->block_rsv);
>>  	btrfs_free_path(path);
>> @@ -4468,10 +4559,16 @@ int btrfs_recover_relocation(struct btrfs_root *root)
>>  	unset_reloc_control(rc);
>>
>>  	trans = btrfs_join_transaction(rc->extent_root);
>> -	if (IS_ERR(trans))
>> +	if (IS_ERR(trans)) {
>>  		err = PTR_ERR(trans);
>> -	else
>> -		err = btrfs_commit_transaction(trans, rc->extent_root);
>> +		goto out_free;
>> +	}
>> +	err = qgroup_fix_relocated_data_extents(trans, rc);
>> +	if (err < 0) {
>> +		btrfs_abort_transaction(trans, err);
>> +		goto out_free;
>> +	}
>> +	err = btrfs_commit_transaction(trans, rc->extent_root);
>>  out_free:
>>  	kfree(rc);
>>  out:
>
> Hi Qu,
>
> This function call to qgroup_fix_relocated_data_extents()
> in btrfs_recover_relocation() fails (null pointer reference)
> because rc->data_inode is null.

Right, since rc->data_inode is only initialized in 
btrfs_relocate_block_group().
Here we will access NULL pointer and cause problem.

Would you please provide some images to trigger the NULL pointer error?

I created several images to test the btrfs_recover_relocation() routine 
using the method I mentioned below, but they didn't trigger NULL pointer 
as they didn't meet (rc->stage == UPDATE_DATA_PTRS and 
rc->extents_found) check.

>
> On reading the code it seems we are not moving data around. Do we really
> to call qgroup_fix_relocated_data_extents() in btrfs_recover_relocation()?

Normally, we need to call qgroup_fix_relocated_data_extents() after 
calling merge_reloc_roots().

If not, if merge_reloc_roots() swapped tree blocks containing data 
extents, we will leak data space of that block group again.

Since the problem is not about moving(copying) data, but swapping tree 
blocks, which changed owner of tree blocks and data extents inside it.

In fact I just created such image, which can leads to corrupted qgroup 
since we can't re-dirty extents at btrfs_recover_relocation().

(And found a btrfsck bug which leads to segfault checking the image)

You can download the image and try.
https://drive.google.com/file/d/0BxpkL3ehzX3pV1E3VkpfbmJrWmc/view?usp=sharing


>
> Without the last hunk, I tried creating a btrfs device by crashing the
> system in the middle of a btrfs balance and tried checking for qgroup
> inconsistencies, but could not find any. However, I am not sure if my
> testcase is complete, though I tried it multiple times.

It's a little hard to create such image by just crashing the system 
while balance.
Instead, we need to grab the on-disk data at special time point.

Normally I'd just add 30s sleep and pr_info() before the final 
btrfs_commit_transaction() in relocate_block_group(), just like patch below:

------
@@ -4207,6 +4210,11 @@ restart:
                         err = ret;
                 goto out_free;
         }
+       if (rc->stage == UPDATE_DATA_PTRS && rc->extents_found) {
+               pr_info("sleep 30s\n");
+               msleep(30 * 1000);
+               pr_info("sleep done\n");
+       }
         btrfs_commit_transaction(trans, rc->extent_root);
  out_free:
         btrfs_free_block_rsv(rc->extent_root, rc->block_rsv);
------

When the sleep happens, dd the image to some other place. And mount 
it(original disk must be removed).


Another trick is, to bump tree levels to 2, which can expose quite a lot 
of new bugs.
I use the following small script with above kernel hack to dump the image:
------
#!/bin/bash

dev=/dev/vdb5
mnt=/mnt/test/
trace_dir=/sys/kernel/debug/tracing
fsstress=/home/adam/xfstests/ltp/fsstress

create_files () {
	prefix=$1
	size=$2
	nr=$3
	dir=$4

	for i in $(seq $nr); do
		filename=$(printf "%s_%05d" "$prefix" $i)
		xfs_io -f -c "pwrite 0 $size" $dir/$filename > /dev/null
	done
}

umount $mnt &> /dev/null
mkfs.btrfs $dev -f -b 512M -n 4k
mount -o nospace_cache $dev $mnt


create_files inline 2K 1000 $mnt
create_files large 4M 5 $mnt

sync

btrfs quota enable $mnt
btrfs quota rescan -w $mnt
sync
btrfs qgroup show -prce --raw $mnt

btrfs balance start -d $mnt # dump the image during the sleep window
sync
btrfs qgroup show -prce --raw $mnt

------

Unfortunately, I only tested my old patch with tree level 0 images, 
which doesn't exposed the qgroup leak in btrfs_recover_relocation().
(In that case, tree reloc tree are not modified at all, all data extents 
are just pointing to old extents)

I'll create a fix which doesn't use data_inode, but manually searching 
data reloc tree to fix the problem.

Thanks,
Qu
>
>


