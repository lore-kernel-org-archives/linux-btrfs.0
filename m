Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33740 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbcETR77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 13:59:59 -0400
Received: by mail-io0-f171.google.com with SMTP id t40so62477661ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 10:59:59 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: Ferry Toth <ftoth@exalondelft.nl>, linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <CAPmG0jYi+gCO3Ps4Xi1ahE4qoqMt6ZmLMrxT_URDHdaA_cZCLg@mail.gmail.com>
 <1c1358af-4549-618a-c408-b93832d33225@gmail.com> <nhnfu8$igq$1@ger.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9bde1aa8-fac5-34c4-dffc-0bf15d86c008@gmail.com>
Date: Fri, 20 May 2016 13:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <nhnfu8$igq$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-20 13:02, Ferry Toth wrote:
> We have 4 1TB drives in MBR, 1MB free at the beginning, grub on all 4,
> then 8GB swap, then all the rest btrfs (no LVM used). The 4 btrfs
> partitions are in the same pool, which is in btrfs RAID10 format. /boot
> is in subvolume @boot.
If you have GRUB installed on all 4, then you don't actually have the 
full 2047 sectors between the MBR and the partition free, as GRUB is 
embedded in that space.  I forget exactly how much space it takes up, 
but I know it's not the whole 1023.5K  I would not suggest risking usage 
of the final 8k there though.  You could however convert to raid1 
temporarily, and then for each device, delete it, reformat for bcache, 
then re-add it to the FS.  This may take a while, but should be safe (of 
course, it's only an option if you're already using a kernel with bcache 
support).
> In this configuration nothing would beat btrfs if I could just add 2
> SSD's to the pool that would be clever enough to be paired in RAID1 and
> would be preferred for small (<1GB) file writes. Then balance should be
> able to move not often used files to the HDD.
>
> None of the methods mentioned here sound easy or quick to do, or even
> well tested.
It really depends on what you're used to.  I would consider most of the 
options easy, but one of the areas I'm strongest with is storage 
management, and I've repaired damaged filesystems and partition tables 
by hand with a hex editor before, so I'm not necessarily a typical user. 
  If I was going to suggest something specifically, it would be 
dm-cache, because it requires no modification to the backing store at 
all, but that would require running on LVM if you want it to be easy to 
set up (it's possible to do it without LVM, but you need something to 
call dmsetup before mounting the filesystem, which is not easy to 
configure correctly), and if you're on an enterprise distro, it may not 
be supported.

If you wanted to, it's possible, and not all that difficult, to convert 
a BTRFS system to BTRFS on top of LVM online, but you would probably 
have to split out the boot subvolume to a separate partition (depends on 
which distro you're on, some have working LVM support in GRUB, some 
don't).  If you're on a distro which does have LVM support in GRUB, the 
procedure would be:
1. Convert the BTRFS array to raid1. This lets you run with only 3 disks 
instead of 4.
2. Delete one of the disks from the array.
3. Convert the disk you deleted from the array to a LVM PV and add it to 
a VG.
4. Create a new logical volume occupying almost all of the PV you just 
added (having a little slack space is usually a good thing).
5. Add use btrfs replace to add the LV to the BTRFS array while deleting 
one of the others.
6. Repeat from step 3-5 for each disk, but stop at step 4 when you have 
exactly one disk that isn't on LVM (so for four disks, stop at step four 
when you have 2 with BTRFS+LVM, one with just the LVM logical volume, 
and one with just BTRFS).
7. Reinstall GRUB (it should pull in LVM support now).
8. Use BTRFS replace to move the final BTRFS disk to the empty LVM volume.
9. Convert the now empty final disk to LVM using steps 3-4
10. Add the LV to the BTRFS array and rebalance to raid10.
11. Reinstall GRUB again (just to be certain).

I've done essentially the same thing on numerous occasions when 
reprovisioning for various reasons, and it's actually one of the things 
outside of the xfstests that I check with my regression testing 
(including simulating a couple of the common failure modes).  It takes a 
while (especially for big arrays with lots of data), but it works, and 
is relatively safe (you are guaranteed to be able to rebuild a raid1 
array of 3 disks from just 2, so losing the disk in the process of 
copying it will not result in data loss unless you hit a kernel bug).
