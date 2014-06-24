Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbaFXLqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 07:46:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WzPAo-0004LQ-4o
	for linux-btrfs@vger.kernel.org; Tue, 24 Jun 2014 13:46:02 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 13:46:02 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 13:46:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "-d single" for data blocks on a multiple devices doesn't work
 as it should
Date: Tue, 24 Jun 2014 11:45:50 +0000 (UTC)
Message-ID: <pan$22dbe$42ad0785$2759193a$9b9beea1@cox.net>
References: <53A955F8.8090101@nv-systems.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gerald Hopf posted on Tue, 24 Jun 2014 12:42:00 +0200 as excerpted:

> After copying, I then unmounted the filesystem, switched off one of the
> two 3TB USB disks and mounted the remaining 3TB disk in recovery mode
> (-o degraded,ro) and proceeded to check whether any data was still left
> alive.
> 
> Result:
> - the directories and files were there and looked good (metadata raid1
> seems to work)
> - some small files I tested were fine (probably 50%?)
> - even some the medium sized files (50-100MB) were fine (not sure about
> the percentage, might have been less than for the small files)
> - not a single one (!) of the big files (3GB-15GB) survived
> 
> Conclusion:
> The "-d single" allocator is useless (or broken?). It seems to randomly
> write data blocks to each of the multiple devices, thereby combining the
> disadvantage of a single disk (low write speed) with the disadvantage of
> raid0 (loss of all files when a device is missing), while not offering
> any benefits.

A little familiarity with btrfs' chunk allocator and it's obvious what 
happened.  The critical point is that btrfs data chunks are 1 GiB in 
size, so files over a GiB will require multiple data chunks.  Meanwhile, 
from what I've read (I'm not an expert here but it does match what you 
saw), the chunk allocation algorithm allocates new chunks from the device 
with the most space left.

With two equal sized 3 TB devices and metadata in (default) raid1 mode, 
thus metadata allocations two (256 MiB) chunks at a time, one from each 
device, with single data mode, the 1 GiB data chunks will be allocated 
from one device to put it 1 GiB allocated ahead of the other, then from 
the other device since it has more unallocated space left to bring it up 
even with the first one again.  Thus allocation will be alternating, 1 
GiB data from one, the next from the other.

Which with files over a GiB in size and only two devices, pretty much 
guarantees the file will be split, 1 GiB chunks, chunks on alternating 
devices.

Single data mode doesn't make any specific guarantees about recovery, 
however (altho for files significantly under a GiB in size some should 
still be recoverable as long as the metadata is intact, presumably 
because it's in raid1 mode), and for most usage, 1 GiB plus files are 
still rather less common than smaller sizes, so that's where we are ATM.

If you want somewhat better chances with large files, add more drives of 
the same size, since the effect of single-mode allocation with multiple 
drives in that case should be round-robin, so say 2-GiB files should have 
a reasonable chance of recovery (not hitting the bad drive) with 8 our 10 
drives in the filesystem.  Tho you're pretty much screwed on the 15 GiB 
files unless you run say 50 devices, in which case the chance of more 
than one going out at a time is unfortunately going to be dramatically 
higher as well.

The other alternative would be raid1 or raid10 mode data, or, when raid5/6 
modes are completed (AFAIK raid5/6 mode is still lacking full recovery 
code, tho the parity is being written), those, since that would be more 
efficient storage-wise than raid1 (with raid6 more reliable as well, 
since current raid1 and raid10 modes are only two-way-mirroring[1], so 
drop more than one device and data's likely to be gone, while raid6 
should allow dropping two devices -- when the recovery code is complete 
and tested, of course).

Farther out, there has been discussion of adding additional chunk 
allocation schemes and making the choice configurable, which is really 
what you're asking for.  But while I think that's reasonably likely to 
eventually happen, I wouldn't expect to see it for a year at least, and 
honestly it's more likely two years out or more...

... Unless of course you happen to have sufficient interest in that 
feature to either code it up yourself if you have the skill, or (assuming 
you have the resources) sponsor someone who actually has the skill to do 
so.  After all, people either scratching their own itches or hiring 
others to do it for them is what drives freedomware forward. =:^)

---
[1] My own #1 anticipated feature is N-way-mirroring, with my personal 
sweet spot being N=3.  Combined with the existing data-integrity and 
scrub features, three-way-mirroring would be /so/ sweet!  Which is why 
I'm impatiently waiting for raid5/6 completion, since that's next on the 
roadmap after that.  But it has been "at least a couple kernels out" for 
over a year now, so it's taking awhile.  =:^( Meanwhile we all gotta make 
do with what's available now, which isn't /too/ shabby, after all. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

