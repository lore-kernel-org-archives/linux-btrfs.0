Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34467 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933580AbeAONnq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 08:43:46 -0500
Received: by mail-io0-f178.google.com with SMTP id c17so13118566iod.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 05:43:45 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
 <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d48fabd3-a154-c83e-dd24-1c550ca2f229@gmail.com>
Date: Mon, 15 Jan 2018 08:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS4ZKYbZGbpuOcCCuNdcZjNNUf=gkBu6Ky_DdJ-zVB+HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-13 17:09, Chris Murphy wrote:
> On Fri, Jan 12, 2018 at 11:24 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
> 
>> To that end, I propose the following text for the FAQ:
>>
>> Q: Do I need to run a balance regularly?
>>
>> A: While not strictly necessary for normal operations, running a filtered
>> balance regularly can help prevent your filesystem from ending up with
>> ENOSPC issues.  The following command run daily on each BTRFS volume should
>> be more than sufficient for most users:
>>
>> `btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`
> 
> 
> Daily? Seems excessive.
For handling of chunks that are only 25% full and capping it at 10 
chunks processed each for data and metadata?  That's only (assuming I 
remember the max chunk size correctly) about 15GB of data being moved at 
the absolute most, and that will likely only happen in pathologically 
bad cases.  In most cases it should be either nothing (in most cases) or 
about 768MB being shuffled around, and even on traditional hard drives 
that should complete insanely fast (barring impact from very large 
numbers of snapshots or use of qgroups).

If there are no chunks that match (or only one chunk), this finishes in 
at most a second with near zero disk I/O.  If exactly two match (which 
should be the common case for most users when it matches at all), it 
should take at most a few seconds to complete, even on traditional hard 
drives.  If more match, it will of course take longer, but it should be 
pretty rare that more than two match.

Given that, it really doesn't seem all that excessive to me.  As a point 
of comparison, automated X.509 certificate renewal checks via certbot 
take more resources to perform when there's not a renewal due than this 
balance command takes when there's nothing to work on, and it's 
absolutely standard to run the X.509 checks daily despite the fact that 
weekly checks would still give no worse security (certbot will renew 
things well before they expire).
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
In the first case, you're dealing with a special configuration that 
makes most of this irrelevant most of the time (as I'm assuming things 
change _enough_ between snapshots that dumping most of them will 
completely empty out most of the chunks they were stored in).

In the second I'd have to say you've been lucky.  I've personally never 
run a volume that close to full with BTRFS without balancing regularly 
and not had some kind of issue.
> 
> I really think suggestions this broad are just going to paper over
> bugs or design flaws, we won't see as many bug reports and then real
> problems won't get fixed.
So maybe we should fix things so that this is never needed?  Yes, it's a 
workaround for a well known and documented design flaw (and yes, I 
consider the whole two-level allocator's handling of free space 
exhaustion to be a design flaw), but I don't see any patches forthcoming 
to fix it, so if we want to keep users around, we need to provide some 
way for them to mitigate the problems it can cause (otherwise we won't 
find any bugs because we won't have any users).
> 
> I also thing the time based method is too subjective. What about the
> layout means a balance is needed? And if it's really a suggestion, why
> isn't there a chron or systemd unit that just does this for the user,
> in btrfs-progs, working and enabled by default? I really do not like
> all this hand holding of Btrfs, it's not going to make it better.
For a filesystem you really have two generic possibilities for use cases:

1. It's designed for general purpose usage.  Doesn't really excel at any 
thing in particular, but isn't really bad at anything either.
2. It's designed for a very specific use case.  Does an amazing job for 
that particular use case and possibly for some similar ones, and may or 
may not do a reasonable job for other use cases.

Your comments here seem to imply that BTRFS falls under the second case, 
which is odd since most everything else I've seen implies that BTRFS 
fits the first case (or is trying to at least).  In either case though, 
you need to provide something to deal with this particular design flaw.

In the first case, you _need_ to make it as easy as possible for people 
who have no understanding of computers to use.  While needing balances 
from time to time is not exactly in-line with that, requiring people to 
try and judge based on the numbers whether or not a balance is warranted 
is even less in-line with it.  By just telling people to automate it and 
give reasonable filters to the balance command, we remove the guesswork 
entirely, and make things far easier for people.

In the second case, it's generally more acceptable to require more work 
of the user, but making baseline prophylactic maintenance something that 
you can't trivially automate is still a bad idea (imagine how popular 
ZFS would be if you could only run scrubs manually).

That said, if you can find or write up a script that reliably does the 
math to check if a balance is needed and then actually runs it if it is, 
I would be more than happy to recommend that in the FAQ instead.
> 
>> A full, unfiltered balance (one without any options passed in) is completely
>> unnecessary for normal usage of a filesystem.
> 
> That's good advice.
And so far it seems to be the one thing that everyone agrees on ;).
