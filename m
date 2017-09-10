Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38709 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdIJJRu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 05:17:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id x17so4588303wmd.5
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 02:17:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BB503B0C-5A1A-4ADE-9EDA-B07D9C6DA138@rqc.ru>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru> <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
 <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com> <BB503B0C-5A1A-4ADE-9EDA-B07D9C6DA138@rqc.ru>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sun, 10 Sep 2017 11:17:27 +0200
Message-ID: <CAA7pwKPVsbSiM_oBKF4-xYmenbwWpKJWn1-0h=hJiPvQH5EQFA@mail.gmail.com>
Subject: Re: Please help with exact actions for raid1 hot-swap
To: Marat Khalili <mkh@rqc.ru>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 September 2017 at 08:33, Marat Khalili <mkh@rqc.ru> wrote:
> It doesn't need replaced disk to be readable, right?

Only enough to be mountable, which it already is, so your read errors
on /dev/sdb isn't a problem.

> Then what prevents same procedure to work without a spare bay?

It is basically the same procedure but with a bunch of gotchas due to
bugs and odd behaviour. Only having one shot at it, before it can only
be mounted read-only, is especially problematic (will be fixed in
Linux 4.14).


> --
>
> With Best Regards,
> Marat Khalili
>
> On September 9, 2017 1:29:08 PM GMT+03:00, Patrik Lundquist <patrik.lundquist@gmail.com> wrote:
>>On 9 September 2017 at 12:05, Marat Khalili <mkh@rqc.ru> wrote:
>>> Forgot to add, I've got a spare empty bay if it can be useful here.
>>
>>That makes it much easier since you don't have to mount it degraded,
>>with the risks involved.
>>
>>Add and partition the disk.
>>
>># btrfs replace start /dev/sdb7 /dev/sdc(?)7 /mnt/data
>>
>>Remove the old disk when it is done.
>>
>>> --
>>>
>>> With Best Regards,
>>> Marat Khalili
>>>
>>> On September 9, 2017 10:46:10 AM GMT+03:00, Marat Khalili
>><mkh@rqc.ru> wrote:
>>>>Dear list,
>>>>
>>>>I'm going to replace one hard drive (partition actually) of a btrfs
>>>>raid1. Can you please spell exactly what I need to do in order to get
>>>>my
>>>>filesystem working as RAID1 again after replacement, exactly as it
>>was
>>>>before? I saw some bad examples of drive replacement in this list so
>>I
>>>>afraid to just follow random instructions on wiki, and putting this
>>>>system out of action even temporarily would be very inconvenient.
>>>>
>>>>For this filesystem:
>>>>
>>>>> $ sudo btrfs fi show /dev/sdb7
>>>>> Label: 'data'  uuid: 37d3313a-e2ad-4b7f-98fc-a01d815952e0
>>>>>     Total devices 2 FS bytes used 106.23GiB
>>>>>     devid    1 size 2.71TiB used 126.01GiB path /dev/sda7
>>>>>     devid    2 size 2.71TiB used 126.01GiB path /dev/sdb7
>>>>> $ grep /mnt/data /proc/mounts
>>>>> /dev/sda7 /mnt/data btrfs
>>>>> rw,noatime,space_cache,autodefrag,subvolid=5,subvol=/ 0 0
>>>>> $ sudo btrfs fi df /mnt/data
>>>>> Data, RAID1: total=123.00GiB, used=104.57GiB
>>>>> System, RAID1: total=8.00MiB, used=48.00KiB
>>>>> Metadata, RAID1: total=3.00GiB, used=1.67GiB
>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>> $ uname -a
>>>>> Linux host 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC
>>>>> 2017 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>>I've got this in dmesg:
>>>>
>>>>> [Sep 8 20:31] ata6.00: exception Emask 0x0 SAct 0x7ecaa5ef SErr 0x0
>>>>> action 0x0
>>>>> [  +0.000051] ata6.00: irq_stat 0x40000008
>>>>> [  +0.000029] ata6.00: failed command: READ FPDMA QUEUED
>>>>> [  +0.000038] ata6.00: cmd 60/70:18:50:6c:f3/00:00:79:00:00/40 tag
>>3
>>>>> ncq 57344 in
>>>>>                        res 41/40:00:68:6c:f3/00:00:79:00:00/40
>>Emask
>>>>> 0x409 (media error) <F>
>>>>> [  +0.000094] ata6.00: status: { DRDY ERR }
>>>>> [  +0.000026] ata6.00: error: { UNC }
>>>>> [  +0.001195] ata6.00: configured for UDMA/133
>>>>> [  +0.000030] sd 6:0:0:0: [sdb] tag#3 FAILED Result:
>>hostbyte=DID_OK
>>>>> driverbyte=DRIVER_SENSE
>>>>> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 Sense Key : Medium Error
>>>>> [current] [descriptor]
>>>>> [  +0.000004] sd 6:0:0:0: [sdb] tag#3 Add. Sense: Unrecovered read
>>>>> error - auto reallocate failed
>>>>> [  +0.000005] sd 6:0:0:0: [sdb] tag#3 CDB: Read(16) 88 00 00 00 00
>>00
>>>>
>>>>> 79 f3 6c 50 00 00 00 70 00 00
>>>>> [  +0.000003] blk_update_request: I/O error, dev sdb, sector
>>>>2045996136
>>>>> [  +0.000047] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0,
>>>>rd
>>>>> 1, flush 0, corrupt 0, gen 0
>>>>> [  +0.000062] BTRFS error (device sda7): bdev /dev/sdb7 errs: wr 0,
>>>>rd
>>>>> 2, flush 0, corrupt 0, gen 0
>>>>> [  +0.000077] ata6: EH complete
>>>>
>>>>There's still 1 in Current_Pending_Sector line of smartctl output as
>>of
>>>>
>>>>now, so it probably won't heal by itself.
>>>>
>>>>--
>>>>
>>>>With Best Regards,
>>>>Marat Khalili
>>>>--
>>>>To unsubscribe from this list: send the line "unsubscribe
>>linux-btrfs"
>>>>in
>>>>the body of a message to majordomo@vger.kernel.org
>>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
