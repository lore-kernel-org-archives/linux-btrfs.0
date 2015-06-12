Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33602 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbbFLSE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 14:04:57 -0400
Received: by lbcue7 with SMTP id ue7so23892015lbc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 11:04:55 -0700 (PDT)
Date: Fri, 12 Jun 2015 21:04:53 +0300
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [systemd-devel] [survey]  BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150612210453.3dee4563@opensuse.site>
In-Reply-To: <557ADBAE.9040407@oracle.com>
References: <557ADBAE.9040407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

В Fri, 12 Jun 2015 21:16:30 +0800
Anand Jain <anand.jain@oracle.com> пишет:

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
>   - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
>     register the device provided (same as btrfs device scan
>     command or the BTRFS_IOC_SCAN_DEV ioctl)
>     OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
>     to check the state of the device pool. ?
> 

udev is using it to incrementally assemble multi-device btrfs, so in
this case I think it should. Are there any other users?

>   - If the the device in the argument is already mounted,
>     can it straightaway return 0 (ready) ? (as of now it would
>     again independently read the SB determine total_devices
>     and check against num_devices.
> 

I think yes; obvious use case is btrfs mounted in initrd and later
coldplug. There is no point to wait for anything as filesystem is
obviously there.

>   - What should be the expected return when the FS is mounted
>     and there is a missing device.
> 

This is similar to problem mdadm had to solve. mdadm starts timer as
soon as enough raid devices are present; if timer expires before raid
is complete, raid is started in degraded mode. This avoids spurious
rebuilds. So it would be good if btrfs could distinguish between enough
devices to mount and all devices.
