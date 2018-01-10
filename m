Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:46777 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933668AbeAJRBr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 12:01:47 -0500
Received: by mail-it0-f42.google.com with SMTP id c16so165222itc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 09:01:47 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Tom Worster <fsb@thefsb.org>, linux-btrfs@vger.kernel.org
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
 <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
 <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
 <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
 <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3e353e79-3a13-d2cf-e098-6074a3e17918@gmail.com>
Date: Wed, 10 Jan 2018 12:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-10 11:30, Tom Worster wrote:
> On 9 Jan 2018, at 22:49, Duncan wrote:
> 
>> AFAIK, such corruption reports re balance aren't really balance, per se,
>> at all.
>>
>> Instead, what I've seen in nearly all cases is a number of filesystem
>> maintenance commands involving heavy I/O colliding, that is, being run at
>> the same time
> 
> I hope there is consensus on this because it might be the key to 
> resolving the contradictions that appear to me in the following 
> propositions that all seem plausible/reasonable:
> 
> - Depletion of unallocated space (DoUS, apologies for coining the term 
> if there already is one) is a property of BTRFS even if the volume's 
> capacity is more than enough for the files on it.
Strictly speaking this particular statement is only true in that there 
are still probably bugs in the allocator.  The goal is for this to never 
be a significant problem as long as you have a reasonable amount of free 
space (reasonable being enough for at least a couple of chunks to be 
allocated).

Also, for future reference, the term we typically use is ENOSPC, as 
that's the symbolic name for the error code you get when this happens 
(or when your filesystem is just normally full), but I actually kind of 
like your name for it too, it conveys the exact condition being 
discussed in a way that should be a bit easier for non-technical types 
to understand.
> 
> - To a user that isn't a BTRFS expert, DoUS can be unexpected, its 
> advance can be surprisingly fast and it can become severe.
Absolutely correct, and actually true even for a number of BTRFS 
'experts' (no, seriously, I know of a number of cases where this caught 
'experts' (including myself) by surprise simply because they ran into a 
corner case they had never dealt with or found a bug in the allocator).
> 
> - BTRFS does not recycle allocated but unused space to the unallocated 
> pool.
Kind of.

The regular BTRFS allocator will (usually) preferentially avoid using 
blocks of free space smaller than a given size for new allocations. 
Without the 'ssd' mount option set, or when using Linux kernel version 
4.14 or newer, the minimum size is 64kB, so it's generally not too bad 
unless you regularly are dealing with lots of small files that change 
very frequently.  With the 'ssd' mount option set on Linux kernels prior 
to 4.14, the minimum size is 2MB, which tends to result in really poor 
space utilization, though it's still mostly an issue with volumes 
holding lots of small files that change frequently or see lots of small 
changes to large files.

However, this does not mean that that space will always be unused.  If 
space gets tight, BTRFS will use that previously allocated space to it's 
fullest, and it will reuse it in other circumstances too.
> 
> - Resolving severe DoUS involves either running `btrfs balance` or 
> recreating the filesystem from, e.g. backups.
In most cases yes, though it is sometimes possible to resolve simply by 
dropping snapshots if you have a lot of them and then deleting some files.
> 
> - People have reported that `btrfs balance` sometimes causes filesystem 
> corruption.
As I commented, I've not heard about this specifically, and I'm inclined 
to agree with Duncan's assessment that it's probably from people running 
multiple low-level maintenance operations happening concurrently 
(running two or more balances at the same time is known to be able to 
cause this type of corruption, and as a result there's locking in the 
kernel to prevent you from running more than one balance at a time on a 
filesystem).>
> - Some experienced users say that, to resolve a problem with DoUS, they 
> would rather recreate the filesystem than run balance.
This is kind of independent of BTRFS.  A lot of seasoned system 
administrators are going to be more likely to just rebuild a broken 
filesystem from scratch if possible than repair it simply because it's 
more reliable and generally guaranteed to fix the issue.  It largely 
comes down to the mentality of the individual, and how confident they 
are that they can fix a problem in a reasonable amount of time without 
causing damage elsewhere.
> 
> - Some experienced users say you should stop all other use of the 
> filesystem while running balance.
I've never seen any evidence that this is actually needed, but it does 
make the balance operation finish faster.  Strictly speaking, it 
shouldn't be needed at all (that's part of the point of having CoW 
semantics in the filesystem, it makes it easier to handle maintenance 
on-line).
> 
> - Some experts recommend running balance regularly, even once a day, to 
> prevent DoUS. >
> Without some satisfactory way to resolve the contradictions, I'm not 
> sure how to proceed. For example, I'm not willing to offload the 
> workload from each filesystem once a day for prophylactic balance. And 
> I'm not going to let balance run unattended if those more experienced 
> than me say it's known to corrupt filesystems. The best I can do is 
> monitor DoUS and respond ad hoc. Or I can use a different fs type.
It may be worth seriously looking at whether you actually _need_ BTRFS 
for your use case.  In general, unless you need at least one of it's 
features, and either can't get that feature with ZFS or just want to 
avoid using ZFS, you are likely better-off for the time being using 
another filesystem.

In my case for example, I _really_ want to avoid dealing with ZFS on 
Linux because of how it impacts what kernel versions I use and the fact 
that I don't trust the proprietary NVIDIA drivers to get along with it, 
and I need the checksumming and online transformation features 
(reshaping, profile conversion, device replacement, etc) of BTRFS.  If 
it weren't for all of that, I would not be using BTRFS at all.
> 
> But if Duncan is right (which, for me, is practically the same as 
> consensus on the proposition) that problems with corruption while 
> running balance are associated with heavy coincident IO activity, then I 
> can see a reasonable way forwards. I can even see how general 
> recommendations for BTRFS maintenance might develop.
As I commented above, I would tend to believe Duncan is right in this 
case (both because it makes sense, and because he seems to generally be 
right about this type of thing).  That said, I really do think that 
normal user I/O is probably not the issue, but low-level filesystem 
operations are.  That said, there is no reason that BTRFS shouldn't either:
1. Handle this just fine without causing corruption.
or:
2. Extend the mutex used to prevent concurrent balances to cover other 
operations that might cause issues (that is, make it so you can't scrub 
a filesystem while it's being balanced, or defragment it, or whatever else).
