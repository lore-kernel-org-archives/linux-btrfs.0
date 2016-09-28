Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:57700 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932179AbcI1MZj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 08:25:39 -0400
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
 <4f91af54-78ae-5c08-3daa-8a0c16210e5f@profihost.ag>
 <57EBB329.9060009@cn.fujitsu.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <8dfc4782-7f11-64d1-1e86-7aeebbfc4f17@profihost.ag>
Date: Wed, 28 Sep 2016 14:25:33 +0200
MIME-Version: 1.0
In-Reply-To: <57EBB329.9060009@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.09.2016 um 14:10 schrieb Wang Xiaoguang:
> hello,
> 
> On 09/28/2016 08:02 PM, Stefan Priebe - Profihost AG wrote:
>> Hi Xiaoguang Wang,
>>
>> Am 28.09.2016 um 13:35 schrieb Wang Xiaoguang:
>>> hello,
>>>
>>> On 09/28/2016 07:15 PM, Stefan Priebe - Profihost AG wrote:
>>>> Dear list,
>>>>
>>>> is there any chance anybody wants to work with me on the following
>>>> issue?
>>> Though I'm also somewhat new to btrfs, but I'd like to.
>>>
>>>> BTRFS: space_info 4 has 18446742286429913088 free, is not full
>>>> BTRFS: space_info total=98247376896, used=77036814336, pinned=0,
>>>> reserved=0, may_use=1808490201088, readonly=0
>>>>
>>>> i get this nearly every day.
>>>>
>>>> Here are some msg collected from today and yesterday from different
>>>> servers:
>>>> | BTRFS: space_info 4 has 18446742182612910080 free, is not full |
>>>> | BTRFS: space_info 4 has 18446742254739439616 free, is not full |
>>>> | BTRFS: space_info 4 has 18446743980225085440 free, is not full |
>>>> | BTRFS: space_info 4 has 18446743619906420736 free, is not full |
>>>> | BTRFS: space_info 4 has 18446743647369576448 free, is not full |
>>>> | BTRFS: space_info 4 has 18446742286429913088 free, is not full
>>>>
>>>> What i tried so far without success:
>>>> - use vanilla 4.8-rc8 kernel
>>>> - use latest vanilla 4.4 kernel
>>>> - use latest 4.4 kernel + patches from holger hoffstaette
>>>> - use clear_cache,space_cache=v2
>>>> - use clear_cache,space_cache=v1
>>>>
>>>> But all tries result in ENOSPC after a short period of time doing
>>>> backups.
>>> I also met enospc error in 4.8-rc6 when doing big files create and
>>> delete tests,
>>> for my cases, I have written some patches to fix it.
>>> Would you please apply my patches to have a try:
>>> btrfs: try to satisfy metadata requests when every flush_space() returns
>>> btrfs: try to write enough delalloc bytes when reclaiming metadata space
>>> btrfs: make shrink_delalloc() try harder to reclaim metadata space
>>> You can find them in btrfs mail list.
>> those are already in the patchset from holger:
>>
>> So i have these in my testing patchset (latest 4.4 kernel + patches from
>> holger hoffstaette):
>>
>> btrfs-20160921-try-to-satisfy-metadata-requests-when-every-flush_space()-returns.patch
>>
>>
>> btrfs-20160921-try-to-write-enough-delalloc-bytes-when-reclaiming-metadata-space.patch
>>
>>
>> btrfs-20160922-make-shrink_delalloc()-try-harder-to-reclaim-metadata-space.patch
>>
> OK, I see.
> But given that you often run into enospc errors, can you work out a
> reproduce
> script according to you work load. That will give us great help.

I already tried that but it wasn't working. It seems i need a test
device with +20TB and i need creating file that big in the tests. But
that isn't easy. Currently i've no test hardware that big. May be i
should try that on a production server.

Stefan

> Reagrds,
> Xiaoguang Wang
> 
>>
>> Greets,
>> Stefan
>>
>>> Regards,
>>> Xiaoguang Wang
>>>> Greets,
>>>> Stefan
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>>
>>
> 
> 
> 
