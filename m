Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38524 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbbKIV3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Nov 2015 16:29:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zvu0A-0003yq-2O
	for linux-btrfs@vger.kernel.org; Mon, 09 Nov 2015 22:29:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 22:29:22 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 22:29:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
Date: Mon, 9 Nov 2015 21:29:10 +0000 (UTC)
Message-ID: <pan$24d10$91cf318$b08c3c88$ac288e4@cox.net>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
	<5640A903.9030209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Mon, 09 Nov 2015 09:09:07 -0500 as
excerpted:

>>   btrfs fi show
>>   Label: none  uuid: 52f170c1-725c-457d-8cfd-d57090460091
>>    Total devices 2 FS bytes used 112.00KiB
>>    devid    1 size 2.00GiB used 417.50MiB path /dev/sdc 
>>    devid    2 size 2.00GiB used 417.50MiB path /dev/sdd
>>
>>   Global spare
>>    device size 3.00GiB path /dev/sde

First of all, thanks from me too, AJ, for this very nice new feature. =:^)

> Would I be correct in assuming that we can have more than one hot-spare
> device at a time?  If so, what method is used to select which one to use
> when one is needed?

In the later patches overview section, patches 10,11,12,13/15 paragraph, 
AJ mentions a helper function to pick/release a spare device from/to the 
spare devices pool.  That would appear to be patch 13, provide framework 
to get and put a spare device.

Which means yes, multiple hot-spares are (at least planned to be) 
allowed. =:^)

While I'm not a coder and could very well be misinterpreting this, 
however, reading the btrfs_get_spare_device function in patch 13, there's 
a comment that goes like this:

>> /* as of now there is only one device in the spare fs_devices */

I don't read C well enough to know whether that's a comment on the 
internal progress in the function (tho I don't see any obvious hints to 
indicate that), or whether it can be taken at face value, that right now 
there's only provision for one in the "pool" (seems the more obvious 
interpretation).

So unless my lack of C skills is deceiving me, while a pool is intended, 
current patch implementation status simply assumes a spare pool of one, 
and the first spare found is picked. The put function in the same patch 
doesn't appear to have a limit on the number of spares that can be added, 
so assuming the current pool implementation allows it, more than one 
spare can be added to the pool, but as I said, the get function appears 
to assume just one in the pool, so picks the first spare it finds.


Which is quite reasonable for a first patch series posting that may well 
require additional iterations, particularly so given the get helper 
function is already nicely modularized so adding more complex picker 
logic should be relatively simple.


Not that targeting particular use-cases is appropriate at this point, but 
simply for information purposes, my particular use-case is a bunch of 
different size independent raid1 btrfs on partitions, but with the 
devices composing each raid1 of identical size.  I think a reasonably 
simple picker logic optimization would be to first check if there's a 
spare matching the size of the failing device, and use it in preference 
to others of different sizes if so.

Given my partitioned usage, a failing physical device will trigger a 
whole slew of failing btrfs logical devices (partitions on that physical 
device), so in ordered for this feature to be of much use to me I'd have 
to maintain a whole series of spares, one for each btrfs logical device 
on a partition on the failing physical device, since they'd all fail at 
once.

Since those partitions and the btrfs on top of them are different sizes, 
a size-matching logic lets me partition the physical spare identically to 
the operational devices and simply add all the partitions to the spare 
list, while without size-matching logic, to ensure a large enough spare 
was picked for the largest btrfs, I'd have to make all the spares that 
size, and they'd no longer all fit on a single physical device of the 
same size as the originals, possibly not even on two physical devices 
that size.

At least at the non-enterprise level, size-similar picking logic would 
seem to be pretty useful if not feature critical, then, and given that 
it /should/ be reasonably simple to implement, I'd hope that doing so 
becomes a priority, tho certainly an initial first-pick base 
implementation to which size-similar logic can be added later, is fine as 
well.  I'd just hope that "later" is within a couple kernel cycles, not a 
couple kernel major version cycles (~4 years each with bumps at .20).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

