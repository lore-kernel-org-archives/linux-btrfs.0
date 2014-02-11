Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57512 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaBKFYJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 00:24:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WD5pH-0007i7-3r
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 06:24:07 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 06:24:07 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 06:24:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: system stuck with flush-btrfs-4 at 100% after filesystem resize
Date: Tue, 11 Feb 2014 05:23:43 +0000 (UTC)
Message-ID: <pan$5e1c6$a27fbfc4$e7ace450$1b6a04a0@cox.net>
References: <52F67926.7060209@navitsky.org> <52F8F1C4.5070701@navitsky.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Navitsky posted on Mon, 10 Feb 2014 07:35:32 -0800 as excerpted:

[I rearranged your upside-down posting so the reply comes in context 
after the quote.]

> On 2/8/2014 10:36 AM, John Navitsky wrote:

>> I have a large file system that has been growing.  We've resized it a
>> couple of times with the following approach:
>>
>>    lvextend -L +800G /dev/raid/virtual_machines
>>    btrfs filesystem resize +800G /vms
>>
>> I think the FS started out at 200G, we increased it by 200GB a time or
>> two, then by 800GB and everything worked fine.
>>
>> The filesystem hosts a number of virtual machines so the file system is
>> in use, although the VMs individually tend not to be overly active.
>>
>> VMs tend to be in subvolumes, and some of those subvolumes have
>> snapshots.
>>
>> This time, I increased it by another 800GB, and it it has hung for many
>> hours (over night) with flush-btrfs-4 near 100% cpu all that time.
>>
>> I'm not clear at this point that it will finish or where to go from
>> here.
>>
>> Any pointers would be much appreciated.

> As a follow-up, at some point over the weekend things did finish on
> their own:
> 
> romulus:/vms/johnn-sles11sp3 # df -h /vms
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/dm-4       2.6T  1.6T  1.1T  60% /vms
> romulus:/vms/johnn-sles11sp3 #
> 
> I'd still be interested in any comments about what was going on or
> suggestions.

I'm guessing you don't have the VM images set NOCOW (no-copy-on-write), 
which means over time they'll **HEAVILY** fragment since every time 
something changes in the image and is written back to the file, that 
block is written somewhere else due to COW.  We've had some reports of 
hundreds of thousands of extents in VM files of a few gigs!

It's also worth noting that while NOCOW does normally mean in-place 
writes, a change after a snapshot means unsharing the data since the 
snapshotted data has now diverged, which means mandatory single-shot COW 
in ordered to keep the new change from overwriting the old snapshot 
version.  That of course triggers fragmentation too, since everything 
that changes in the image between snapshots must be written elsewhere, 
altho the fragmentation won't be nearly as fast as the default COW mode 
will.

So what was very likely taking the time was tracking down all those 
potentially hundreds of thousands of fragments/extents in ordered to re-
write the files as triggered by the size increase and presumably the 
physical location on-device.

I'd strongly suggest that you set all VMs NOCOW (chattr +C).  However, 
there's a wrinkle.  In ordered to be effective on btrfs, NOCOW must be 
set on a file while it is still zero-size, before it has data written to 
it.  The easiest way to do that is to set NOCOW on the directory, which 
doesn't really affect the directory itself, but DOES cause all new files 
(and subdirs, so it nests) created in that directory to inherit the NOCOW 
attribute.  Then copy the file in, preferably either catting it in with 
redirection to create/write the file, or copying it from another 
filesystem, such that you know it's actually copying the data and not 
simply hard-linking it, thus ensuring that the new copy is actually a new 
copy, so the NOCOW will actually take effect.

By organizing your VM images into dirs, all with NOCOW set, so the images 
inherit it at creation, you'll save yourself the fragmentation of the 
repeated COW writes.  However, as I mentioned, the first time a block is 
written after a snapshot it's still a COW write, unavoidably so.  Thus, 
I'd suggest keeping btrfs snapshots of your VMs to a minimum (preferably 
0), using ordinary full-copy backups to other media, instead, thus 
avoiding that first COW-after-snapshot effect, too.

Meanwhile, it's worth noting that if a file is written sequentially 
(append only) and not written "into", as will typically be the case with 
the VM backups, there's nothing to trigger fragmentation.  So the backups 
don't have to be NOCOW, since they'll be written once and left alone.  
But the actively in-use and thus often written to operational VM images 
should be NOCOW, and preferably not snapshotted, to keep fragmentation to 
a minimum.

Finally, of course you can use btrfs defrag to manually deal with the 
problem.  However, do note that the snapshot aware defrag introduced with 
kernel 3.9 simply does NOT scale well once the number of snapshots 
reaches near 1000, and the snapshot-awareness has just been disabled 
again (in kernel 3.14-rc), until the code can be reworked to scale 
better.  So I'd suggest if you /are/ using snapshots and trying to work 
with defrag, you'll want a very new 3.14-rc kernel in ordered to avoid 
that problem, but avoiding it does come at the cost of losing space 
efficiency when defragging snapshotted btrfs, as the non-snapshot-aware 
version will tend to create separate copies of the data on each snapshot 
it is run on, thus decreasing shared data blocks and increasing space 
usage, perhaps dramatically.

So again, at least for now, and at least for large (half-gig or larger) VM 
images and other "internal write" files such as databases, etc, I'd 
suggest NOCOW, and don't snapshot, backup to a separate filesystem 
instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

