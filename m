Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36657 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbbFLNQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 09:16:43 -0400
Message-ID: <557ADBAE.9040407@oracle.com>
Date: Fri, 12 Jun 2015 21:16:30 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
CC: lennart@poettering.net, dsterba@suse.cz
Subject: [survey]  BTRFS_IOC_DEVICES_READY return status
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



BTRFS_IOC_DEVICES_READY is to check if all the required devices
are known by the btrfs kernel, so that admin/system-application
could mount the FS. It is checked against a device in the argument.

However the actual implementation is bit more than just that,
in the way that it would also scan and register the device
provided in the argument (same as btrfs device scan subcommand
or BTRFS_IOC_SCAN_DEV ioctl).

So BTRFS_IOC_DEVICES_READY ioctl isn't a read/view only ioctl,
but its a write command as well.

Next, since in the kernel we only check if total_devices
(read from SB)  is equal to num_devices (counted in the list)
to state the status as 0 (ready) or 1 (not ready). But this
does not work in rest of the device pool state like missing,
seeding, replacing since total_devices is actually not equal
to num_devices in these state but device pool is ready for
the mount and its a bug which is not part of this discussions.


Questions:

  - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
    register the device provided (same as btrfs device scan
    command or the BTRFS_IOC_SCAN_DEV ioctl)
    OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
    to check the state of the device pool. ?

  - If the the device in the argument is already mounted,
    can it straightaway return 0 (ready) ? (as of now it would
    again independently read the SB determine total_devices
    and check against num_devices.

  - What should be the expected return when the FS is mounted
    and there is a missing device.


Thanks, Anand
