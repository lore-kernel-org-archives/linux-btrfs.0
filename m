Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59725 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935337AbeF2BLE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 21:11:04 -0400
Subject: Re: call trace: WARNING: at
 /build/linux-uwVqDp/linux-4.16.16/fs/btrfs/ctree.h:1565 btrfs_update_device
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
References: <50443c666dc4509d74f9f23d7012080845a20940.camel@scientia.net>
 <f9d51250-28aa-318e-502f-c5b3526969a0@gmx.com>
 <f86948875cb746c6a8c74526913017052153d1bf.camel@scientia.net>
 <43a3fb8f-d8a8-7e2f-a143-207bd3ba8c74@gmx.com>
 <236b95bb46abce6e40040765b24199169541a1d2.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <530a3014-52a2-0e82-425c-7648abd86ac6@gmx.com>
Date: Fri, 29 Jun 2018 09:10:49 +0800
MIME-Version: 1.0
In-Reply-To: <236b95bb46abce6e40040765b24199169541a1d2.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月29日 09:05, Christoph Anton Mitterer wrote:
> Hey Qu and Nikolay.
> 
> 
> On Thu, 2018-06-28 at 22:58 +0800, Qu Wenruo wrote:
>> Nothing special. Btrfs-progs will handle it pretty well.
> Since this a remote system where the ISP provides only a rescue image
> with pretty old kernel/btrfs-progs, I had to copy a current local
> binary and use that... but that seemed to have worked quite well

Glad that works.

Just forgot to mention, if it's only device size unalignment while the
super block total_bytes is still accurate, you could just modify it
on-line, using "btrfs fi resize"
Just like
# btrfs fi resize 1:-4K <mnt>

Then it should fix device size unalignment.

> 
>> Because the WARN_ON() is newly added.
> Ah I see.
> 
>> Yep, latest will warn about it, and --repair can also fix it too.
> Great.
> 
> 
> On Thu, 2018-06-28 at 17:25 +0300, Nikolay Borisov wrote:
>> Was this an old FS or a fresh one?
> You mean in terms of original fs creation? Probably rather oldish.. I'd
> guess at least a year or maybe even 2-3 or more.
> 
>> Looking at the callstack this
>> seems
>> to have occured due to "btrfs_set_device_total_bytes(leaf, dev_item,
>> btrfs_device_get_disk_total_bytes(device));" call. Meaning the total
>> bytes of the disk were unalgined. Perhaps this has been like that for
>> quite some time, then you did a couple of kernel upgrades (this
>> WARN_ON
>> was added later than 4.11) and just now you happened to delete a
>> chunk
>> which would trigger a device update on-disk ?
> Could be...
> 
> 
> The following was however still a bit strange:
> sda2 and sdb2 are the partitions on the two HDDs forming the RAID1.
> 
> 
> root@rescue ~ # ./btrfs rescue fix-device-size /dev/sda2
> Fixed device size for devid 2, old size: 999131127296 new size: 999131123712
> Fixed super total bytes, old size: 1998262251008 new size: 1998262247424
> Fixed unaligned/mismatched total_bytes for super block and device items
> root@rescue ~ # ./btrfs rescue fix-device-size /dev/sdb2
> No device size related problem found
> 
> As you can see, no alignment issues were found on sdb2.
> 
> I've created these at the same time...
> I don't think (but cannot exclude for 100%) that this server ever lost
> a disk (in that case I could image that newer progs/kernel might have
> created sdb2 with proper alignment)
> 
> Looking at the partitions:
> 
> root@rescue ~ # gdisk -l /dev/sda
> GPT fdisk (gdisk) version 1.0.1
> 
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: present
> 
> Found valid GPT with protective MBR; using GPT.
> Disk /dev/sda: 1953525168 sectors, 931.5 GiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 1953525134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048         2097151   1023.0 MiB  EF02  BIOS boot partition
>    2         2097152      1953525134   930.5 GiB   8300  Linux filesystem
> root@rescue ~ # gdisk -l /dev/sdb
> GPT fdisk (gdisk) version 1.0.1
> 
> Partition table scan:
>   MBR: protective
>   BSD: not present
>   APM: not present
>   GPT: present
> 
> Found valid GPT with protective MBR; using GPT.
> Disk /dev/sdb: 1953525168 sectors, 931.5 GiB
> Logical sector size: 512 bytes
> Disk identifier (GUID): 
> Partition table holds up to 128 entries
> First usable sector is 34, last usable sector is 1953525134
> Partitions will be aligned on 2048-sector boundaries
> Total free space is 2014 sectors (1007.0 KiB)
> 
> Number  Start (sector)    End (sector)  Size       Code  Name
>    1            2048         2097151   1023.0 MiB  EF02  BIOS boot partition
>    2         2097152      1953525134   930.5 GiB   8300  Linux filesystem
> 
> 
> Both the same... so if there was no device replace or so... then I
> wonder why only one device was affected.

Maybe it's the old mkfs causing the problem?
Although mkfs.btrfs added device size alignment much earlier than
kernel, it's still possible that the old mkfs doesn't handle the initial
device and extra device (mkfs.btrfs will always create a temporary fs on
the first device, then add all the other devices to the system) the same
way.

Thanks,
Qu

> 
> 
> Cheers,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
