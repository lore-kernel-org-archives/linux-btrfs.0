Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:41855 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbaLTK5m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 05:57:42 -0500
Message-ID: <54955624.5040808@pobox.com>
Date: Sat, 20 Dec 2014 02:57:40 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca>
In-Reply-To: <20141217024228.GA5544@pyropus.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2014 06:42 PM, Charles Cazabon wrote:
> Hi,
>
> I've been running btrfs for various filesystems for a few years now, and have
> recently run into problems with a large filesystem becoming *really* slow for
> basic reading.  None of the debugging/testing suggestions I've come across in
> the wiki or in the mailing list archives seems to have helped.
>
> Background: this particular filesystem holds backups for various other
> machines on the network, a mix of rdiff-backup data (so lots of small files)
> and rsync copies of larger files (everything from ~5MB data files to ~60GB VM
> HD images).  There's roughly 16TB of data in this filesystem (the filesystem
> is ~17TB).  The btrfs filesystem is a simple single volume, no snapshots,
> multiple devices, or anything like that.  It's an LVM logical volume on top of
> dmcrypt on top of an mdadm RAID set (8 disks in RAID 6).
>
> The performance:  trying to copy the data off this filesystem to another
> (non-btrfs) filesystem with rsync or just cp was taking aaaages - I found one
> suggestion that it could be because updating the atimes required a COW of the
> metadata in btrfs, so I mounted the filesystem noatime, but this doesn't
> appear to have made any difference.  The speeds I'm seeing (with iotop)
> fluctuate a lot.  They spend most of the time in the range of 1-3 MB/s, with
> large periods of time where no IO seems to happen at all, and occasional short
> spikes to ~25-30 MB/s.  System load seems to sit around 10-12 (with only 2
> processes reported as running, everything else sleeping) while this happens.
> The server is doing nothing other than this copy at the time.  The only
> processes using any noticable CPU are rsync (source and destination processes,
> around 3% CPU each, plus an md0:raid6 process around 2-3%), and a handful of
> "kworker" processes, perhaps one per CPU (there are 8 physical cores in the
> server, plus hyperthreading).
>
> Other filesystems on the same physical disks have no trouble exceeding 100MB/s
> reads.  The machine is not swapping (16GB RAM, ~8GB swap with 0 swap used).
>
> Is there something obvious I'm missing here?  Is there a reason I can only
> average ~3MB/s reads from a btrfs filesystem?
>
> kernel is x86_64 linux-stable 3.17.6.  btrfs-progs is v3.17.3-3-g8cb0438.
> Output of the various info commands is:
>
>    $ sudo btrfs fi df /media/backup/
>    Data, single: total=16.24TiB, used=15.73TiB
>    System, DUP: total=8.00MiB, used=1.75MiB
>    System, single: total=4.00MiB, used=0.00
>    Metadata, DUP: total=35.50GiB, used=34.05GiB
>    Metadata, single: total=8.00MiB, used=0.00
>    unknown, single: total=512.00MiB, used=0.00
>
>    $ btrfs --version
>    Btrfs v3.17.3-3-g8cb0438
>
>    $ sudo btrfs fi show
>
>    Label: 'backup'  uuid: c18dfd04-d931-4269-b999-e94df3b1918c
>      Total devices 1 FS bytes used 15.76TiB
>      devid    1 size 16.37TiB used 16.31TiB path /dev/mapper/vg-backup
>
> Thanks in advance for any suggestions.
>
> Charles
>

Totally spit-balling ideas here (e.g. no suggestion as to which one to 
try first etc, just typing them as they come to me):

Have you tried increasing the number of stripe buffers for the 
filesystem? If you've gotten things spread way out you might be 
thrashing your stripe cache. (see /sys/block/md(number 
here)/md/stripe_cache_size).

Have you taken SMART (smartmotools etc) to these disks to see if any of 
them are reporting any sort of incipient failure conditions? If one or 
more drives is reporting recoverable read errors it might just be 
clogging you up.

Try experimentally mounting the filesystem read-only and dong some read 
tests. This elimination of all possible write sources will tell you 
things. In particular if all your reads just start breezing through then 
you know something in the write path is "iffy". One thing that comes to 
mind is that anything accessing the drive with a barrier-style operation 
(wait for verification of data sync all the way to disk) would have to 
pass all the way down through the encryption layer which could be having 
a multiplier effect. (you know, lots of very short delays making a large 
net delay).

Have you changed any hardware lately in a way that could de-optimize 
your interrupt handling.

I have a vague recollection that somewhere in the last month and a half 
or so there was a patch here (or in the kernel changelogs) about an 
extra put operation (or something) that would cause a worker thread to 
roll over to -1, then spin back down to zero before work could proceed. 
I know, could I _be_ more vague? Right? Try switching to kernel 3.18.1 
to see if the issue just goes away. (Honestly this one's just been 
scratching at my brain since I started writing this reply and I just 
_can't_ remember the reference for it... dangit...)

When was the last time you did any of the maintenance things (like 
balance or defrag)? Not that I'd want to sit through 15Tb of that sort 
of thing, but I'm curious about the maintenance history.

Does the read performance fall off with uptime? E.g. is it "okay" right 
after a system boot and then start to fall off as uptime (and activity) 
increases? I _imagine_ that if your filesystem huge and your server is 
modest by comparison in terms of ram, cache pinning and fragmentation 
can start becoming a real problem. What else besides marshaling this 
filesystem is this system used for?

Have you tried segregating some of your system memory for to make sure 
that you aren't actually having application performance issues?  I've 
had some luck with kernelcore= and moveablecore= (particularly 
moveablecore=) kernel command line options when dealing with IO induced 
fragmentation. On problematic systems I'll try classifying at least 1/4 
of the system ram as movablecore. (e.g. on my 8GiB laptop were I do some 
of my experimental work, I have moveablecore=2G on the command line). 
Any pages that get locked into memory will be moved out of the 
movable-only memory first. This can have a profound (usually positive) 
effect on applications that want to spread out in memory. If you are 
running anything that likes large swaths of memory then this can help a 
lot. Particularly if you are also running programs that traverse large 
swaths of disk. Some programs (rsync of large files etc may be such a 
program) can do "much better" if you've done this. (BUT DON'T OVERDO IT, 
enough is good but too much is very bad. 8-) ).


ASIDE: Anything that uses hugepages, transparent or explicit, in any 
serious number has a tendency to antagonize the system cache (and 
vice-versa). It's a silent fight of the cache-pressure sort. When you 
explicitly declare an amount of ram for moveable pages only, the disk 
cache will not grow into that space. so moveablecore=3G creates 3GiB of 
space where only unlocked pages (malloced heap, stack, etc; basically 
only things that can get moved -- particularly swapped -- will go in 
that space.) The practical effect is that certain kinds of pressures 
will never compete. So broad-format disk I/O (e.g. using find etc) will 
tend to be on one side of the barrier while video playback buffers and 
virtual machine's ram regions are on the other. The broad and deep 
filesystem you describe could be thwarting your program's attempt to 
access it. That is, the rsync's need to load a large number of inodes 
could be starving rsync for memory (etc). Keeping the disk cache out of 
your program's space at least in part could prevent some very 
"interesting" contention models from ruining your day.

Or it could just make things worse.

So it's worth a try but it's not gospel. 8-)
