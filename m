Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54910 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751248AbcDOBRy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 21:17:54 -0400
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
To: <fdmanana@gmail.com>
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
 <pan$91701$3af360aa$c931211b$9c451328@cox.net>
 <CAL3q7H7zawdrwbnnwr4nRg5PTj3BqRjDpZJo+idxCANMs185LA@mail.gmail.com>
 <570F2BF0.2060409@cn.fujitsu.com>
 <CAL3q7H53zyb2QGE6__9eHmaah31ikZvUO9L78cK1eJ2bfD4nyQ@mail.gmail.com>
CC: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5710413D.6030505@cn.fujitsu.com>
Date: Fri, 15 Apr 2016 09:17:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H53zyb2QGE6__9eHmaah31ikZvUO9L78cK1eJ2bfD4nyQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/04/14 10:21 +0100:
> On Thu, Apr 14, 2016 at 6:34 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Ping?
>>
>> Cc: Chris and David
>>
>> It seems that this fix is missing in 4.6 merge window.
>> Or did I miss something?
>
> 4.5-rc7:  https://lkml.org/lkml/2016/3/4/695

Strangely, not in integration-4.6.

This makes me wonder which branch I should use now...

Thanks,
Qu

>
>>
>> Thanks,
>> Qu
>>
>>
>> Filipe Manana wrote on 2016/03/03 09:10 +0000:
>>>
>>> On Thu, Mar 3, 2016 at 4:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>>>
>>>> fdmanana posted on Wed, 02 Mar 2016 15:49:38 +0000 as excerpted:
>>>>
>>>>> When looking for orphan roots during mount we can end up hitting a
>>>>> BUG_ON() (at root-item.c:btrfs_find_orphan_roots()) if a log tree is
>>>>> replayed and qgroups are enabled.
>>>>
>>>>
>>>> This should hit 4.6, right?  Will it hit 4.5 before release?
>>>
>>>
>>> It's not the first time you do a similar question, and if it's
>>> targeted at me, all I can tell you is I don't know. It's the
>>> maintainers (Chris, Josef, David)  who decide when to pick patches and
>>> for which releases.
>>>
>>>>
>>>> Because I wasn't sure of current quota functionality status, but this bug
>>>> obviously resets the counter on my ongoing "two kernel cycles with no
>>>> known quota bugs before you try to use quotas" recommendation.
>>>
>>>
>>> You shouldn't spread such affirmation with such a level of certainty
>>> every time a user reports a problem.
>>> There are many bugs affecting the last 2 to 3 releases, but there are
>>> also many bugs present since btrfs was added to the linux kernel tree,
>>> and many others present for 2+ years, etc.
>>>
>>>>
>>>> Meanwhile, what /is/ current quota feature status?  Other than this bug,
>>>> is it now considered known bug free, or is more quota reworking and/or
>>>> bug fixing known to be needed for 4.6 and beyond?
>>>>
>>>> IOW, given that two release cycles no known bugs counter, are we
>>>> realistically looking at that being 4.8, or are we now looking at 4.9 or
>>>> beyond for reasonable quota stability?
>>>
>>>
>>> I don't know. I generally don't look actively look at qgroups, and I'm
>>> not a user either.
>>> You can only take conclusions based on user bug reports. Probably
>>> there aren't more bugs for qgroups than there are for send/receive or
>>> even non-btrfs specific features for example.
>>>
>>>>
>>>> --
>>>> Duncan - List replies preferred.   No HTML msgs.
>>>> "Every nonfree program has a lord, a master --
>>>> and if you use the program, he is your master."  Richard Stallman
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>
>>
>
>
>


