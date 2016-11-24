Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48222 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754815AbcKXEoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 23:44:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1c9ltv-0004b2-Pa
        for linux-btrfs@vger.kernel.org; Thu, 24 Nov 2016 05:44:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Inconsistent free space with false ENOSPC
Date: Thu, 24 Nov 2016 04:44:41 +0000 (UTC)
Message-ID: <pan$ba8df$dcc54160$f631205d$ba008359@cox.net>
References: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
        <010201588d22ec8f-40a41aa2-9046-462a-ab95-347f101dfd02-000000@eu-west-1.amazonses.com>
        <pan$aca24$249fdeaf$20473dcc$c7efe94c@cox.net>
        <0102015891fee0c8-d9e6073c-c86c-43a7-80f7-3d51dfefa0fd-000000@eu-west-1.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Raiber posted on Wed, 23 Nov 2016 16:22:29 +0000 as excerpted:

> On 23.11.2016 07:09 Duncan wrote:
>> Yes, you're in a *serious* metadata bind.
>> Any time global reserve has anything above zero usage, it means the
>> filesystem is in dire straits, and well over half of your global
>> reserve is used, a state that is quite rare as btrfs really tries hard
>> not to use that space at all under normal conditions and under most
>> conditions will ENOSPC before using the reserve at all.
>>
>> And the global reserve comes from metadata but isn't accounted in
>> metadata usage, so your available metadata is actually negative by the
>> amount of global reserve used.
>>
>> Meanwhile, all available space is allocated to either data or metadata
>> chunks already -- no unallocated space left to allocate new metadata
>> chunks to take care of the problem (well, ~1 MiB unallocated, but
>> that's not enough to allocate a chunk, metadata chunks being nominally
>> 256 MiB in size and with metadata dup, a pair of metadata chunks must
>> be allocated together, so 512 MiB would be needed, and of course even
>> if the 1 MiB could be allocated, it'd be ~1/2 MiB worth of metadata due
>> to metadata-dup and you're 300+ MiB into global reserve, so it wouldn't
>> even come close to fixing the problem).
>>
>>
>> Now normally, as mentioned in the ENOSPC discussion in the FAQ on the
>> wiki, temporarily adding (btrfs device add) another device of some GiB
>> (32 GiB should do reasonably well, 8 GiB may, a USB thumb drive of
>> suitable size can be used if necessary) and using the space it makes
>> available to do a balance (-dusage= incrementing from 0 to perhaps 30
>> to 70 percent, higher numbers will take longer and may not work at
>> first) in ordered to combine partially used chunks and free enough
>> space to then remove (btrfs device remove) the temporarily added
>> device.
>>
>> However, in your case the data usage is 488 of 508 GiB on a 512 GiB
>> device with space needed for several GiB of metadata as well, so while
>> in theory you could free up ~20 GiB of space that way and that should
>> get you out of the immediate bind, the filesystem will still be very
>> close to full, particularly after clearing out the global reserve
>> usage, with perhaps 16 GiB unallocated at ideal, ~97% used.  And as any
>> veteran sysadmin or filesystem expert will tell you, filesystems in
>> general like 10-20% free in ordered to be able to "breath" or work most
>> efficiently, with btrfs being no exception, so while the above might
>> get you out of the immediate bind, it's unlikely to work for long.
>>
>> Which means once you're out of the immediate bind, you're still going
>> to need to free some space, one way or another, and that might not be
>> as simple as the words make it appear.
> 
> Yes, adding a temporary disk allowed me to fix it. Though, it wanted to
> write RAID1 metadata instead of DUP first, which further confused me.

When a btrfs has two devices, it defaults to raid1 metadata.

However, as the wiki covers, if you are short on metadata, you need to 
balance data chunks to consolidate them, not metadata, as all those 
chunks will be full already, thus the suggested -d, with the usage filter 
(thus -dusage=) to limit balancing to those chunks that are less than X 
percent full in ordered to efficiently consolidate them without wasting 
time rewriting chunks that are at or near 100 percent full already and 
thus can't be consolidated anyway.  That effect is compounded since the 
more data a chunk contains the longer it takes to rewrite, while 
conversely, the more data a chunk contains the more chunks of about the 
same percentage full must be rewritten in ordered to free just one chunk. 
10 chunks at 10% full consolidate to one, freeing 9, while taking about 
the same time to rewrite as a single 100% full chunk.  10 chunks at 90% 
full take 9 times as long as a single full chunk to rewrite, but only 
free 1 chunk.

Thus the idea is to start at -dusage=0, and increase a few percentage 
points at a time until you're either satisfied with the amount of space 
freed, or you've decided it's not worth the time it's taking to do even 
higher percentages -- even on ssd as I am here, I'll normally stop at 
between 50 and 70 percent, tho on ssd, not so much because of the time it 
takes, but more because it's a waste of ssd write cycles -- not worth the 
additional cost in write cycles to rewrite chunks more than 70% full, 
because it takes rewriting so many of them to free just one.

And the -d would have only dealt with data chunks, so the only metadata 
rewrites would have been the ones necessary to point to the new location 
for the data chunks.  Of course that wouldn't have been zero, 
particularly so since the existing metadata chunks were full, and the new 
ones would default to raid1, but that would soon enough be rewritten back 
to dup when the btrfs device remove of the temporary device was done.

> File system is being written to by a program that watches disk usage and
> deletes stuff/stops writing if too much is used. But it could not
> anticipate the jump from 20GiB to zero free. I have now set
> "metadata_ratio=8" to prevent that, and will lower it if it still
> becomes a problem.

Yes, that should work, altho under ordinary circumstances manually 
setting that ratio is discouraged. The option is mostly just legacy code 
from back before btrfs could normally allocate metadata chunks on its own 
when it needed them, but then again, the ordinary recommendation is not 
to run over 90% full, as well, and the metadata ratio option remains 
there for special cases, with yours obviously being one of them.  

> Perhaps it would be good to somehow show that "global reserve" belongs
> to metadata and show in btrfs fi usage/df that metadata is full if
> global reserve>=free metadata, so that future users are not as confused
> by this situation as I was.

This has actually been in active discussion and AFAIK it is pretty much 
agreed among the devs that eventually, the metadata usage figures should 
include global reserve as well, and global reserve as a separate 
statistic will at minimum be deemphasized, and may be moved out of user-
targeted btrfs commands entirely and only exposed in developer-targeted 
debug commands.  Only the patches actually doing that haven't been merged 
yet.  There have been some posted, with the discussion centering on 
whether global reserve should be indented under metadata but still show 
up, or whether it should be folded into metadata and removed as a 
separate item from user targeted reports entirely.

So it /is/ set to change at some point.  It's worth noting here that on 
this list at least, btrfs status remains "under heavy development, 
stabilizing, but not yet fully stable and mature", and command output 
formats remain subject to change as well, so changes of this nature can 
indeed be expected.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

