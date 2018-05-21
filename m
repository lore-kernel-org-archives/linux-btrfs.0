Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:33220 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbeEUTWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 15:22:01 -0400
Received: by mail-it0-f46.google.com with SMTP id e185-v6so9460701ita.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 12:22:01 -0700 (PDT)
Subject: Re: Any chance to get snapshot-aware defragmentation?
To: dsterba@suse.cz,
        =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org, gotar@polanet.pl
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <20180521174331.GZ6649@suse.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <61aa1fea-7d07-4f0b-f177-340971106df1@gmail.com>
Date: Mon, 21 May 2018 15:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <20180521174331.GZ6649@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-21 13:43, David Sterba wrote:
> On Fri, May 18, 2018 at 01:10:02PM -0400, Austin S. Hemmelgarn wrote:
>> On 2018-05-18 12:36, Niccolò Belli wrote:
>>> On venerdì 18 maggio 2018 18:20:51 CEST, David Sterba wrote:
>>>> Josef started working on that in 2014 and did not finish it. The patches
>>>> can be still found in his tree. The problem is in excessive memory
>>>> consumption when there are many snapshots that need to be tracked during
>>>> the defragmentation, so there are measures to avoid OOM. There's
>>>> infrastructure ready for use (shrinkers), there are maybe some problems
>>>> but fundamentally is should work.
>>>>
>>>> I'd like to get the snapshot-aware working again too, we'd need to find
>>>> a volunteer to resume the work on the patchset.
>>>
>>> Yeah I know of Josef's work, but 4 years had passed since then without
>>> any news on this front.
>>>
>>> What I would really like to know is why nobody resumed his work: is it
>>> because it's impossible to implement snapshot-aware degram without
>>> excessive ram usage or is it simply because nobody is interested?
>> I think it's because nobody who is interested has both the time and the
>> coding skills to tackle it.
>>
>> Personally though, I think the biggest issue with what was done was not
>> the memory consumption, but the fact that there was no switch to turn it
>> on or off.  Making defrag unconditionally snapshot aware removes one of
>> the easiest ways to forcibly unshare data without otherwise altering the
>> files (which, as stupid as it sounds, is actually really useful for some
>> storage setups), and also forces the people who have ridiculous numbers
>> of snapshots to deal with the memory usage or never defrag.
> 
> Good points. The logic of the sharing-aware is a technical detail,
> what's being discussed is the usecase and I think this would be good to
> clarify.
> 
> 1) always -- the old (and now disabled) way, unconditionally (ie. no
>     option for the user), problems with memory consumption
> 
> 2) more fine grained:
> 
> 2.1) defragment only the non-shared extents, ie. no sharing awareness
>       needed, shared extents will be silently skipped
> 
> 2.2) defragment only within the given subvolume -- like 1) but by user's choice
> 
> The naive dedup, that Tomasz (CCed) mentions in another mail, would be
> probably beyond the defrag purpose and would make things more
> complicated.
> 
> I'd vote for keeping complexity of the ioctl interface and defrag
> implementation low, so if it's simply saying "do forcible defrag" or
> "skip shared", then it sounds ok.
> 
> If there's eg. "keep sharing only on this <list> subvolunes", then it
> would need to read the snapshot ids from ioctl structure, then enumerate
> all extent owners and do some magic to unshare/defrag/share. That's a
> quick idea, lots of details would need to be clarified.
> 
 From my perspective, I see two things to consider that are somewhat 
orthogonal to each other:

1. Whether to recurse into subvolumes or not (IIRC, we currently do not 
do so, because we see them like a mount point).
2. Whether to use the simple (not reflink-aware) defrag, the reflink 
aware one, or to base it on the extent/file type (use old simpler one 
for unshared extents, and new reflink aware one for shared extents).

This second set of options is what I'd like to see the most (possibly 
without the option to base it on file or extent sharing automatically), 
though the first one would be nice to have.

Better yet, having that second set of options and making the new 
reflink-aware defrag opt-in would allow people who really want it to use 
it, and those of us who don't need it for our storage setups to not need 
to worry about it.
