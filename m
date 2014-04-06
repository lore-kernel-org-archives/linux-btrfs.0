Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaDFKxT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Apr 2014 06:53:19 -0400
Message-ID: <534131F0.7090806@oracle.com>
Date: Sun, 06 Apr 2014 18:52:32 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com,
        wangsl.fnst@cn.fujitsu.com
Subject: Re: [PATCH RFC v2] Btrfs: device_list_add() should not update list
 when mounted
References: <1396431813-24177-1-git-send-email-anand.jain@oracle.com> <1396432101-24276-1-git-send-email-anand.jain@oracle.com> <20140404133536.GT29256@twin.jikos.cz>
In-Reply-To: <20140404133536.GT29256@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the comments.
More inline below.


On 04/04/2014 21:35, David Sterba wrote:
> On Wed, Apr 02, 2014 at 05:48:21PM +0800, Anand Jain wrote:
>> Device list add shouldn't update the list when FS is mounted,
>> unless the whole loop w.r.t to bringing back the missing disk
>> is completed. (That is making it to be part of the group profile
>> and the code for this isn't there yet).
>>
>> As as of now (without this patch) when device is scanned with
>> missing disk, it would update in the device list but the disk
>> is left unused, it won't be opened by the btrfs and won't be
>> part of the btrfs group profile operation.
>>
>> reproducer 1:
>>   mkfs.btrfs -draid1 -mraid1 /dev/sdb /dev/sdc
>>   modprobe -r btrfs
>>   mount -o degraded /dev/sdb /btrfs
>>   btrfs dev scan /dev/sdc
>>
>>   use btrfs-devlist (or any of your method) to know that
>>   /dev/sdc isn't actually part of the above FS, (though now
>>   the missing disk path is updated in the btrfs_fs_devices)
>>   whats more btrfs kernel didn't open it all.
>
> Up to now, it works as expected. A device is permanently opened only via
> mount, 'dev scan' lets the kernel module know about the device, but does
> not keep it open.

  Yes. But we unset the missing flag and FS would continue to be mounted.

  (Reviewing the kernel memory for btrfs_fs_devices and the btrfs_device
  list, will help to understand whats going on inside the btrfs
  kernel).

  In this case as the above FS is already mounted when dev scan /dev/sdc
  is run, should dev scan also trigger to open the reappearing
  device ? as at this point the missing flag is unset.

  Note that when you run btrfs fi show -m here (or for that matter
  -d also) it would show to the end user that /dev/sdc is already
  a part of the FS.

  After you create ext4, btrfs fi show -m (now not -d) will still
  show /dev/sdc is part of btrfs, since /dev/sdc is in the
  btrfs_fs_device->btrfs_devices list kernel memory.


>>   And so mkfs.ext4 can be successfully be created on /dev/sdc,
>>   whereas it fails on /dev/sdb
>
> This should not matter, the device /dev/sdc is not opened, one could
> overwrite the block device without restrictions. Besides this passes
> because mkfs.ext4 does not check the device for existing filesystems.
> Try other mkfs':
>
> # mkfs.btrfs /dev/sda14
> /dev/sda14 appears to contain an existing filesystem (btrfs).
> Error: Use the -f option to force overwrite.
>
> # mkfs.xfs /dev/sda14
> mkfs.xfs: /dev/sda14 appears to contain an existing filesystem (btrfs).
> mkfs.xfs: Use the -f option to force overwrite.

   But the problem is /dev/sdc (in the above reproducer) is in the
   btrfs btrfs_fs_device and btrfs_devices kernel memory list,
   and so btrfs fi show -m would show /dev/sdc as well.
   btrfs-devlist is more simple to understand what going on with
   in kernel.

   Again. If _other_ FS claims the device, the btrfs fi show -m
   would continue to show the /dev/sdc and the worst is "missing"
   flag unset.

   pls use btrfs-devlist to have kernel's view.

>> reproducer 2:
>> disappear a disk then replace (RAID1) the disappeared disk
>> and then make the disappeared disk to reappear.
>>
>>   mkfs.btrfs -f -m raid1 -d raid1 /dev/sdc /dev/sdd
>>   mount /dev/sdc /btrfs
>>   dd if=/dev/zero of=/btrfs/tf1 count=1
>>   btrfs fi sync /btrfs
>>
>> devmgt[1] will help to attach or detach a disk easily
>>
>>   devmgt show
>>   devmgt detach /dev/sdc
>>
>> btrfs sill unaware of device missing (but thats not the point)
>
> Because it prints the device state cached in memory, there's no
> validation step, and no way as of now to tell btrfs the device is gone.

   Yep. device kobject looks a bit promising, but the notification
   are designed for the user land not for the kernel land.

   Any idea how do we get the notification in the kernel when
   the relevant driver knows that device has disappeared. ??

   Luns disappearing are a common scenario at the data center
   we need to harden the code against it.

>>   btrfs fi show -m
>> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
>>          Total devices 2 FS bytes used 32.00KiB
>>          devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <--
>>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
>>
>>   btrfs rep start -f 1 /dev/sde /btrfs
>> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
>>          Total devices 2 FS bytes used 32.00KiB
>>          devid    1 size 958.94MiB used 115.88MiB path /dev/sde
>>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
>>
>> so far good. now missing /dev/sdc comes-back.
>>
>>   devmgt attach host2
>>
>> btrfs fi show -m shows sdc
>> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120^M
>>          Total devices 2 FS bytes used 32.00KiB^M
>>          devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <- Wrong.
>>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
>>
>> this is wrong it should be sde.
>
> Agreed, this is a problem.

   Thanks. But Do you think that when we unset the missing flag
   in the kernel (of a _mounted_ btrfs FS), as in the reproducer1
   should we ensure it won't be usable by other FS ?

>> this happened because when
>> disk comes back device_list_add() is called which would invariably
>> replace the existing disk with the given disk with the same fsid/devid.
>> But the actual IO is still going to sde not to sdc.
>
> Yes, because it's the 'sde' device that has been open and used, so it's
> possible that 'btrfs fi show' wrongly identifies the device.

  Uh. nope. btrfs fi show -m show what is in the kernel's
  btrfs_fs_device. Which is right way.

  btrfs fi show -d adds its intelligence (wrong) would
  rebuild device list in the user land which does not
  match with the kernel. End User don't care what btrfs-progs
  thinks about the devices. But they want to know how
  the btrfs kernel is managing the disk group-profile.

  Please look at the kernel's in memory btrfs_fs_device
  and btrfs_device list using btrfs-devlist.


>> Further when we start fresh with (modprobe -r btrfs)
>> unless it is carefully managed using btrfs dev scan <dev>
>> it may pair with wrong disk (there will be a new patch
>> to fix this).
>
> IOW, there are more than one devices with the same fsid/id. The same as
> if we do 'dd'. This is a known problem, and you demonstrated another way
> how to get to it.

  its quite a possible scenario at the data center

> IIRC, theres' no way for the kernel module to know which of the devices
> with same fsid/id is the one desired to mount. The workaround is "don't
> do that".

  :-) Yes indeed. But I had a RFC which would also check transid and
  keeps the disk having higher transid.

  http://marc.info/?t=138902753300002&r=1&w=2

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
