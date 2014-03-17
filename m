Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46392 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750941AbaCQFMp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 01:12:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140317034451.GW6143@merlins.org>
Date: Sun, 16 Mar 2014 23:12:43 -0600
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <B593C5F2-5CE0-428C-97FB-A75AB0B11254@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>
 <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>
 <20140317005145.GZ16946@merlins.org>
 <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com>
 <20140317011752.GV6143@merlins.org>
 <3592E609-7145-4F1A-8B16-EEF3C736D191@colorremedies.com>
 <20140317034451.GW6143@merlins.org>


On Mar 16, 2014, at 9:44 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Mar 16, 2014 at 08:56:35PM -0600, Chris Murphy wrote:
> 
>>> If I add a device, isn't it going to grow my raid to make it bigger instead
>>> of trying to replace the bad device?
>> 
>> Yes if it's successful. No if it fails which is the problem I'm having.
> 
> That's where I don't follow you.
> You just agreed that it will grow my raid.
> So right now it's 4.5TB with 10 drives, if I add one drive, it will grow to
> 5TB with 11 drives.
> How does that help?

If you swap the faulty drive for a good drive, I'm thinking then you'll be able to device delete the bad device, which ought to be "missing" at that point; or if that fails you should be able to do a balance, and then be able to device delete the faulty drive.

The problem I'm having is that when I detach one device out of a 3 device raid5, btrfs fi show doesn't list it as missing. It's listed without the /dev/sdd designation it had when attached, but now it's just blank.


> Why would btrfs allow me to remove the faulty device since it does not let
> you remove a device from a running raid. If I grow it to a bigger raid, it
> still won't let me remove the device, will it?

Maybe not, but it seems like it ought to let you balance, which should only be across available devices at which point you should be able to device delete the bad one. That's assuming you've physically detached the faulty device from the start though.

> 
>>> In swraid5, if I add a device, it will grow the raid, unless the array is
>>> running in degraded mode.
>>> However, I can't see if btrfs tools know it's in degraded mode or not.
>> 
>> Only once the device is missing, apparently, and then mounted -o degraded.
> 
> Dully noted.
> If you agree that adding an 11th drive to my array will not help, I'll
> unmount the filesystem, remount it in degraded mode with 9 drives and try to
> add the new 11th drive.

That's the only option I see at the moment in any case, other than blowing it all away and starting from scratch. What I don't know is whether you will be able to 'btrfs device delete' what ought to now be a missing device, since you have enough drives added to proceed with that deletion; or if you'll have to balance first. And I don't even know if the balance will work and then let you device delete if it's a dead end at this point.

> 
>>> If you are sure adding a device won't grow my raid, I'll give it a shot.
>> 
>> No I'm not sure. And yes I suspect it will make it bigger. But so far a.) replace isn't supported yet; and b.) delete causes the volume to go below the minimum required for normal operation which it won't allow; which leaves c.) add a device but I'm getting a hang. So I'm stuck at this point.
> 
> Right. So I think we also agree that adding a device to the running
> filesystem is not what I want to do since it'll grow it and do nothing to
> let me remove he faulty one. 

The grow is entirely beside the point. You definitely can't btrfs replace, or btrfs device delete, so what else is there but try btrfs device add, or obliterate it and start over?


Chris Murphy

