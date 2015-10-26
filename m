Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32838 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbJZHJS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 03:09:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zqbu7-0002JX-EM
	for linux-btrfs@vger.kernel.org; Mon, 26 Oct 2015 08:09:15 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 08:09:15 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 08:09:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recover btrfs volume which can only be mounded in read-only
 mode
Date: Mon, 26 Oct 2015 07:09:10 +0000 (UTC)
Message-ID: <pan$64d73$867e5ae0$e0eaca78$1ba6fac6@cox.net>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
	<561E6969.40500@oracle.com> <561EBAB1.6030600@gmail.com>
	<pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
	<CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
	<pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net> <562369E8.60709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Katsubo posted on Sun, 18 Oct 2015 11:44:08 +0200 as excerpted:

[Regarding the btrfs raid1 "device-with-the-most-space" chunk-allocation 
strategy.]

> I think the mentioned strategy (fill in the device with most free space)
> is not most effective. If the data is spread equally, the read
> performance would be higher (reading from 3 disks instead of 2). In my
> case this is even crucial, because the smallest drive is SSD (and it is
> not loaded at all).
> 
> Maybe I don't see the benefit from the strategy which is currently
> implemented (besides that it is robust and well-tested)?

Two comments:

1) As Hugo alluded to, in striped mode (raid0/5/6 and I believe 10), the 
chunk allocator goes wide, allocating a chunk from each device with free 
space, then striping at something smaller (64 KiB maybe?).  When the 
smallest device is full, it reduces the width by one and continues 
allocating, down to the minimum stripe width for the raid type.  However, 
raid1 and single do device-with-the-most-space first, thus, particularly 
for raid1, ensuring maximum usage of available space.

Were raid1 to do width-first, capacity would be far lower and much more 
of the largest device would remain unusable, because some chunk pairs 
would be allocated entirely on the smaller devices, meaning less of the 
largest device would be used before the smaller devices fill up and no 
more raid1 chunks could be allocated as only the single largest device 
has free space left and raid1 requires allocation on two separate devices.

In the three-device raid1 case, the difference in usable capacity would 
be 1/3 the capacity of the smallest device, since until it is full, 1/3 
of all allocations would be to the two smaller devices, leaving that much 
more space unusable on the largest device.

So you see there's a reason for most-space-first, that being that it 
forces one chunk from each pair-allocation to the largest device, thereby 
most efficiently distributing space so as to leave as little space as 
possible unusable due to only one device left when pair-allocation is 
required.

2) There has been talk of a more flexible chunk allocator with an admin-
specified strategy allowing smart use of hybrid ssd/disk filesystems, for 
instance.  Perhaps put the metadata on the ssds, for instance, since 
btrfs metadata is relatively hot as in addition to the traditional 
metadata, it contains the checksums which btrfs of course checks on read.

However, this sort of thing is likely to be some time off, as it's 
relatively lower priority than various other possible features.  
Unfortunately, given the rate of btrfs development, "some time off" is in 
practice likely to be at least five years out.

In the mean time, there's technologies such as bcache that allow hybrid 
caching of "hot" data, designed to present themselves as virtual block 
devices so btrfs as well as other filesystems can layer on top.

And in fact, we have some regular users that have btrfs on top of bcache 
actually deployed, and from reports, it now works quite well.  (There 
were some problems awhile in the past, but they're several years in the 
past now, back well before the last couple LTS kernel series that's the 
oldest recommended for btrfs deployment.)

If you're interested, start a new thread with btrfs on bcache in the 
subject line, and you'll likely get some very useful replies. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

