Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33862 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdAKTED (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 14:04:03 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so158731wmi.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 11:04:03 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Best practices for raid 1
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
In-Reply-To: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
Date: Wed, 11 Jan 2017 19:04:00 +0000
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <F9190DED-AA28-4C6E-9217-4C567BBFF0A7@gmail.com>
References: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
To: Vinko Magecic <vinko.magecic@construction.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 10 Jan 2017, at 21:07, Vinko Magecic <vinko.magecic@construction.com> wrote:
> 
> Hello,
> 
> I set up a raid 1 with two btrfs devices and came across some situations in my testing that I can't get a straight answer on.
> 1) When replacing a volume, do I still need to `umount /path` and then `mount -o degraded ...` the good volume before doing the `btrfs replace start ...` ? I didn't see anything that said I had to and when I tested it without mounting the volume it was able to replace the device without any issue. Is that considered bad and could risk damage or has `replace` made it possible to replace devices without umounting the filesystem?

No need to unmount, just replace old with new. Your scenario seems very convoluted and it’s pointless

> 2) Everything I see about replacing a drive says to use `/old/device /new/device` but what if the old device can't be read or no longer exists? Would that be a `btrfs device add /new/device; btrfs balance start /new/device` ?
In case where old device is missing you’ve got few options:
- if you have enough space to fit the data and enough of disks to comply with redundancy - just remove the drive, So for example is you have 3 x 1TB drives with raid 1 And use less than 1TB of data total - juste remove one drive and you will have 2 x 1TB drives in raid 1 and btrfs fill just rebalance stuff for you !
- if you have not enough space to fi the data / not enough disks left to comply with raid lever - your only option is to add disk first then remove missing (btrfs dev delete missing /mount_point_of_your_fs)

> 3) When I have the RAID1 with two devices and I want to grow it out, which is the better practice? Create a larger volume, replace the old device with the new device and then do it a second time for the other device, or attaching the new volumes to the label/uuid one at a time and with each one use `btrfs filesystem resize devid:max /mountpoint`.

You kinda misunderstand the principal of btrfs. Btrfs will span across ALL the available space you’ve got. If you have multiple devices in this setup (remember that partition IS A DEVICE), it will span across multiple devices and you can’t change this. Now btrfs resize is mean for resizing a file system occupying a device (or partition). So work flow is that is you want to shrink a device (partition) you first shrink fs on this device than size down the device (partition) … if you want to increase the size of device (partition) you increase size of device (partition) than you grow filesystem within this device (partition). This is 100% irrespective of total cumulative size of file system. 

Let’s say you’ve got a btrfs file system that is spanning across 3 x 1TB devices … and those devices are partitions. You have raid 1 setup - your complete amount of available space is 1.5 TB. Let’s say you want to shrink of of partitions to 0.5TB -> first you shrink FS on this partition (balance will runn automatically) -> you shrink partition down to 0.5TB -> from now on your total available space is 1.25TB. 

Simples right ? :)

> Thanks
> 
> 
> 
> 
>    --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

