From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: Re: multiple device usage
Date: Sun, 28 Dec 2008 21:26:11 +0800
Message-ID: <977a2be20812280526y10eb4646i18cdc17c3af072f3@mail.gmail.com>
References: <556243856@web.de> <49559672.7060204@gmail.com>
	 <000c01c9682d$16b30da0$6602a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Yan Zheng" <ukernel@gmail.com>, linux-btrfs@vger.kernel.org
To: Roland <devzero@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <000c01c9682d$16b30da0$6602a8c0@bui.materna.com>
List-ID: <linux-btrfs.vger.kernel.org>

> so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk ,
> replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk and
                                                 ~~~~~~~~~~~~~~~~~~~~~~~
                                                This step will fail, you will
get a "/dev/sdb is mounted" by mkfs.btrfs, but for other slots it's ok.

> then re-add - all while mount telling me, that /dev/sdb is still in use !?

2008/12/27 Roland <devzero@web.de>:
>>> i have some difficulty in understanding multi-device handling in depth.
>>>
>>> as
>>> http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>>> tells,
>>>
>>> btrfs can span over multiple devices at the same time. (great feature,
>>> btw !)
>>>
>>> ok then:
>>>
>>> mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs
>>> spanning
>>> over /dev/sdb and sdc
>>>
>>> mount /dev/sdb /btrfs - mounts it
>>>
>>> btrfs-vol -b /btrfs - does a rebalancing of all data and metadata
>>>
>>> btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes any
>>> extends in use on sdc to sdb (killer feature!!!)
>>>
>>> but what if i want to remove /dev/sdb ? (as that one is in use for the
>>> mount)
>>>
>>
>> Devices in btrfs are equal, so you can do this. The only glitch is
>> /proc/mounts and mount(8) get confused.
>
> so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk ,
> replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk and
> then re-add - all while mount telling me, that /dev/sdb is still in use !?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Zhu Yanhai
