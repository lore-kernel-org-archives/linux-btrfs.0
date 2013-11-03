Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55647 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3KCXHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 18:07:14 -0500
Received: by mail-ee0-f50.google.com with SMTP id b45so8013eek.9
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 15:07:12 -0800 (PST)
Message-ID: <5276D71D.6050808@gmail.com>
Date: Mon, 04 Nov 2013 00:07:09 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] BTRFS_PROG: mount.btrfs helper
References: <1383503921-6694-1-git-send-email-kreijack@inwind.it> <5276BED4.4060707@suse.com>
In-Reply-To: <5276BED4.4060707@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-03 22:23, Jeff Mahoney wrote:
> On 11/3/13, 1:38 PM, Goffredo Baroncelli wrote:
>> Hi all,
>>
>> this patch provides a mount.btrfs helper for the mount command to
>> mounting a btrfs filesystem.
>> A btrfs filesystem could spans several disks. This helper scans all
>> the partition to discover all the disks required to mount a filesystem.
>> So it is not necessary any-more to "scan" manually the partitions to mount
>> a filesystem via the "btrfs device scan" command.
>>
>> It adds in the option parameters the devices required to mount a
>> filesystem. Supposing that a filesystem is composed by several disks
>> (/dev/sd[cdef]), when the user does "mount /dev/sdd /mnt", mount calls
>> mount.btrfs which int turn calls the mount(2) syscall like:
>> mount("/dev/sdd", "/mnt", "btrfs", 0,
>> "device=/dev/sdc,device=/dev/sde,device=/de/vsdf").
>>
>> This helper uses both the libblkid and libmount to discover the
>> devices, to compute the parameters manipulation and to update the mtab
>> file.
>>
>> I got the idea from the btrfs.wiki; its biggest gains is to avoid the
>> separation of scanning phases (at boot time or during the block device
>> discovery) from the mounting. Also mkfs.btrfs could avoid to re-do a
>> rescan of the devices after a formatting.
>>
>> mount.btrfs doesn't add more requirement than the mount command. It
>> would be possible to remove the "btrfs" command from the initramfs, and
>> all the related scripts (in my debian both udev and btrfs-tools
>> packages contains three udev rules for btrfs).
>>
>> Comments are welcome.
> 
> I like the idea but I'm concerned how well this will perform on large
> systems with thousands of disks attached. btrfs dev scan can have a list
> of potential devices specified, but this helper defaults to all devices.

liblkid uses a cache to increase the speed of a search.

Only if some incoherency from the data is found (like a mkfs after a
boot) a "probe all" is executed.
But in this case we could update mkfs.btrfs to invalidate the blkid
cache of disks involved (which should be done in any case)

> A quick test run with 2000 scsi_debug targets shows that btrfs dev scan
> can take 8 seconds, and that's with no actual I/O occurring. I don't
> think we want to specify the list of devices to scan on the mount
> command line, but perhaps an /etc config file that limits the scan to a
> list of devices (and defaults to all) similar to how mdadm.conf works
> would be a good improvement.

I tried in qemu-kvm:

# btrfs device scan                   # it took about 8sec

# modprobe scsi_debug num_tgts=2000   # 8 seconds were required
                                      # before all udev instances ended

But when I performed a blkid -c /dev/null (which should rebuild the
cache) it takes ages....
I have to investigate a bit...

> -Jeff

BR
G.Baroncelli
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
