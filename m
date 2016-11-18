Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36397 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750866AbcKRCmc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 21:42:32 -0500
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
To: Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        <linux-btrfs@vger.kernel.org>, <kreijack@libero.it>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <20161117231310.GN21290@hungrycats.org>
 <e1f1b582-78b6-ec53-81ca-f9917a346d71@cn.fujitsu.com>
 <20161118015646.GZ16645@carfax.org.uk>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <accaf5fe-431b-ffe7-8415-656a4d5c012b@cn.fujitsu.com>
Date: Fri, 18 Nov 2016 10:42:23 +0800
MIME-Version: 1.0
In-Reply-To: <20161118015646.GZ16645@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/18/2016 09:56 AM, Hugo Mills wrote:
> On Fri, Nov 18, 2016 at 09:19:11AM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/18/2016 07:13 AM, Zygo Blaxell wrote:
>>> On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
>>>> Fix the so-called famous RAID5/6 scrub error.
>>>>
>>>> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
>>>> sight.
>>>> (Yes, without the Phoronix report on this,
>>>> https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
>>>> I won't ever be aware of it)
>>>
>>> If you're hearing about btrfs RAID5 bugs for the first time through
>>> Phoronix, then your testing coverage is *clearly* inadequate.
>>
>> I'm not fixing everything, I'm just focusing on the exact one bug
>> reported by Goffredo Baroncelli.
>>
>> Although it seems that, the bug reported by him is in fact two bugs.
>> One is race condition I'm fixing, another one is that recovery is
>> recovering data correctly, but screwing up parity.
>>
>> I just don't understand why you always want to fix everything in one step.
>
>    Fix the important, fundamental things first, and the others
> later. This, from my understanding of Zygo's comments, appears to be
> one of the others.
>
>    It's papering over the missing bricks in the wall instead of
> chipping out the mortar and putting new bricks in. It may need to be
> fixed, but it's not the fundamental "OMG, everything's totally broken"
> problem. If anything, it's only a serious problem *because* the other
> thing (write hole) is still there.
>
>    It just seems like a piece of mis-prioritised effort.

It seems that, we have different standards on the priority.

For me, if some function on the very basic/minimal environment can't 
work reliably, then it's a high priority bug.

In this case, in a very minimal setup, with only 128K data spreading on 
3 devices RAID5. With a data stripe fully corrupted, without any other 
thing interfering.
Scrub can't return correct csum error number and even cause false 
unrecoverable error, then it's a high priority thing.

If the problem involves too many steps like removing devices, degraded 
mode, fsstress and some time. Then it's not that priority unless one 
pin-downs the root case to, for example, degraded mode itself with 
special sequenced operations.

Yes, in fact sometimes our developers are fixing such bug at high 
priority, but that's because other part has no such obvious problem.
But if we have obvious and easy to reproduce bug, then we should start 
from that.

So I don't consider the problem Zygo written is a high priority problem.

>
>>> Fill up a RAID5 array, start a FS stress test, pull a drive out while
>>> that's running, let the FS stress test run for another hour, then try
>>> to replace or delete the missing device.  If there are any crashes,
>>> corruptions, or EIO during any part of this process (assuming all the
>>> remaining disks are healthy), then btrfs RAID5 is still broken, and
>>> you've found another bug to fix.
>>
>> Then it will be another bug to fix, not the bug I'm fixing.
>> Unless you can prove whatever the bug is, is relating to the fix, I
>> don't see any help then.
>>
>>>
>>> The fact that so many problems in btrfs can still be found this way
>>> indicates to me that nobody is doing this basic level of testing
>>> (or if they are, they're not doing anything about the results).
>>>
>>>> Unlike many of us(including myself) assumed, it's not a timed bomb buried
>>>> deeply into the RAID5/6 code, but a race condition in scrub recovery
>>>> code.
>>>
>>> I don't see how this patch fixes the write hole issue at the core of
>>> btrfs RAID56.  It just makes the thin layer of bugs over that issue a
>>> little thinner.  There's still the metadata RMW update timebomb at the
>>> bottom of the bug pile that can't be fixed by scrub (the filesystem is
>>> unrecoverably damaged when the bomb goes off, so scrub isn't possible).
>>
>> Not "the core of btrfs RAID56", but "the core of all RAID56".
>>
>> And, this is just another unrelated problem, I didn't even want to
>> repeat what I've written.
>
>    That's the one that needs fixing *first*, though. (IMO, YMMV,
> Contents may have settled in transit).

And forget to mention, we don't even have an idea on how to fix the 
generic RAID56 RMW problem, even for mdadm RAID56.

BTW, for mdadm RAID56, they just scrub the whole array after every power 
loss, we could just call user to do that, and btrfs csum can assist 
scrub to do a better job than mdadm raid56.

Although, we must make sure btrfs scrub on raid56 won't cause false 
alert(the patchset) and no screwed up parity(I'll fix soon) first.

Thanks,
Qu

>
>    Hugo.
>
>> Thanks,
>> Qu
>>
>>>
>>>> The problem is not found because normal mirror based profiles aren't
>>>> affected by the race, since they are independent with each other.
>>>
>>> True.
>>>
>>>> Although this time the fix doesn't affect the scrub code much, it should
>>>> warn us that current scrub code is really hard to maintain.
>>>
>>> This last sentence is true.  I found and fixed three BUG_ONs in RAID5
>>> code on the first day I started testing in degraded mode, then hit
>>> the scrub code and had to give up.  It was like a brick wall made out
>>> of mismatched assumptions and layering inversions, using uninitialized
>>> kernel data as mortar (though I suppose the "uninitialized" data symptom
>>> might just have been an unprotected memory access).
>>>
>>>> Abuse of workquque to delay works and the full fs scrub is race prone.
>>>>
>>>> Xfstest will follow a little later, as we don't have good enough tools
>>>> to corrupt data stripes pinpointly.
>>>>
>>>> Qu Wenruo (2):
>>>>  btrfs: scrub: Introduce full stripe lock for RAID56
>>>>  btrfs: scrub: Fix RAID56 recovery race condition
>>>>
>>>> fs/btrfs/ctree.h       |   4 ++
>>>> fs/btrfs/extent-tree.c |   3 +
>>>> fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>> 3 files changed, 199 insertions(+)
>>>>
>


