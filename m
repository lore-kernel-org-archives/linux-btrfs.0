Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49111 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaCQDox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 23:44:53 -0400
Date: Sun, 16 Mar 2014 20:44:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Message-ID: <20140317034451.GW6143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3592E609-7145-4F1A-8B16-EEF3C736D191@colorremedies.com>
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

On Sun, Mar 16, 2014 at 08:56:35PM -0600, Chris Murphy wrote:
> >>> polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 `pwd`
> >>> ERROR: error removing the device '/dev/mapper/crypt_sde1' - Invalid argument
> >> 
> >> You didn't specify a mount point, is the reason for that error. But also, since you're already effectively degraded with 1 disk you can't remove a 2nd without causing array collapse. You have to add a new device first *and* you have to "rebuild" with balance. Then presumably we can remove the device. But I'm stuck adding so I can't test anything else.
> > 
> > You missed the `pwd` :)
> 
> I just don't know what it means, it's not a reference to mount point I'm familiar with.

Try echo `pwd` and you'll understand :)
 
> > I'm trying to remove the drive that is causing issues, that doesn't make
> > things worse, does it?
> 
> I don't think you can force a Btrfs volume to go degraded with a device delete command right now, just like there isn't a command to make it go missing or faulty, like md raid.
> > Does btrtfs not know that device is the bad one even thouth it's spamming my
> > logs continuously about it?
> 
> With raid5, you're always at the minimum number of devices to be normally mounted. Removing one immediately makes it degraded which I don't think it's going to permit. At least, I get an error when I do it even without a device giving me fits.

Ok, I understand that.

> > If I add a device, isn't it going to grow my raid to make it bigger instead
> > of trying to replace the bad device?
> 
> Yes if it's successful. No if it fails which is the problem I'm having.

That's where I don't follow you.
You just agreed that it will grow my raid.
So right now it's 4.5TB with 10 drives, if I add one drive, it will grow to
5TB with 11 drives.
How does that help?
Why would btrfs allow me to remove the faulty device since it does not let
you remove a device from a running raid. If I grow it to a bigger raid, it
still won't let me remove the device, will it?
 
> > In swraid5, if I add a device, it will grow the raid, unless the array is
> > running in degraded mode.
> > However, I can't see if btrfs tools know it's in degraded mode or not.
> 
> Only once the device is missing, apparently, and then mounted -o degraded.
 
Dully noted.
If you agree that adding an 11th drive to my array will not help, I'll
unmount the filesystem, remount it in degraded mode with 9 drives and try to
add the new 11th drive.

> > If you are sure adding a device won't grow my raid, I'll give it a shot.
> 
> No I'm not sure. And yes I suspect it will make it bigger. But so far a.) replace isn't supported yet; and b.) delete causes the volume to go below the minimum required for normal operation which it won't allow; which leaves c.) add a device but I'm getting a hang. So I'm stuck at this point.

Right. So I think we also agree that adding a device to the running
filesystem is not what I want to do since it'll grow it and do nothing to
let me remove he faulty one. 

> > I'll add the new device first after you confirm that there is no chance
> > it'll try to grow the filesystem :)
> 
> I confirm nothing since I can't proceed with a device add.

Fair enough.

So unless someone tells me otherwise, I will unmount the filesystem, remount
it in degraded mode, and then try to add the 11th drive when the 10th one is
missing.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
