Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbaLXAlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 19:41:52 -0500
Message-ID: <549A0BCD.9080208@cn.fujitsu.com>
Date: Wed, 24 Dec 2014 08:41:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: How btrfs-find-root knows that the block is actually a root?
References: <CAOcd+r2_CkP7wiU3OETxhdVtkTpZYiz0GxSx7BDEsFU6H+0_RQ@mail.gmail.com>	<5498FD52.6050807@cn.fujitsu.com> <CAOcd+r3bsi=6Yf8ru4XgzQc4GmrOyVUMLBK=+8LxgYKeuN2EKA@mail.gmail.com>
In-Reply-To: <CAOcd+r3bsi=6Yf8ru4XgzQc4GmrOyVUMLBK=+8LxgYKeuN2EKA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: How btrfs-find-root knows that the block is actually a root?
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月23日 18:08
> Hi Qu,
>
> On Tue, Dec 23, 2014 at 7:27 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> -------- Original Message --------
>> Subject: How btrfs-find-root knows that the block is actually a root?
>> From: Alex Lyakas <alex.btrfs@zadarastorage.com>
>> To: linux-btrfs <linux-btrfs@vger.kernel.org>
>> Date: 2014年12月22日 22:57
>>> Greetings,
>>>
>>> I am looking at the code of search_iobuf() in
>>> btrfs-find-root.c.(3.17.3)  I see that we probe nodesize blocks one by
>>> one, and for each block we check:
>>> - its owner is what we are looking for
>>> - its header->bytenr is what we are looking at currently
>>> - its level is not too small
>>> - it has valid checksum
>>> - it has the desired generation
>>>
>>> If all those conditions are true, we declare this block as a root and
>>> end the program.
>>>
>>> How do we actually know that it's a root and not a leaf or an
>>> intermediate node? What if we are searching for a root of the root
>>> tree, which has one node and two leafs (all have the same highest
>>> transid), and one of the leafs has "logical" lower than the actual
>>> root, i.e., it comes first in our scan. Then we will declare this leaf
>>> as a root, won't we? Or somehow the root always has the lowest
>>> "logical"?
>> You can refer to this patch:
>> https://patchwork.kernel.org/patch/5285521/
> I see that this has not been applied to any of David's branches. Do
> you have a repo to look at this code in its entirety?
Saddly, no personal repo...
>
>> Your questions are mostly right.
>> The best method should be search through all the metadata, and only the
>> highest level header for
>> a given generation may be the root for that generation.
>>
>> But that method still has some problems.
>> 1) Overwritten old node/leaf
>> As btrfs metadata cow happens, old node/leaf may be overwritten and become
>> incompletely,
>> so above method won't always work as expected.
>>
>> 2) Corrupted fs
>> That will makes everything not work as expected.
>> But sadly, when someone needs to use btrfs-find-root, there is a high
>> possibility the fs is already corrupted.
>>
>> 3) Slow speed
>> It needs to scan over all the sectors of metadata chunks, it may var from
>> megabytese to tegabytes,
>> which makes the complete scan impractical.
>> So current find-root uses a trade-off, if find a header at the position
>> superblock points to, and generation
>> matches, then just consider it as the desired root and exit.
> I think this is a bit optimistic. What if the root tree has several
> leaves having the same generation as the root? Then we might declare a
> leaf as a root and exit. But further recovery based on that output
> will get us into trouble.
That's right, but if btrfs-find-root takes several hours each time to do 
full scan, most user will be crazy...
Especially when it is executed on a clean btrfs.

>
>>> Also, I am confused by this line:
>>> level = h_level;
>>> This means that if we encounter a block that "seems good", we will
>>> skip all other blocks that have lower level. Is this intended?
>> This is intended, for case user already know the root's level, so it will
>> skip any header whose level is below it.
> But this line is performed before the generation check. Let's say that
> user did not specify any level (so search_level==0). Then assume we
> encounter a block, which has lower generation than what we need, but
> higher level. At this point, we do
> level = h_level;
> and we will skip any blocks lower than this level from now on. What if
> the root tree got shirnked (due to subvolume deletion, for example),
> and the "good" root has lower level? We will skip it then, and will
> not find the root.
>
> Thanks for your comments,
> Alex.
Oh, I misunderstand your meaning, you're completely right, the original 
codes will skip any level
lower than current found.
That's deadly for root with higher generation but with lower level, as 
you mentioned, item delete.

So the best method would be only skip leaf/node whose level is lower 
than current found highest
level *among the same generation*.
Oh, that's what I do in my patch. :-)

Thanks,
Qu
>
>
>> Thanks,
>> Qu
>>>
>>> Thanks,
>>> Alex.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

