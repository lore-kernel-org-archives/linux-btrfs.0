From: "Roland" <devzero@web.de>
Subject: Re: multiple device usage
Date: Mon, 29 Dec 2008 13:31:18 +0100
Message-ID: <006a01c969b1$5954fe40$6602a8c0@bui.materna.com>
References: <556243856@web.de> <49559672.7060204@gmail.com> <000c01c9682d$16b30da0$6602a8c0@bui.materna.com> <977a2be20812280526y10eb4646i18cdc17c3af072f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Cc: "Yan Zheng" <ukernel@gmail.com>, <linux-btrfs@vger.kernel.org>
To: "yanhai zhu" <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>> so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk 
>> ,
>> replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk 
>> and
>                                                 ~~~~~~~~~~~~~~~~~~~~~~~
>                                                This step will fail, you 
> will
> get a "/dev/sdb is mounted" by mkfs.btrfs, but for other slots it's ok.

isn`t this sort of a design issue then?
no way to work around this ?

i think online data migration and disk replacement is a killer feature of 
btrfs
(even zfs doesn`t have this!), but  if you always have one out of X disks 
which
can`t be used for this, then it`s of no real value, imho.

regards
roland


>
>> then re-add - all while mount telling me, that /dev/sdb is still in use 
>> !?
>
> 2008/12/27 Roland <devzero@web.de>:
>>>> i have some difficulty in understanding multi-device handling in depth.
>>>>
>>>> as
>>>> http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>>>> tells,
>>>>
>>>> btrfs can span over multiple devices at the same time. (great feature,
>>>> btw !)
>>>>
>>>> ok then:
>>>>
>>>> mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs
>>>> spanning
>>>> over /dev/sdb and sdc
>>>>
>>>> mount /dev/sdb /btrfs - mounts it
>>>>
>>>> btrfs-vol -b /btrfs - does a rebalancing of all data and metadata
>>>>
>>>> btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes 
>>>> any
>>>> extends in use on sdc to sdb (killer feature!!!)
>>>>
>>>> but what if i want to remove /dev/sdb ? (as that one is in use for the
>>>> mount)
>>>>
>>>
>>> Devices in btrfs are equal, so you can do this. The only glitch is
>>> /proc/mounts and mount(8) get confused.
>>
>> so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk 
>> ,
>> replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk 
>> and
>> then re-add - all while mount telling me, that /dev/sdb is still in use 
>> !?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> -- 
> Regards,
> Zhu Yanhai 

