Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbeCPSpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 14:45:05 -0400
Subject: Re: [PATCH] btrfs: Document parameters of btrfs_reserve_extent
To: Liu Bo <obuil.liubo@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <1520936552-11586-1-git-send-email-nborisov@suse.com>
 <CANQeFDDtByiOwt-=ffNHB1iyUBzcvQoNLT2LM6ETLWstOzNiZg@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <34f4d6f0-4f04-7d3a-4e46-c341f401be65@suse.com>
Date: Fri, 16 Mar 2018 20:44:56 +0200
MIME-Version: 1.0
In-Reply-To: <CANQeFDDtByiOwt-=ffNHB1iyUBzcvQoNLT2LM6ETLWstOzNiZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.03.2018 20:43, Liu Bo wrote:
> On Tue, Mar 13, 2018 at 3:22 AM, Nikolay Borisov <nborisov@suse.com> wrote:
>> This function is the entry to the extent allocator and as such has
>> quite a number of parameters. Some of those have subtle effects on the
>> allocation algorithm. Document the parameters.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index bb1861033071..60ece25101ee 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7961,6 +7961,51 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
>>         up_read(&info->groups_sem);
>>  }
>>
>> +/*
>> + * btrfs_reserve_extent - entry point to the extent allocator. Tries to find a
>> + *                       hole that is at least as big as @num_bytes.
>> + *
>> + * @root           -   The root that will contains this extent
>> + *
>> + * @ram_bytes      -   The amount of space in ram that @num_bytes take. This
>> + *                     is used for accounting purposes. This value differs
>> + *                     than @num_bytes only in the case of compressed extents.
>> + *
>> + * @num_bytes      -   Number of bytes to allocates on-disk.
>> + *
>> + * @min_alloc_size -   Indicates the minimum amount of memory that the
> 
> Could you please pick another word instead of "memory", like hole or
> extent or space?

Good point, i guess it's a brain fair. I'd rather use "space". I see
David has already merged it. David do you mind fixing it in-place?

> 
> Others look good to me.
> 
> Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> 
> thanks,
> liubo
> 
>> + *                     allocator should try to satisfy. In some cases
>> + *                     @num_bytes may be larger than what is required and if
>> + *                     the filesystem is fragmented then allocation fails.
>> + *                     However, the presence of @min_alloc_size gives a
>> + *                     chance to try and satisfy the smaller allocation.
>> + *
>> + * @empty_size     -   A hint that you plan on doing more cow. This is the
>> + *                     size in bytes the allocator should try to find free
>> + *                     next to the block it returns.  This is just a hint and
>> + *                     may be ignored by the allocator.
>> + *
>> + * @hint_byte      -   Hint to the allocator to start searching above the byte
>> + *                     address passed. It might be ignored.
>> + *
>> + * @ins            -   This key is modified to record the found hole. It will
>> + *                     have the following values:
>> + *                     ins->objectid == start position
>> + *                     ins->flags = BTRFS_EXTENT_ITEM_KEY
>> + *                     ins->offset == the size of the hole.
>> + *
>> + * @is_data        -   Boolean flag indicating whether an extent is
>> + *                     allocated for data (true) or metadata (false)
>> + *
>> + * @delalloc       -   Boolean flag indicating whether this allocation is for
>> + *                     delalloc or not. If 'true' data_rwsem of block groups
>> + *                     is going to be acquired.
>> + *
>> + *
>> + * Returns 0 when an allocation succeeded or < 0 when an error occurred. In
>> + * case -ENOSPC is returned then @ins->offset will contain the size of the
>> + * largest available hole the allocator managed to find.
>> + */
>>  int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
>>                          u64 num_bytes, u64 min_alloc_size,
>>                          u64 empty_size, u64 hint_byte,
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
