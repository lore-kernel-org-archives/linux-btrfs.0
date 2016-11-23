Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33961 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbcKWGJS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 01:09:18 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1c9Qk2-0005D1-BV
        for linux-btrfs@vger.kernel.org; Wed, 23 Nov 2016 07:09:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Inconsistent free space with false ENOSPC
Date: Wed, 23 Nov 2016 06:09:04 +0000 (UTC)
Message-ID: <pan$aca24$249fdeaf$20473dcc$c7efe94c@cox.net>
References: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
        <010201588d22ec8f-40a41aa2-9046-462a-ab95-347f101dfd02-000000@eu-west-1.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Raiber posted on Tue, 22 Nov 2016 17:43:46 +0000 as excerpted:

> On 22.11.2016 15:16 Martin Raiber wrote:
>> ...
>> Interestingly,
>> after running "btrfs check --repair" "df" shows 0 free space (Used
>> 516456408 Available 0), being inconsistent with the below other btrfs
>> free space information.
>>
>> btrfs fi usage output:
>>
>> Overall:
>>     Device size:                 512.00GiB
>>     Device allocated:            512.00GiB
>>     Device unallocated:            1.04MiB
>>     Device missing:                  0.00B
>>     Used:                        492.03GiB
>>     Free (estimated):             19.59GiB      (min: 19.59GiB)
>>     Data ratio:                       1.00
>>     Metadata ratio:                   2.00
>>     Global reserve:              512.00MiB      (used: 326.20MiB)
>>
>> Data,single: Size:507.98GiB, Used:488.39GiB
>>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b  507.98GiB
>>
>> Metadata,DUP: Size:2.00GiB, Used:1.82GiB
>>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    4.00GiB
>>
>> System,DUP: Size:8.00MiB, Used:80.00KiB
>>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b   16.00MiB
>>
>> Unallocated:
>>    /dev/mapper/LUKS-CC-9a6043feb9d946269555a71ec0742c8b    1.04MiB

> Looking at the code, it seems df shows zero if the available metadata
> space is smaller than the used global reserve. So this file system might
> be out of metadata space.

Yes, you're in a *serious* metadata bind.

Any time global reserve has anything above zero usage, it means the 
filesystem is in dire straits, and well over half of your global reserve 
is used, a state that is quite rare as btrfs really tries hard not to use 
that space at all under normal conditions and under most conditions will 
ENOSPC before using the reserve at all.

And the global reserve comes from metadata but isn't accounted in 
metadata usage, so your available metadata is actually negative by the 
amount of global reserve used.

Meanwhile, all available space is allocated to either data or metadata 
chunks already -- no unallocated space left to allocate new metadata 
chunks to take care of the problem (well, ~1 MiB unallocated, but that's 
not enough to allocate a chunk, metadata chunks being nominally 256 MiB 
in size and with metadata dup, a pair of metadata chunks must be 
allocated together, so 512 MiB would be needed, and of course even if the 
1 MiB could be allocated, it'd be ~1/2 MiB worth of metadata due to 
metadata-dup and you're 300+ MiB into global reserve, so it wouldn't even 
come close to fixing the problem).


Now normally, as mentioned in the ENOSPC discussion in the FAQ on the 
wiki, temporarily adding (btrfs device add) another device of some GiB 
(32 GiB should do reasonably well, 8 GiB may, a USB thumb drive of 
suitable size can be used if necessary) and using the space it makes 
available to do a balance (-dusage= incrementing from 0 to perhaps 30 to 
70 percent, higher numbers will take longer and may not work at first) in 
ordered to combine partially used chunks and free enough space to then 
remove (btrfs device remove) the temporarily added device.

However, in your case the data usage is 488 of 508 GiB on a 512 GiB 
device with space needed for several GiB of metadata as well, so while in 
theory you could free up ~20 GiB of space that way and that should get 
you out of the immediate bind, the filesystem will still be very close to 
full, particularly after clearing out the global reserve usage, with 
perhaps 16 GiB unallocated at ideal, ~97% used.  And as any veteran 
sysadmin or filesystem expert will tell you, filesystems in general like 
10-20% free in ordered to be able to "breath" or work most efficiently, 
with btrfs being no exception, so while the above might get you out of 
the immediate bind, it's unlikely to work for long.

Which means once you're out of the immediate bind, you're still going to 
need to free some space, one way or another, and that might not be as 
simple as the words make it appear.

It's worth noting that btrfs keeps the original full extents around until 
all references to all (4 KiB on x86/amd64) blocks within the extent are 
gone.  So if you have an originally half GiB file that was in a single 
extent, and have heavily rewritten most of it, thus triggering COW to 
write most blocks elsewhere, if a single 4 KiB block from the original 
remains unrewritten, it's quite likely that 4 KiB block from the original 
will still be pinning the entire half GiB extent, keeping it from being 
freed.

Of course snapshots, which you mentioned, complicate the picture by 
continuing to keep references to extents as they were at the time the 
snapshot was taken.

So getting rid of your oldest snapshots will probably release some space, 
which can then be rebalanced into unallocated space, but it's quite 
possible that you won't be able to reclaim as much space that way as you 
might expect, particularly if as described above, some of your files are 
mostly but not entirely rewritten since the original write, and a few 
unchanged blocks remain, continuing to lock much larger extents into 
place due to current references to blocks in the original extent.

What you might have to do is eliminate all snapshots holding references 
to the old files, then copy --reflink=never (or simply cross-filesystem 
copy so reflink-copy can't be used) the current files elsewhere, delete 
the existing copy, and copy/move them back into place, thus releasing the 
old extent references and freeing the space those old extents took.

Of course depending on the circumstances and how your backups are handled 
(noting your urbackup.org email address here), it may be simpler to start 
with a fresh filesystem, either blowing away the existing one and 
starting over, or archiving the existing one as-is and starting over.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

