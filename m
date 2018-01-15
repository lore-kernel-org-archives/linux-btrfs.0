Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:56070 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751004AbeAOSbN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 13:31:13 -0500
From: "Tom Worster" <fsb@thefsb.org>
To: "Chris Murphy" <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Mon, 15 Jan 2018 13:23:05 -0500
Message-ID: <3BF0F2D0-AC05-4EF9-A159-7DBF5A42A79C@thefsb.org>
In-Reply-To: <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
 <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13 Jan 2018, at 17:09, Chris Murphy wrote:

> On Fri, Jan 12, 2018 at 11:24 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>
>> To that end, I propose the following text for the FAQ:
>>
>> Q: Do I need to run a balance regularly?
>>
>> A: While not strictly necessary for normal operations, running a 
>> filtered
>> balance regularly can help prevent your filesystem from ending up 
>> with
>> ENOSPC issues.  The following command run daily on each BTRFS volume 
>> should
>> be more than sufficient for most users:
>>
>> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 
>> -mlimit=2..10`
>
>
> Daily? Seems excessive.
>
> I've got multiple Btrfs file systems that I haven't balanced, full or
> partial, in a year. And I have no problems. One is a laptop which
> accumulates snapshots until roughly 25% free space remains and then
> most of the snapshots are deleted, except the most recent few, all at
> one time. I'm not experiencing any problems so far. The other is a NAS
> and it's multiple copies, with maybe 100-200 snapshots. One backup
> volume is 99% full, there's no more unallocated free space, I delete
> snapshots only to make room for btrfs send receive to keep pushing the
> most recent snapshot from the main volume to the backup. Again no
> problems.
>
> I really think suggestions this broad are just going to paper over
> bugs or design flaws, we won't see as many bug reports and then real
> problems won't get fixed.

This is just an answer to a FAQ. This is not Austin or anyone else 
trying to telling you or anyone else that you should do this. It should 
be clear that there is an implied caveat along the lines of: "There are 
other ways to manage allocation besides regular balancing. This 
recommendation is a For-Dummies-kinda default that should work well 
enough if you don't have another strategy better adapted to your 
situation." If this implication is not obvious enough then we can add 
something explicit.


> I also thing the time based method is too subjective. What about the
> layout means a balance is needed? And if it's really a suggestion, why
> isn't there a chron or systemd unit that just does this for the user,
> in btrfs-progs, working and enabled by default?

As a newcomer to BTRFS, I was astonished to learn that it demands each 
user figure out some workaround for what is, in my judgement, a required 
but missing feature, i.e. a defect, a bug. At present the docs are 
pretty confusing for someone trying to deal with it on their own.

Unless some better fix is in the works, this _should_ be a systemd unit 
or something. Until then, please put it in FAQ.


> I really do not like
> all this hand holding of Btrfs, it's not going to make it better.

Maybe it won't but, absent better proposals, and given the nature of the 
problem, this kind of hand-holding is only fair to the user.

Tom
