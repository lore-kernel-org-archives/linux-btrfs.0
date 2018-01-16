Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:46728 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPM5p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 07:57:45 -0500
Received: by mail-io0-f175.google.com with SMTP id f34so11426314ioi.13
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jan 2018 04:57:45 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Chris Murphy <lists@colorremedies.com>, Tom Worster <fsb@thefsb.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
 <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
 <3BF0F2D0-AC05-4EF9-A159-7DBF5A42A79C@thefsb.org>
 <CAJCQCtSKhpLPu_YtbLNEjd82fwgqN+5w=GZociXhJacOQbCjZw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <88164eee-ead2-e6a3-9d6a-aeb0803466db@gmail.com>
Date: Tue, 16 Jan 2018 07:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSKhpLPu_YtbLNEjd82fwgqN+5w=GZociXhJacOQbCjZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-16 01:45, Chris Murphy wrote:
> On Mon, Jan 15, 2018 at 11:23 AM, Tom Worster <fsb@thefsb.org> wrote:
>> On 13 Jan 2018, at 17:09, Chris Murphy wrote:
>>
>>> On Fri, Jan 12, 2018 at 11:24 AM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>
>>>> To that end, I propose the following text for the FAQ:
>>>>
>>>> Q: Do I need to run a balance regularly?
>>>>
>>>> A: While not strictly necessary for normal operations, running a filtered
>>>> balance regularly can help prevent your filesystem from ending up with
>>>> ENOSPC issues.  The following command run daily on each BTRFS volume
>>>> should
>>>> be more than sufficient for most users:
>>>>
>>>> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`
>>>
>>> Daily? Seems excessive.
>>>
>>> I've got multiple Btrfs file systems that I haven't balanced, full or
>>> partial, in a year. And I have no problems. One is a laptop which
>>> accumulates snapshots until roughly 25% free space remains and then
>>> most of the snapshots are deleted, except the most recent few, all at
>>> one time. I'm not experiencing any problems so far. The other is a NAS
>>> and it's multiple copies, with maybe 100-200 snapshots. One backup
>>> volume is 99% full, there's no more unallocated free space, I delete
>>> snapshots only to make room for btrfs send receive to keep pushing the
>>> most recent snapshot from the main volume to the backup. Again no
>>> problems.
>>>
>>> I really think suggestions this broad are just going to paper over
>>> bugs or design flaws, we won't see as many bug reports and then real
>>> problems won't get fixed.
>>
>> This is just an answer to a FAQ. This is not Austin or anyone else trying to
>> telling you or anyone else that you should do this. It should be clear that
>> there is an implied caveat along the lines of: "There are other ways to
>> manage allocation besides regular balancing. This recommendation is a
>> For-Dummies-kinda default that should work well enough if you don't have
>> another strategy better adapted to your situation." If this implication is
>> not obvious enough then we can add something explicit.
> 
> It's an upstream answer to a frequently asked question. It's rather
> official, or about as close as it gets to it.
> 
>>
>>> I also thing the time based method is too subjective. What about the
>>> layout means a balance is needed? And if it's really a suggestion, why
>>> isn't there a chron or systemd unit that just does this for the user,
>>> in btrfs-progs, working and enabled by default?
>>
>> As a newcomer to BTRFS, I was astonished to learn that it demands each user
>> figure out some workaround for what is, in my judgement, a required but
>> missing feature, i.e. a defect, a bug. At present the docs are pretty
>> confusing for someone trying to deal with it on their own.
>>
>> Unless some better fix is in the works, this _should_ be a systemd unit or
>> something. Until then, please put it in FAQ.
> 
> At least openSUSE has a systemd unit for a long time now, but last
> time I checked (a bit over a year ago) it's disabled by default. Why?
> 
> And insofar as I'm aware, openSUSE users aren't having big problems
> related to lack of balancing, they have problems due to the lack of
> balancing combined with schizo snapper defaults, which are these days
> masked somewhat by turning on quotas so snapper can be more accurate
> about cleaning up.
And in turn causing other issues because of the quotas, but that's 
getting OT...
> 
> Basically the scripted balance tells me two things:
> a. Something is broken (still)
> b. None of the developers has time to investigate coherent bug reports
> about a. and fix/refine it.
I don't entirely agree here.  The issue is essentially inherent in the 
very design of the two-stage allocator itself, so it's not really 
something that can just be fixed by some simple surface patch.  The only 
real options I see to fix it are either:
1. Redesign the allocator
or:
2. figure out some way to handle this generically and automatically.

The first case is pretty much immediately out because it will almost 
certainly require a breaking change in the on-disk format.  The second 
is extremely challenging to do right, and likely to cause some 
significant controversy among list regulars (I for one don't want the FS 
doing stuff behind my back that impacts performance, and I have a 
feeling that quite a lot of other people here don't either).

Given that, I would say time is only a (probably small) part of it. 
This is not an easy thing to fix given the current situation, and 
difficult problems tend to sit around with no progress for very long 
periods of time in open source development.
> 
> And therefore papering over the problem is all we have. Basically it's
> a sledgehammer approach.
How exactly is this any different than requiring a user to manually 
scrub things to check data that's not being actively used?  Or requiring 
manual invocation of defragmentation?  Or even batch deduplication?

All of those are manually triggered solutions to 'problems' with the 
filesystem, just like this is.  The only difference is that people are 
used to needing to manually defrag disks, and reasonably used to the 
need for manual scrubs (and don't seem to care much about dedupe), while 
doing something like this to keep the allocator happy is absolutely 
alien to them (despite being no different conceptually in that respect 
from defrag, just operating at a different level).
> 
> The main person working on enoscp stuff is Josef so I'd run this by
> him and make sure this papering over bugs is something he agrees with.
I agree that Josef's input would be nice to have, as he really does 
appear to be the authority on this type of thing.

I would also love to hear from someone at Facebook about their 
experience with this type of thing, as they probably have the largest 
current deployment of BTRFS around.
> 
>>
>>> I really do not like
>>> all this hand holding of Btrfs, it's not going to make it better.
>>
>> Maybe it won't but, absent better proposals, and given the nature of the
>> problem, this kind of hand-holding is only fair to the user.
> 
> This is hardly the biggest gotcha with Btrfs. I'm fine with the idea
> of papering over design flaws and long standing bugs with user space
> work arounds. I just want everyone on the same page about it, so it's
> not some big surprise it's happening. As far as I know, none of the
> developers regularly looks at the Btrfs wiki.
> 
> And I think the best way of communicating:
> a. this is busted, and it sucks
> b. here's a proposed user space work around, so users aren't so pissed off.
> 
> Is to try and get it into btrfs-progs, and enabled by default, because
> that will get in front of at least one developer.
Maybe it's time someone writes up a BCP document and includes that as a 
man page bundled with btrfs-progs?  That would get much better developer 
visibility, would be much easier to keep current, and would probably 
cover the biggest issue with our documentation currently (it's great for 
technical people, but somewhat horrendous for new users without 
technical background).  We've already essentially got the beginnings of 
such a document between the FAQ and the Gotcha's page on the wiki.
