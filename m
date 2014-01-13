Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33041 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaAMHVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 02:21:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2bqH-0007th-3t
	for linux-btrfs@vger.kernel.org; Mon, 13 Jan 2014 08:21:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 08:21:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 08:21:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Issues with "no space left on device" maybe related to 3.13
 and/or kvm disk image fragmentation
Date: Mon, 13 Jan 2014 07:21:26 +0000 (UTC)
Message-ID: <pan$7af36$542cb610$935a8f99$e4118763@cox.net>
References: <52D2F9FF.5060905@kuther.net> <52D31FB5.1040906@kuther.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Kuther posted on Mon, 13 Jan 2014 00:05:25 +0100 as excerpted:
> 

[ Rearranged to standard quote/reply order so replies are in context.  
Top-posting is irritating to try to reply to.]

> Am 12.01.2014 21:24, schrieb Thomas Kuther:
>> 
>> I'm experiencing an interesting issue with the BTRFS filesystem on my
>> SSD drive. It first occured some time after the upgrade to kernel
>> 3.13-rc (-rc3 was my first 3.13-rc) but I'm not sure if it is related.
>> 
>> The obvious symptoms are that services on my system started crashing
>> with "no space left on device" errors.
>> 
>> └» mount |grep "/mnt/ssd"
>> /dev/sda2 on /mnt/ssd type btrfs
>> (rw,noatime,compress=lzo,ssd,noacl,space_cache)
>> 
>> └» btrfs fi df /mnt/ssd
>> Data, single: total=113.11GiB, used=90.02GiB
>> System, DUP: total=64.00MiB, used=24.00KiB
>> System, single: total=4.00MiB, used=0.00
>> Metadata, DUP: total=3.00GiB, used=2.46GiB

This shows only half the story, tho.  You also need the output of btrfs fi 
show /mnt/ssd.  Btrfs fi show displays how much of the total available 
space is chunk-allocated; btrfs fi df displays how much of the chunk-
allocation for each type is actually used.  Only with both of them is the 
picture complete enough to actually see what's going on.

>> I use snapper on two subvolumes of that BTRFS volume (/ and /home) -
>> each keeping 7 daily snapshots and up to 10 hourlys.
>> 
>> When I saw those errors I started to delete most of the older
>> snapshots,
>> and the issue went away instantly, but this couldn't be a solution nor
>> a workaround.
>> 
>> I do though have a "usual suspect" on that BTRFS volume. A KVM disk
>> image of a Win8 VM (I _need_ Adobe Lightroom)
>> 
>> » lsattr /mnt/ssd/kvm-images/
>> ---------------C /mnt/ssd/kvm-images/Windows_8_Pro.qcow2
>> 
>> So the image has CoW disabled. Now comes the interesting part:
>> I'm trying to copy off the image to my raid5 array (BTRFS ontop of a
>> mdraid 5 - absolutely no issues with that one), but the cp process
>> seems like it's stalled.
>> 
>> After one hour the size of the destination copy is still 0 bytes. iotop
>> almost constantly show values like
>> 
>>  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
>>  4636 be/4 tom        14.40 K/s    0.00 B/s  0.00 %  0.71 % cp
>> /mnt/ssd/kvm-images/Windows_8_Pro.qcow2 .
>> 
>> It tries to read the file with some 14K/s and writes absolutely
>> nothing.
>> 
>> Any idea what's going wrong here, or suggestions how to get that qcow
>> file copied off? I do have a backup, but honestly that one is quite
>> aged - so simply rm'ing it would be the very last thing I'd like to
>> try.

OK.  There's a familiar known-troublesome pattern here that your 
situation fits... with one difference that I had previously /thought/ 
would ameliorate the problem, but either you didn't catch the problem 
soon enough, or the root issue is more complex than I at first understood 
(quite possible, since while I'm a regular on the list and thus see the 
common issues posted, I'm just a btrfs user/admin, not a dev, btrfs or 
otherwise).

The base problem is that btrfs is normally a copy-on-write filesystem, 
and frequently internally-rewritten (as opposed to sequential-write 
append-only or write once, read many) files are in general a COW-
filesystem's worst-case, the larger the file and more frequently 
partially rewritten, the worse it is, since every small internal write 
will COW the area being written elsewhere, quickly fragmenting large 
routinely internal-written files such as VM images into hundreds of 
thousands of extents!  =:^(

In general, btrfs has two methods to help deal with that.  For smaller 
files the autodefrag mount option can help.  For larger files autodefrag 
can be a performance issue in itself due to write magnification (each 
small internal write triggering a rewrite of the entire multi-gig file), 
but there's the NOCOW extended-attribute, which is what /has/ been 
recommended for these things as it's supposed to tell the filesystem to 
do in-place rewrites instead of COW.  That doesn't seem to have worked 
for you, which is the interesting bit, but it's possible that's an 
artifact of how it was handled.  Additionally, there's the snapshot 
aspect throwing further complexity into the works, as described below.

OK, so the file has NOCOW (the +C xattribute) set, which is good.  *BUT*, 
when/how did you set it?  On btrfs that can make all the difference!

The caveat with NOCOW on btrfs is that in ordered to be properly 
effective, NOCOW must be set on the file when it's first created, before 
there's actually any data in it.  If the attribute is not set until 
later, when the file is not zero-size, behavior isn't what one might 
expect or desire -- simply stated, it doesn't work.

The simplest way to ensure that a file gets the NOCOW attribute set while 
it's still empty is to set the attribute on the parent directory before 
the file is created in the first place.  Any newly created files will 
then automatically inherit the directory's attribute, and thus will be 
set NOCOW from the beginning.

A second method is to do it manually by first creating the zero-length 
file using touch, then setting the NOCOW attribute using chattr +C, and 
only /then/ copying the content into it.  However, this is a rather 
difficult for files created by other processes, so the directory 
inheritance method is generally recommended as the simplest method.

So now the question is, the file has NOCOW set as recommended, but was it 
set before the file had content in it as required, or was NOCOW only set 
later, on the existing file with its existing content, thus in practice 
nullifying the effect of setting it at all?

Meanwhile, the other significant factor here is the snapshotting.  In VM-
image-cases *WITHOUT* the NOCOW xattr properly set, heavy snapshotting of 
a filesystem with VM images is a known extreme worst-case of the worst-
cases, with *EXTREMELY* bad behavior characteristics that don't scale 
well at all, such that attempting to work with that file will tie up the 
filesystem in huge knots such that very little forward progress can be 
made, period.  We're talking days or even weeks to do what /should/ have 
taken a few minutes, due to the *SEVERE* scaling issues.  They're working 
on the problem, but it's a tough one to solve and its scale only recently 
became apparent.

Actually, the current theory is that the recent changes to make defrag 
snapshot-aware may have triggered the severe scaling issues we're seeing 
now.  Before that, the situation was bad, but apparently not horribly 
terribly broken to the point of not working at all, as it is now.

But as I said, the previous recommendation has been to NOCOW the file to 
prevent the problem from ever appearing in the first place.

Which you have apparently done and the problem is still there, except 
that we don't know yet whether you set NOCOW effectively, probably using 
the inheritance method, or not.  If you set it effectively, then the 
problem is worse, MUCH worse, than thought, since the recommended 
workaround, doesn't workaround.  But if you set it too late to be 
effective, then the problem is simply another instance of the already 
known issue.

As for how to manage the existing file, you seem to have figured that out 
already, below...

>> PS: please reply-to-all, I'm not subscribed. Thanks.

OK.  I'm doing so here, but please remind in every reply.

FWIW, I read and respond to the list as a newsgroup using gmane.org's 
list2news service and normally reply to the "newsgroup", which gets 
forwarded to the list.  So I'm not actually using a mail client but a 
news client, and replying to both author and newsgroup/list isn't 
particularly easy, nor do I do it often, so reminding with every reply 
does help me remember.

> I did some more digging, and I think I have two maybe unrelated issues
> here.
> 
> The "no space left on device" could be caused by the amount of metadata
> used. I defragmented the KVM image and other parts, ran a "balance start
> -dusage=5", and now it looks like
> 
> └» btrfs fi df /
> Data, single: total=113.11GiB, used=88.83GiB
> System, DUP: total=64.00MiB, used=24.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=3.00GiB, used=2.40GiB

Just as a hint, you can get rid of that extra system chunk (the empty 
single one) by doing a balance -sf (system, force, force necessary when 
balancing system chunks only, not as part of metadata).   Since that's 
only a few KiB of actual system data, it should go fast, and you won't 
have that second system chunk display any more. =:^)

> The issue with copying/moving off the KVM image still remains. Using
> "cp" or "mv" hangs. Interestingly, what did work was using "qemu-img
> convert -O raw ..." so now I have a fresh backup at least. The VM works
> just fine with the original image file. I really wonder what goes wrong
> with cp and mv.

They're apparently getting caught up in that 100k-extents snapshot 
scaling morass...

But *THANKS* for the qemu-img convert idea.  I haven't setup any VMs here 
so didn't know about that at all.  At least now I can pass on something 
that should actually let people get a backup to work with. =:^)


Meanwhile...

> And I stumbled over a third issue with my raid5 array:
> └» df -h|grep /mnt/btrfs
> /dev/md0        5,5T    3,4T  2,1T   63% /mnt/btrfs
> └» sudo btrfs fi df /mnt/btrfs/
> Data, single: total=3.33TiB, used=3.33TiB
> System, DUP: total=8.00MiB, used=388.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, DUP: total=56.12GiB, used=5.14GiB
> Metadata, single: total=8.00MiB, used=0.00

Again, you can use balance to get rid of those unused single chunks.  
They're currently an artifact from the creation of the filesystem due to 
how mkfs.btrfs works at present, so I've started doing a balance 
immediately after first mount to deal with them, before there's anything 
on the filesystem so the balance goes real fast. =:^)  3+ TiB of data is 
a little late for that, but you can balance metadata (and system) only, 
at least.
 
> The array has been grown quite a while ago using "btrfs filesystem
> resize max", but "btrfs fi df" still shows the old data size. How could
> that happen?

As hinted at above, btrfs fi df <mntpnt> is only half the story, 
displaying how much of currently allocated chunks are used and for what 
(data/metadata/system/shared/etc).  What it does *NOT* display is how 
much of the total filesystem size is actually allocated in the first 
place.  That's where btrfs fi show <mntpnt> comes in.  (Just btrfs fi 
show, without the <mntpnt> parameter, works fine if you've only a single 
btrfs or maybe a couple, but once you get a half dozen or so, adding the 
<mntpnt> just as you do for df, is useful to just display the one.)

Consider: On a single device btrfs, data is single mode by default, with 
data chunks normally 1 GiB each, metadata is dup mode by default, with 
metadata chunks normally 1/4 GiB (256 MiB), but due to dup mode, two of 
them are allocated at a time, so half a GiB.

Given that, how do you represent unallocated space that could be 
allocated as either data (single, takes the space of the size of the 
data, or a bit less when compression is on) or metadata (dup, takes twice 
as much space as the size of the actual metadata as there's two copies of 
it), depending on what is needed?

Of course btrfs can be used on multiple devices in various raid modes as 
well, complicating the picture further, particularly in the future when 
each subvolume can have its own single/dup/raid policy applied so they're 
not the same.

The way btrfs deals with this question is that btrfs fi show displays 
allocated vs. total space (with the space that doesn't show up as 
allocated obviously being... unallocated! =:^), while btrfs fi df, 
displays the usage detail on only /allocated/ space.

Meanwhile, plain df (not btrfs df, just df) currently doesn't work 
particularly well for btrfs, because the rules it uses to display used 
vs. available space that work on most filesystems, don't really apply to 
btrfs in the same way, and it doesn't know to apply different rules to 
btrfs or what they might be if it did.  (There's an effort to teach df to 
know about btrfs and similar filesystems, but it's early stage ATM, as 
there's some very real questions to settle on exactly what a sensible 
kernel API might look like for that, first, with the assumption being 
that if the interface is designed correctly, other filesystems will be 
able to make use of it in the future as well.)

> This is becomming a "collection of maybe unrelated BTRFS funny tales"
> thread... still I'd be happy on suggestions regarding any of the issues.

Some of this stuff, including discussion of the issues surrounding space 
used and left, is covered on the btrfs wiki, here (bookmark it! =:^) :

https://btrfs.wiki.kernel.org

In particular, see FAQ items 4.4-4.10 (documentation, faq...) covering 
space questions, but it's worth reading pretty much all the User level 
(as opposed to developer) documentation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

