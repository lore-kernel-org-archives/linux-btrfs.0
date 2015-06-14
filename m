Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33989 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbFNFsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jun 2015 01:48:05 -0400
Received: by lbcmx3 with SMTP id mx3so36986256lbc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jun 2015 22:48:03 -0700 (PDT)
Date: Sun, 14 Jun 2015 08:48:01 +0300
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: kreijack@inwind.it, systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [systemd-devel] [survey]  BTRFS_IOC_DEVICES_READY return status
Message-ID: <20150614084801.6cfed8ee@opensuse.site>
In-Reply-To: <557BF979.9040106@oracle.com>
References: <557ADBAE.9040407@oracle.com>
	<20150612210453.3dee4563@opensuse.site>
	<557B3C32.9030707@inwind.it>
	<557BF979.9040106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

В Sat, 13 Jun 2015 17:35:53 +0800
Anand Jain <anand.jain@oracle.com> пишет:

> 
> Thanks for your reply Andrei and Goffredo.
> more below...
> 
> On 06/13/2015 04:08 AM, Goffredo Baroncelli wrote:
> > On 2015-06-12 20:04, Andrei Borzenkov wrote:
> >> В Fri, 12 Jun 2015 21:16:30 +0800
> >> Anand Jain <anand.jain@oracle.com> пишет:
> >>
> >>>
> >>>
> >>> BTRFS_IOC_DEVICES_READY is to check if all the required devices
> >>> are known by the btrfs kernel, so that admin/system-application
> >>> could mount the FS. It is checked against a device in the argument.
> >>>
> >>> However the actual implementation is bit more than just that,
> >>> in the way that it would also scan and register the device
> >>> provided in the argument (same as btrfs device scan subcommand
> >>> or BTRFS_IOC_SCAN_DEV ioctl).
> >>>
> >>> So BTRFS_IOC_DEVICES_READY ioctl isn't a read/view only ioctl,
> >>> but its a write command as well.
> >>>
> >>> Next, since in the kernel we only check if total_devices
> >>> (read from SB)  is equal to num_devices (counted in the list)
> >>> to state the status as 0 (ready) or 1 (not ready). But this
> >>> does not work in rest of the device pool state like missing,
> >>> seeding, replacing since total_devices is actually not equal
> >>> to num_devices in these state but device pool is ready for
> >>> the mount and its a bug which is not part of this discussions.
> >>>
> >>>
> >>> Questions:
> >>>
> >>>    - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
> >>>      register the device provided (same as btrfs device scan
> >>>      command or the BTRFS_IOC_SCAN_DEV ioctl)
> >>>      OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
> >>>      to check the state of the device pool. ?
> >>>
> >>
> >> udev is using it to incrementally assemble multi-device btrfs, so in
> >> this case I think it should.
> 
>   Nice. Thanks for letting me know this.
> 
> > I agree, the ioctl name is confusing, but unfortunately this is an API and
> > it has to be stay here forever. Udev uses it, so we know for sure that it
> > is widely used.
> 
>   ok. what goes in stays there forever. its time to update
>   the man page rather.
> 
> >> Are there any other users?
> >>
> >>>    - If the the device in the argument is already mounted,
> >>>      can it straightaway return 0 (ready) ? (as of now it would
> >>>      again independently read the SB determine total_devices
> >>>      and check against num_devices.
> >>>
> >>
> >> I think yes; obvious use case is btrfs mounted in initrd and later
> >> coldplug. There is no point to wait for anything as filesystem is
> >> obviously there.
> >>
> 
>   There is little difference. If the device is already mounted.
>   And there are two device paths for the same device PA and PB.
>   The path as last given to either 'btrfs dev scan (BTRFS_IOC_SCAN_DEV)'
>   or 'btrfs device ready (BTRFS_IOC_DEVICES_READY)' will be shown
>   in the 'btrfs filesystem show' or '/proc/self/mounts' output.
>   It does not mean that btrfs kernel will close the first device path
>   and reopen the 2nd given device path, it just updates the device path
>   in the kernel.
> 
>   Further, the problem will be more intense in this eg.
>   if you use dd and copy device A to device B.
>   After you mount device A, by just providing device B in the
>   above two commands you could let kernel update the device path,
>   again all the IO (since device is mounted) are still going to
>   the device A (not B), but /proc/self/mounts and 'btrfs fi show'
>   shows it as device B (not A).
> 
>   Its a bug. very tricky to fix.
> 
>    - we can't return -EBUSY for subsequent (after mount) calls
>    for the above two ioctls (if a mounted device is used as an argument).
>    Since admin/system-application might actually call again to
>    mount subvols.
> 
>    - we can return success (without updating the device path) but,
>    we would be wrong when device A is copied into device B using dd.
>    Since we would check against the on device SB's fsid/uuid/devid.
>    Checking using strcmp the device paths is not practical since there
>    can be different paths to the same device (lets says mapper).
> 

Neither of those problems are specific to mounted filesystem. The
order of device discovery is non-deterministic. If you duplicate devices
(snapshot, dd) it is unpredictable which devices will be included in
btrfs. I.e. if you have A, B, C and A1, B1, C1 filesystem could be
assembled as A, B, C1 and next boot as A, B1, C.

Other systems attempt to mitigate such situation by keeping track of
both on-disk identification and physical device properties (e.g.
changing LU number will cause VMware to block access to disk on
assumption that it is snapshot). One possibility is to store disk
physical identity (UUID, serial number) and compare on access. 

Unless this is done, to guard against such case full device scan must
be performed and attempt to mount such filesystem (that has duplicated
members) blocked until admin resolves the issue. If filesystem is already
mounted, any attempt to add duplicated member must be rejected.

>    (any suggestion on how to check if its the same device in the
>    kernel?).
> 

I do not know kernel interfaces, but querying for unique device
identification sounds like the most generic approach. OTOH there are
multiple supported methods and that is already what user space does
quite well, so could be done in cooperation with it?

>    - Also if we don't let to update the device path after device is
>    mounted, then are there chances that we would be stuck with the
>    device path during initrd which does not make any sense to the
>    user ?
> 

I think this is independent. udev is only concerned with "is btrfs
ready to be mounted" or not. I do not see why it would prevent updating
device paths in kernel if needed.

> 
> >>>    - What should be the expected return when the FS is mounted
> >>>      and there is a missing device.
> >
> > I suggest to not invest further energy on a ioctl API. If you want these kind of information, you (we) should export these in sysfs:
> > In an ideal world:
> >
> > - a new btrfs device appears
> > - udev register it with BTRFS_IOC_SCAN_DEV:
> > - udev (or mount ?) checks the status of the filesystem reading the sysfs entries (total devices, present devices, seed devices, raid level....); on the basis of the local policy (allow degraded mount, device timeout, how many device are missing, filesystem redundancy level.....) udev (mount) may mount the filesystem with the appropriate parameter (ro, degraded, or even insert a spare device to correct a missing device....)
> 
>   Yes. sysfs interface is coming. few framework patch were sent sometime
>   back, any comments will help. On the ioctl part I am trying to fix the
>   bug(s).
> 

As we need to call into btrfs anyway, it would actually be easier if
BTRFS_IOC_DEVICES_READY could return both indication that btrfs can be
mounted and whether it is incomplete. It already has all information
and it saves extra calls each time. But as it is API now, it probably
won't happen (BTRFS_IOC_DEVICES_READY_V2?)

> >>>
> >>
> >> This is similar to problem mdadm had to solve. mdadm starts timer as
> >> soon as enough raid devices are present; if timer expires before raid
> >> is complete, raid is started in degraded mode. This avoids spurious
> >> rebuilds. So it would be good if btrfs could distinguish between enough
> >> devices to mount and all devices.
> 
> > These are two different things: how export the filesystem information (I am still convinced that these have to be exported via sysfs), and what the system has to do in case of ... (a missing device ?). The latter is a policy, and I think that it should be not rely in the kernel.
> >
> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> >

