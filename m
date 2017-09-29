Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51195 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbdI2GJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 02:09:04 -0400
Subject: Re: [PATCH v2 2/5] btrfs: tree-checker: Enhance btrfs_check_node
 output
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170929013702.17814-1-quwenruo.btrfs@gmx.com>
 <20170929013702.17814-3-quwenruo.btrfs@gmx.com>
 <8f388764-785e-0fd0-9b70-0bcfcbcb92ef@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0fa914fe-c08c-5fac-09e8-b69bbe1da03c@gmx.com>
Date: Fri, 29 Sep 2017 14:08:18 +0800
MIME-Version: 1.0
In-Reply-To: <8f388764-785e-0fd0-9b70-0bcfcbcb92ef@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月29日 14:05, Nikolay Borisov wrote:
> 
> 
> On 29.09.2017 04:36, Qu Wenruo wrote:
>> Use inline function to replace macro since we don't need
>> stringification.
>> (Macro still exist until all caller get updated)
>>
>> And add more info about the error.
>>
>> For nr_items error, report if it's too large or too small, and output
>> valid value range.
>>
>> For blk pointer, added a new alignment checker.
>>
>> For key order, also output the next key to make the problem more
>> obvious.
>>
>> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> ---
>>   fs/btrfs/tree-checker.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 61 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 301243a69dea..a51f2503acc4 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -37,6 +37,48 @@
>>   		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
>>   		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
>>   
>> +/*
>> + * Error message should follow the format below:
>> + * corrupt <type>: <identifier>, <reason>[, <bad_value>]
>> + *
>> + * @type:	Either leaf or node
>> + * @identifier:	The necessary info to locate the leaf/node.
>> + * 		It's recommened to decode key.objecitd/offset if it's
>> + * 		meaningful.
>> + * @reason:	What's wrong
>> + * @bad_value:	Optional, it's recommened to output bad value and its
>> + *		expected value (range).
>> + *
>> + * Since comma is used to separate the components, only SPACE is allowed
>> + * inside each component.
>> + */
>> +
>> +/*
>> + * Append the generic "corrupt leaf/node root=%llu block=%llu slot=%d: " to
>> + * @fmt.
>> + * Allowing user to customize their output.
>> + */
>> +__printf(4, 5)
>> +static void generic_err(const struct btrfs_root *root,
>> +			const struct extent_buffer *eb,
>> +			int slot, const char *fmt, ...)
>> +{
>> +	struct va_format vaf;
>> +	va_list args;
>> +
>> +	va_start(args, fmt);
>> +
>> +	vaf.fmt = fmt;
>> +	vaf.va = &args;
>> +
>> +	btrfs_crit(root->fs_info,
>> +		"corrupt %s: root=%llu block=%llu slot=%d, %pV",
>> +		btrfs_header_level(eb) == 0 ? "leaf" : "node",
>> +		root->objectid, btrfs_header_bytenr(eb), slot,
>> +		&vaf);
>> +	va_end(args);
>> +}
>> +
>>   static int check_extent_data_item(struct btrfs_root *root,
>>   				  struct extent_buffer *leaf,
>>   				  struct btrfs_key *key, int slot)
>> @@ -282,8 +324,10 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
>>   
>>   	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(root->fs_info)) {
>>   		btrfs_crit(root->fs_info,
>> -			   "corrupt node: block %llu root %llu nritems %lu",
>> -			   node->start, root->objectid, nr);
>> +			"corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%u]",
>> +			   root->objectid, node->start,
>> +			   nr == 0 ? "small" : "large", nr,
>> +			   BTRFS_NODEPTRS_PER_BLOCK(root->fs_info));
>>   		return -EIO;
> 
> This is separate from this patch but :
> 
> Why not EUCLEAN, could we get this error because of corrupted data and
> not necessarily EIO ? Your other patches consistently use EUCLEAN ?

Just forgot that.

Old code I didn't modify, but since it's moved to new place, EUCLEAN 
makes sense.

I'll update the patchset (if there is any).

Thanks for pointing this out,
Qu

> 
>>   	}
>>   
>> @@ -293,13 +337,26 @@ int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
>>   		btrfs_node_key_to_cpu(node, &next_key, slot + 1);
>>   
>>   		if (!bytenr) {
>> -			CORRUPT("invalid item slot", node, root, slot);
>> +			generic_err(root, node, slot,
>> +				"invalid node pointer, have %llu shouldn't be 0",
>> +				bytenr);
> 
> nit: Perhaps just say "Invalid null node pointer", if we trigger this
> assert it means bytenr is 0 so I see no reason why we should be doing
> any special formatting. It's not a big deal so might not be worth it a
> resend unless there are other comments.
> 
>>   			ret = -EIO;
> 
> Ditto w.r.t EIO  ?
> 
>>   			goto out;
>>   		}
>> +		if (!IS_ALIGNED(bytenr, root->fs_info->sectorsize)) {
>> +			generic_err(root, node, slot,
>> +				"unaligned pointer, have %llu should be aligned to %u",
>> +				bytenr, root->fs_info->sectorsize);
>> +			ret = -EUCLEAN;
>> +			goto out;
>> +		}
>>   
>>   		if (btrfs_comp_cpu_keys(&key, &next_key) >= 0) {
>> -			CORRUPT("bad key order", node, root, slot);
>> +			generic_err(root, node, slot,
>> +				"bad key order, current key (%llu %u %llu) next key (%llu %u %llu)",
>> +				key.objectid, key.type, key.offset,
>> +				next_key.objectid, next_key.type,
>> +				next_key.offset);
>>   			ret = -EIO;
> 
> Ditto w.r.t return code?
> 
>>   			goto out;
>>   		}
>>
