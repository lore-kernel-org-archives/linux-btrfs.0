Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:34853 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAPGpd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Jan 2018 01:45:33 -0500
Received: by mail-ot0-f178.google.com with SMTP id 53so12717061otj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 22:45:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3BF0F2D0-AC05-4EF9-A159-7DBF5A42A79C@thefsb.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com> <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
 <3BF0F2D0-AC05-4EF9-A159-7DBF5A42A79C@thefsb.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 15 Jan 2018 23:45:31 -0700
Message-ID: <CAJCQCtSKhpLPu_YtbLNEjd82fwgqN+5w=GZociXhJacOQbCjZw@mail.gmail.com>
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Tom Worster <fsb@thefsb.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 15, 2018 at 11:23 AM, Tom Worster <fsb@thefsb.org> wrote:
> On 13 Jan 2018, at 17:09, Chris Murphy wrote:
>
>> On Fri, Jan 12, 2018 at 11:24 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>
>>> To that end, I propose the following text for the FAQ:
>>>
>>> Q: Do I need to run a balance regularly?
>>>
>>> A: While not strictly necessary for normal operations, running a filtered
>>> balance regularly can help prevent your filesystem from ending up with
>>> ENOSPC issues.  The following command run daily on each BTRFS volume
>>> should
>>> be more than sufficient for most users:
>>>
>>> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`
>>
>>
>>
>> Daily? Seems excessive.
>>
>> I've got multiple Btrfs file systems that I haven't balanced, full or
>> partial, in a year. And I have no problems. One is a laptop which
>> accumulates snapshots until roughly 25% free space remains and then
>> most of the snapshots are deleted, except the most recent few, all at
>> one time. I'm not experiencing any problems so far. The other is a NAS
>> and it's multiple copies, with maybe 100-200 snapshots. One backup
>> volume is 99% full, there's no more unallocated free space, I delete
>> snapshots only to make room for btrfs send receive to keep pushing the
>> most recent snapshot from the main volume to the backup. Again no
>> problems.
>>
>> I really think suggestions this broad are just going to paper over
>> bugs or design flaws, we won't see as many bug reports and then real
>> problems won't get fixed.
>
>
> This is just an answer to a FAQ. This is not Austin or anyone else trying to
> telling you or anyone else that you should do this. It should be clear that
> there is an implied caveat along the lines of: "There are other ways to
> manage allocation besides regular balancing. This recommendation is a
> For-Dummies-kinda default that should work well enough if you don't have
> another strategy better adapted to your situation." If this implication is
> not obvious enough then we can add something explicit.

It's an upstream answer to a frequently asked question. It's rather
official, or about as close as it gets to it.



>
>
>> I also thing the time based method is too subjective. What about the
>> layout means a balance is needed? And if it's really a suggestion, why
>> isn't there a chron or systemd unit that just does this for the user,
>> in btrfs-progs, working and enabled by default?
>
>
> As a newcomer to BTRFS, I was astonished to learn that it demands each user
> figure out some workaround for what is, in my judgement, a required but
> missing feature, i.e. a defect, a bug. At present the docs are pretty
> confusing for someone trying to deal with it on their own.
>
> Unless some better fix is in the works, this _should_ be a systemd unit or
> something. Until then, please put it in FAQ.

At least openSUSE has a systemd unit for a long time now, but last
time I checked (a bit over a year ago) it's disabled by default. Why?

And insofar as I'm aware, openSUSE users aren't having big problems
related to lack of balancing, they have problems due to the lack of
balancing combined with schizo snapper defaults, which are these days
masked somewhat by turning on quotas so snapper can be more accurate
about cleaning up.

Basically the scripted balance tells me two things:
a. Something is broken (still)
b. None of the developers has time to investigate coherent bug reports
about a. and fix/refine it.

And therefore papering over the problem is all we have. Basically it's
a sledgehammer approach.

The main person working on enoscp stuff is Josef so I'd run this by
him and make sure this papering over bugs is something he agrees with.




>
>
>> I really do not like
>> all this hand holding of Btrfs, it's not going to make it better.
>
>
> Maybe it won't but, absent better proposals, and given the nature of the
> problem, this kind of hand-holding is only fair to the user.


This is hardly the biggest gotcha with Btrfs. I'm fine with the idea
of papering over design flaws and long standing bugs with user space
work arounds. I just want everyone on the same page about it, so it's
not some big surprise it's happening. As far as I know, none of the
developers regularly looks at the Btrfs wiki.

And I think the best way of communicating:
a. this is busted, and it sucks
b. here's a proposed user space work around, so users aren't so pissed off.

Is to try and get it into btrfs-progs, and enabled by default, because
that will get in front of at least one developer.



-- 
Chris Murphy
