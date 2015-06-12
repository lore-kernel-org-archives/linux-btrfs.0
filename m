Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:49359 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751424AbbFLUIW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 16:08:22 -0400
Message-ID: <557B3C32.9030707@inwind.it>
Date: Fri, 12 Jun 2015 22:08:18 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Andrei Borzenkov <arvidjaar@gmail.com>, Anand Jain <anand.jain@oracle.com>
CC: systemd-devel@lists.freedesktop.org,
        "linux-btrfs@vger.kernel.org >> linux-btrfs"
	<linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz
Subject: Re: [systemd-devel] [survey]  BTRFS_IOC_DEVICES_READY return status
References: <557ADBAE.9040407@oracle.com> <20150612210453.3dee4563@opensuse.site>
In-Reply-To: <20150612210453.3dee4563@opensuse.site>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-12 20:04, Andrei Borzenkov wrote:
> В Fri, 12 Jun 2015 21:16:30 +0800
> Anand Jain <anand.jain@oracle.com> пишет:
> 
>>
>>
>> BTRFS_IOC_DEVICES_READY is to check if all the required devices
>> are known by the btrfs kernel, so that admin/system-application
>> could mount the FS. It is checked against a device in the argument.
>>
>> However the actual implementation is bit more than just that,
>> in the way that it would also scan and register the device
>> provided in the argument (same as btrfs device scan subcommand
>> or BTRFS_IOC_SCAN_DEV ioctl).
>>
>> So BTRFS_IOC_DEVICES_READY ioctl isn't a read/view only ioctl,
>> but its a write command as well.
>>
>> Next, since in the kernel we only check if total_devices
>> (read from SB)  is equal to num_devices (counted in the list)
>> to state the status as 0 (ready) or 1 (not ready). But this
>> does not work in rest of the device pool state like missing,
>> seeding, replacing since total_devices is actually not equal
>> to num_devices in these state but device pool is ready for
>> the mount and its a bug which is not part of this discussions.
>>
>>
>> Questions:
>>
>>   - Do we want BTRFS_IOC_DEVICES_READY ioctl to also scan and
>>     register the device provided (same as btrfs device scan
>>     command or the BTRFS_IOC_SCAN_DEV ioctl)
>>     OR can BTRFS_IOC_DEVICES_READY be read-only ioctl interface
>>     to check the state of the device pool. ?
>>
> 
> udev is using it to incrementally assemble multi-device btrfs, so in
> this case I think it should. 

I agree, the ioctl name is confusing, but unfortunately this is an API and 
it has to be stay here forever. Udev uses it, so we know for sure that it
is widely used.

> Are there any other users?
> 
>>   - If the the device in the argument is already mounted,
>>     can it straightaway return 0 (ready) ? (as of now it would
>>     again independently read the SB determine total_devices
>>     and check against num_devices.
>>
> 
> I think yes; obvious use case is btrfs mounted in initrd and later
> coldplug. There is no point to wait for anything as filesystem is
> obviously there.
> 
>>   - What should be the expected return when the FS is mounted
>>     and there is a missing device.

I suggest to not invest further energy on a ioctl API. If you want these kind of information, you (we) should export these in sysfs:
In an ideal world:

- a new btrfs device appears
- udev register it with BTRFS_IOC_SCAN_DEV:
- udev (or mount ?) checks the status of the filesystem reading the sysfs entries (total devices, present devices, seed devices, raid level....); on the basis of the local policy (allow degraded mount, device timeout, how many device are missing, filesystem redundancy level.....) udev (mount) may mount the filesystem with the appropriate parameter (ro, degraded, or even insert a spare device to correct a missing device....)

>>
> 
> This is similar to problem mdadm had to solve. mdadm starts timer as
> soon as enough raid devices are present; if timer expires before raid
> is complete, raid is started in degraded mode. This avoids spurious
> rebuilds. So it would be good if btrfs could distinguish between enough
> devices to mount and all devices.

These are two different things: how export the filesystem information (I am still convinced that these have to be exported via sysfs), and what the system has to do in case of ... (a missing device ?). The latter is a policy, and I think that it should be not rely in the kernel.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
