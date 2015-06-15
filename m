Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:56035 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbFOKlZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 06:41:25 -0400
Date: Mon, 15 Jun 2015 12:41:22 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Anand Jain <anand.jain@oracle.com>
Cc: kreijack@inwind.it, Andrei Borzenkov <arvidjaar@gmail.com>,
        systemd-devel@lists.freedesktop.org, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150615104122.GA25616@gardel-login>
References: <557ADBAE.9040407@oracle.com>
 <20150612210453.3dee4563@opensuse.site>
 <557B3C32.9030707@inwind.it>
 <557BF979.9040106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557BF979.9040106@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 13.06.15 17:35, Anand Jain (anand.jain@oracle.com) wrote:

> >>Are there any other users?
> >>
> >>>   - If the the device in the argument is already mounted,
> >>>     can it straightaway return 0 (ready) ? (as of now it would
> >>>     again independently read the SB determine total_devices
> >>>     and check against num_devices.
> >>>
> >>
> >>I think yes; obvious use case is btrfs mounted in initrd and later
> >>coldplug. There is no point to wait for anything as filesystem is
> >>obviously there.
> >>
> 
>  There is little difference. If the device is already mounted.
>  And there are two device paths for the same device PA and PB.
>  The path as last given to either 'btrfs dev scan (BTRFS_IOC_SCAN_DEV)'
>  or 'btrfs device ready (BTRFS_IOC_DEVICES_READY)' will be shown
>  in the 'btrfs filesystem show' or '/proc/self/mounts' output.
>  It does not mean that btrfs kernel will close the first device path
>  and reopen the 2nd given device path, it just updates the device path
>  in the kernel.

The device paths shown in /proc/self/mountinfo is also weird in other
cases: if people boot up without initrd, and use a btrfs fs as root,
then it will always carry the string /dev/root in there, which is
completely useless, since such a device never exists in userspace or
/sys, and hence one cannot make sense of. Moreover, if one then asks
the kernel for the devices backing the btrfs fs via the ioctl it will
also return /dev/root for it, which is really useless.

I think in general I'd prefer if btrfs would stop returning the device
paths it got from userspace or the kernel, and would always return
sanitized ones that use the official kernel names for the devices in
them. Specifically, the member devices ioctl should always return
names like "/dev/sda5", even if I mount something using root= on the
kernel cmdline, or if I mount /dev/disks/by-uuid/.... via a symlink
instead of the real kernel name of the device.

Then, I think it would be a good idea to always update the device
string shown in /proc/self/mountinfo to be a concatenated version of
the list of device names reported by the ioctl. So that a btrfs RAID
would show "/dev/sda5:/dev/sdb6:/dev/sdc5" or so. And if I remove or
add backing devices the string really should be updated.

The btrfs client side tools then could use udev to get a list of the
device node symlinks for each device to help the user identifying
which backing devices belong to a btrfs pool.

Lennart

-- 
Lennart Poettering, Red Hat
