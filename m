Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44065 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750850AbcI3CYx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 22:24:53 -0400
Subject: Re: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
To: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1474570050-4715-1-git-send-email-rgoldwyn@suse.de>
 <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
 <628e1dcd-ddc3-3f37-8a47-c01c912db970@suse.com>
 <65e6515c-a9f3-d5f9-db6b-3ffd8d97f90e@cn.fujitsu.com>
 <0e892f0a-22b3-0fd7-ac8f-d52b76b4d4af@suse.de>
 <1274b3b2-d196-ee9e-2261-d2f5cb906477@cn.fujitsu.com>
 <2a9a3890-3f32-f175-b4aa-becf7caabb7f@suse.de>
 <cb81e839-1040-0942-3206-fa6acd9ee547@cn.fujitsu.com>
 <3ef8e20a-d671-7691-d964-014f35299703@suse.com>
 <1d2ddf05-81d7-4be9-fe32-909ef121f3db@cn.fujitsu.com>
 <16c4c9a0-a698-91ab-2136-4731fea1850d@suse.de>
 <232dee19-bf1d-4cf1-68a0-6c12981cb6b9@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e4ec9745-ff03-8670-4fc7-8745390849d4@cn.fujitsu.com>
Date: Fri, 30 Sep 2016 10:24:46 +0800
MIME-Version: 1.0
In-Reply-To: <232dee19-bf1d-4cf1-68a0-6c12981cb6b9@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/30/2016 10:18 AM, Qu Wenruo wrote:
> Your original fix is good.
>
> Feel free to my tag after enriching the comment in btrfs_invalidatepage().
Feel free to "add" my tag...
>
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Thanks again for your founding and sorry for the extra time reviewing.
for your "finding"...

My English just sucks....
>
> Thanks
> Qu
>
>
> At 09/29/2016 07:13 PM, Goldwyn Rodrigues wrote:
>>
>>
>> On 09/29/2016 03:57 AM, Qu Wenruo wrote:
>>> Thanks for your test script.
>>>
>>> I succeeded in pinning down the problem.
>>>
>>> The problem is, btrfs is invalidate pages that belongs to ordered
>>> extent(goes through writeback)
>>
>>
>> No, I don't think invalidated pages are going through writeback. The
>> problem is that the space for extent allocation is done before the
>> writeback and if pages are invalidated before writeback, it is not
>> accounted for.
>>
>>>
>>> The ftrace(with more tracepoints to trace qgroup->reserved change)
>>> shows:
>>> ------
>>> btrfs_qgroup_release_data: root=257, ino=257, start=0, len=4096,
>>> reserved=4096, op=free
>>> qgroup_update_reserve: qgid = 257, cur_reserved = 16171008, diff = -4096
>>> btrfs_qgroup_release_data: root=257, ino=257, start=4096, len=4096,
>>> reserved=4096, op=free
>>> qgroup_update_reserve: qgid = 257, cur_reserved = 16166912, diff = -4096
>>> btrfs_qgroup_release_data: root=257, ino=257, start=8192, len=4096,
>>> reserved=4096, op=free
>>> qgroup_update_reserve: qgid = 257, cur_reserved = 16162816, diff = -4096
>>> btrfs_qgroup_release_data: root=257, ino=257, start=12288, len=4096,
>>> reserved=4096, op=free
>>> qgroup_update_reserve: qgid = 257, cur_reserved = 16158720, diff = -4096
>>> btrfs_qgroup_release_data: root=257, ino=257, start=16384, len=4096,
>>> reserved=4096, op=free
>>> qgroup_update_reserve: qgid = 257, cur_reserved = 16154624, diff = -4096
>>
>> This is a little confusing. There is no qgroup_update_reserve() function
>> in the source. Where did you add this?
>>
>>>
>>>
>>> ^^^^^ Btrfs invalidates 5 pages of ino 257 qg 257, range 0 ~ 20K.
>>>
>>> btrfs_qgroup_release_data: root=257, ino=257, start=0, len=5242880,
>>> reserved=5222400, op=release
>>>
>>> ^^^^^ Here ordered_io finishes, write the whole 5M data, while
>>> QGROUP_RESERVED only returned 5M - 20K.
>>> ------
>>>
>>> The problem is at btrfs_add_delayed_data_ref(), we use the assumption
>>> that, qgroup reserved space is the same as extent size(5M)
>>> But in fact, btrfs_qgroup_release_data() only release (5M - 20K).
>>> Leaking the 20K.
>>
>> Yes, this is more like it. However, I would put it the other way. It
>> releases 5M when it should have released 5M-20K, because 20k was
>> released when invalidating page.
>>
>>>
>>> Calltrace:
>>> btrfs_finish_ordered_io()
>>> |- inserted_reserved_file_extent()
>>>    |- btrfs_alloc_reserved_file_extent()
>>>    |  ^^ Here we tell delayed_ref to free 5M later
>>>    |- btrfs_qgroup_release_data()
>>>       ^^ We only released (5M - 20K), as the first 5 pages
>>>          are freed by btrfs_invalidatepage()
>>>
>>> If btrfs is designed to freeing pages which belongs to ordered_extent,
>>> then it totally breaks the qgroup assumption.
>>>
>>> Then we have several ways to fix it:
>>> 1) Fix race between ordered extent(writeback) with invalidatepage()
>>>    Make btrfs_invalidatepage() skips pages that are already in
>>>    ordered_extent, then we're OK.
>>>
>>>    This is much like your original fix, but I'm not sure if DIRTY page
>>>    flag is bond to ordered_extent.
>>>    And more comment will help.
>>
>>
>> So, what you mean is that fix is correct, I just need to reword the
>> patch header.
>>
>>>
>>> 2) Make btrfs_qgroup_release_data() return accurate num bytes
>>>    And then pass it to delayed_ref head.
>>>
>>>    This is quite anti-intuition. If we're adding a new extent, how
>>>    could it happen that some pages are already invalidated?
>>>
>>
>> I agree. It is counter-intutive and will increase complexity.
>>
>>> Anyway, awesome work, exposed a quite strange race and makes us re-think
>>> the base of qgroup reserve space framework.
>>
>> Thanks.
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


