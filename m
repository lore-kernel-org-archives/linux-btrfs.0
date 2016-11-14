Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34212 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932899AbcKNSjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:39:11 -0500
Received: by mail-it0-f65.google.com with SMTP id q124so16004923itd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 10:39:09 -0800 (PST)
Subject: Re: Announcing btrfs-dedupe
To: James Pharaoh <james@wellbehavedsoftware.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
Cc: Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
Date: Mon, 14 Nov 2016 13:39:02 -0500
MIME-Version: 1.0
In-Reply-To: <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-14 13:22, James Pharaoh wrote:
> On 14/11/16 19:07, Zygo Blaxell wrote:
>> On Mon, Nov 07, 2016 at 07:49:51PM +0100, James Pharaoh wrote:
>>> Annoyingly I can't find this now, but I definitely remember reading
>>> someone,
>>> apparently someone knowledgable, claim that the latest version of the
>>> kernel
>>> which I was using at the time, still suffered from issues regarding the
>>> dedupe code.
>>
>>> This was a while ago, and I would be very pleased to hear that there
>>> is high
>>> confidence in the current implementation! I'll post a link if I
>>> manage to
>>> find the comments.
>>
>> I've been running the btrfs dedup ioctl 7 times per second on average
>> over 42TB of test data for most of a year (and at a lower rate for two
>> years).  I have not found any data corruptions due to _dedup_.  I did
>> find
>> three distinct data corruption kernel bugs unrelated to dedup, and two
>> test machines with bad RAM, so I'm pretty sure my corruption detection
>> is working.
>>
>> That said, I wouldn't run dedup on a kernel older than 4.4.  LTS kernels
>> might be OK too, but only if they're up to date with backported btrfs
>> fixes.
>
> Ok, I think this might have referred to the 4.2 kernel, which was newly
> released at the time. I wish I could find the post!
>
>> Kernels older than 3.13 lack the FILE_EXTENT_SAME ioctl and can
>> only deduplicate static data (i.e. data you are certain is not being
>> concurrently modified).  Before 3.12 there are so many bugs you might
>> as well not bother.
>
> Yes well I don't need to be told that, sadly.
>
>> Older kernels are bad for dedup because of non-corruption reasons.
>> Between 3.13 and 4.4, the following bugs were fixed:
>>
>>     - false-negative capability checks (e.g. same-inode, EOF extent)
>>     reduce dedup efficiency
>>
>>     - ctime updates (older versions would update ctime when a file was
>>     deduped) mess with incremental backup tools, build systems, etc.
>>
>>     - kernel memory leaks (self-explanatory)
>>
>>     - multiple kernel hang/panic bugs (e.g. a deadlock if two threads
>>     try to read the same extent at the same time, and at least one
>>     of those threads is dedup; and there was some race condition
>>     leading to invalid memory access on dedup's comparison reads)
>>     which won't eat your data, but they might ruin your day anyway.
>
> Ok, I have thing I've seen some stuff like this, I certainly have
> problems, but never a loss of data. Things can take a LONG time to get
> out of the filesystem, though.
>
>> There is also a still-unresolved problem where the filesystem CPU usage
>> rises exponentially for some operations depending on the number of shared
>> references to an extent.  Files which contain blocks with more than a few
>> thousand shared references can trigger this problem.  A file over 1TB can
>> keep the kernel busy at 100% CPU for over 40 minutes at a time.
>
> Yes, I see this all the time. For my use cases, I don't really care
> about "shared references" as blocks of files, but am happy to simply
> deduplicate at the whole-file level. I wonder if this still will have
> the same effect, however. I guess that this could be mitigated in a
> tool, but this is going to be both annoying and not the most elegant
> solution.
The issue is at the extent level, so it will impact whole files too (but 
it will have less impact on defragmented files that are then 
deduplicated as whole files).  Pretty much anything that pins references 
to extents will impact this, so cloned extents and snapshots will also 
have an impact.
>
>> There might also be a correlation between delalloc data and hangs in
>> extent-same, but I have NOT been able to confirm this.  All I know
>> at this point is that doing a fsync() on the source FD just before
>> doing the extent-same ioctl dramatically reduces filesystem hang rates:
>> several weeks between hangs (or no hangs at all) with fsync, vs. 18 hours
>> or less without.
>
> Interesting, I'll maybe see if I can make use of this.
>
> One thing I am keen to understand is if BTRFS will automatically ignore
> a request to deduplicate a file if it is already deduplicated? Given the
> performance I see when doing a repeat deduplication, it seems to me that
> it can't be doing so, although this could be caused by the CPU usage you
> mention above.
What's happening is that the dedupe ioctl does a byte-wise comparison of 
the ranges to make sure they're the same before linking them.  This is 
actually what takes most of the time when calling the ioctl, and is part 
of why it takes longer the larger the range to deduplicate is.  In 
essence, it's behaving like an OS should and not trusting userspace to 
make reasonable requests (which is also why there's a separate ioctl to 
clone a range from another file instead of deduplicating existing data).

TBH, even though it's kind of annoying from a performance perspective, 
it's a rather nice safety net to have.  For example, one of the cases 
where I do deduplication is a couple of directories where each directory 
is an overlapping partial subset of one large tree which I keep 
elsewhere.  In this case, I can tell just by filename exactly what files 
might be duplicates, so the ioctl's check lets me just call the ioctl on 
all potential duplicates (after checking size, no point in wasting time 
if the files obviously aren't duplicates), and have it figure out 
whether or not they can be deduplicated.
>
> In any case, I'm considering some digging into the filesystem structures
> to see if I can work this out myself before i do any deduplication. I'm
> fairly sure this should be relatively simple to work out, at least well
> enough for my purposes.
Sadly, there's no way to avoid doing so right now.

