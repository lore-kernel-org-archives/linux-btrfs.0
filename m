Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbbFOPB6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 11:01:58 -0400
Date: Mon, 15 Jun 2015 17:01:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        lennart@poettering.net
Subject: Re: [survey]  BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150615150156.GO6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <557ADBAE.9040407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557ADBAE.9040407@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2015 at 09:16:30PM +0800, Anand Jain wrote:
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

The implemented DEVICES_READY behaviour is intentional, but not a good
example of ioctl interface design. I asked for a more generic interface
to querying devices when this patch was submitted but to no outcome.

> Next, since in the kernel we only check if total_devices
> (read from SB)  is equal to num_devices (counted in the list)
> to state the status as 0 (ready) or 1 (not ready). But this
> does not work in rest of the device pool state like missing,
> seeding, replacing since total_devices is actually not equal
> to num_devices in these state but device pool is ready for
> the mount and its a bug which is not part of this discussions.

That's an example why the single-shot ioctl is bad - it relies on some
internal state that's otherwise nontrivial to get.

> Questions:
> 
>   - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
>     register the device provided (same as btrfs device scan
>     command or the BTRFS_IOC_SCAN_DEV ioctl)
>     OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
>     to check the state of the device pool. ?

This has been mentioned in the thread, we cannot change the ioctl that
way. Extensions are possible as far as they stay backward compatible
without changes to the existing users.

>   - If the the device in the argument is already mounted,
>     can it straightaway return 0 (ready) ? (as of now it would
>     again independently read the SB determine total_devices
>     and check against num_devices.

We can do that, looks like a safe optimization.

>   - What should be the expected return when the FS is mounted
>     and there is a missing device.

I think the current ioctl cannot give a good answer to that, similar to
the seeding or dev-replace case. We'd need an improved ioctl or do it
via sysfs which is my preference at the moment.
