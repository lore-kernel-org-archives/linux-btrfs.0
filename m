Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:35406 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751988AbbIWSuR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 14:50:17 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID6 duplicate device in array after replacing a drive. what
 the?
References: <3593680.XCB9qMyItR@roar> <5602D419.4090105@inwind.it>
To: Rob <btrfswok@jabawok.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Message-ID: <5602F466.6000703@libero.it>
Date: Wed, 23 Sep 2015 20:50:14 +0200
MIME-Version: 1.0
In-Reply-To: <5602D419.4090105@inwind.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-09-23 18:32, Goffredo Baroncelli wrote:
> On 2015-09-21 12:20, Rob wrote:
>> 2. btrfs scrub cancel /media/btrfs-rpi-raid6
>> 
>> - I waited 4h but this didnt return to a prompt (tried unmounting,
>> killall -9 btrfs) so i switched power off to the disks, replaced
>> the faulty disk and switched the enclosure on again.
> 
> I don't understood if the disks are in an external enclosure which
> was switched OFF (leaving the system ON) or you have switched OFF all
> the system. Could you clarify ?
> 

I was able to reproduce this; the good new is that I reproduced this issue with an old kernel (v4.1.5); a more recent kernel (v4.2.1) doesn't show the problem.

I suspect that the commit below solved this issue:

  commit 4fde46f0cc71c7aba299ee6dfb4f017fb97b6e70
  Author: Anand Jain <Anand.Jain@oracle.com>
  Date:   Wed Jun 17 21:10:48 2015 +0800

    Btrfs: free the stale device
    
    When btrfs on a device is overwritten with a new btrfs (mkfs),
    the old btrfs instance in the kernel becomes stale. So with this
    patch, if kernel finds device is overwritten then delete the stale
    fsid/uuid.
    
To trigger the problem you have to re-register two different devices (== different dev_uuid) with the same device name and the same fs_uuid (without rebooting).

Below how I reproduced this issue:

# creating the filesystem
truncate -s 20G img0
truncate -s 20G img1
truncate -s 20G img2
truncate -s 20G img3
losetup /dev/loop0 img0
losetup /dev/loop1 img1
losetup /dev/loop2 img2
losetup /dev/loop3 img3 
mkfs.btrfs -draid6 -mraid6 /dev/loop[0-3]

# mount and use the filesystem
mount /dev/loop1 /mnt/test
[...]
umount /mnt/test


# remove the img2, rotate the devices
losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2
losetup -d /dev/loop3

losetup /dev/loop1 img0
losetup /dev/loop2 img1
losetup /dev/loop3 img3
#NOTE /dev/loop0 is unassigned

mount -o degraded /dev/loop1 /mnt/test
btrfs fi usage /mnt/test

WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:		  80.00GiB
    Device allocated:		  20.00MiB
    Device unallocated:		  79.98GiB
    Device missing:		     0.00B
    Used:			     0.00B
    Free (estimated):		  20.07TiB	(min: 81.99GiB)
    Data ratio:			      0.00
    Metadata ratio:		      0.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,single: Size:8.00MiB, Used:0.00B
   /dev/loop1	   8.00MiB

Data,RAID6: Size:2.00GiB, Used:11.00MiB
   /dev/loop1	   1.00GiB
   /dev/loop2	   1.00GiB
   /dev/loop2	   1.00GiB
   /dev/loop3	   1.00GiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/loop1	   8.00MiB

Metadata,RAID6: Size:2.00GiB, Used:112.00KiB
   /dev/loop1	   1.00GiB
   /dev/loop2	   1.00GiB
   /dev/loop2	   1.00GiB
   /dev/loop3	   1.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/loop1	   4.00MiB

System,RAID6: Size:16.00MiB, Used:16.00KiB
   /dev/loop1	   8.00MiB
   /dev/loop2	   8.00MiB
   /dev/loop2	   8.00MiB
   /dev/loop3	   8.00MiB

Unallocated:
   /dev/loop1	  17.97GiB
   /dev/loop2	  17.99GiB
   /dev/loop2	  17.99GiB
   /dev/loop3	  17.99GiB



BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
