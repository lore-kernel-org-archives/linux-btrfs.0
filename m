Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62668 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbcKRG2M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 01:28:12 -0500
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <20161117231310.GN21290@hungrycats.org>
 <e1f1b582-78b6-ec53-81ca-f9917a346d71@cn.fujitsu.com>
 <20161118015646.GZ16645@carfax.org.uk>
 <accaf5fe-431b-ffe7-8415-656a4d5c012b@cn.fujitsu.com>
 <20161118044307.GA8685@hungrycats.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        kreijack@libero.it
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c38da10b-2fe3-9a25-d8f2-64371ffd5e77@gmx.com>
Date: Fri, 18 Nov 2016 14:27:42 +0800
MIME-Version: 1.0
In-Reply-To: <20161118044307.GA8685@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/18/2016 12:43 PM, Zygo Blaxell wrote:
> On Fri, Nov 18, 2016 at 10:42:23AM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/18/2016 09:56 AM, Hugo Mills wrote:
>>> On Fri, Nov 18, 2016 at 09:19:11AM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> At 11/18/2016 07:13 AM, Zygo Blaxell wrote:
>>>>> On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
>>>>>> Fix the so-called famous RAID5/6 scrub error.
>>>>>>
>>>>>> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
>>>>>> sight.
>>>>>> (Yes, without the Phoronix report on this,
>>>>>> https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
>>>>>> I won't ever be aware of it)
>>>>>
>>>>> If you're hearing about btrfs RAID5 bugs for the first time through
>>>>> Phoronix, then your testing coverage is *clearly* inadequate.
>>>>
>>>> I'm not fixing everything, I'm just focusing on the exact one bug
>>>> reported by Goffredo Baroncelli.
>>>>
>>>> Although it seems that, the bug reported by him is in fact two bugs.
>>>> One is race condition I'm fixing, another one is that recovery is
>>>> recovering data correctly, but screwing up parity.
>>>>
>>>> I just don't understand why you always want to fix everything in one step.
>>>
>>>   Fix the important, fundamental things first, and the others
>>> later. This, from my understanding of Zygo's comments, appears to be
>>> one of the others.
>>>
>>>   It's papering over the missing bricks in the wall instead of
>>> chipping out the mortar and putting new bricks in. It may need to be
>>> fixed, but it's not the fundamental "OMG, everything's totally broken"
>>> problem. If anything, it's only a serious problem *because* the other
>>> thing (write hole) is still there.
>>>
>>>   It just seems like a piece of mis-prioritised effort.
>>
>> It seems that, we have different standards on the priority.
>
> My concern isn't priority.  Easier bugs often get fixed first.  That's
> just the way Linux development works.
>
> I am very concerned by articles like this:
>
> 	http://phoronix.com/scan.php?page=news_item&px=Btrfs-RAID5-RAID6-Fixed
>
> with headlines like "btrfs RAID5/RAID6 support is finally fixed" when
> that's very much not the case.  Only one bug has been removed for the
> key use case that makes RAID5 interesting, and it's just the first of
> many that still remain in the path of a user trying to recover from a
> normal disk failure.
>
> Admittedly this is Michael's (Phoronix's) problem more than Qu's, but
> it's important to always be clear and _complete_ when stating bug status
> because people quote statements out of context.  When the article quoted
> the text
>
> 	"it's not a timed bomb buried deeply into the RAID5/6 code,
> 	but a race condition in scrub recovery code"
>
> the commenters on Phoronix are clearly interpreting this to mean "famous
> RAID5/6 scrub error" had been fixed *and* the issue reported by Goffredo
> was the time bomb issue.  It's more accurate to say something like
>
> 	"Goffredo's issue is not the time bomb buried deeply in the
> 	RAID5/6 code, but a separate issue caused by a race condition
> 	in scrub recovery code"
>
> Reading the Phoronix article, one might imagine RAID5 is now working
> as well as RAID1 on btrfs.  To be clear, it's not--although the gap
> is now significantly narrower.
>
>> For me, if some function on the very basic/minimal environment can't work
>> reliably, then it's a high priority bug.
>>
>> In this case, in a very minimal setup, with only 128K data spreading on 3
>> devices RAID5. With a data stripe fully corrupted, without any other thing
>> interfering.
>> Scrub can't return correct csum error number and even cause false
>> unrecoverable error, then it's a high priority thing.
>
>> If the problem involves too many steps like removing devices, degraded mode,
>> fsstress and some time. Then it's not that priority unless one pin-downs the
>> root case to, for example, degraded mode itself with special sequenced
>> operations.
>
> There are multiple bugs in the stress + remove device case.  Some are
> quite easy to isolate.  They range in difficulty from simple BUG_ON
> instead of error returns to finally solving the RMW update problem.
>
> Run the test, choose any of the bugs that occur to work on, repeat until
> the test stops finding new bugs for a while.  There are currently several
> bugs to choose from with various levels of difficulty to fix them, and you
> should hit the first level of bugs in a matter of hours if not minutes.
>
> Using this method, you would have discovered Goffredo's bug years ago.
> Instead, you only discovered it after Phoronix quoted the conclusion
> of an investigation that started because of problems I reported here on
> this list when I discovered half a dozen of btrfs's critical RAID5 bugs
> from analyzing *one* disk failure event.

Nope, I don't want to touch anything related to degraded mode if any 
fundamental function is broken, and the bug Goffredo reported has 
nothing to do with any steps you mentioned.

How I find the problem is never related to the bug fix.
Yeah, I found it in Phoronix or whatever other source, then does it have 
anything related to the fix?

You can continue your test or fix or report. But that has nothing 
related to the problem I'm fixing.

Write the blahblah in another thread or open it as BZ, you are not 
helping reviewing the bug but showing off how quickly you find a bug.

I'm already frustrated of your complain about words like "you could have 
found the problem years ago".

This is never a fair thing to be blamed for just fixing a bug that one 
guy reported earlier.

>
>> Yes, in fact sometimes our developers are fixing such bug at high priority,
>> but that's because other part has no such obvious problem.
>> But if we have obvious and easy to reproduce bug, then we should start from
>> that.
>
> To be able to use a RAID5 in production it must be possible to recover
> from one normal disk failure without being stopped by *any* bug in
> most cases.  Until that happens, users should be aware that recovery
> doesn't work yet.
>
>> So I don't consider the problem Zygo written is a high priority problem.
>
> I really don't care about the order the bugs get fixed.  Just please
> don't say (or even suggest through omission) that you've fixed the
> *last* one until you can pass a test based on typical failure modes
> users will experience.

I never think RAID5/6 is stable and will never use it(in fact, the whole 
btrfs, in any of my working boxes).
If you think I'm expressing thing like whatever you think, that's just 
your misunderstanding.

Thanks,
Qu

>
>> And forget to mention, we don't even have an idea on how to fix the generic
>> RAID56 RMW problem, even for mdadm RAID56.
>
> It can be solved in the extent allocator if we can adjust it to prevent
> allocation patterns that result in RMW writes.  Btrfs CoW logic will
> take care of the rest.  I've written about this already on this list.
>
>> BTW, for mdadm RAID56, they just scrub the whole array after every power
>> loss, we could just call user to do that, and btrfs csum can assist scrub to
>> do a better job than mdadm raid56.
>
> mdadm did properly solve the RMW problem recently, so mdadm is currently
> ahead of btrfs.  Btrfs can even solve the RMW problem two different ways.
> One of these could massively outperform mdadm's brute-force solution.
>
>> Although, we must make sure btrfs scrub on raid56 won't cause false
>> alert(the patchset) and no screwed up parity(I'll fix soon) first.
>
> With a raid5 data + raid1 metadata array this would result in a tolerable
> level of data loss.  This is where I *thought* btrfs RAID5 was a year
> ago when I started using it (and eight months before I started *reading*
> the code), but the btrfs code at the time failed miserably when writing
> to block groups in degraded mode, and I had to patch the kernel to make
> any serious attempt at recovery at all.
>
>> Thanks,
>> Qu
>>
>>>
>>>   Hugo.
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>> The problem is not found because normal mirror based profiles aren't
>>>>>> affected by the race, since they are independent with each other.
>>>>>
>>>>> True.
>>>>>
>>>>>> Although this time the fix doesn't affect the scrub code much, it should
>>>>>> warn us that current scrub code is really hard to maintain.
>>>>>
>>>>> This last sentence is true.  I found and fixed three BUG_ONs in RAID5
>>>>> code on the first day I started testing in degraded mode, then hit
>>>>> the scrub code and had to give up.  It was like a brick wall made out
>>>>> of mismatched assumptions and layering inversions, using uninitialized
>>>>> kernel data as mortar (though I suppose the "uninitialized" data symptom
>>>>> might just have been an unprotected memory access).
>>>>>
>>>>>> Abuse of workquque to delay works and the full fs scrub is race prone.
>>>>>>
>>>>>> Xfstest will follow a little later, as we don't have good enough tools
>>>>>> to corrupt data stripes pinpointly.
>>>>>>
>>>>>> Qu Wenruo (2):
>>>>>> btrfs: scrub: Introduce full stripe lock for RAID56
>>>>>> btrfs: scrub: Fix RAID56 recovery race condition
>>>>>>
>>>>>> fs/btrfs/ctree.h       |   4 ++
>>>>>> fs/btrfs/extent-tree.c |   3 +
>>>>>> fs/btrfs/scrub.c       | 192 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>> 3 files changed, 199 insertions(+)
>>>>>>
>>>
>>
>>
>>
