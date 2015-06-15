Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:56089 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbFOKqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 06:46:22 -0400
Date: Mon, 15 Jun 2015 12:46:18 +0200
From: Lennart Poettering <lennart@poettering.net>
To: kreijack@inwind.it
Cc: Anand Jain <anand.jain@oracle.com>, Andrei Borzenkov <arvidjaar@gmail.com>,
        systemd-devel@lists.freedesktop.org, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150615104618.GB25616@gardel-login>
References: <557ADBAE.9040407@oracle.com>
 <20150612210453.3dee4563@opensuse.site>
 <557B3C32.9030707@inwind.it>
 <557BF979.9040106@oracle.com>
 <557C479F.2070403@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557C479F.2070403@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 13.06.15 17:09, Goffredo Baroncelli (kreijack@libero.it) wrote:

> > Further, the problem will be more intense in this eg. if you use dd
> > and copy device A to device B. After you mount device A, by just
> > providing device B in the above two commands you could let kernel
> > update the device path, again all the IO (since device is mounted)
> > are still going to the device A (not B), but /proc/self/mounts and
> > 'btrfs fi show' shows it as device B (not A).
> > 
> > Its a bug. very tricky to fix.
> 
> In the past [*] I proposed a mount.btrfs helper . I tried to move the logic outside the kernel.
> I think that the problem is that we try to manage all these cases
> from a device point of view: when a device appears, we register the
> device and we try to mount the filesystem... This works very well
> when there is 1-volume filesystem. For the other cases there is a
> mess between the different layers:

> - kernel
> - udev/systemd
> - initrd logic
> 
> My attempt followed a different idea: the mount helper waits the
> devices if needed, or if it is the case it mounts the filesystem in
> degraded mode. All devices are passed as mount arguments
> (--device=/dev/sdX), there is no a device registration: this avoids
> all these problems.

Hmm, no. /bin/mount should not block for devices. That's generally
incompatible with how the tool is used, and in particular from
systemd. We would not make use for such a scheme in
systemd. /bin/mount should always be short-running.

I am pretty sure that if such automatic degraded mounting should be
supported, then this should be done with some background storage
daemon that alters the effect of the READY ioctl somehow after the
timeout, and then retriggers the devcies so that systemd takes
note. (or, alternatively: such a scheme could even be implemented all
in kernel, based on some configurable kernel setting...)

Lennart

-- 
Lennart Poettering, Red Hat
