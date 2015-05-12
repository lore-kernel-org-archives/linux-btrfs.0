Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55292 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbbELHkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 03:40:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ys4nk-0008PN-JT
	for linux-btrfs@vger.kernel.org; Tue, 12 May 2015 09:40:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 09:40:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2015 09:40:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: feature like mirror split kind of functionality to btrfs
Date: Tue, 12 May 2015 07:40:21 +0000 (UTC)
Message-ID: <pan$27d9b$4c16d7cc$864c66f2$e106fd86@cox.net>
References: <loom.20150511T120703-840@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sri posted on Mon, 11 May 2015 10:13:52 +0000 as excerpted:

> btrfs can able to handle disk (LVM functionality) and it offers adding
> new disks and delete disks of existing btrfs file system.
> 
> I would like to know functionality like below.
> 
> say i have 2 disks  (1 and 2) and btrfs created on top of it.
> 
> Now I will add 2 more disks (3 and 4) and say RAID1 to existing 2 disks
> while adding to existing btrfs file system.
> 
> Then I run sync kind of functionality which replicates data of 1$2 on
> 3$4.
> 
> Once sync is complete, I will ask btrfs to split 3&4 from it.
> 
> End of this I will have 3$4 disks as separate copy of existing btrfs. If
> there is a failure I use 3$4 as backed up disks which I can mount on
> same machine during disaster recovery or mount on other machine (assume
> disks are SCSI LUNS from array) and bring the file system back.
> 
> Would like to know such functionality exists currently or any plans of
> doing it.

No such functionality exists currently, because while you could make a 
btrfs raid1 out of the four devices, and raid1 mode has two copies (no N-
way mirroring yet, tho it's supposed to be next up on the supported raid 
roadmap now that raid56 is done and now stabilizing), there's presently 
no way to tell the chunk allocator to allocate one copy to one set of 
devices, while the other copy goes to a different set.

What happens now is that the device with the most free space gets a chunk 
allocated, tho on a multi-device btrfs, the allocator does ensure for 
raid1 that the two mirrors don't end up on the same device, so for raid1 
the effect is a mirror chunk is allocated from each of the two devices 
with the most space remaining.

Which in your 2-devices, add two more, balance to raid1, scenario, means 
as the balance-convert to raid1 occurs, at first both new copies of 
existing chunks will go to the two new devices as they'll have the most 
space available, while later, after the space available equalizes, the 
allocator will effectively round-robin among all four devices.

To get that split functionality currently, then, you really need to be 
able to present btrfs with only two devices, so the btrfs allocator in 
raid1 mode puts one copy on each device.  If the existing content is 
small enough to fit on a single device, that's simple.  If not, then you 
end up having to layer btrfs on top of something else that combines 
underlying devices and presents only two devices to btrfs.  Of course 
that "something else" can be lvm2 or dmraid or mdraid or hardware raid 
or...


There's plans to make the allocator more configurable in the future, so 
it can support splits like that among other things, but ATM and likely 
for a decade at least, btrfs is opportunity rich and developer poor, and 
repeated experience demonstrates that these features often take several 
times the initial estimate in implementation time (just look at how long 
raid56 mode took, I was told that N-way mirroring was roadmapped right 
after raid56, which was roadmapped for the next kernel, back around the 
3.4 era, it was finally complete in 3.19, three years later).

So even tho it's planned, it make take awhile.  But the wiki has a 
Project Ideas page.  

https://btrfs.wiki.kernel.org/index.php/Project_ideas

In particular see section 3, projects claimed and in progress, 3.1, 
multiple devices, 3.1.5, chunk allocation groups.  It doesn't say much, 
but Hugo Mills is the guy who will know the status best, as he has 
claimed the project.  Here's a direct link:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Chunk_allocation_groups

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

