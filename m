Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:48616 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750923AbbFMPRq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 11:17:46 -0400
Message-ID: <557C479F.2070403@libero.it>
Date: Sat, 13 Jun 2015 17:09:19 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, Andrei Borzenkov <arvidjaar@gmail.com>
CC: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [systemd-devel] [survey]  BTRFS_IOC_DEVICES_READY return status
References: <557ADBAE.9040407@oracle.com> <20150612210453.3dee4563@opensuse.site> <557B3C32.9030707@inwind.it> <557BF979.9040106@oracle.com>
In-Reply-To: <557BF979.9040106@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-13 11:35, Anand Jain wrote:
> 
> Thanks for your reply Andrei and Goffredo. more below...
> 
> On 06/13/2015 04:08 AM, Goffredo Baroncelli wrote:
>> On 2015-06-12 20:04, Andrei Borzenkov wrote:
>>> В Fri, 12 Jun 2015 21:16:30 +0800 Anand Jain
>>> <anand.jain@oracle.com> пишет:
>>> 
>>>> 
>>>> 
>>>> BTRFS_IOC_DEVICES_READY is to check if all the required
>>>> devices are known by the btrfs kernel, so that
>>>> admin/system-application could mount the FS. It is checked
>>>> against a device in the argument.
>>>> 
>>>> However the actual implementation is bit more than just that, 
>>>> in the way that it would also scan and register the device 
>>>> provided in the argument (same as btrfs device scan subcommand 
>>>> or BTRFS_IOC_SCAN_DEV ioctl).
>>>> 
>>>> So BTRFS_IOC_DEVICES_READY ioctl isn't a read/view only ioctl, 
>>>> but its a write command as well.
>>>> 
>>>> Next, since in the kernel we only check if total_devices (read
>>>> from SB)  is equal to num_devices (counted in the list) to
>>>> state the status as 0 (ready) or 1 (not ready). But this does
>>>> not work in rest of the device pool state like missing, 
>>>> seeding, replacing since total_devices is actually not equal to
>>>> num_devices in these state but device pool is ready for the
>>>> mount and its a bug which is not part of this discussions.
>>>> 
>>>> 
>>>> Questions:
>>>> 
>>>> - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and 
>>>> register the device provided (same as btrfs device scan command
>>>> or the BTRFS_IOC_SCAN_DEV ioctl) OR can BTRFS_IOC_DEVICES_READY
>>>> be read-only ioctl interface to check the state of the device
>>>> pool. ?
>>>> 
>>> 
>>> udev is using it to incrementally assemble multi-device btrfs, so
>>> in this case I think it should.
> 
> Nice. Thanks for letting me know this.
> 
>> I agree, the ioctl name is confusing, but unfortunately this is an
>> API and it has to be stay here forever. Udev uses it, so we know
>> for sure that it is widely used.
> 
> ok. what goes in stays there forever. its time to update the man page
> rather.
> 
>>> Are there any other users?
>>> 
>>>> - If the the device in the argument is already mounted, can it
>>>> straightaway return 0 (ready) ? (as of now it would again
>>>> independently read the SB determine total_devices and check
>>>> against num_devices.
>>>> 
>>> 
>>> I think yes; obvious use case is btrfs mounted in initrd and
>>> later coldplug. There is no point to wait for anything as
>>> filesystem is obviously there.
>>> 
> 
> There is little difference. If the device is already mounted. And
> there are two device paths for the same device PA and PB. The path as
> last given to either 'btrfs dev scan (BTRFS_IOC_SCAN_DEV)' or 'btrfs
> device ready (BTRFS_IOC_DEVICES_READY)' will be shown in the 'btrfs
> filesystem show' or '/proc/self/mounts' output. It does not mean that
> btrfs kernel will close the first device path and reopen the 2nd
> given device path, it just updates the device path in the kernel.
> 
> Further, the problem will be more intense in this eg. if you use dd
> and copy device A to device B. After you mount device A, by just
> providing device B in the above two commands you could let kernel
> update the device path, again all the IO (since device is mounted)
> are still going to the device A (not B), but /proc/self/mounts and
> 'btrfs fi show' shows it as device B (not A).
> 
> Its a bug. very tricky to fix.

In the past [*] I proposed a mount.btrfs helper . I tried to move the logic outside the kernel.
I think that the problem is that we try to manage all these cases from a device point of view: when a device appears, we register the device and we try to mount the filesystem... This works very well when there is 1-volume filesystem. For the other cases there is a mess between the different layers:
- kernel
- udev/systemd
- initrd logic

My attempt followed a different idea: the mount helper waits the devices if needed, or if it is the case it mounts the filesystem in degraded mode. All devices are passed as mount arguments (--device=/dev/sdX), there is no a device registration: this avoids all these problems.

[*] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/40767

back to your questions

> - we can't return -EBUSY for subsequent (after mount) calls for the
> above two ioctls (if a mounted device is used as an argument). Since
> admin/system-application might actually call again to mount subvols.

I am not sure that the two things are related: the mount doesn't use BTRFS_IOC_DEVICES_READY. After BTRFS_IOC_DEVICES_READY returns OK, all the filesystem belongs this FSID should be mounted; but it is a job of systemd/initramfs/sysv... a further failed BTRFS_IOC_DEVICES_READY shouldn't case any problem ...


> 
> - we can return success (without updating the device path) but, we
> would be wrong when device A is copied into device B using dd. Since
> we would check against the on device SB's fsid/uuid/devid. Checking
> using strcmp the device paths is not practical since there can be
> different paths to the same device (lets says mapper).

> 
> (any suggestion on how to check if its the same device in the 
> kernel?).

check minor/major ?

> 
> - Also if we don't let to update the device path after device is 
> mounted, then are there chances that we would be stuck with the 
> device path during initrd which does not make any sense to the user
> ?
> 
> 
>>>> - What should be the expected return when the FS is mounted and
>>>> there is a missing device.
>> 
>> I suggest to not invest further energy on a ioctl API. If you want
>> these kind of information, you (we) should export these in sysfs: 
>> In an ideal world:
>> 
>> - a new btrfs device appears - udev register it with
>> BTRFS_IOC_SCAN_DEV: - udev (or mount ?) checks the status of the
>> filesystem reading the sysfs entries (total devices, present
>> devices, seed devices, raid level....); on the basis of the local
>> policy (allow degraded mount, device timeout, how many device are
>> missing, filesystem redundancy level.....) udev (mount) may mount
>> the filesystem with the appropriate parameter (ro, degraded, or
>> even insert a spare device to correct a missing device....)
> 
> Yes. sysfs interface is coming. few framework patch were sent
> sometime back, any comments will help. On the ioctl part I am trying
> to fix the bug(s).




> 
>>>> 
>>> 
>>> This is similar to problem mdadm had to solve. mdadm starts timer
>>> as soon as enough raid devices are present; if timer expires
>>> before raid is complete, raid is started in degraded mode. This
>>> avoids spurious rebuilds. So it would be good if btrfs could
>>> distinguish between enough devices to mount and all devices.
> 
>> These are two different things: how export the filesystem
>> information (I am still convinced that these have to be exported
>> via sysfs), and what the system has to do in case of ... (a missing
>> device ?). The latter is a policy, and I think that it should be
>> not rely in the kernel.
>> 
>> 
>>> -- To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in the body of a message to
>>> majordomo@vger.kernel.org More majordomo info at
>>> http://vger.kernel.org/majordomo-info.html
>>> 
>> 
>> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
