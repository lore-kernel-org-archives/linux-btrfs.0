Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60052 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbbJNVKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 17:10:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmTJG-0008AH-0v
	for linux-btrfs@vger.kernel.org; Wed, 14 Oct 2015 23:10:06 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 23:10:06 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 23:10:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
Date: Wed, 14 Oct 2015 21:09:53 +0000 (UTC)
Message-ID: <pan$df62e$350f553$54891d85$87e6b956@cox.net>
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
	<pan$39697$bacd3e0c$3e39ab12$ed8c21a7@cox.net>
	<20151014091325.GL25907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 14 Oct 2015 09:13:25 +0000 as excerpted:

> On Wed, Oct 14, 2015 at 05:08:17AM +0000, Duncan wrote:
>> Carmine Paolino posted on Tue, 13 Oct 2015 23:21:49 +0200 as excerpted:
>> 
>> > I have an home server with 3 hard drives that I added to the same
>> > btrfs filesystem. Several hours ago I run `btrfs balance start
>> > -dconvert=raid0 /` and as soon as I run `btrfs fi show /` I lost my
>> > ssh connection to the machine. The machine is still on, but it
>> > doesn’t even respond to ping[. ...]
>> > 
>> > (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a 2TB
>> > usb 2.0 one so the transfer speeds are pretty low)
>> 
> 
>    Note also that RAID-0 is a poor choice for this configuration,
> because you'll only get 640 GB usable space out of it. With single,
> you'll get the full sum of 2370 GB usable. With RAID-1, you'll have 320
> GB usable. The low figures for the RAID-0 and -1 come from the fact that
> you've got two small devices, and that both RAID-0 and RAID-1 have a
> minimum of two devices per block group. You can play around with the
> configurations at http://carfax.org.uk/btrfs-usage

Thanks, Hugo.  I totally forgot about the sizing effects of raid0 with 
that sort of wide device mismatch, but you have a very good point as I 
can't imagine anyone limiting their space usage like that on purpose.

Tho AFAIK the raid0 space available space would be 120*3 + (250-120)*2 =
360 + 130*2 = 360+260 = 620 GB?  (Raid0 stripe 3 devices wide until the 
120 gig device is full, 2 devices wide after that until the remainder of 
the 250 gig device is full, the rest of the 2 TB device unused as there's 
no second device available to raid0 stripe with.)

In the event that a raid0 of the three is desired, I'd partition up the 
big 2 TB device with the partition for the raid0 being 250 GB, same as 
the second largest device, with the remaining ~1750 GB then being 
available for use as a single-device filesystem.

Alternatively, one /could/ partition up the 2 TB device as eight 250 GB 
partitions, and add each of those separately to the raid0, thus letting 
the filesystem do 10-way raid0 striping on the first 120 GB, 9-way raid0 
striping after that, tho 8 of those strips would actually be on 
partitions of the same physical device.  It'd certainly be slow, but it'd 
use the available space on the 2 TB device, if that was the primary 
object.

But single mode would certainly be more efficient, for sure.

Meanwhile, raid0 in general, even totally apart from btrfs, should always 
be considered usable only for throw-away data, either because there's a 
backup or because it really is throw-away (I used to use mdraid0 on 
partitions for my distro's package repo and similar effective internet 
local cache data, for instance, where loss of the raid0 simply meant 
redownloading what it had cached), because with raid0, loss of a single 
device means loss of everything on the raid, so you've effectively 
multiplied the chance of failure by the number of physical devices in the 
raid0.  So quite apart from the backups rule I mentioned earlier, raid0 
really does mean throw-away data, not worth worrying about recovery.  
Raid0's primary use is simply speed, but across USB2, it can't even 
really be used for speed, so there's really no use for it at all, unless 
one is simply doing it "because they can" (like the raid0 of about 50 
1.44 MB floppies I believe I watched a youtube video of, at one point, 
simply "because they can"!).

Btrfs multi-device single mode (at least with single mode for metadata as 
well as data) isn't really better than raid0 in terms of reliability, but 
at least it lets you use the full capacity of the devices.  (Btrfs raid1 
metadata, single data, is the default for multi-device btrfs, and is at 
least in theory /somewhat/ more reliable than single-mode metadata, since 
at least in theory, a dropped device at least lets you recover anything 
that didn't happen to be on the bad device, but in practice I'd not 
recommend relying on that.  Plan as if it was raid0 reliability -- loss 
of a single device means loss of the entire thing.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

