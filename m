From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Sun, 12 Feb 2012 22:31:42 +0000 (UTC)
Message-ID: <pan.2012.02.12.22.31.41@cox.net>
References: <pan.2012.01.26.15.41.32@cox.net>
	<201201291223.40161.kreijack@inwind.it>
	<COL113-W485767962008EF29E7E27EB08D0@phx.gbl>
	<pan.2012.01.31.05.55.47@cox.net> <4F3573E7.9080306@ubuntu.com>
	<pan.2012.02.11.05.48.22@cox.net> <4F370219.1000205@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Sat, 11 Feb 2012 19:04:41 -0500 as excerpted:

> On 02/11/2012 12:48 AM, Duncan wrote:
>> So you see, a separate /boot really does have its uses. =:^)
> 
> True, but booting from removable media is easy too, and a full livecd
> gives much more recovery options than the grub shell.

And a rootfs backup that's simply a copy of rootfs at the time it was 
taken is even MORE flexible, especially when rootfs is arranged to 
contain all packages installed by the package manager.  That's what I 
use.  If misfortune comes my way right in the middle of a critical 
project and rootfs dies, simply root= on the kernel command line at the 
grub prompt, to the backup root, and assuming that critical project is on 
another filesystem (such as home), I can normally simply continue where I 
left off.  Full X and desktop, browser, movie players, document editors 
and viewers, presentation software, all the software I had on the system 
at the time I made the backup, directly bootable without futzing around 
with data restores, etc. =:^)

> It is the corrupted root fs that is of much more concern than /boot.

Yes, but to the extent that /boot is the gateway to both the rootfs and 
its backup... and digging out the removable media is at least a /bit/ 
more hassle than simply altering the root= (and mdX=) on the kernel 
command line...`

(Incidentally, I've thought for quite some time that I really should have 
had two such backups, such that if I'm just doing the backup when 
misfortune strikes and takes out both the working rootfs and its backup, 
the backup being mounted and actively written at the time of the 
misfortune, I could always boot to the second backup.  But I hadn't 
considered that when I did the current layout.  Given that rootfs with 
the full installed system's only 4.75 gigs (with a quarter gig /usr/local 
on the same 5 gig partitioned md/raid), it shouldn't be /too/ difficult 
to fit that in at my next rearrange, especially if I do the 4/3 raid10s 
as you suggested (for another ~100 gig since I'm running 300 gig disks).)

>> I don't "grok" [raid10]
> 
> To grok the other layouts, it helps to think of the simple two disk
> case.
> A far layout is like having a raid0 across the first half of the disk,
> then mirroring the whole first half of the disk onto the second half of
> the other disk.  Offset has the mirror on the next stripe so each stripe
> is interleaved with a mirror stripe, rather than having all original,
> then all mirrors after.
> 
> It looks like mdadm won't let you use both at once, so you'd have to go
> with a 3 way far or offset.  Also I was wrong about the additional
> space.  You would only get 25% more space since you still have 3 copies
> of all data so you get 4/3 times the space, but you will get much better
> throughput since it is striped across all 4 disks.  Far gives better
> sequential read since it reads just like a raid0, but writes have to
> seek all the way across the disk to write the backup.  Offset requires
> seeks between each stripe on read, but the writes don't have to seek to
> write the backup.

Thanks.  That's reasonably clear.  Beyond that, I just have to DO IT, to 
get comfortable enough with it to be confident in my restoration 
abilities under the stress of an emergency recovery.  (That's the reason 
I ditched the lvm2 layer I had tried, the additional complexity of that 
one more layer was simply too much for me to be confident in my ability 
to manage it without fat-fingering under the stress of an emergency 
recovery situation.)

> You also could do a raid6 and get the double failure tolerance, and two
> disks worth of capacity, but not as much read throughput as raid10.

Ugh!  That's what I tried as my first raid layout, when I was young and 
foolish, raid-wise!  Raid5/6's read-modify-write cycle in ordered to get 
the parity data written was simply too much!  Combine that with the 
parallel job read boost of raid1, and raid1 was a FAR better choice for 
me than raid6!

Actually, since much of my reading /is/ parallel jobs and the kernel i/o 
scheduler and md do such a good job of taking advantage of raid1's 
parallel-read characteristics, it has seemed I do better with that that 
with raid0!  I do still have one raid0, for gentoo's package tree, the 
kernel tree, etc, since redundancy doesn't matter for it and the 4X space 
it gives me for that is nice, but bigger storage, I'd have it all raid1 
(or now raid10) and not have to worry about other levels.

Counterintuitively, even write seems more responsive with raid1 than 
raid0, in actual use.  The only explanation I've come up with for that is 
that in practice, any large scale writes tend to be reads from elsewhere 
as well, and the md scheduler is evidently smart enough to read from one 
spindle and write to the others, then switch off to catch up writing on 
the formerly read-spindle, such that there's rather less head seeking 
between read and write than there'd be otherwise.  Since raid0 only has 
the single copy, the data MUST be read from whatever spindle it resides 
on, thus eliminating the kernel/md's ability to smart-schedule, favoring 
one spindle at a time for reads to eliminate seeks.

For that reason, I've always thought that if I went to raid10, I'd try to 
do it with at least triple spindle at the raid1 level, thus hoping to get 
both the additional redundancy and parallel scheduling of raid1, while 
also getting the thruput speed and size of the stripes.

Now you've pointed out that I can do essentially that with a triple 
mirror on quad spindle raid10, and I'm seeing new possibilities open up...

>> Multiple
>> raids, with the ones I'm not using ATM offline, means I don't have to
>> worry about recovering the entire thing, only the raids that were
>> online and actually dirty at the time of crash or whatever.
> 
> Depends on what you mean by recovery.  Re-adding a drive that you
> removed will be faster with multiple raids ( though write-intent bitmaps
> also take care of that ), but if you actually have a failed disk and
> have to replace it with a new one, you still have to do a rebuild on all
> of the raids so it ends up taking the same total time.

Very good point.  I was talking about re-adding.  For various reasons 
including hardware power-on stability latency (these particular disks 
apparently take a bit to stabilize after power on and suspend-to-disk 
often kicks a disk on resume due to ID-match-failure, which then appears 
as say sde instead of sdb; I've solved that problem by simply leaving on 
or shutting down the system instead of using suspend-to-disk), faulty 
memory at one point causing kernel panics, and the fact that I run live-
git kernels, I've had rather more experience with re-add than I would 
have liked.  But that has made me QUITE confident in my ability to 
recover from either that or a dead drive, since I've had rather more 
practice than I anticipated.

But all my experience has been with re-add, so that's what I was thinking 
about when I said recovery.  Thanks for pointing out that I omitted to 
mention that as I was really quite oblivious. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

