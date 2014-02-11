Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53499 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751291AbaBKBp0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 20:45:26 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52F73E2B.9080103@friedels.name>
Date: Mon, 10 Feb 2014 18:45:23 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name> <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com> <52F73E2B.9080103@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 9, 2014, at 1:36 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> 
> Yes, but I can create that space.
> So, for me the next steps would be to:
> -generate enough room on the filesystem
> -btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/BTRFS/Video
> -btrfs device delete /dev/sdc1 /mnt/BTRFS/Video
> 
> Right?

No. You said you need to recreate the file system, and only have these two devices and therefore must remove one device. You can't achieve that with raid1 which requires minimum two devices.

-dconvert=single -mconvert=dup -sconvert=dup

> 
>>> next, I'm doing the balance for the subvolume /mnt/BTRFS/backups
>> 
>> You told us above  you deleted that subvolume. So how are you balancing it?
> 
> Yes, that was my understanding from my research:
> You tell btrfs, that you want to remove one disc from the filesystem and then balance it to move the data on the remaining disc. I did find this logical. I was expecting that I possibly need a further command to tell btrfs that it's not a raid anymore, but I thought this could also be automagical.
> I understand, that's not the way it is implemented, but it's not a crazy idea, is it?

Well it's not the right way to think that devices are raid1 or raid0. It's the data or metadata that has that attribute. And by removing a device you are managing devices, not the attribute of data or metadata chunks. Since you're already at the minimum number of disks for raid0, that's why conversion is needed first.


> 
>> And also, balance applies to a mountpoint, and even if you mount a
> > subvolume to that mountpoint, the whole file system is balanced.
> > Not just the mounted subvolume.
> 
> That is confusing. (I mean: I understand what you are saying, but it's counterintuitive). Why is this the case?

A subvolume is a file system tree. The data created in that tree is allocated to chunks which can contain data from other trees. And balance reads/writes chunks. It's not a subvolume aware command.


> 
>>> In parallel, I try to delete /mnt/BTRFS/rsnapshot, but it fails:
>>>  btrfs subvolume delete  /mnt/BTRFS/rsnapshot/
>>>  Delete subvolume '/mnt/BTRFS/rsnapshot'
>>>  ERROR: cannot delete '/mnt/BTRFS/rsnapshot' - Inappropriate ioctl
>>>  for  device
>>> 
>>> Why's that?
>>> But even more: How do I free sdc1 now?!
>> 
>> 
>> Well I'm pretty confused because again, I can't tell if your paths refer to
> > subvolumes or if they refer to mount points.
> 
> Now I am confused. These paths are the paths to which I mounted the subvolumes:
> my (abbreviated) fstab:
> UUID=xy      /mnt/BTRFS/Video btrfs subvol=Video
> UUID=xy     /mnt/BTRFS/rsnapshot btrfs subvol=rsnapshot
> UUID=xy     /mnt/BTRFS/backups btrfs subvol=backups
> 
> 
> > The balance and device delete commands all refer to a mount point, which is the path returned by the df command.
> So this:
> /dev/sdb1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/Video
> /dev/sdb1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/backups
> /dev/sdc1       5,5T    3,5T  2,0T   64% /mnt/BTRFS/rsnapshot

You can't delete a mounted subvolume. You'd have to unmount it first. And then you'd have to mount a parent subvolume. So if the subvolume you want to delete is in the ID 5 subvolume, you must mount that subvolume, for example:
 
mount /dev/sdb1 /mnt/btrfs
btrfs subvolume delete /mnt/btrfs/<subvolumetodelete>



Chris Murphy