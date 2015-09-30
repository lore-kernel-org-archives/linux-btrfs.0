Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394AbbI3Btz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 21:49:55 -0400
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929215135.GZ3902@dastard> <560B354B.9050400@cn.fujitsu.com>
 <560B3E9D.8050701@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <560B3FBE.6080809@cn.fujitsu.com>
Date: Wed, 30 Sep 2015 09:49:50 +0800
MIME-Version: 1.0
In-Reply-To: <560B3E9D.8050701@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Tsutomu Itoh wrote on 2015/09/30 10:45 +0900:
> On 2015/09/30 10:05, Qu Wenruo wrote:
>> Dave Chinner wrote on 2015/09/30 07:51 +1000:
>>> On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
>>>> Normally, a bull fallocate call on a fully written and synced file
>>>> should not add an extent.
>>>
>>> Why not? Filesystems can do whatever they want with extents during
>>> a fallocate call. e.g. if the blocks are shared, then fallocate
>>> might break the block sharing so future overwrites don't get
>>> ENOSPC. This is a requirement set down by posix_fallocate(3)
>>>
>>> "After a successful call to posix_fallocate(), subsequent writes to
>>> bytes in the specified range are guaranteed not  to fail because of
>>> lack of disk space."
>>>
>>> Hence if you've got a file with shared blocks, a "full fallocate"
>>> must change the extent layout to break the sharing. As such, the
>>> premise of this test is wrong.
>>
>> First, btrfs never meets the posix_fallocate requirement by its COW
>> nature.
>>
>> Btrfs fallocate can only ensure at most next write will not cause ENOSPC.
>> Only when btrfs fallocate a new prealloc extent, next write into it
>> may use the space if they are not shared between different snapshots.
>>
>> Under most case, btrfs fallocate follows the behavior of other non-COW
>> filesystems.
>> Which means, btrfs won't alloc new extent if there is existing extent,
>> not matter if it's shared or not.
>>
>> As a result, fallocate in btrfs only works in a limited use-case, and
>> can easily break posix requirement.
>> Like the following case without snapshots:
>> 1)Fallocate 0~50M
>> 2)Write 0~50M        <- Will not return ENOSPC
>> 3)Write 0~25M        <- COW happens, allocate another 25M,
>>                 may cause ENOSPC.
>> Or even easier with snapshot:
>> 1)Fallocate 0~50M in subvol A
>> 2)Snapshot subvol A into snap B
>> 3)Write 0~25M in subvol A *OR* snap B <- COW happens, may cause ENOSPC
>>
>> As in step 3), fallocated 50M is shared, so write will be forced COW.
>>
>> So I'd prefer to make btrfs follows the behavior of other non-COW
>> filesystems, as posix standard doesn't fit well here.
>>>
>>> That's not to say that btrfs has a bug:
>>>
>>>> Btrfs has a bug to always truncate the last page if the fallocate start
>>>> offset is smaller than inode size.
>>>
>>> But it' not clear that this behaviour is actually a bug if it's not
>>> changing the file data.
>> File data is not changed, as btrfs just COW the last tailing page, as
>> reset the last already 0 part.
>>
>> Like the follow ascii arts:
>>
>> 0)Before
>> 0    4K    8K    12K    16K
>> |///////////////////////////|000|
>> |<----------Extent A----------->|
>> The file is 14K size, on disk(to be accurate, btrfs logical address
>> space) it takes 16K, with last 2K padding 0.
>>
>> And all that 16K is in extent A.
>>
>> 1)Fallocate 0~14K
>> In fact, all space in range 0~14K is allocated, so there is no need to
>> reallocate any space.
>>
>> 2)But in btrfs
>> Result will be:
>> 0    4K    8K    12K    16K
>> |///////////////////////////|000|
>> |<------Extent A------->|<--B-->|
>>
>> Btrfs has a wrong judgment, which will always re-padding the last page.
>> Causing a new extent, extent B to be created.
>> Even the contents is the same with original last page.
>>
>> It's OK not to consider it as a bug, at least data is not corrupted.
>> But IMO the btrfs behavior is not needed and need optimization.
>
>> So kernel patch is submitted to btrfs ml:
>> https://patchwork.kernel.org/patch/7284431/
>
> Is this https://patchwork.kernel.org/patch/7283461/ ?  Right?
>
> Thanks,
> Tsutomu

Oh, my fault, 728461 is the right patch...

Thanks for pointing this out,
Qu
>
>>
>> And if fstests is not the proper place, any idea where such "test
>> case" should belong?
>>
>> Thanks,
>> Qu
>>
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
