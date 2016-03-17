Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44906 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbcCQGFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 02:05:08 -0400
Subject: Re: Mounting RAID1 degraded+rw only works once
To: Anand Jain <anand.jain@oracle.com>,
        Sebastian Ochmann <ochmann@informatik.uni-bonn.de>,
        <linux-btrfs@vger.kernel.org>
References: <56E9AAB9.6070408@informatik.uni-bonn.de>
 <56EA0F60.9020806@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56EA4907.4060904@cn.fujitsu.com>
Date: Thu, 17 Mar 2016 14:04:55 +0800
MIME-Version: 1.0
In-Reply-To: <56EA0F60.9020806@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2016/03/17 09:58 +0800:
>
>
>
>> In particular, I don't understand a
>> behavior I'm seeing which somehow takes part of the advantage away from
>> the idea of having a RAID for me.
>
>   Yep. Very true. I am trying fix them.
>
>   Generally, a storage/volume-manager need to match the Enterprise
>   storage data center requirements, and I do understand the reliability,
>   availability, serviceability (RAS) gaps in the current btrfs volume
>   manager.
>
>> The main issue I have is as follows. I can mount a RAID1 with missing
>> devices using the "degraded" option. So far so good. I know I should add
>> another device at that point, but let's say I don't have a device ready
>> but need to keep my system running. The problem is that once I write
>> some data to the device and unmount it, I cannot mount it degraded+rw
>> again but only degraded+ro.
>
>   A known issue and a critical (in the enterprise storage standard) bug.
>   There is a patch set to fix.
>      'btrfs: Hot spare and Auto replace'
>   I hoped it got reviewed/merged sooner.

IHMO, splitting them into per-chunk-degraded-mount and 
hot-spare-auto-replace part will make things much easier to get merged.

Thanks,
Qu

>
>   As I am getting couple of other private request for the hot spare
>   patch set, also of latest I see there are some critical changes in
>   the replace part of the code, looks like its time to revive them.
>   Thanks for asking. I shall find some time in the early next week
>   for this.
>
>> And at that point I can't make changes such
>> as adding new devices and rebalancing as far as I see, rendering the
>> degraded RAID useless for me for keeping the system running.
>>
>> Example:
>>
>> - Create RAID1 (data+metadata) with 2 devices
>>
>> - mount the filesystem
>>
>> - btrfs fi df /something:
>>
>> Data, RAID1: total=112.00MiB, used=40.76MiB
>> System, RAID1: total=8.00MiB, used=16.00KiB
>> Metadata, RAID1: total=32.00MiB, used=768.00KiB
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>> - unmount
>>
>> - Destroy one of the devices (dd over it or whatever)
>>
>> - mount with "-o degraded"
>>
>> - Write some data to the device (not sure if this is strictly necessary).
>>
>> - unmount the filesystem
>>
>> - Try to mount with "-o degraded" again. It doesn't allow you to do so
>> (if it does, try to unmount and mount again, sometimes it needs two
>> tries). dmesg says "missing devices(1) exceeds the limit(0), writable
>> mount is not allowed"
>>
>> - mounting with "-o degraded,ro" works.
>>
>> - btrfs fi df [dev]:
>>
>> Data, RAID1: total=112.00MiB, used=40.76MiB
>> System, RAID1: total=8.00MiB, used=16.00KiB
>> System, single: total=8.00MiB, used=0.00B
>> Metadata, RAID1: total=32.00MiB, used=768.00KiB
>> Metadata, single: total=28.00MiB, used=80.00KiB
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>> Now there is some RAID1 and some single data. Which could make sense
>> since writing to the device in degraded mode could only be done on the
>> single device. Still, I cannot make changes to the filesystem now and
>> can "only" recover the data from it, but that's not really the idea of a
>> RAID1 in my opinion.
>>
>> Any advice?
>
>    Fix is in the hot-spare patch set. And it should mount RW with that.
>
>    Any test results will help.
>
> Thanks, Anand
>
>> Versions:
>> - Kernel 4.4.5-1-ARCH
>> - btrfs-progs 4.4.1
>>
>> Best regards
>> Sebastian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


