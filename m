From: "Roland" <devzero@web.de>
Subject: Re: multiple device usage
Date: Sat, 27 Dec 2008 15:12:01 +0100
Message-ID: <000c01c9682d$16b30da0$6602a8c0@bui.materna.com>
References: <556243856@web.de> <49559672.7060204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Cc: <linux-btrfs@vger.kernel.org>
To: "Yan Zheng" <ukernel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>> i have some difficulty in understanding multi-device handling in depth.
>>
>> as 
>> http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
>> tells,
>>
>> btrfs can span over multiple devices at the same time. (great feature, 
>> btw !)
>>
>> ok then:
>>
>> mkfs.btrfs -m single -d single  /dev/sdb /dev/sdc - creates a btrfs 
>> spanning
>> over /dev/sdb and sdc
>>
>> mount /dev/sdb /btrfs - mounts it
>>
>> btrfs-vol -b /btrfs - does a rebalancing of all data and metadata
>>
>> btrfs-vol -r /dev/sdc - removes one of the volumes and redistributes any
>> extends in use on sdc to sdb (killer feature!!!)
>>
>> but what if i want to remove /dev/sdb ? (as that one is in use for the
>> mount)
>>
>
> Devices in btrfs are equal, so you can do this. The only glitch is
> /proc/mounts and mount(8) get confused.

so i can do btrfs-vol -r /dev/sdb while it`s being mounted, pull the disk , 
replace it with a bigger one, rescan-scsi-bus, mkfs.btrfs the new disk and 
then re-add - all while mount telling me, that /dev/sdb is still in use !? 

