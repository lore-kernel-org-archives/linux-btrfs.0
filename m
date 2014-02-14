Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:40517 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNPGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 10:06:46 -0500
Received: by mail-yk0-f171.google.com with SMTP id q9so23481116ykb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 07:06:45 -0800 (PST)
Message-ID: <52FE2F14.4040707@gmail.com>
Date: Fri, 14 Feb 2014 06:58:28 -0800
From: Daniel Lee <longinus00@gmail.com>
MIME-Version: 1.0
To: Axelle <aafortinet@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Recovering from hard disk failure in a pool
References: <CANKzOHBR6oYRrfDKtS-qh3JZ_LZTmUFwDtaAb7+N+A4MOTe-cg@mail.gmail.com>	<20140214105817.GA6490@carfax.org.uk> <CANKzOHCaBDuVxu7=VvshzdkwttGNS9D6rNqNmvJNNM1qsAXcyA@mail.gmail.com>
In-Reply-To: <CANKzOHCaBDuVxu7=VvshzdkwttGNS9D6rNqNmvJNNM1qsAXcyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/14/2014 03:04 AM, Axelle wrote:
> Hi Hugo,
>
> Thanks for your answer.
> Unfortunately, I had also tried
>
> sudo mount -o degraded /dev/sdc1 /samples
> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> and dmesg says:
> [ 1177.695773] btrfs: open_ctree failed
> [ 1247.448766] device fsid 545e95c6-d347-4a8c-8a49-38b9f9cb9add devid
> 2 transid 31105 /dev/sdc1
> [ 1247.449700] device fsid 545e95c6-d347-4a8c-8a49-38b9f9cb9add devid
> 1 transid 31105 /dev/sdc6
> [ 1247.458794] device fsid 545e95c6-d347-4a8c-8a49-38b9f9cb9add devid
> 2 transid 31105 /dev/sdc1
> [ 1247.459601] device fsid 545e95c6-d347-4a8c-8a49-38b9f9cb9add devid
> 1 transid 31105 /dev/sdc6
> [ 4013.363254] device fsid 545e95c6-d347-4a8c-8a49-38b9f9cb9add devid
> 2 transid 31105 /dev/sdc1
> [ 4013.408280] btrfs: allowing degraded mounts
> [ 4013.555764] btrfs: bdev (null) errs: wr 0, rd 14, flush 0, corrupt 0, gen 0
> [ 4015.600424] Btrfs: too many missing devices, writeable mount is not allowed
> [ 4015.630841] btrfs: open_ctree failed
Did the crashed /dev/sdb have more than 1 partitions in your raid1
filesystem?
>
> Yes, I know, I'll probably be losing a lot of data, but it's not "too
> much" my concern because I had a backup (sooo happy about that :D). If
> I can manage to recover a little more on the btrfs volume it's bonus,
> but in the event I do not, I'll be using my backup.
>
> So, how do I fix my volume? I guess there would be a solution apart
> from scratching/deleting everything and starting again...
>
>
> Regards,
> Axelle
>
>
>
> On Fri, Feb 14, 2014 at 11:58 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Fri, Feb 14, 2014 at 11:35:56AM +0100, Axelle wrote:
>>> Hi,
>>> I've just encountered a hard disk crash in one of my btrfs pools.
>>>
>>> sudo btrfs filesystem show
>>> failed to open /dev/sr0: No medium found
>>> Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
>>>         Total devices 3 FS bytes used 112.70GB
>>>         devid    1 size 100.61GB used 89.26GB path /dev/sdc6
>>>         devid    2 size 93.13GB used 84.00GB path /dev/sdc1
>>>         *** Some devices missing
>>>
>>> The device which is missing is /dev/sdb. I have replaced it with a new
>>> hard disk. How do I add it back to the volume and fix the device
>>> missing?
>>> The pool is expected to mount to /samples (it is not mounted yet).
>>>
>>> I tried this - which fails:
>>> sudo btrfs device add /dev/sdb /samples
>>> ERROR: error adding the device '/dev/sdb' - Inappropriate ioctl for device
>>>
>>> Why isn't this working?
>>    Because it's not mounted. :)
>>
>>> I also tried this:
>>> sudo mount -o recovery /dev/sdc1 /samples
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>>>        missing codepage or helper program, or other error
>>>        In some cases useful info is found in syslog - try
>>>        dmesg | tail  or so
>>> same with /dev/sdc6
>>    Close, but what you want here is:
>>
>> mount -o degraded /dev/sdc1 /samples
>>
>> not "recovery". That will tell the FS that there's a missing disk, and
>> it should mount without complaining. If your data is not RAID-1 or
>> RAID-10, then you will almost certainly have lost some data.
>>
>>    At that point, since you've removed the dead disk, you can do:
>>
>> btrfs device delete missing /samples
>>
>> which forcibly removes the record of the missing device.
>>
>>    Then you can add the new device:
>>
>> btrfs device add /dev/sdb /samples
>>
>>    And finally balance to repair the RAID:
>>
>> btrfs balance start /samples
>>
>>    It's worth noting that even if you have RAID-1 data and metadata,
>> losing /dev/sdc in your current configuration is likely to cause
>> severe data loss -- probably making the whole FS unrecoverable. This
>> is because the FS sees /dev/sdc1 and /dev/sdc6 as independent devices,
>> and will happily put both copies of a piece of RAID-1 data (or
>> metadata) on /dev/sdc -- one on each of sdc1 and sdc6. I therefore
>> wouldn't recommend running like that for very long.
>>
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>            --- All hope abandon,  Ye who press Enter here. ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

