Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:56000 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbbFOKdD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 06:33:03 -0400
Date: Mon, 15 Jun 2015 12:27:02 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Anand Jain <anand.jain@oracle.com>
Cc: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [survey]  BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150615102702.GA25599@gardel-login>
References: <557ADBAE.9040407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557ADBAE.9040407@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12.06.15 21:16, Anand Jain (anand.jain@oracle.com) wrote:

> 
> 
> BTRFS_IOC_DEVICES_READY is to check if all the required devices
> are known by the btrfs kernel, so that admin/system-application
> could mount the FS. It is checked against a device in the argument.
> 
> However the actual implementation is bit more than just that,
> in the way that it would also scan and register the device
> provided in the argument (same as btrfs device scan subcommand
> or BTRFS_IOC_SCAN_DEV ioctl).
> 
> So BTRFS_IOC_DEVICES_READY ioctl isn't a read/view only ioctl,
> but its a write command as well.
> 
> Next, since in the kernel we only check if total_devices
> (read from SB)  is equal to num_devices (counted in the list)
> to state the status as 0 (ready) or 1 (not ready). But this
> does not work in rest of the device pool state like missing,
> seeding, replacing since total_devices is actually not equal
> to num_devices in these state but device pool is ready for
> the mount and its a bug which is not part of this discussions.
> 
> 
> Questions:
> 
>  - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
>    register the device provided (same as btrfs device scan
>    command or the BTRFS_IOC_SCAN_DEV ioctl)
>    OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
>    to check the state of the device pool. ?

I am pretty sure the kernel should not change API on this now. Hence:
stick to the current behaviour, please.

>  - If the the device in the argument is already mounted,
>    can it straightaway return 0 (ready) ? (as of now it would
>    again independently read the SB determine total_devices
>    and check against num_devices.

Yeah, I figure that might make sense to do.

>  - What should be the expected return when the FS is mounted
>    and there is a missing device.

An error, as it already does.

I am pretty sure that mounting "degraded" file systems should be an
exceptional operation, and not the common scheme. If it should happen
automatically at all, then it should be triggered by some daemon or
so, but not by udev/systemd.

Lennart

-- 
Lennart Poettering, Red Hat
