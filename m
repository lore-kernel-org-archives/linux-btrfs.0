Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34864 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdAPQ3n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 11:29:43 -0500
Received: by mail-io0-f173.google.com with SMTP id j18so95217811ioe.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jan 2017 08:29:43 -0800 (PST)
Subject: Re: Unocorrectable errors with RAID1
To: Christoph Groth <christoph@grothesque.org>
References: <87o9z7dzvd.fsf@grothesque.org>
 <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
 <87fukjdna0.fsf@grothesque.org>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
Date: Mon, 16 Jan 2017 11:29:38 -0500
MIME-Version: 1.0
In-Reply-To: <87fukjdna0.fsf@grothesque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-16 10:42, Christoph Groth wrote:
> Austin S. Hemmelgarn wrote:
>> On 2017-01-16 06:10, Christoph Groth wrote:
>
>>> root@mim:~# btrfs fi df /
>>> Data, RAID1: total=417.00GiB, used=344.62GiB
>>> Data, single: total=8.00MiB, used=0.00B
>>> System, RAID1: total=40.00MiB, used=68.00KiB
>>> System, single: total=4.00MiB, used=0.00B
>>> Metadata, RAID1: total=3.00GiB, used=1.35GiB
>>> Metadata, single: total=8.00MiB, used=0.00B
>>> GlobalReserve, single: total=464.00MiB, used=0.00B
>
>> Just a general comment on this, you might want to consider running a
>> full balance on this filesystem, you've got a huge amount of slack
>> space in the data chunks (over 70GiB), and significant space in the
>> Metadata chunks that isn't accounted for by the GlobalReserve, as well
>> as a handful of empty single profile chunks which are artifacts from
>> some old versions of mkfs.  This isn't of course essential, but
>> keeping ahead of such things does help sometimes when you have issues.
>
> Thanks!  So slack is the difference between "total" and "used"?  I saw
> that the manpage of "btrfs balance" explains this a bit in its
> "examples" section.  Are you aware of any more in-depth documentation?
> Or one has to look at the source at this level?
There's not really much in the way of great documentation that I know 
of.  I can however cover the basics here:

BTRFS uses a 2 level allocation system.  At the higher level, you have 
chunks.  These are just big blocks of space on the disk that get used 
for only one type of lower level allocation (Data, Metadata, or System). 
  Data chunks are normally 1GB, Metadata 256MB, and System depends on 
the size of the FS when it was created.  Within these chunks, BTRFS then 
allocates individual blocks just like any other filesystem.  When there 
is no free space in any existing chunks for a new block that needs 
allocated, a new chunk is allocated.  Newly allocated chunks may be 
larger (if the filesystem is really big) or smaller (if the FS doesn't 
have much free space left at the chunk level) than the default.  In the 
event that BTRFS can't allocate a new chunk because there's no room, a 
couple of different things could happen.  If the chunk to be allocated 
was a data chunk, you get -ENOSPC (usually, sometimes you might get 
other odd results) in the userspace application that triggered the 
allocation.  However, if BTRFS needs room for metadata, then it will try 
to use the GlobalReserve instead.  This is a special area within the 
metadata chunks that's reserved for internal operations and trying to 
get out of free space exhaustion situations.  If that fails, then the 
filesystem is functionally dead, reads will still work, and you might be 
able to write very small amounts of data at a time, but it's not 
possible from a practical perspective to recover a filesystem in such a 
situation.

The 'total' value in fi df output is the total space allocated to chunks 
of that type, while the 'used' value is how much is actually being used. 
  It's worth noting that since GlobalReserve is a part of the Metadata 
chunks, the total there is part of the total for Metadata, but not the 
used value (so in an ideal situation with no slack space at the block 
level, you would still see a difference between metadata total and used 
equal to the global reserve total).

What balancing does is send everything back through the allocator, which 
in turn back-fills chunks that are only partially full, and removes ones 
that are now empty.  In normal usage, it's not absolutely needed.  From 
a practical perspective though, it's generally a good idea to keep the 
slack space (the difference between total and used) within chunks to a 
minimum to try and avoid getting the filesystem stuck with no free space 
at the chunk level.
>
> I ran
>
> btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft /
> btrfs balance start -dusage=25 -musage=25 /
>
> This resulted in
>
> root@mim:~# btrfs fi df /
> Data, RAID1: total=365.00GiB, used=344.61GiB
> System, RAID1: total=32.00MiB, used=64.00KiB
> Metadata, RAID1: total=2.00GiB, used=1.35GiB
> GlobalReserve, single: total=460.00MiB, used=0.00B
This is a much saner looking FS, you've only got about 20GB of slack in 
Data chunks, and less than 1GB in metadata, which is reasonable given 
the size of the FS and how much data you have on it.  Ideal values for 
both are actually hard to determine, as having no slack in the chunks 
actually hurts performance a bit, and the ideal values depend on how 
much your workloads hit each type of chunk.
>
> I hope that one day there will be a daemon that silently performs all
> the necessary btrfs maintenance in the background when system load is low!
FWIW, while there isn't a daemon yet that does this, it's a perfect 
thing for a cronjob.  The general maintenance regimen that I use for 
most of my filesystems is:
* Run 'btrfs balance start -dusage=20 -musage=20' daily.  This will 
complete really fast on most filesystems, and keeps the slack-space 
relatively under-control (and has the nice bonus that it helps 
defragment free space.
* Run a full scrub on all filesystems weekly.  This catches silent 
corruption of the data, and will fix it if possible.
* Run a full defrag on all filesystems monthly.  This should be run 
before the balance (reasons are complicated and require more explanation 
than you probably care for).  I would run this at least weekly though on 
HDD's, as they tend to be more negatively impacted by fragmentation.
There are a couple of other things I also do (fstrim and punching holes 
in large files to make them sparse), but they're not really BTRFS 
specific.  Overall, with a decent SSD (I usually use Crucial MX series 
SSD's in my personal systems), these have near zero impact most of the 
time, and with decent HDD's, you should have limited issues as long as 
you run on only one FS at a time.
>
>>> * So scrubbing is not enough to check the health of a btrfs file
>>> system?  It’s also necessary to read all the files?
>
>> Scrubbing checks data integrity, but not the state of the data. IOW,
>> you're checking that the data and metadata match with the checksums,
>> but not necessarily that the filesystem itself is valid.
>
> I see, but what should one then do to detect problems such as mine as
> soon as possible?  Periodically calculate hashes for all files? I’ve
> never seen a recommendation to do that for btrfs.
Scrub will verify that the data is the same as when the kernel 
calculated the block checksum.  That's really the best that can be done. 
  In your case, it couldn't correct the errors because both copies of 
the corrupted blocks were bad (this points at an issue with either RAM 
or the storage controller BTW, not the disks themselves).  Had one of 
the copies been valid, it would have intelligently detected which one 
was bad and fixed things.  It's worth noting that the combination of 
checksumming and scrub actually provides more stringent data integrity 
guarantees than any other widely used filesystem except ZFS.

As far as general monitoring, in addition to scrubbing (and obviously 
watching SMART status) you want to check the output of 'btrfs device 
stats' for non-zero error counters (these are cumulative counters that 
are only reset when the user says to do so, so right now they'll show 
aggregate data for the life of the FS), and if you're paranoid, watch 
that the mount options on the FS don't change (some monitoring software 
such as Monit makes this insanely easy to do), as the FS will go 
read-only if a severe error is detected (stuff like a failed read at the 
device level, not just checksum errors).
>
>> There are a few things you can do to mitigate the risk of not using
>> ECC RAM though:
>> * Reboot regularly, at least weekly, and possibly more frequently.
>> * Keep the system cool, warmer components are more likely to have
>> transient errors.
>> * Prefer fewer numbers of memory modules when possible.  Fewer modules
>> means less total area that could be hit by cosmic rays or other
>> high-energy radiation (the main cause of most transient errors).
>
> Thanks for the advice, I think I buy the regular reboots.
>
> As a consequence of my problem I think I’ll stop using RAID1 on the file
> server, since this only protects against dead disks, which evidently is
> only part of the problem.  Instead, I’ll make sure that the laptop that
> syncs with the server has a SSD that is big enough to hold all the data
> that is on the server as well (1 TB SSDs are affordable now).  This way,
> instead of disk-level redundancy, I’ll have machine-level redundancy.
> When something like the current problem hits one of the two machines, I
> should still have a usable second machine with all the data on it.
I actually have a similar situation, I've got a laptop that I back-up to 
a personal server system.  In my case though, I've take a much 
higher-level approach, the backup storage is in fact GlusterFS (a 
clustered filesystem) running on top of BTRFS on 3 different systems 
(the server, plus a pair of Intel NUC's that are just dedicated SAN 
systems).  If I didn't have the hardware to do this or cared about 
performance more (I'm lucky if I get 20MB/s write speed, but most of the 
issue is that I went cheap on the NUC's), I would probably still be 
using BTRFS in raid1 mode on the server despite keeping a copy on the 
laptop, simply because that provides an extra layer of protection on the 
server side.
