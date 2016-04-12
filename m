Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34439 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370AbcDLSJp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 14:09:45 -0400
Received: by mail-lf0-f52.google.com with SMTP id j11so36679449lfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 11:09:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570D19D9.8030702@googlemail.com>
References: <570CCCFB.5000104@googlemail.com>
	<570D19D9.8030702@googlemail.com>
Date: Tue, 12 Apr 2016 20:09:42 +0200
Message-ID: <CAPmG0jbOTFvQ83Qrf=ut5YiGUBtkhGMDr1nQdicB+MsVbwE2Qg@mail.gmail.com>
Subject: Re: enospace regression in 4.4
From: Henk Slager <eye1tm@gmail.com>
To: Julian Taylor <jtaylor.debian@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 5:52 PM, Julian Taylor
<jtaylor.debian@googlemail.com> wrote:
> smaller testcase that shows the immediate enospc after fallocate -> rm,
> though I don't know if it is really related to the full filesystem
> bugging out as the balance does work if you wait a few seconds after the
> balance.
> But this sequence of commands did work in 4.2.
>
>  $ sudo btrfs fi show /dev/mapper/lvm-testing
> Label: none  uuid: 25889ba9-a957-415a-83b0-e34a62cb3212
>         Total devices 1 FS bytes used 225.18MiB
>         devid    1 size 5.00GiB used 788.00MiB path /dev/mapper/lvm-testing
>
>  $ fallocate -l 4.4G test.dat
>  $ rm -f test.dat
>  $ sudo btrfs fi balance start -dusage=0 .
> ERROR: error during balancing '.': No space left on device
> There may be more info in syslog - try dmesg | tail

It seems that kernel 4.4.6 waits longer with de-allocating empty
chunks and the balance kicks in at a time when the 5 GiB is still
completely filled with chunks. As balance needs uncallocated space (on
device level, how much depends on profiles), this error can be
expected.

> On 04/12/2016 12:24 PM, Julian Taylor wrote:
>> hi,
>> I have a system with two filesystems which are both affected by the
>> notorious enospace bug when there is plenty of unallocated space
>> available. The system is a raid0 on two 900 GiB disks and an iscsi
>> single/dup 1.4TiB.
>> To deal with the problem I use a cronjob that uses fallocate to give me
>> an advance notice on the issue so I can apply the only workaround that
>> works for me, which is shrink the fs to the minimum and grow it again.
>> This has worked fine for a couple of month.
>>
>> I now updated from 4.2 to 4.4.6 and it appears my cronjob actually
>> triggers an immediate enospc in the balance after removing the
>> fallocated file and the shrink/resize workaround does not work anymore.

The filesystem itself is not resized AFAIU, correct?

>> it is mounted with enospc_debug but that just says "2 enospc in
>> balance". Nothing else useful in the log.
>>
>> I had to revert back to 4.2 to get the system running again so it is
>> currently not available for more testing, but I may be able to do more
>> tests if required in future.
>>
>> The cronjob does this once a day:
>>
>> #!/bin/bash
>> sync
>>
>> check() {
>>   date
>>   mnt=$1
>>   time btrfs fi balance start -mlimit=2 $mnt
>>   btrfs fi balance start -dusage=5 $mnt
>>   sync
>>   freespace=$(df -B1 $mnt | tail -n 1 | awk '{print $4 -
>> 50*1024*1024*1024}')
>>   fallocate -l $freespace $mnt/falloc
>>   /usr/sbin/filefrag $mnt/falloc
>>   rm -f $mnt/falloc
>>   btrfs fi balance start -dusage=0 $mnt

See comment for smaller test; Maybe you could put a delay of larger
than the commit time before this balance. To give the kernel itself
the possibility to cleanup empty chunks.

>>   time btrfs fi balance start -mlimit=2 $mnt
>>   time btrfs fi balance start -dlimit=10 $mnt
>>   date
>> }
>>
>> check /data
>> check /data/nas

It could be that now with kernel 4.4.6 or newer, the original enospc
(so not the ones due to balances) does not popup anymore. That would
mean the cronjob workaround itself creates a problem now. Can you give
some background on what other (types of) enospc occurred in the past
and was this with 4.2 kernel ? or older?

You could shrink a file-system by a few GiB's (without changing the
size of the underlying device), so that once it really gets filled up
and hits enospc, you resize to max again and delete files or snapshot
or something. Of course no option for a 24/7 unattended system, but
maybe for a client laptop as testing.

>> btrfs info:
>>
>>
>>  ~ $ btrfs --version
>> btrfs-progs v4.4
>> sagan5 ~ $ sudo btrfs fi show
>> Label: none  uuid: e4aef349-7a56-4287-93b1-79233e016aae
>>       Total devices 2 FS bytes used 898.18GiB
>>       devid    1 size 880.00GiB used 473.03GiB path /dev/mapper/data-linear1
>>       devid    2 size 880.00GiB used 473.03GiB path /dev/mapper/data-linear2
>>
>> Label: none  uuid: 14040f9b-53c8-46cf-be6b-35de746c3153
>>       Total devices 1 FS bytes used 557.19GiB
>>       devid    1 size 1.36TiB used 585.95GiB path /dev/sdd
>>
>>  ~ $ sudo btrfs fi df /data
>> Data, RAID0: total=938.00GiB, used=895.09GiB
>> System, RAID1: total=32.00MiB, used=112.00KiB
>> Metadata, RAID1: total=4.00GiB, used=3.10GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> sagan5 ~ $ sudo btrfs fi usage /data
>> Overall:
>>     Device size:                 1.72TiB
>>     Device allocated:          946.06GiB
>>     Device unallocated:                813.94GiB
>>     Device missing:                0.00B
>>     Used:                      901.27GiB
>>     Free (estimated):          856.85GiB      (min: 449.88GiB)
>>     Data ratio:                             1.00
>>     Metadata ratio:                 2.00
>>     Global reserve:            512.00MiB      (used: 0.00B)
>>
>> Data,RAID0: Size:938.00GiB, Used:895.09GiB
>>    /dev/dm-1   469.00GiB
>>    /dev/mapper/data-linear1    469.00GiB
>>
>> Metadata,RAID1: Size:4.00GiB, Used:3.09GiB
>>    /dev/dm-1     4.00GiB
>>    /dev/mapper/data-linear1      4.00GiB
>>
>> System,RAID1: Size:32.00MiB, Used:112.00KiB
>>    /dev/dm-1    32.00MiB
>>    /dev/mapper/data-linear1     32.00MiB
>>
>> Unallocated:
>>    /dev/dm-1   406.97GiB
>>    /dev/mapper/data-linear1    406.97GiB
