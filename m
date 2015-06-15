Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:57295 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbFORiI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 13:38:08 -0400
Date: Mon, 15 Jun 2015 19:38:06 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Anand Jain <anand.jain@oracle.com>, Andrei Borzenkov <arvidjaar@gmail.com>,
        systemd-devel@lists.freedesktop.org, dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [survey] BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150615173806.GB26366@gardel-login>
References: <557ADBAE.9040407@oracle.com>
 <20150612210453.3dee4563@opensuse.site>
 <557B3C32.9030707@inwind.it>
 <557BF979.9040106@oracle.com>
 <557C479F.2070403@libero.it>
 <20150615104618.GB25616@gardel-login>
 <557F0A26.8070308@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557F0A26.8070308@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 15.06.15 19:23, Goffredo Baroncelli (kreijack@inwind.it) wrote:

> On 2015-06-15 12:46, Lennart Poettering wrote:
> > On Sat, 13.06.15 17:09, Goffredo Baroncelli (kreijack@libero.it) wrote:
> > 
> >>> Further, the problem will be more intense in this eg. if you use dd
> >>> and copy device A to device B. After you mount device A, by just
> >>> providing device B in the above two commands you could let kernel
> >>> update the device path, again all the IO (since device is mounted)
> >>> are still going to the device A (not B), but /proc/self/mounts and
> >>> 'btrfs fi show' shows it as device B (not A).
> >>>
> >>> Its a bug. very tricky to fix.
> >>
> >> In the past [*] I proposed a mount.btrfs helper . I tried to move the logic outside the kernel.
> >> I think that the problem is that we try to manage all these cases
> >> from a device point of view: when a device appears, we register the
> >> device and we try to mount the filesystem... This works very well
> >> when there is 1-volume filesystem. For the other cases there is a
> >> mess between the different layers:
> > 
> >> - kernel
> >> - udev/systemd
> >> - initrd logic
> >>
> >> My attempt followed a different idea: the mount helper waits the
> >> devices if needed, or if it is the case it mounts the filesystem in
> >> degraded mode. All devices are passed as mount arguments
> >> (--device=/dev/sdX), there is no a device registration: this avoids
> >> all these problems.
> > 
> > Hmm, no. /bin/mount should not block for devices. That's generally
> > incompatible with how the tool is used, and in particular from
> > systemd. We would not make use for such a scheme in
> > systemd. /bin/mount should always be short-running.
> 
> Apart systemd, which are these incompatibilities ? 

Well, /bin/mount is not a daemon, and it should not be one.

> > I am pretty sure that if such automatic degraded mounting should be
> > supported, then this should be done with some background storage
> > daemon that alters the effect of the READY ioctl somehow after the
> > timeout, and then retriggers the devcies so that systemd takes
> > note. (or, alternatively: such a scheme could even be implemented all
> > in kernel, based on some configurable kernel setting...)
> 
> I recognize that this solution provides the maximum compatibility
> with the current implementation. However it seems too complex to
> me. Re-trigging a devices seems to me more a workaround than a
> solution.

Well, it's not really ugly. I mean, if the state or properties of a
device change, then udev should update its information about it, and
that's done via a retrigger. We do that all the time already, for
example when an existing loopback device gets a backing file assigned
or removed. I am pretty sure that loopback case is very close to what
you want to do here, hence retriggering (either from the kernel side,
or from userspace), appears like an OK thing to do.

> Could a generator do this job ? I.e. this generator (or storage
> daemon) waits that all (or enough) devices are appeared, then it
> creates a .mount unit: do you think that it is doable ?

systemd generators are a way to extend the systemd unit dep tree with
units. They are very short running, and are executed only very very
early at boot. They cannot wait for anything, they don#t have access
to devices and are not run when they are appear.

Lennart

-- 
Lennart Poettering, Red Hat
