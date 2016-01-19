Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33640 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbcASMW0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 07:22:26 -0500
Received: by mail-io0-f170.google.com with SMTP id q21so578974610iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 04:22:25 -0800 (PST)
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <loom.20160116T132316-196@post.gmane.org>
 <569C41B1.1090206@cn.fujitsu.com>
 <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
 <569C58FB.70407@cn.fujitsu.com> <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
 <569CDF0D.9030609@gmail.com> <pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <569E2A44.3040109@gmail.com>
Date: Tue, 19 Jan 2016 07:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-19 03:30, Duncan wrote:
> Austin S. Hemmelgarn posted on Mon, 18 Jan 2016 07:48:13 -0500 as
> excerpted:
>
>> On 2016-01-17 22:51, Duncan wrote:
>>>
>>> Checking a bit more my understanding, since you brought up the btrfs
>>> "commit=" mount option.
>>>
>>> I knew about the option previously, and obviously knew it worked in the
>>> same context as the page-cache stuff, but in my understanding the btrfs
>>> "commit=" mount option operates at the filesystem layer, not the
>>> general filesystem-vm layer controlled by /proc/sys/vm/dirty_*.  In my
>>> understanding, therefore, the two timeouts could effectively be added,
>>> yielding a maximum 1 minute (30 seconds btrfs default commit time plus
>>> 30 seconds vm expiry) commit time.
>>
>> In a way, yes, except the commit option controls when a transaction is
>> committed, and thus how often the log tree gets cleared.  It's
>> essentially saying 'ensure the filesystem is consistent without
>> replaying a log at least this often'.  AFAIUI, this doesn't guarantee
>> that you'll go that long without a transaction, but puts an upper bound
>> on it.  Looking at it another way, it pretty much says that you don't
>> care about losing the last n seconds of changes to the FS.
>
> Thanks.  That's the way I was treating it.
>
>> The sysctl values are a bit different, and control how long the kernel
>> will wait in the VFS layer to try and submit a larger batch of writes at
>> once, so that the block layer has more it can try to merge, and
>> hopefully things get written out faster as a result.  IOW, it's a knob
>> to control the VFS level write-back caching to try and tune for
>> performance.  This also ties in with
>> /proc/sys/vm/dirty_writeback_centisecs, which is how often after the
>> expiration hits that the kernel will flush a chunk of the cache, and
>> /proc/sys/vm/dirty_{background,}_{bytes,ratio} which puts an upper limit
>> on how much data will be buffered before trying to flush it out to
>> persistent storage.  You almost certainly want to change these, as they
>> defaults to 10% of system RAM, which is why it often takes a ridiculous
>> amount of time to unmount a flash drive that's been written to a lot.
>> dirty_{ratio,bytes} control the per-process limit, and
>> dirty_background_{ratio,bytes} control the system-wide limit.
>
> Got that too, and yes, I've been known to recommend to others changes to
> the now-days ridiculous 10% of system RAM buffer thing, as well. =:^)
> Random writes to spinning rust in particular may be 30 MiB/sec real-
> world, and 10% of 16 GiB is 1.6 GiB, 50-some seconds worth of writeback.
> When the timeout is 30 seconds and the backlog is nearly double that,
> something's wrong.  I set mine to 3% foreground (~ half a gig @ 16 GiB)
> and 1% (~160 MiB) background when I upgraded to 16 GiB RAM, tho now I
> have fast SSDs, but didn't see a need to boost it back up, as half a GiB
> is quite enough to have unsynced in case of a crash anyway.
Personally I usually just use small byte values (64MB for the system 
wide limit, and 4MB for the per-process limit).  I also do a decent 
amount of work with removable media (which takes longer to unmount the 
higher these are), and have good SSD's that do proper write-reordering 
and guarantee that writes will finish even if power dies in the middle, 
and don't care as much about write performance on my traditional disks 
(most of those are used as backing storage for VM's which can fit their 
entire working set in RAM, so having fast storage isn't as high priority 
for them).
>
> (Obviously once RAM goes above ~16 GiB, for systems not yet on fast SSD,
> the bytes values begin to make more sense to use than ratio, as 1% of RAM
> is simply no longer fine enough granularity.  But 1% of 16 GiB is ~163
> MiB, ~5 seconds worth @ 30 MiB/sec, so fine /enough/... barely.  The 3%
> foreground figure is then ~16 seconds worth of writeback, a bit
> uncomfortable if you're waiting on it, but comfortably below the 30
> second timeout and still at least tolerable in human terms, so not /too/
> bad.  And as I said, for me the system and /home are now on fast SSD, so
> in practice the only time I'm worrying about spinning rust transfer
> backlogs is on the media and backups drive, which is still spinning
> rust.  And it's tolerable there, so the ratio knobs continue to be fine,
> for my own use.)
>
>>> But that has always been an unverified on my part fuzzy assumption.
>>> The two times could be the same layer, with the btrfs mount option
>>> being a per-filesystem method of controlling the same thing that
>>> /proc/sys/vm/ dirty_expire_centisecs controls globally (as you seemed
>>> to imply above), or the two could be different layers but with the
>>> countdown times overlapping, both of which would result in a 30-second
>>> total timeout, instead of the 30+30=60 that I had assumed.
>>
>> The two timers do overlap.
>
> Good to have it verified. =:^)  The difference between 30 seconds and a
> minute's worth of work lost in a crash can be quite a lot, if one was
> copying a big set of small files at the time.
>
>>> And while we're at it, how does /proc/sys/vm/vfs_cache_pressure play
>>> into all this?  I know the dirty_* and how the dirty_*bytes vs.
>>> dirty_*ratio vs. dirty_*centisecs thing works, but don't quite
>>> understand how vfs_cache_pressure fits in with dirty_*.
>
>> vfs_cache_pressure controls how likely the kernel is to drop clean pages
>> (the documentation says just dentries and inodes, but I'm relatively
>> certain it's anything in the VFS cache) from the VFS cache to get memory
>> to allocate.  The higher this is, the more likely the VFS cache is to
>> get invalidated.  In general, you probably want to increase this on
>> systems that have fast storage (like SSD's or really good SAS RAID
>> arrays, 150 is usually a decent start), and decrease it if you have
>> really slow storage (Like a Raspberry Pi for example).  Setting this too
>> low (below about 50) however, will give you a very high chance of
>> getting an OOM condition.
>
> So vfs_cache_pressure only applies if you're out of "free" memory, and
> the kernel has to decide whether to dump cache or OOM, correct?  On
> systems with enough memory, and with stuff like the local package cache
> and/or multimedia on separate partitions that are mounted only when
> needed and unmounted when not, so actual system-and-apps plus buffers
> plus cache memory generally stays reasonably below total RAM, with
> reasonable ulimits and tmpfs maximum sizes set so apps can't go hog-wild,
> there's zero cache pressure so this setting doesn't apply at all...
> unless/until there's a bad kernel leak and/or several apps go somewhat
> wild, plus something's maximizing a few of those tmpfs, all at once, of
> course.
Kind of, it comes into play any time the kernel goes to reclaim memory, 
which is usually to complete higher order allocations in kernel space 
(like allocating big DMA buffers or similar stuff).  It's important to 
note that it's not usually a factor in dealing with an OOM condition 
(unless you lower it, in which case it can be a big contributing 
factor).  As an example, say you plug in a USB NIC, the kernel has to 
allocate a lot of different things to be able to work with it reliably, 
and /proc/sys/vfs_cache_pressure tells it how much to favor dropping 
bits of the VFS cache to satisfy those allocations as opposed to other 
methods (like memory compaction, which can be expensive on big systems).
>
> (As I write this system/app memory usage is ~2350 MiB, buffers 4 MiB,
> cache 7321 MiB, total usage ~9680 MiB, on a 16 GiB system.  That's with
> about three days uptime, after mounting the packages partition and
> remounting / rw and doing a bunch of builds, then umounting the pkgs
> partition, killing X and running a lib_users check to ensure no services
> are running on outdated deleted libs and need restarted, remounting / ro,
> and restarting X.  At some point I had the media partition mounted too,
> but now it's unmounted again, dropping that cache.  So in addition to
> cache memory which /could/ be dumped if I had to, I have 6+ GiB of
> entirely idle unused memory.  Nice as I don't have swap configured, so if
> I'm out of RAM, I'm out, but there's a lot of cache to dump first before
> it gets that bad.  Meanwhile, zero cache pressure, and 6+ GiB of spare
> RAM to use for apps/tmpfs/cache if I need it, before any cache dumps at
> all! =:^)
I wish I could get away with running without swap :)  My laptop only has 
8G of RAM, and I run Xen on my desktop, which means I have significantly 
less than the 32G of installed RAM to work with from my desktop VM 
there, and if I don't use swap, I often end up killing the machine 
trying to do some of the multimedia work I sometimes do.  OTOH, I've got 
swap on an SSD on both systems, which gets me ridiculous performance 
since I've got them configured to swap in and out pages in groups the 
size of an erase block on the SSD (which also means that it's not 
tearing up the SSD as much either).
>
>> Documentation/sysctl/vm.txt in the kernel sources covers them, although
>> the documentation is a bit sparse even there.
>
> I knew the kernel's proc documentation in Documentation/filesystems/
> proc.txt, plus whatever outside resource it was that originally got me
> looking into the whole thing in the first place, I had the /proc/sys/vm/
> dirty_* files and their usage covered.  But the sysctl/* doc files and
> the the vfs_cache_pressure proc file, not so much, and as I said I didn't
> understand how the btrfs commit= mount option fit into all of this.  So
> now I have a rather better understanding of how it all fits together. =:^)
Glad I could help.  The sysctl options are one of the places I would 
love to see better documented, I just don't have the time and enough 
knowledge of them to do so myself.  There's still a significant number 
that aren't documented there at all (lots of them in /proc/sys/kernel).

