Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62236 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934198AbdIZA2m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 20:28:42 -0400
Subject: Re: [PATCH v2 3/4] btrfs: Add sanity check for EXTENT_DATA when
 reading out leaf
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
 <20170823075759.13982-4-quwenruo.btrfs@gmx.com>
 <20170925154503.GL31640@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d90b5bd1-8b8f-4403-6d46-a817d935d63d@gmx.com>
Date: Tue, 26 Sep 2017 08:28:25 +0800
MIME-Version: 1.0
In-Reply-To: <20170925154503.GL31640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月25日 23:45, David Sterba wrote:
> On Wed, Aug 23, 2017 at 04:57:58PM +0900, Qu Wenruo wrote:
>> Add extra checker for item with EXTENT_DATA type.
>> This checks the following thing:
>> 0) Key offset
>>     All key offset must be aligned to sectorsize.
>>     Inline extent must have 0 for key offset.
>>
>> 1) Item size
>>     Plain text inline file extent size must match item size.
> 
> 'plain text' seems to be a bit misleading, I don't think we've ever
> referred to uncompressed extent as such, although it makes some sense. I
> think 'uncompressed' would work too.

I'll use 'uncompressed' instead.

> 
>>     (compressed inline file extent has no info about its on-disk size)
>>     Regular/preallocated file extent size must be a fixed value.
>>
>> 2) Every member of regular file extent item
>>     Including alignment for bytenr and offset, possible value for
>>     compression/encryption/type.
>>
>> 3) Type/compression/encode must be one of the valid values.
>>
>> This should be the most comprehensive and restrict check in the context
>> of btrfs_item for EXTENT_DATA.
>>
>> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> ---
>>   fs/btrfs/disk-io.c              | 108 ++++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/btrfs_tree.h |   1 +
>>   2 files changed, 109 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index e034d08bd036..b92296c6a698 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -549,6 +549,103 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
>>   		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
>>   		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
>>   
>> +static int check_extent_data_item(struct btrfs_root *root,
>> +				  struct extent_buffer *leaf,
>> +				  struct btrfs_key *key, int slot)
>> +{
>> +	struct btrfs_file_extent_item *fi;
>> +	u32 sectorsize = root->fs_info->sectorsize;
>> +	u32 item_size = btrfs_item_size_nr(leaf, slot);
>> +
>> +	if (!IS_ALIGNED(key->offset, sectorsize)) {
>> +		CORRUPT("unaligned key offset for file extent",
> 
> The CORRUPT macro does not print any details beyond what it gets from
> the parameters, so here we'd like to know which extent it is and what's
> the size. The sectorsize can be found elsewhere so it does not need
> to be printed.

Did you mean despite bytenr of the tree block and root objectid, we 
should output more info about the key?

By "size" did you mean the disk_num_bytes of the extent?

But since the offset is already invalid, I don't think we can trust any 
data from that structure, so what we can output is only about the key.

I can enhance the output to output the key, but I'm afraid I can't 
output anything more than that.

> 
>> +			leaf, root, slot);
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>> +
>> +	if (btrfs_file_extent_type(leaf, fi) >= BTRFS_FILE_EXTENT_LAST_TYPE) {
>> +		CORRUPT("invalid file extent type", leaf, root, slot);
> 
> "invalid file extent type %d"
> 
> and actually, we could add some item-specific helpers to report the
> corruption so if it's for an extent, print the generic extent
> information, plus an additional information what exactly was wrong.

For additional info I'm completely fine.

But I'm not sure if it's good to output more info about the item.

The biggest problem is, when any member of the item can't pass 
validation checker, we can't trust the whole item.
So the item-specific info may not contain meaningful info.

> 
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	/*
>> +	 * Support for new compression/encrption must introduce incompat flag,
>> +	 * and must be caught in open_ctree().
>> +	 */
>> +	if (btrfs_file_extent_compression(leaf, fi) >= BTRFS_COMPRESS_LAST) {
>> +		CORRUPT("invalid file extent compression", leaf, root, slot);
>> +		return -EUCLEAN;
>> +	}
>> +	if (btrfs_file_extent_encryption(leaf, fi)) {
>> +		CORRUPT("invalid file extent encryption", leaf, root, slot);
>> +		return -EUCLEAN;
>> +	}
>> +	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
>> +		/* Inline extent must have 0 as key offset */
>> +		if (key->offset) {
>> +			CORRUPT("inline extent has non-zero key offset",
>> +				leaf, root, slot);
>> +			return -EUCLEAN;
>> +		}
>> +
>> +		/* Compressed inline extent has no on-disk size, skip it */
>> +		if (btrfs_file_extent_compression(leaf, fi) !=
>> +		    BTRFS_COMPRESS_NONE)
>> +			return 0;
>> +
>> +		/* Plaintext inline extent size must match item size */
>> +		if (item_size != BTRFS_FILE_EXTENT_INLINE_DATA_START +
>> +		    btrfs_file_extent_ram_bytes(leaf, fi)) {
>> +			CORRUPT("plaintext inline extent has invalid size",
>> +				leaf, root, slot);
>> +			return -EUCLEAN;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +
>> +	/* regular or preallocated extent has fixed item size */
>> +	if (item_size != sizeof(*fi)) {
>> +		CORRUPT(
>> +		"regluar or preallocated extent data item size is invalid",
>> +			leaf, root, slot);
>> +		return -EUCLEAN;
>> +	}
>> +	if (!IS_ALIGNED(btrfs_file_extent_ram_bytes(leaf, fi), sectorsize) ||
> 
> Is this condition right? I think I've seen random numbers of ram_bytes
> in the output of dump-tree so I wonder if this applies only to some
> extents where the condition holds.

Please note that, this condition is only for regular/prealloc file 
extent items, so ram_bytes should be sectorsize aligned.
(Inlined extent is handled lines before and it will always end with a 
return)

> 
>> +	    !IS_ALIGNED(btrfs_file_extent_disk_bytenr(leaf, fi), sectorsize) ||
>> +	    !IS_ALIGNED(btrfs_file_extent_disk_num_bytes(leaf, fi),
>> +			sectorsize) ||
>> +	    !IS_ALIGNED(btrfs_file_extent_offset(leaf, fi), sectorsize) ||
>> +	    !IS_ALIGNED(btrfs_file_extent_num_bytes(leaf, fi), sectorsize)) {
>> +		CORRUPT(
>> +		"regular or preallocated extent data item has unaligned value",
>> +			leaf, root, slot);
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int check_leaf_item(struct btrfs_root *root,
>> +			   struct extent_buffer *leaf,
>> +			   struct btrfs_key *key, int slot)
>> +{
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * Considering how overcrowded the code will be inside the switch,
>> +	 * complex verification is better to moved its own function.
>> +	 */
>> +	switch (key->type) {
>> +	case BTRFS_EXTENT_DATA_KEY:
>> +		ret = check_extent_data_item(root, leaf, key, slot);
>> +		break;
>> +	}
>> +	return ret;
>> +}
>> +
>>   static noinline int check_leaf(struct btrfs_root *root,
>>   			       struct extent_buffer *leaf)
>>   {
>> @@ -605,9 +702,13 @@ static noinline int check_leaf(struct btrfs_root *root,
>>   	 * 1) key order
>>   	 * 2) item offset and size
>>   	 *    No overlap, no hole, all inside the leaf.
>> +	 * 3) item content
>> +	 *    If possible, do comprehensive sanity check.
>> +	 *    NOTE: All check must only rely on the item data itself.
>>   	 */
>>   	for (slot = 0; slot < nritems; slot++) {
>>   		u32 item_end_expected;
>> +		int ret;
>>   
>>   		btrfs_item_key_to_cpu(leaf, &key, slot);
>>   
>> @@ -650,6 +751,13 @@ static noinline int check_leaf(struct btrfs_root *root,
>>   			return -EUCLEAN;
>>   		}
>>   
>> +		/*
>> +		 * Check if the item size and content meets other limitation
>> +		 */
>> +		ret = check_leaf_item(root, leaf, &key, slot);
>> +		if (ret < 0)
>> +			return ret;
>> +
>>   		prev_key.objectid = key.objectid;
>>   		prev_key.type = key.type;
>>   		prev_key.offset = key.offset;
>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
>> index 10689e1fdf11..3aadbb74a024 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -732,6 +732,7 @@ struct btrfs_balance_item {
>>   #define BTRFS_FILE_EXTENT_INLINE 0
>>   #define BTRFS_FILE_EXTENT_REG 1
>>   #define BTRFS_FILE_EXTENT_PREALLOC 2
>> +#define BTRFS_FILE_EXTENT_LAST_TYPE	3
> 
> This can be confusing as the LAST is one more than the last valid one.
> And the BTRFS_COMPRESS_LAST got removed already so I don't want to
> re-introduce it in another way.

What about using the same method of btrfs_csum_sizes[]?

A new array called btrfs_file_extent_types[] and check the size of it 
seems good for me.

Thanks for the review,
Qu

> 
> I'd like to merge the series now, as the error message tuning can come
> later and we can start testing the sanity checks now. So I'm going to
> fix only the minor things and then please address the comments that may
> need more changes like adding the error reporting helpers etc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
