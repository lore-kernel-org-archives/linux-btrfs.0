Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41310 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933115AbcJQJHm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 05:07:42 -0400
Subject: Re: [PATCH 2/2] btrfs: fix false enospc for compression
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <20161006025139.22776-1-wangxg.fnst@cn.fujitsu.com>
 <20161006025139.22776-2-wangxg.fnst@cn.fujitsu.com>
 <5800E4AB.2010701@applied-asynchrony.com>
CC: <jbacik@fb.com>, <dsterba@suse.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5804937A.2060506@cn.fujitsu.com>
Date: Mon, 17 Oct 2016 17:01:46 +0800
MIME-Version: 1.0
In-Reply-To: <5800E4AB.2010701@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

On 10/14/2016 09:59 PM, Holger Hoffstätte wrote:
> On 10/06/16 04:51, Wang Xiaoguang wrote:
>> When testing btrfs compression, sometimes we got ENOSPC error, though fs
>> still has much free space, xfstests generic/171, generic/172, generic/173,
>> generic/174, generic/175 can reveal this bug in my test environment when
>> compression is enabled.
>>
>> After some debuging work, we found that it's btrfs_delalloc_reserve_metadata()
>> which sometimes tries to reserve plenty of metadata space, even for very small
>> data range. In btrfs_delalloc_reserve_metadata(), the number of metadata bytes
>> we try to reserve is calculated by the difference between outstanding_extents
>> and reserved_extents. Please see below case for how ENOSPC occurs:
>>
>>    1, Buffered write 128MB data in unit of 128KB, so finially we'll have inode
>> outstanding extents be 1, and reserved_extents be 1024. Note it's
>> btrfs_merge_extent_hook() that merges these 128KB units into one big
>> outstanding extent, but do not change reserved_extents.
>>
>>    2, When writing dirty pages, for compression, cow_file_range_async() will
>> split above big extent in unit of 128KB(compression extent size is 128KB).
>> When first split opeartion finishes, we'll have 2 outstanding extents and 1024
>> reserved extents, and just right now the currently generated ordered extent is
>> dispatched to run and complete, then btrfs_delalloc_release_metadata()(see
>> btrfs_finish_ordered_io()) will be called to release metadata, after that we
>> will have 1 outstanding extents and 1 reserved extents(also see logic in
>> drop_outstanding_extent()). Later cow_file_range_async() continues to handles
>> left data range[128KB, 128MB), and if no other ordered extent was dispatched
>> to run, there will be 1023 outstanding extents and 1 reserved extent.
>>
>>    3, Now if another bufferd write for this file enters, then
>> btrfs_delalloc_reserve_metadata() will at least try to reserve metadata
>> for 1023 outstanding extents' metadata, for 16KB node size, it'll be 1023*16384*2*8,
>> about 255MB, for 64K node size, it'll be 1023*65536*8*2, about 1GB metadata, so
>> obviously it's not sane and can easily result in enospc error.
>>
>> The root cause is that for compression, its max extent size will no longer be
>> BTRFS_MAX_EXTENT_SIZE(128MB), it'll be 128KB, so current metadata reservation
>> method in btrfs is not appropriate or correct, here we introduce:
>> 	enum btrfs_metadata_reserve_type {
>>          	BTRFS_RESERVE_NORMAL,
>>          	BTRFS_RESERVE_COMPRESS,
>> 	};
>> and expand btrfs_delalloc_reserve_metadata() and btrfs_delalloc_reserve_space()
>> by adding a new enum btrfs_metadata_reserve_type argument. When a data range will
>> go through compression, we use BTRFS_RESERVE_COMPRESS to reserve metatata.
>> Meanwhile we introduce EXTENT_COMPRESS flag to mark a data range that will go
>> through compression path.
>>
>> With this patch, we can fix these false enospc error for compression.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> I took some time again to get this into my tree on top of what's in
> btrfs-4.9rc1 and managed to merge it after all.
>
> Both this and patch #1 seem to work fine, and they don't seem to cause any
> regressions; ran a couple of both full and incremental rsync backups with
>> 100GB on a new and now compressed subvolume without problem. Also Stefan
> just reported that his ENOSPC seems to be gone as well, so it seems to be
> good. \o/
>
> So for both this and patch #1 have a careful:
>
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>
> Also a comment about something I found while resolving conflicts caused
> by the preliminary dedupe suppoort:
>
> [..]
>>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
>> -			      struct extent_state **cached_state);
>> +			      struct extent_state **cached_state, int flag);
>>   int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
>> -			    struct extent_state **cached_state);
>> +			    struct extent_state **cached_state, int flag);
> [..]
>>   int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
>>   		      struct page **pages, size_t num_pages,
>>   		      loff_t pos, size_t write_bytes,
>> -		      struct extent_state **cached);
>> +		      struct extent_state **cached, int flag);
> Instead of adding "int flag" why not use the already defined
> btrfs_metadata_reserve_type enum? I know it's just an int at the end of
> the day, but the dedupe support already added another "int dedupe" argument
> and it's probably easy to cause confusion.
> Maybe later it would be beneficial to consolidate the flags into a consistent
> set of enum values to prevent more "int flag" inflation and better declare the
> intent of the extent state change. Not sure if that makes sense.
Yes, agree.
I'll rebase them later, thanks.

Regards,
Xiaoguang Wang

>
> thanks,
> Holger
>
>
>



