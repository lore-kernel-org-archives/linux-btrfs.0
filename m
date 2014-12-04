Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60193 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDSjq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:39:46 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so28945170wid.12
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:39:44 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
Date: Thu,  4 Dec 2014 19:39:37 +0100
Message-Id: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
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

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

Changelog
V2: moved some chunk from patch#5 to patch#2
V1: first issue
