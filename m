Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47810 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaDUVKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 17:10:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcLTX-0004yV-MT
	for linux-btrfs@vger.kernel.org; Mon, 21 Apr 2014 23:10:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 23:10:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 23:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size
 Drives
Date: Mon, 21 Apr 2014 21:09:52 +0000 (UTC)
Message-ID: <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net>
References: <53540367.4050707@aeb.io>
	<D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
	<5354A4EA.3000209@aeb.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Brenner posted on Sun, 20 Apr 2014 21:56:10 -0700 as excerpted:

> So ... BTRFS at this point in time, does not actually "stripe" the data
> across N number of devices/blocks for aggregated performance increase
> (both read and write)?

What Chris says is correct, but just in case it's unclear as written, let 
me try a reworded version, perhaps addressing a few uncaught details in 
the process.

1) Btrfs treats data and metadata separately, so unless they're both 
setup the same way (both raid0 or both single or whatever), different 
rules will apply to each.

2) Btrfs separately allocates data and metadata chunks, then fills them 
in until it needs to allocate more.  So as the filesystem fills, there 
will come a point at which all space is allocated to either data or 
metadata chunks and no more chunk allocations can be made.  At this 
point, you can still write to the filesystem, filling up the chunks that 
are there, but one or the other will fill up first, and then you'll get 
errors.

2a) By default, data chunks are 1 GiB in size, metadata chunks are 256 
MiB, altho the last ones written can be smaller to fill the available 
space.   Note that except for single mode, all chunks must be written in 
multiples: pairs for dup, raid1, a minimum of pairs for raid0, a minimum 
of triplets for raid5, a minimum of quads for raid6, raid10.  Thus, when 
using unequal sized devices or a number of devices that doesn't evenly 
match the minimum multiple, it's very likely that depending on the size 
of the individual devices, some space may not actually be allocatable.  
This is what Chris was seeing with his 3 device raid0, 2G, 3G, 4G.  The 
first two fill up, leaving no room to allocate in pairs+, with a gig of 
space left unused on the 4G device.

2b) For various reasons it usually the metadata that fills up first.  
When that happens, further operations (even attempting to delete files, 
since on a COW filesystem deletions require room to rewrite the metadata) 
return ENOSPC.  There are various tricks that can be tried when this 
happens (balance, etc) to recover some likely not yet full data chunks to 
unallocated and thus have more room to write metadata, but ideally, you 
watch the btrfs filesystem df and btrfs filesystem show stats and 
rebalance before you start getting ENOSPC errors.

It's also worth noting that btrfs reserves some metadata space, typically 
around 200 MiB, for its own usage.  Since metadata chunks are normally 
256 MiB in size, an easy way to look at it is to simply say you always 
need a spare metadata chunk allocated.  Once the filesystem cannot 
allocate more and you're on your last one, you run into ENOSPC trouble 
pretty quickly.

2c) Chris has reported the opposite situation in his test.  With no more 
space to allocate, he filled up his data chunks first.  At that point 
there's metadata space still available, thus the zero-length files he was 
reporting.  (Technically, he could probably write really small files too, 
because if they're small enough, likely something under 16 KiB and 
possibly something under 4 KiB, depending on the metadata node size (4 KiB 
by default until recently, 16 KiB from IIRC kernel 3.13), btrfs will 
write them directly into the metadata node and not actually allocate a 
data extent for them.  But the ~20 MiB files he was trying were too big 
for that, so he was getting the metadata allocation but not the data, 
thus zero-length files.)

Again, a rebalance might be able to return some unused metadata chunks to 
the unallocated pool, allowing a little more data to be written.

2d)  Still, if you keep adding more, there comes a point at which no more 
can be written using current data and metadata modes and there's no 
further partially written chunks to free using balance either, at which 
point the filesystem is full, even if there's still space left unused on 
one device.

With those basics in mind, we're now equipped to answer the question 
above.

On a multi-device filesystem, in default data allocation "single" mode, 
btrfs can sort of be said to stripe in theory, since it'll allocate 
chunks from all available devices, but since it's allocating and using 
only a single data chunk at a time and they're a GiB in size, the 
"stripes" are effectively a GiB in size, far too large to get any 
practical speedup from them.

But single mode does allow using that last bit of space on unevenly sized 
devices, and if a device goes bad, you can still recover files written to 
the other devices.

OTOH, raid0 mode will allocate in gig chunks per device across all 
available devices (minimum two) at once and will then write in much 
smaller stripes (IIRC 64 KiB, since that's the normal device read-ahead 
size) in the pre-allocated chunks, giving you far faster single-thread 
access.

But raid0 mode does require pair-minimum chunk allocation, so if the 
devices are uneven in size, depending on exact device sizes you'll likely 
end up with some unusable space on the last device.  Also, as is normally 
the case with raid0, if a device dies, consider the entire filesystem 
toast.  (In theory you can often still recover some files smaller than 
the stripe size, particularly if the metadata was raid1 as it is by 
default so it's still available, but in practice, if you're storing 
anything but throwaway data on a raid0 and/or you don't have current/
tested backups, you're abusing raid0 and playing Russian roulette with 
your data.  Just don't put valuable data on raid1 in the first place and/
or keep current/tested backups, and you can simply scrap the raid0 when a 
device dies without worry.)

OTOH, I vastly prefer raid1 here, both for the traditional device-fail 
redundancy and to take advantage of btrfs' data integrity features should 
one copy of the data go bad for some reason.  My biggest gripe is that 
currently btrfs raid1 only does pair-mirroring regardless of the number 
of devices thrown at it, and my sweet-spot is triplet-mirroring, which 
I'd really *REALLY* like to have available, just in case.  Oh, well...  
Anyway, for multi-threaded primarily read-based IO, raid1 mode is the 
better choice, since you get N-thread access in parallel, with N=number-
of-mirrors.  (Again, I'd really REALLY like N=3, but oh, well... it's on 
the roadmap.  I'll have to wait...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

