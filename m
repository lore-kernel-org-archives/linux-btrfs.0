Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43042 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbcCXGMA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 02:12:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiyUv-0002lt-Ch
	for linux-btrfs@vger.kernel.org; Thu, 24 Mar 2016 07:11:57 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 07:11:57 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 07:11:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Thu, 24 Mar 2016 06:11:44 +0000 (UTC)
Message-ID: <pan$bb328$cf4ba5ae$55fe61f9$a9194f18@cox.net>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
	<CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
	<56F349F0.5070202@cn.fujitsu.com> <56F34D5F.4080407@gmail.com>
	<56F35216.1060103@cn.fujitsu.com> <56F3559C.3030201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brad Templeton posted on Wed, 23 Mar 2016 19:49:00 -0700 as excerpted:

> On 03/23/2016 07:33 PM, Qu Wenruo wrote:
> 
>>> Still, it seems to me
>>> that the lack of space even after I filled the disks should not
>>> interfere with the balance's ability to move chunks which are found on
>>> both 3 and 4 so that one remains and one goes to the 6.  This action
>>> needs no spare space.   Now I presume the current algorithm perhaps
>>> does not work this way?
>> 
>> No, balance is not working like that.
>> Although most user consider balance is moving data, which is partly
>> right. The fact is, balance is, copy-and-delete. And it needs spare
>> space.
>> 
>> Means you must have enough space for the extents you are balancing,
>> then btrfs will copy them, update reference, and then delete old data
>> (with its block group).
>> 
>> So for balancing data in already filled device, btrfs needs to find
>> space for them first.
>> Which will need 2 devices with unallocated space for RAID1.
>> 
>> And in you case, you only have 1 devices with unallocated space, so no
>> space to balance.
> 
> Ah.  I would class this as a bug, or at least a non-optimal design.  If
> I understand, you say it tries to move both of the matching chunks to
> new homes.  This makes no sense if there are 3 drives because it is
> assured that one chunk is staying on the same drive.   Even with 4 or
> more drives, where this could make sense, in fact it would still be wise
> to attempt to move only one of the pair of chunks, and then move the
> other if that is also a good idea.

What balance does, at its most basic, is rewrite and in the process 
manipulate chunks in some desired way, depending on the filters used, if 
any.  Once the chunks have been rewritten, the old copies are deleted.  
But existing chunks are never simply left in place unless the filters 
exclude them entirely.  If they are rewritten, a new chunk is created and 
the old chunk is removed.

Now one of the simplest and most basic effects of this rewrite process is 
that where two or more chunks of the same type (typically data or 
metadata) are only partially full, the rewrite process will create a new 
chunk and start writing, filling it until it is full, then creating 
another and filling it, etc, which ends up compacting chunks as it 
rewrites them.  So if there's ten chunks and average of 50% full, it'll 
compact that into five chunks, 100% full.  The usage filter is very 
helpful here, letting you tell balance to only bother with chunks that 
are under say 10% (usage=10) full, where you'll get a pretty big effect 
for the effort, as 10 such chunks can be consolidated into one.  Of 
course that would only happen if you /had/ 10 such chunks under 10% full, 
but at say usage=50, you still get one freed chunk for every two balance 
rewrites, taking longer, but still far less time than it would take to 
rewrite 90% full chunks, with far more dramatic effects... as long as 
there are chunks to balance and combine at that usage level, of course.

Here, we're using a different side effect, the fact that with a raid1 
setup, there are always two copies of the chunk, one on each of exactly 
two devices, and that when new chunks are allocated, they *SHOULD* be 
allocated from the devices with the most free space, subject only to the 
rule that both copies cannot be on the same device, so the effect is that 
it'll allocate from the device with the most space left for the first 
copy, and then for the second copy, it'll allocate from the device with 
the most space left, but where the device list excludes the device that 
the first copy is on.

But, the point that Qu is making is that balance, by definition, rewrites 
both raid1 copies of the chunk.  It can't simply rewrite just the one 
that's on the fullest device to the most empty and leave the other copy 
alone.  So what it will do is allocate space for a new chunk from each of 
the two devices with the most space left, and will copy the chunks to 
them, only releasing the existing copies when the copy is done and the 
new copies are safely on their respective devices.

Which means that at least two devices MUST have space left in ordered to 
rebalance from raid1 to raid1.  If only one device has space left, no 
rebalance can be done.

Now your 3 TB and 4 TB devices, one each, are full, with space left only 
on the 6 TB device.  When you first switched from the 2 TB device to the 
6 TB device, the device delete would have rewritten from the 2 TB device 
to the 6 TB device, and you probably had some space left on the other 
devices at that point.  However, you didn't have enough space left on the 
other two devices to utilize much of the 6 TB device, because each time 
you allocated a chunk on the 6 TB device, a chunk had to be allocated on 
one of the others as well, and they simply didn't have enough space left 
by that point to do that too many times.


Now, you /did/ try to rebalance before you /fully/ ran out of space on 
the other devices, and that's what Chris and I were thinking should have 
worked, putting one copy of each rebalanced chunk on the 6 TB device.

But, lacking (preferably) btrfs device usage (or btrfs filesystem show, 
gives a bit less information but does say how much of each device is 
actually used) reports from /before/ the further fillup, we can't say for 
sure how much space was actually left.

Now here's the question.  You said you estimated each drive had ~50 GB 
free when you did the original replace and then tried to balance, but 
where did that 50 GB number come from?

Here's why it matters.  Btrfs allocates space in two steps.  First it 
allocates from the unallocated pool into chunks, which can be data or 
metadata (there's also system chunks, but that's only a few MiB total, in 
your case 32 MiB on each of two devices given the raid1, and doesn't 
change dramatically with usage as data and metadata chunks do).

And it can easily happen that all available space is already allocated 
into (partially used) chunks, so there's no actually unallocated space 
left on a device in ordered to allocate further chunks, but there's still 
sufficient space left in the partially used chunks to continue adding and 
changing files for some time.  Only when new chunk allocation is 
necessary will a problem show up.

Now given the various btrfs reports, btrfs fi show and btrfs fi df, or 
btrfs fi usage, or for a device-centric report, btrfs dev usage, possibly 
combined with the other reports depending on what you're trying to figure 
out, it's quite possible to tell exactly what the status of each of the 
devices is, regarding both unallocated space as well as allocated chunks, 
and how much of those allocated chunks is actually used (globally, 
unfortunately actual usage of the chunk allocation isn't broken down by 
device, tho that information isn't technically needed per-device).

But if you're estimating only based on normal df, not the btrfs versions 
of the commands, you don't know how much space remained actually 
unallocated on each device, and for balance, that's the critical thing, 
particularly with raid1, since it MUST have space to allocate new chunks 
on AT LEAST TWO devices.


Which is where the IRC recommendation to add a 4th device of some GiB 
came in, the idea being to add enough unallocated space on that 4th 
device, that being the second device with actually unallocated space, to 
get you out of the tight spot.


There is, however, another factor in play here as well, chunk size.  Data 
chunks are the largest, and are nominally 1 GiB in size.  *HOWEVER*, on 
devices over some particular size, they can increase in size upto, a dev 
stated in one thread, 10 GiB in size.  However, while I know it can 
happen at larger filesystem and device sizes, I don't have the foggiest 
what the conditions and algorithms for chunk size are.  But with TB-scale 
devices and btrfs', it's very possible, even likely, that you're dealing 
with over the 1 GiB nominal size.

And if you're dealing with 10 GiB chunk sizes, or possibly even larger if 
I took that dev's chunk size limitation comments out of context and am 
wrong about that chunk size limit...

You may well simply not have a second device with enough unallocated 
space on it to properly handle the chunk sizes on that filesystem.  
Certainly, the btrfs fi usage report you posted showed a few gigs of 
unallocated space on each of three of the four devices (with all sorts of 
space left on the 6 TB device, of course), but all three were in the 
single-digits GB, and if most of your data chunks are 10 GiB... you 
simply don't have a device with enough unallocated space left to write 
that second copy.


Tho adding back that 2 TB device and doing a balance should indeed give 
you enough space to put a serious dent in that imbalance.

But as Qu says, you will likely end up having to rebalance several times 
in ordered to get it nicely balanced out, since you'll fill up that under 
2 TiB pretty fast from the other two full devices and it'll start round-
robinning to all three for the second copy before the other two are even 
a TiB down from full.

Again as Qu says, rebalancing to single and back to raid1 is another 
option, that should result in a much faster loading of the 6 TB device.  
I think (but I'm not sure) that the the single mode allocator still uses 
the "most space" allocation algorithm, in which case, given a total raid1 
usage of 7.77 TiB, which should be 3.88 TiB (~4.25 TB) in single mode, 
you should end up with a nearly free 3 TB device, just under 1 GiB on the 
4 TB device, and just under 3 TB on the 6 TB device, basically 3 TB free/
unallocated on each of the three devices.

(The tiny 4th device should be left entirely free in that case and should 
then be trivial to device delete as there will be nothing on it to move 
to other devices, it'll be a simple change to the system chunk device 
data and the superblocks on the other three devices.)

Then you can rebalance to raid1 mode again, and it should use up that 3 
TB on each device relatively evenly, round-robinning an unused device  
that alternates on each set of chunks copied.  While ~3/4 of all chunks 
should start out with their single-mode copy on the 6 TB device, 3/4 of 
all chunks deleted will be off it, leaving it free to get one of the two 
copies most of the time.  You should end up with about 1.3 TB free per 
device, with about 1.6 TB of the 3 TB device allocated, 2.6 TB of the 4 
TB device allocated, together pretty well sharing one copy of each chunk 
between them, and 4.3 T of the 6 TB device used, pretty much one copy of 
each chunk on its own.

The down side to that is that you're left with only a single copy while 
in single mode, and if that copy gets corrupted, you simply lose whatever 
was in that now corrupted chunk.  If the data's valuable enough, you may 
thus prefer to do repeated balances.

The other alternative of course is to ensure that everything that's not 
trivially replaced is backed up, and start from scratch with a newly 
created btrfs on the three devices, restoring to it from backup.

That's what I'd do, since the sysadmin's rule of backups in simple form 
says if it's not backed up, you are by definition of your (in)action, 
defining that data as worth less than the time/trouble/resources 
necessary to back it up.  So if it's worth the hassle it should be 
already backed up so you can simply blow away the existing filesystem, 
create it over new, and restore from backups, and if you don't have those 
backups, then by definition it's not worth the hassle, and starting over 
with a fresh filesystem is all three of (1) less hassle, (2) a chance to 
take advantage of newer filesystem options that weren't available when 
you first created the existing filesystem, and (3) a clean start, blowing 
away any chance of some bug lurking in the existing layout waiting to 
come back and bite you after you've put all the work into those 
rebalances, if you choose them over the clean start.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

