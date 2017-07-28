Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57110 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdG1BMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 21:12:39 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: convert: properly handle reserved ranges
 while iterating files
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <20170725205443.29874-1-jeffm@suse.com>
 <b9faaaad-1d57-918d-2f9a-3f14160d7811@gmx.com>
 <040281e8-680a-561e-1302-771be2eea4e1@suse.com>
 <a0220785-58fd-a8aa-cf80-c64d5228ebb0@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <cbf37890-8c53-5db4-d8ab-cc97431f0f70@gmx.com>
Date: Fri, 28 Jul 2017 09:12:26 +0800
MIME-Version: 1.0
In-Reply-To: <a0220785-58fd-a8aa-cf80-c64d5228ebb0@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月28日 05:29, Jeff Mahoney wrote:
> On 7/27/17 12:38 PM, Jeff Mahoney wrote:
>> On 7/26/17 9:35 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年07月26日 04:54, jeffm@suse.com wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>
>>>> Commit 522ef705e38 (btrfs-progs: convert: Introduce function to calculate
>>>> the available space) changed how we handle migrating file data so that
>>>> we never have btrfs space associated with the reserved ranges.  This
>>>> works pretty well and when we iterate over the file blocks, the
>>>> associations are redirected to the migrated locations.
>>>>
>>>> This commit missed the case in block_iterate_proc where we just check
>>>> for intersection with a superblock location before looking up a block
>>>> group.  intersect_with_sb checks to see if the range intersects with
>>>> a stripe containing a superblock but, in fact, we've reserved the
>>>> full 0-1MB range at the start of the disk.  So a file block located
>>>> at e.g. 160kB will fall in the reserved region but won't be excepted
>>>> in block_iterate_block.  We ultimately hit a BUG_ON when we fail
>>>> to look up the block group for that location.
>>>
>>> The description of the problem  is indeed correct.
>>>
>>>>
>>>> This is reproducible using convert-tests/003-ext4-basic.
>>>
>>> Thanks for pointing this out, I also reproduced it.
>>>
>>> While it would be nicer if you could upload a special crafted image as
>>> indicated test case.
>>> IIRC the test passed without problem several versions ago, so there may
>>> be some factors preventing the bug from being exposed.
>>>
>>>>
>>>> The fix is to have intersect_with_sb and block_iterate_proc understand
>>>> the full size of the reserved ranges.  Since we use the range to
>>>> determine the boundary for the block iterator, let's just return the
>>>> boundary.  0 isn't a valid boundary and means that we proceed normally
>>>> with block group lookup.
>>>
>>> I'm OK with current fix as it indeed fix the bug and has minimal impact
>>> on current code.
>>>
>>> So feel free to add:
>>> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>
>>> While I think there is a better way to solve it more completely.
>>>
>>> As when we run into block_iterate_proc(), we have already created
>>> ext2_save/image.
>>> So we can use the the image as ext2 <-> btrfs position mapping, just as
>>> we have already done in record_file_blocks().
>>>
>>> That's to say, we don't need too much care about the intersection with
>>> reserved range, but just letting record_file_blocks() to handle it will
>>> be good enough.
>>>
>>> What do you think about this idea?
>>
>> I think you're right.  It should do the mapping already so we don't need
>> to do anything special in block_iterate_proc.  I can test that in a bit.
> 
> So the idea works and, in fact, we could really get rid of most of
> block_iterate_proc and still get correct results.  This code is an
> optimization so that we can quickly assemble larger extents and not have
> to grow on-disk extents repeatedly.  The code as it is does the right
> thing most of the time but the boundary condition triggers the barrier
> for every block in a migrated range and record_file_blocks must do the
> growing.  The end result works fine, it's just slower than it needs to
> be for that 0-1MB range.  I'm not sure I care enough to invest the time
> to fix that.

Yes, the record_file_extent() handles the mapping in a slow way, by 
doing btrfs_search_slot() to do the mapping, no matter if it's in the 
reserved range.
So performance is much slower.

Performance wise, I'm OK using the current code.

Thanks,
Qu

> 
> -Jeff
> 
>> -Jeff
>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>>> ---
>>>>    convert/source-fs.c | 25 +++++++++++--------------
>>>>    1 file changed, 11 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/convert/source-fs.c b/convert/source-fs.c
>>>> index 80e4e41..09f6995 100644
>>>> --- a/convert/source-fs.c
>>>> +++ b/convert/source-fs.c
>>>> @@ -28,18 +28,16 @@ const struct simple_range btrfs_reserved_ranges[3]
>>>> = {
>>>>        { BTRFS_SB_MIRROR_OFFSET(2), SZ_64K }
>>>>    };
>>>>    -static int intersect_with_sb(u64 bytenr, u64 num_bytes)
>>>> +static u64 intersect_with_reserved(u64 bytenr, u64 num_bytes)
>>>>    {
>>>>        int i;
>>>> -    u64 offset;
>>>>    -    for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>>>> -        offset = btrfs_sb_offset(i);
>>>> -        offset &= ~((u64)BTRFS_STRIPE_LEN - 1);
>>>> +    for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
>>>> +        const struct simple_range *range = &btrfs_reserved_ranges[i];
>>>>    -        if (bytenr < offset + BTRFS_STRIPE_LEN &&
>>>> -            bytenr + num_bytes > offset)
>>>> -            return 1;
>>>> +        if (bytenr < range_end(range) &&
>>>> +            bytenr + num_bytes >= range->start)
>>>> +            return range_end(range);
>>>>        }
>>>>        return 0;
>>>>    }
>>>> @@ -64,14 +62,14 @@ int block_iterate_proc(u64 disk_block, u64
>>>> file_block,
>>>>                          struct blk_iterate_data *idata)
>>>>    {
>>>>        int ret = 0;
>>>> -    int sb_region;
>>>> +    u64 reserved_boundary;
>>>>        int do_barrier;
>>>>        struct btrfs_root *root = idata->root;
>>>>        struct btrfs_block_group_cache *cache;
>>>>        u64 bytenr = disk_block * root->sectorsize;
>>>>    -    sb_region = intersect_with_sb(bytenr, root->sectorsize);
>>>> -    do_barrier = sb_region || disk_block >= idata->boundary;
>>>> +    reserved_boundary = intersect_with_reserved(bytenr,
>>>> root->sectorsize);
>>>> +    do_barrier = reserved_boundary || disk_block >= idata->boundary;
>>>>        if ((idata->num_blocks > 0 && do_barrier) ||
>>>>            (file_block > idata->first_block + idata->num_blocks) ||
>>>>            (disk_block != idata->disk_block + idata->num_blocks)) {
>>>> @@ -91,9 +89,8 @@ int block_iterate_proc(u64 disk_block, u64 file_block,
>>>>                    goto fail;
>>>>            }
>>>>    -        if (sb_region) {
>>>> -            bytenr += BTRFS_STRIPE_LEN - 1;
>>>> -            bytenr &= ~((u64)BTRFS_STRIPE_LEN - 1);
>>>> +        if (reserved_boundary) {
>>>> +            bytenr = reserved_boundary;
>>>>            } else {
>>>>                cache = btrfs_lookup_block_group(root->fs_info, bytenr);
>>>>                BUG_ON(!cache);
>>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> 
> 
