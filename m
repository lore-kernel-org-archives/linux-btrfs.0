Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:32859 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBKRCU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 12:02:20 -0500
Received: by mail-qc0-f175.google.com with SMTP id x13so13205093qcv.6
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 09:02:19 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 11 Feb 2014 18:02:19 +0100
Message-ID: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
Subject: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when
 removing drive)
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Kyle Gates <kylegates@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello and thanks for your feedback !

Cc back to the mailing-list as it may be of interest here as well.

On 11 February 2014 16:11, Kyle Gates <kylegates@hotmail.com> wrote:
>> The big problem I currently have is that based on your input, I
>> hesitate a lot on my partitioning scheme: should I use a dedicated
>> /boot partition or should I have one global BTRFS partition ?
>> It is not very clear in the doc (a lof of people used a dedicated
>> /boot because at that time, grub couldn't natively boot BTRFS it
>> seems, but it has changed).
>> Could you recommend a partitioning scheme for a simple RAID1 with 2
>> identical hard drives (just for home computing, not business).
>
> I run a 1GiB RAID1 btrfs /boot in mixed mode with grub2 and gpt partitions.
> IIRC grub2 doesn't understand lzo compression nor subvolumes.
>

Well I did tried to read about this and ended up being confused
because development is so fast, documentation can become quickly
outdated.
It seems that grub can boot BTRFS /boot subvolumes:
https://bbs.archlinux.org/viewtopic.php?pid=1222358

However Chris Murphy has some problems a few months ago:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/29140

So I still don't know if it is a good idea or not to have a BTRFS /boot ?
Of course the idea is that I would like to snapshot /boot and have it on RAID1.

To summarize, I think I have 3 options for partitioning (I am not
considering UEFI secure boot or swap):
1) grub, BTRFS partition (i.e. full disk in BTRFS), /boot inside BTRFS subvolume
2) grub, GPT partition, with (A) on sda1, and a BTRFS partition on
sda2, /boot inside BTRFS subvolume
3) grub, GPT partition, with (A) on sda1, /boot (ext4) on sda2, and a
BTRFS on sda3

(A) = BIOS Boot partition (1 MiB) or EFI System Partition (FAT32, 550MiB)

I don't really see the point of having UEFI/ESP if I don't use other
proprietary operating system, so I think I will go with (A) = BIOS
Boot partition except if there is someting I have missed.

Can someone recommend which one would be the most stable and easier to manage ?

Thanks in advance,
