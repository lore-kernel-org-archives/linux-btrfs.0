Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:53126
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934987AbcKNSXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:23:04 -0500
Subject: Re: Announcing btrfs-dedupe
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
Cc: Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
Date: Mon, 14 Nov 2016 19:22:59 +0100
MIME-Version: 1.0
In-Reply-To: <20161114180714.GF21290@hungrycats.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/11/16 19:07, Zygo Blaxell wrote:
> On Mon, Nov 07, 2016 at 07:49:51PM +0100, James Pharaoh wrote:
>> Annoyingly I can't find this now, but I definitely remember reading someone,
>> apparently someone knowledgable, claim that the latest version of the kernel
>> which I was using at the time, still suffered from issues regarding the
>> dedupe code.
>
>> This was a while ago, and I would be very pleased to hear that there is high
>> confidence in the current implementation! I'll post a link if I manage to
>> find the comments.
>
> I've been running the btrfs dedup ioctl 7 times per second on average
> over 42TB of test data for most of a year (and at a lower rate for two
> years).  I have not found any data corruptions due to _dedup_.  I did find
> three distinct data corruption kernel bugs unrelated to dedup, and two
> test machines with bad RAM, so I'm pretty sure my corruption detection
> is working.
>
> That said, I wouldn't run dedup on a kernel older than 4.4.  LTS kernels
> might be OK too, but only if they're up to date with backported btrfs
> fixes.

Ok, I think this might have referred to the 4.2 kernel, which was newly 
released at the time. I wish I could find the post!

> Kernels older than 3.13 lack the FILE_EXTENT_SAME ioctl and can
> only deduplicate static data (i.e. data you are certain is not being
> concurrently modified).  Before 3.12 there are so many bugs you might
> as well not bother.

Yes well I don't need to be told that, sadly.

> Older kernels are bad for dedup because of non-corruption reasons.
> Between 3.13 and 4.4, the following bugs were fixed:
>
> 	- false-negative capability checks (e.g. same-inode, EOF extent)
> 	reduce dedup efficiency
>
> 	- ctime updates (older versions would update ctime when a file was
> 	deduped) mess with incremental backup tools, build systems, etc.
>
> 	- kernel memory leaks (self-explanatory)
>
> 	- multiple kernel hang/panic bugs (e.g. a deadlock if two threads
> 	try to read the same extent at the same time, and at least one
> 	of those threads is dedup; and there was some race condition
> 	leading to invalid memory access on dedup's comparison reads)
> 	which won't eat your data, but they might ruin your day anyway.

Ok, I have thing I've seen some stuff like this, I certainly have 
problems, but never a loss of data. Things can take a LONG time to get 
out of the filesystem, though.

> There is also a still-unresolved problem where the filesystem CPU usage
> rises exponentially for some operations depending on the number of shared
> references to an extent.  Files which contain blocks with more than a few
> thousand shared references can trigger this problem.  A file over 1TB can
> keep the kernel busy at 100% CPU for over 40 minutes at a time.

Yes, I see this all the time. For my use cases, I don't really care 
about "shared references" as blocks of files, but am happy to simply 
deduplicate at the whole-file level. I wonder if this still will have 
the same effect, however. I guess that this could be mitigated in a 
tool, but this is going to be both annoying and not the most elegant 
solution.

> There might also be a correlation between delalloc data and hangs in
> extent-same, but I have NOT been able to confirm this.  All I know
> at this point is that doing a fsync() on the source FD just before
> doing the extent-same ioctl dramatically reduces filesystem hang rates:
> several weeks between hangs (or no hangs at all) with fsync, vs. 18 hours
> or less without.

Interesting, I'll maybe see if I can make use of this.

One thing I am keen to understand is if BTRFS will automatically ignore 
a request to deduplicate a file if it is already deduplicated? Given the 
performance I see when doing a repeat deduplication, it seems to me that 
it can't be doing so, although this could be caused by the CPU usage you 
mention above.

In any case, I'm considering some digging into the filesystem structures 
to see if I can work this out myself before i do any deduplication. I'm 
fairly sure this should be relatively simple to work out, at least well 
enough for my purposes.

James
