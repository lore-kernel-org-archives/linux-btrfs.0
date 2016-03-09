Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:48458 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbcCIAON (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 19:14:13 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 53C8FAC014E
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 09:14:03 +0900 (JST)
Subject: Re: Btrfsck memory usage reduce idea
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <56DD14B6.4070908@cn.fujitsu.com>
 <56DE8D1D.5050504@jp.fujitsu.com> <56DE9171.8040309@cn.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DF6AC2.3050207@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 09:13:54 +0900
MIME-Version: 1.0
In-Reply-To: <56DE9171.8040309@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/08 17:46, Qu Wenruo wrote:
>
> Satoru Takeuchi wrote on 2016/03/08 17:28 +0900:
>> Hi Qu,
>>
>> On 2016/03/07 14:42, Qu Wenruo wrote:
>>> Hi,
>>>
>>> As many have already known, "btrfs check" is a memory eater.
>>>
>>> The problem is, btrfsck checks extent tree in a very comprehensive
>>> method.
>>> 1) Create extent_ref for each extent item with backref
>>> 2) Iterate all other trees to add extent ref
>>> 3) If one extent_ref with all ref/backref matches, it's deleted.
>>>
>>> The method is good, can found any extent mismatch problem when
>>> checking extent tree. (Although it has already iterated the whole fs)
>>> For a large enough filesystem, it may have tegas of extents, and
>>> memory is easy eaten up.
>>>
>>>
>>> We hope to fix it in the following method:
>>> 1) Only check extent backref when iterating extent tree
>>>     Unlike current implement, we check one extent item and its backref
>>>     only.
>>>
>>>     If one backref can't be reached, then it's an error and output (or
>>>     try to fix).
>>>     After iterating all backref of an extent item, all related memory is
>>>     freed and we won't bother recording anything for later use.
>>>
>>>     That's to say, we only care backref mismatch case when checking
>>>     extent tree.
>>>     Case like missing EXTENT_ITEM for some extent is not checked here.
>>>
>>> 2) Check extent ref while iterating other trees
>>>     We only check forward-ref while iterating one tree.
>>>
>>>     In this step, we only check forward-ref, so we can find the remaining
>>>     problem like missing EXTENT_ITEM for given extent.
>>>
>>> Any further advice/suggestion? Or is there anyone already doing such
>>> work?
>>
>> Thank you for your effort. I have basic questions.
>>
>> 1. Could you tell me what you'd like to do?
>>
>>     a) Provide completely the same function with current
>>        implementation by other, more efficient way.
>
> Same function, but less efficient.
> It may takes longer time, more IO, but less memory.

I see.

>
> And some error message will be output at different time.
> E.g, error message for missing backref may be output at fs tree checking time, instead of extent tree checking time.

It's OK if, finally, all error messages the same as the current
implementation are shown.

>
>>     b) Replace the current implementation with the quicker
>>        one that provides the limited function.
>>     c) Any other
>>
>> 2. Do you have the estimation that how long does the
>>     new algorithm take compare with the current one?
>
> Depends on the fs hierarchy. But in all case, IO will be more than original implement.
>
> The most efficient case would be, one subvolume and no dedup file.
> (which means one file extent refer to one extent on data, no in-band or
> out-band dedup).
>
> In that case, old implement will iterate the whole metadata twice,
> and new implement will iterate the whole metadata twice + extra.
>
> For worst case, like inband dedup with multiple almost identical snapshot,
 > things will be much much slower, more IO, more tree search, maybe O(n^2)
 > or more. But memory usage should not be much different though.
>
> In short, use more IO to trade for memory.
>
> Anyway, for a large fs, it won't be possible to take a short time for a comprehensive fsck.

Got it.

Thanks,
Satoru

>
> Thanks,
> Qu
>
>>     # Of course, "currently not sure" is OK at this stage.
>>
>>     I'm interested in it because there is the trade-off
>>     between speed and memory consumption in many case,
>>     and btrfsck takes very long time with a large filesystem.
>>
>> Thanks,
>> Satoru
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
