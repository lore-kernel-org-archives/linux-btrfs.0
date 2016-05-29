Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40360 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbcE2VMY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 17:12:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b780T-0008Q9-21
	for linux-btrfs@vger.kernel.org; Sun, 29 May 2016 23:12:21 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 23:12:21 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 23:12:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Functional difference between "replace" vs "add" then "delete
 missing" with a missing disk in a RAID56 array
Date: Sun, 29 May 2016 21:12:15 +0000 (UTC)
Message-ID: <pan$6528a$83e4cd2a$1902e5d2$b10efb0b@cox.net>
References: <CAMbyGONFW7kRJvNRu3X5p9B0RqTNRzSBYE+XCu=KcaL8KK3n0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Johnson posted on Sun, 29 May 2016 09:33:49 -0700 as excerpted:

> Situation: A six disk RAID5/6 array with a completely failed disk. The
> failed disk is removed and an identical replacement drive is plugged in.

First of all, be aware (as you already will be if you're following the 
list) that there are currently two, possibly related, (semi-?)critical 
known bugs still affecting raid56 mode, with the result being that 
despite raid56 nominal completion in 3.19 and fix of a couple even more 
critical bugs early on, by 4.1 release, raid56 mode remains negatively 
recommended for anything but testing.

One of the two bugs is that restriping (as done by balance either with 
the restripe filters after adding devices or triggered automatically by 
device delete) can, in SOME cases only, with the trigger variable unknown 
at this point, can take an order of magnitude (or even more) longer than 
it should -- we're talking over a week for a rebalance that would be 
expected to be done in under a day, upto possibly months for the multi-TB 
filesystems that are a common use-case for raid5/6, that might be 
expected to take a day or two under normal circumstances.

This rises to critical because other than the impractical time involved, 
once you're talking weeks to months restripe time, the danger of another 
device going out, thereby killing the entire array, increases 
unacceptably, to the point that raid56 cannot be considered usable for 
the normal things people use it for, thus the critical bug rating even if 
in theory the restripe is completing correctly and the data isn't in 
immediate danger.

Obviously you're not hitting it if your results show balance as 
significantly faster, but because we don't know what triggers the problem 
yet, that's no guarantee that you won't hit it later, after somehow 
triggering the problem.

The second bug is equally alarming, but in a different way.  A number of 
people have reported that replacing (by one method or the other) a first 
device appears to work, but if a second replace is attempted, it kills 
the array(!!), so obviously something's going wrong with the first 
replace as it's not returning the array to full undegraded functionality, 
even tho all the current tools as well as operations before the second 
replace is attempted suggest that it has done just that.

This one too remains untraced to an ultimate cause, and while the two 
bugs appear quite different, because they are both critical and remain 
untraced, it remains possible that they are actually simply two different 
symptoms of the same root bug.


So, if you're using raid56 only for testing as is recommended, great, but 
if you're using it for live data, for sure have your backups ready as 
there remains an uncomfortably high chance that you may need to use them 
if something goes wrong with that raid56 and these bug(s) prevent you 
from recovering the array.  Or alternatively, switch to the more mature 
raid1 or raid10 modes if realistic in your use-case, or to more 
traditional solutions such as md/dm-raid underneath btrfs or some other 
filesystem.

(One very interesting solution is btrfs raid1 mode over top of a pair of 
md/dm-raid0 virtual devices, each of which can then be composed of 
multiple physical devices.  This allows btrfs raid1 mode data and 
metadata integrity checking and repair that underlying raid modes don't 
have, and includes the repair of detected checksum errors that btrfs 
single mode won't be able to do because it can detect problems but not 
correct them.  Meanwhile, the underlying raid0 helps make up somewhat for 
the btrfs' poor raid1 optimization and performance as it tends to 
serialize access to multiple devices that other raid solutions 
parallelize.)

Of course, the more mature zfs on linux can be another alternative, if 
you're prepared to overlook the licensing issues and have hardware upto 
the task.

With that warning explained and alternatives provided, to your actual 
question...

> Here I have two options for replacing the disk, assuming the old drive
> is device 6 in the superblock and the replacement disk is /dev/sda.
> 
> 'btrfs replace start 6 /dev/sda /mnt'
> This will start a rebuild of the array using the new drive, copying data
> that would have been on device 6 to the new drive from the parity data.
> 
> btrfs add /dev/sda /mnt && btrfs device delete missing /mnt This adds a
> new device (the replacement disk) to the array and dev delete missing
> appears to trigger a rebalance before deleting the missing disk from the
> array. The end result appears to be identical to option 1.
> 
> A few weeks back I recovered an array with a failed drive using 'delete
> missing' because 'replace' caused a kernel panic. I later discovered
> that this was not (just) a failed drive but some other failed hardware
> that I've yet to start diagnosing. Either motherboard or HBA. The drives
> are in a new server now and I am currently rebuilding the array with
> 'replace', which is believe is the "more correct" way to replace a bad
> drive in an array.
> 
> Both work, but 'replace' seems to be slower so I'm curious what the
> functional differences are between the two. I thought the replace would
> be faster as I assumed it would need to read fewer blocks since instead
> of a complete rebalance it's just rebuilding a drive from parity data.

Replace should be faster if the existing device being replaced is still 
at least mostly functional, as in that case, it's a pretty direct low-
level rewrite of the data from one device to the other.

If the device is dead or missing, or simply so damaged most content will 
need to be reconstructed from parity anyway, then (absent the bug 
mentioned above at least) the add/delete method can indeed be faster.

Note that when reconstructing from parity, /all/ devices must be read in 
ordered to deduce what the content of the missing device actually is.  So 
you are mistaken in regard to /read/.  However, a replace should /write/ 
less data, since while it needs to read all remaining devices to 
reconstruct the content of the missing device, it should only have to 
/write/ the replacement, not all devices, while balance will rewrite most 
or all content on all devices.

But balance is more efficient when the device is actually missing, 
apparently because in that case (again, absent the above mentioned bug) 
its algorithm is more efficient, despite having to rewrite everything, 
instead of just the single device.

(I'm just a user and list regular, not a dev, so I won't attempt to 
explain more "under the hood" than that.)


Meanwhile, not directly appropos to the question, but there are a few 
btrfs features that are known to increase balance times /dramatically/, 
in part due to known scaling issues that are being worked on, but it's a 
multi-year project.

Btrfs quotas are a huge factor in this regard.  However, quotas on btrfs 
continue to be buggy and not always reliable in any case, so the best 
recommendation for now continues to be to simply turn off (or leave off 
if never activated) btrfs quotas if you don't actually need them, and to 
use a more mature filesystem where quotas are mature and reliable if you 
do need them.  That will reduce balance (and btrfs check) times 
/dramatically/.

The other factor is snapshots and/or other forms of heavy reflinking such 
as dedup.  Keeping the number of snapshots per subvolume reasonably low, 
say 250-300 and definitely under 500, helps dramatically in this regard, 
as balance (and check) operations simply don't scale well when there's 
thousands or tens of thousands of reflinks per extent to account for.  
Unfortunately (in this regard) it's incredibly easy and fast to create 
snapshots, deceptively so, masking the work balance and check have to do 
to maintain them.

So scheduled snapshotting is fine, as long as you have scheduled snapshot 
thinning in place as well, keeping the number of snapshots per subvolume 
to a few hundred at most.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

