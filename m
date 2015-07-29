Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39726 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbbG2CJZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 22:09:25 -0400
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
To: <bo.li.liu@oracle.com>
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150728095244.GC1338@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B835CC.5010103@cn.fujitsu.com>
Date: Wed, 29 Jul 2015 10:09:16 +0800
MIME-Version: 1.0
In-Reply-To: <20150728095244.GC1338@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2015/07/28 17:52 +0800:
> On Tue, Jul 28, 2015 at 04:30:36PM +0800, Qu Wenruo wrote:
>> Although Liu Bo has already submitted a V10 version of his deduplication
>> implement, here is another implement for it.
>>
>> [[CORE FEATURES]]
>> The main design concept is the following:
>> 1) Controllable memory usage
>> 2) No guarantee to dedup every duplication.
>> 3) No on-disk format change or new format
>> 4) Page size level deduplication
>>
>> [[IMPLEMENT]]
>> Implement details includes the following:
>> 1) LRU hash maps to limit the memory usage
>>     The hash -> extent mapping is control by LRU (or unlimited), to
>>     get a controllable memory usage (can be tuned by mount option)
>>     alone with controllable read/write overhead used for hash searching.
>>
>> 2) Reuse existing ordered_extent infrastructure
>>     For duplicated page, it will still submit a ordered_extent(only one
>>     page long), to make the full use of all existing infrastructure.
>>     But only not submit a bio.
>>     This can reduce the number of code lines.
>>
>> 3) Mount option to control dedup behavior
>>     Deduplication and its memory usage can be tuned by mount option.
>>     No need to indicated ioctl interface.
>>     And further more, it can easily support BTRFS_INODE flag like
>>     compression, to allow further per file dedup fine tunning.
>>
>> [[TODO]]
>> 1. Add support for compressed extent
>>     Shouldn't be quite hard.
>> 2. Try to merge dedup extent to reduce metadata size
>>     Currently, dedup extent is always in 4K size, although its reference
>>     source can be quite large.
>> 3. Add support for per file dedup flags
>>     Much easier, just like compression flags.
>>
>> [[KNOWN BUG, NEED HELP!]]
>> On the other hand, since it's still a RFC patch, it must has one or more
>> problem:
>
> You may have a look at my patchset, one of them is aimed to address the
> similar problem.
>
> Thanks,
>
> -liubo
In fact, I took a look at your patchset.
But the following two points are not so perfect so I choose to implement 
my own one:
1) Extent size.
    Extent size won't be larger than dedup_bs.
    Causing a lot of fragment even the write is not duplicated.

    So in my implement, for non-duplicated extent, its size will be up
    to 512K, not dedup_size.

    And the 512K limit can be further increase much easier.
    I choose 512K because for 512K extent, its hash can just be stored
    into one page (512K contains 128 pages, each page takes 32bytes for
    hash).

2) Submit bio directly
    Not a fan as it's crossing level.
    Normally bio is submitted in extent_io.c, and now we are doing high
    level metadata modification with low level bio submit in one
    function.

    At least it's not a good idea for me.
    So in my implement, I just add some small hooks into
    cow_file_range(), and even for duplicated page, I reuse the
    ordered_extent infrastructure to handle the inode size update and
    page/extent lock things.

To solve the problem I have another idea, to just submit duplciated 
metadata modification and don't go through ordered_extent.

But it's not perfect either.
we need extra functions to handle inode size update and 
btrfs_ordered_update_i_size() is useless as we don't have ordered_extent.

And if the duplicated page is an outstanding one, to insert the file 
extent, we also need to fill the holes between [inode_size, start).
And most of existing functions to punch hole won't help, as the range 
outstanding range is still locked by us.

Thanks,
Qu
>
>> 1) Race between __btrfs_free_extent() and dedup ordered_extent.
>>     The hook in __btrfs_free_extent() will free the corresponding hashes
>>     of a extent, even there is a dedup ordered_extent referring it.
>>
>>     The problem will happen like the following case:
>> ======================================================================
>>     cow_file_range()
>>       Submit dedup ordered_extent for extent A
>>
>>     commit_transaction()
>>       Extent A needs freeing. As the its ref is decreased to 0.
>>       And dedup ordered_extent can increase only when it hit endio time.
>>
>>     finish_ordered_io()
>>       Add reference to Extent A for dedup ordered_extent.
>>       But it is already freed in previous transaction.
>>       Causing abort_transaction().
>> ======================================================================
>>     I'd like to keep the current ordered_extent method, as it adds the
>>     least number of code lines.
>>     But I can't find a good idea to either delay transaction until dedup
>>     ordered_extent is done or things like that.
>>
>>     Trans->ordered seems to be a good idea, but it seems to cause list
>>     corruption without extra protection in tree log infrastructure.
>>
>> That's the only problem spotted yet.
>> Any early review or advice/question on the design is welcomed.
>>
>> Thanks.
>>
>> Qu Wenruo (14):
>>    btrfs: file-item: Introduce btrfs_setup_file_extent function.
>>    btrfs: Use btrfs_fill_file_extent to reduce duplicated codes
>>    btrfs: dedup: Add basic init/free functions for inband dedup.
>>    btrfs: dedup: Add internal add/remove/search function for btrfs dedup.
>>    btrfs: dedup: add ordered extent hook for inband dedup
>>    btrfs: dedup: Apply dedup hook for write time dedup.
>>    btrfs: extent_map: Add new dedup flag and corresponding hook.
>>    btrfs: extent-map: Introduce orig_block_start member for extent-map.
>>    btrfs: dedup: Add inband dedup hook for read extent.
>>    btrfs: dedup: Introduce btrfs_dedup_free_extent_range function.
>>    btrfs: dedup: Add hook to free dedup hash at extent free time.
>>    btrfs: dedup: Add mount option support for btrfs inband deduplication.
>>    Btrfs: dedup: Support dedup change at remount time.
>>    btrfs: dedup: Add mount option output for inband dedup.
>>
>>   fs/btrfs/Makefile       |   2 +-
>>   fs/btrfs/ctree.h        |  16 ++
>>   fs/btrfs/dedup.c        | 701 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/dedup.h        | 132 +++++++++
>>   fs/btrfs/disk-io.c      |   7 +
>>   fs/btrfs/extent-tree.c  |  10 +
>>   fs/btrfs/extent_io.c    |   6 +-
>>   fs/btrfs/extent_map.h   |   4 +
>>   fs/btrfs/file-item.c    |  61 +++--
>>   fs/btrfs/inode.c        | 228 ++++++++++++----
>>   fs/btrfs/ordered-data.c |  32 ++-
>>   fs/btrfs/ordered-data.h |   8 +
>>   fs/btrfs/super.c        |  39 ++-
>>   13 files changed, 1163 insertions(+), 83 deletions(-)
>>   create mode 100644 fs/btrfs/dedup.c
>>   create mode 100644 fs/btrfs/dedup.h
>>
>> --
>> 2.4.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
