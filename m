Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56182 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932141AbaCQC4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 22:56:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140317011752.GV6143@merlins.org>
Date: Sun, 16 Mar 2014 20:56:35 -0600
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <3592E609-7145-4F1A-8B16-EEF3C736D191@colorremedies.com>
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


On Mar 16, 2014, at 7:17 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Mar 16, 2014 at 07:06:23PM -0600, Chris Murphy wrote:
>> 
>> On Mar 16, 2014, at 6:51 PM, Marc MERLIN <marc@merlins.org> wrote:
>>> 
>>> 
>>> polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 `pwd`
>>> ERROR: error removing the device '/dev/mapper/crypt_sde1' - Invalid argument
>> 
>> You didn't specify a mount point, is the reason for that error. But also, since you're already effectively degraded with 1 disk you can't remove a 2nd without causing array collapse. You have to add a new device first *and* you have to "rebuild" with balance. Then presumably we can remove the device. But I'm stuck adding so I can't test anything else.
> 
> You missed the `pwd` :)

I just don't know what it means, it's not a reference to mount point I'm familiar with.

> I'm trying to remove the drive that is causing issues, that doesn't make
> things worse, does it?

I don't think you can force a Btrfs volume to go degraded with a device delete command right now, just like there isn't a command to make it go missing or faulty, like md raid.


> Does btrtfs not know that device is the bad one even thouth it's spamming my
> logs continuously about it?

With raid5, you're always at the minimum number of devices to be normally mounted. Removing one immediately makes it degraded which I don't think it's going to permit. At least, I get an error when I do it even without a device giving me fits.

> 
> If I add a device, isn't it going to grow my raid to make it bigger instead
> of trying to replace the bad device?

Yes if it's successful. No if it fails which is the problem I'm having.

> In swraid5, if I add a device, it will grow the raid, unless the array is
> running in degraded mode.
> However, I can't see if btrfs tools know it's in degraded mode or not.

Only once the device is missing, apparently, and then mounted -o degraded.

> 
> If you are sure adding a device won't grow my raid, I'll give it a shot.

No I'm not sure. And yes I suspect it will make it bigger. But so far a.) replace isn't supported yet; and b.) delete causes the volume to go below the minimum required for normal operation which it won't allow; which leaves c.) add a device but I'm getting a hang. So I'm stuck at this point.


> 
>>> (again, the data is irrelevant, I have a btrfs receive on it that has
>>> been running for hours and that I'd have to restart, but that's it).
>> 
>> Well at this point I'd leave it alone because at least for me, device add hangs that command and all other subsequent btrfs user space commands. So for all I know (untested) the whole volume will block on this device add and is effectively useless.
> 
> Right. I was hoping that my kernel slightly newer than yours and maybe real
> devices would help, but of course I don't know that.
> 
> I'll add the new device first after you confirm that there is no chance
> it'll try to grow the filesystem :)

I confirm nothing since I can't proceed with a device add.


Chris Murphy

