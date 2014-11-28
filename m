Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:35570 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbaK1RFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 12:05:51 -0500
Message-ID: <5478AB6C.7030809@inwind.it>
Date: Fri, 28 Nov 2014 18:05:48 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org> <5474FBD9.5070709@inwind.it> <20141125222126.GQ17380@hungrycats.org> <54760B89.3050604@inwind.it> <20141127041510.GV17380@hungrycats.org>
In-Reply-To: <20141127041510.GV17380@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/2014 05:15 AM, Zygo Blaxell wrote:
> On Wed, Nov 26, 2014 at 06:19:05PM +0100, Goffredo Baroncelli wrote:
>> On 11/25/2014 11:21 PM, Zygo Blaxell wrote:
>>>>> However I still doesn't understood why you want btrfs-w/multiple disk over LVM ?
>>> I want to split a few disks into partitions, but I want to create,
>>> move, and resize the partitions from time to time.  Only LVM can do
>>> that without taking the machine down, reducing RAID integrity levels,
>>> hotplugging drives, or leaving installed drives idle most of the time.
>>>
>>> I want btrfs-raid1 because of its ability to replace corrupted or lost
>>> data from one disk using the other.  If I run a single-volume btrfs
>>> on LVM-RAID1 (or dm-RAID1, or RAID1 at any other layer of the storage
>>> stack), I can detect lost data, but not replace it automatically from
>>> the other mirror.
>> OK, now I have understood.
>>
>> Anyway as workaround, take in account that you can pass explicitly the
>> devices as:
>>
>> mount -o device=/dev/sda,device=/dev/sdb,device=/dev/sdc /dev/sdd /mnt
>>
>> (supposing that the filesystem is on /dev/sda.../dev/sdd)
>>
>> I am working to a mount.btrfs helper. The aim of this helper is to manage
>> the assembling of multiple devices; the main points will be:
>> - wait until all the devices appeared
> 
> ...and make sure there are no duplicate UUIDs.
Yes, at the end I implemented in this way the "snapshot" detection:
if two autodetected devices have the same DISK_UUID (reported as 
SUB_UUID by blkid), th emount process stopped. I checked also the 
num_device field of the superblock.

> 
>> - allow (if required) to mount in degraded mode after a timeout
> 
> This is a terrible idea with current btrfs, at least for read-write
> degraded mounting (fallback to read-only degraded would be OK).
> Mounting a filesystem read-write and degraded is something you only want
> to do immediately before you replace all the missing disks and bring the
> filesystem up to a non-degraded space and after you've ensured that the
> missing disks can never, ever come back; otherwise, btrfs eats your data
> in a slightly different way than we have discussed so far...

I don't care. If the user pass "degraded" in the options of mount, 
he have it. Anyway this (wrong) btrfs behavior I hope that it will be
solved.
> 
>> - at this point it could/should also skip the lvm-snapshotted devices (but before 
>> I have to know how recognize these) 
> 
> You don't have to recognize them as snapshots (and it's probably better
> not to treat snapshots specially anyway--how do you know whether the
> snapshot or the origin LVs are wanted for mounting?).  You just have to
> detect duplicate UUIDs at the btrfs subdevice level, and if any are found,
> stop immediately (or get a hint from the admin).

For the disk autodetection, I still convinced that it is a "sane" default
to skip the lvm-snapshot

> 
> This is a weakness of the current udev and asynchronous device hotplug
> concept:  there is no notion of bus enumeration in progress, so we can be
> trying to assemble multi-device storage before we have all the devices
> visible.  Assembly of aggregate storage (whatever it is--btrfs, md,
> lvm2...) has to wait until all known storage buses are fully enumerated
> in order to detect if there are duplicates.

It is more complex than that. Some devices may appear after the "1st" bus
enumeration.


> 
>> I hope to issue the patches in the next week
>>
>> BR
>> G.Baroncelli
>>
>> -- 
>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
