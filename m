Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6637 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933453AbdCHBXA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 20:23:00 -0500
Subject: Re: [PATCH v6 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
To: <bo.li.liu@oracle.com>, Filipe Manana <fdmanana@kernel.org>
References: <20170306025547.1858-1-quwenruo@cn.fujitsu.com>
 <20170307204958.GD12408@lim.localdomain>
 <20170307205937.GF12408@lim.localdomain>
 <CAL3q7H7D0J7uVoPeCDryB9+G1WyWh5Nwzx+sKs7g=mw0Cgw3dw@mail.gmail.com>
 <20170308011652.GJ12408@lim.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <38fa13a0-e010-9fc0-eab0-ee8a6f5f483b@cn.fujitsu.com>
Date: Wed, 8 Mar 2017 09:21:15 +0800
MIME-Version: 1.0
In-Reply-To: <20170308011652.GJ12408@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/08/2017 09:16 AM, Liu Bo wrote:
> On Wed, Mar 08, 2017 at 12:17:16AM +0000, Filipe Manana wrote:
>> On Tue, Mar 7, 2017 at 8:59 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>> On Tue, Mar 07, 2017 at 12:49:58PM -0800, Liu Bo wrote:
>>>> On Mon, Mar 06, 2017 at 10:55:46AM +0800, Qu Wenruo wrote:
>>>>> [BUG]
>>>>> When btrfs_reloc_clone_csum() reports error, it can underflow metadata
>>>>> and leads to kernel assertion on outstanding extents in
>>>>> run_delalloc_nocow() and cow_file_range().
>>>>>
>>>>>  BTRFS info (device vdb5): relocating block group 12582912 flags data
>>>>>  BTRFS info (device vdb5): found 1 extents
>>>>>  assertion failed: inode->outstanding_extents >= num_extents, file: fs/btrfs//extent-tree.c, line: 5858
>>>>>
>>>>> Currently, due to another bug blocking ordered extents, the bug is only
>>>>> reproducible under certain block group layout and using error injection.
>>>>>
>>>>> a) Create one data block group with one 4K extent in it.
>>>>>    To avoid the bug that hangs btrfs due to ordered extent which never
>>>>>    finishes
>>>>> b) Make btrfs_reloc_clone_csum() always fail
>>>>> c) Relocate that block group
>>>>>
>>>>> [CAUSE]
>>>>> run_delalloc_nocow() and cow_file_range() handles error from
>>>>> btrfs_reloc_clone_csum() wrongly:
>>>>>
>>>>> (The ascii chart shows a more generic case of this bug other than the
>>>>> bug mentioned above)
>>>>>
>>>>> |<------------------ delalloc range --------------------------->|
>>>>> | OE 1 | OE 2 | ... | OE n |
>>>>>                     |<----------- cleanup range --------------->|
>>>>> |<-----------  ----------->|
>>>>>              \/
>>>>>  btrfs_finish_ordered_io() range
>>>>>
>>>>> So error handler, which calls extent_clear_unlock_delalloc() with
>>>>> EXTENT_DELALLOC and EXTENT_DO_ACCOUNT bits, and btrfs_finish_ordered_io()
>>>>> will both cover OE n, and free its metadata, causing metadata under flow.
>>>>>
>>>>> [Fix]
>>>>> The fix is to ensure after calling btrfs_add_ordered_extent(), we only
>>>>> call error handler after increasing the iteration offset, so that
>>>>> cleanup range won't cover any created ordered extent.
>>>>>
>>>>> |<------------------ delalloc range --------------------------->|
>>>>> | OE 1 | OE 2 | ... | OE n |
>>>>> |<-----------  ----------->|<---------- cleanup range --------->|
>>>>>              \/
>>>>>  btrfs_finish_ordered_io() range
>>>>>
>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>> ---
>>>>> changelog:
>>>>> v6:
>>>>>   New, split from v5 patch, as this is a separate bug.
>>>>> ---
>>>>>  fs/btrfs/inode.c | 51 +++++++++++++++++++++++++++++++++++++++------------
>>>>>  1 file changed, 39 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>> index b2bc07aad1ae..1d83d504f2e5 100644
>>>>> --- a/fs/btrfs/inode.c
>>>>> +++ b/fs/btrfs/inode.c
>>>>> @@ -998,15 +998,24 @@ static noinline int cow_file_range(struct inode *inode,
>>>>>                 BTRFS_DATA_RELOC_TREE_OBJECTID) {
>>>>>                     ret = btrfs_reloc_clone_csums(inode, start,
>>>>>                                                   cur_alloc_size);
>>>>> +                   /*
>>>>> +                    * Only drop cache here, and process as normal.
>>>>> +                    *
>>>>> +                    * We must not allow extent_clear_unlock_delalloc()
>>>>> +                    * at out_unlock label to free meta of this ordered
>>>>> +                    * extent, as its meta should be freed by
>>>>> +                    * btrfs_finish_ordered_io().
>>>>> +                    *
>>>>> +                    * So we must continue until @start is increased to
>>>>> +                    * skip current ordered extent.
>>>>> +                    */
>>>>>                     if (ret)
>>>>> -                           goto out_drop_extent_cache;
>>>>> +                           btrfs_drop_extent_cache(BTRFS_I(inode), start,
>>>>> +                                           start + ram_size - 1, 0);
>>>>>             }
>>>>>
>>>>>             btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>>>>>
>>>>> -           if (disk_num_bytes < cur_alloc_size)
>>>>> -                   break;
>>>>> -
>>>>>             /* we're not doing compressed IO, don't unlock the first
>>>>>              * page (which the caller expects to stay locked), don't
>>>>>              * clear any dirty bits and don't set any writeback bits
>>>>> @@ -1022,10 +1031,21 @@ static noinline int cow_file_range(struct inode *inode,
>>>>>                                          delalloc_end, locked_page,
>>>>>                                          EXTENT_LOCKED | EXTENT_DELALLOC,
>>>>>                                          op);
>>>>> -           disk_num_bytes -= cur_alloc_size;
>>>>> +           if (disk_num_bytes > cur_alloc_size)
>>>>> +                   disk_num_bytes = 0;
>>>>> +           else
>>>>> +                   disk_num_bytes -= cur_alloc_size;
>>>>
>>>> I don't get the logic here, why do we 'break' if disk_num_bytes > cur_alloc_size?
>>>
>>> I assume that you've run fstests against this patch, if so, I actually
>>> start worrying about that no fstests found this problem.
>>
>> The operator is definitely wrong, should be < instead of > (previous
>> patch versions were correct).
>>
>> It's not a surprise fstests don't catch this - one would need a fs
>> with no more free space to allocate new data chunks and existing data
>> chunks would have to be fragmented to the point we need to allocate
>> two or more smaller extents to satisfy the write, so whether fstests
>> exercises this depends on the size of the test devices (mine are 100G
>> for example) and the size of the data the tests create. Having a
>> deterministic test for that for that should be possible and useful.
>
> I see, I think that 'mount -o fragment=data' could help us get it.
>
> Thanks,
>
> -liubo
>
>
I'll also submit a test case for this.

By filling the fs with small files(sectorsize) with sequential number as 
file name.

Then sync fs, remove the files with odd number, then do a large write.

This one should trigger the problem without the use of the debug option, 
and can be a generic test.

Thanks,
Qu


