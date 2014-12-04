Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45482 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaLDSYn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:24:43 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so35590396wib.16
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:24:42 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH][BTRFS-PROGS] Skip LVM snapshot device
Date: Thu,  4 Dec 2014 19:24:25 +0100
Message-Id: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



LVM snapshots are a problem for the btrfs devices management.
BTRFS assumes that each device have an unique 'device UUID'. 
A LVM snapshot breaks this assumption.

This causes a lot of problems if some btrfs device are snapshotted:
- the set of devices for a btrfs multi-volume filesystem may be mixed
(i.e. some NON snapshotted device with some snapshotted devices)
- /proc/mount may returns a wrong device. 

In the mailing list some posts reported these incidents.

This patch allows btrfs to skip LVM snapshot during the device scan 
phase.

But if you need to consider a LVM snapshot you can set the
environment variable BTRFS_SKIP_LVM_SNAPSHOT to "no". In this case
the old behavior is applied.

To check if a device is a LVM snapshot, it is checked the 'udev'
device property 'DM_UDEV_LOW_PRIORITY_FLAG' . If it is set to 1,
the device has to be skipped.

As consequence, btrfs now depends also by the libudev.

The last patch is a check to ensure that the devices list 
doesn't contain two devices with the same dev.uuid. This check is 
performed *ONLY* when btrfs collects the information about all devices (
i.e. btrfs device scan <device> is not this case).

This patch addresses the following cases:
- scanning performed by udev rules
- "btrfs device scan" performed in the initramdisk
- btrfs device scan <device>
- other programs which call btrfs_scan_lblkid()

BR
G.Baroncelli

