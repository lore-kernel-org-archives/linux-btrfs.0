Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn3nam01on0040.outbound.protection.outlook.com ([104.47.33.40]:42164
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751577AbdAJVH2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 16:07:28 -0500
From: Vinko Magecic <vinko.magecic@construction.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Best practices for raid 1
Date: Tue, 10 Jan 2017 21:07:25 +0000
Message-ID: <MWHPR10MB1472DFDAF96ED8C7E5EB9FC494670@MWHPR10MB1472.namprd10.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I set up a raid 1 with two btrfs devices and came across some situations in my testing that I can't get a straight answer on.

1) When replacing a volume, do I still need to `umount /path` and then `mount -o degraded ...` the good volume before doing the `btrfs replace start ...` ? I didn't see anything that said I had to and when I tested it without mounting the volume it was able to replace the device without any issue. Is that considered bad and could risk damage or has `replace` made it possible to replace devices without umounting the filesystem?

2) Everything I see about replacing a drive says to use `/old/device /new/device` but what if the old device can't be read or no longer exists? Would that be a `btrfs device add /new/device; btrfs balance start /new/device` ?

3) When I have the RAID1 with two devices and I want to grow it out, which is the better practice? Create a larger volume, replace the old device with the new device and then do it a second time for the other device, or attaching the new volumes to the label/uuid one at a time and with each one use `btrfs filesystem resize devid:max /mountpoint`.

Thanks


     

    