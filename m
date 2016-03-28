Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35865 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbcC1Klh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 06:41:37 -0400
Received: by mail-lf0-f53.google.com with SMTP id e133so32797762lfe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 03:41:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F8AAE7.5020201@oracle.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
 <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
 <CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
 <1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
 <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
 <CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
 <56F5FD42.5010701@oracle.com> <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
 <56F8AAE7.5020201@oracle.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Mon, 28 Mar 2016 12:41:16 +0200
Message-ID: <CAA7pwKMPWJkVjBSMudQvyVEr8dkyyh1Ev0gGG7RMQ0TEvddLCg@mail.gmail.com>
Subject: Re: Possible Raid Bug
To: Anand Jain <anand.jain@oracle.com>
Cc: Stephen Williams <stephenw@veryfast.biz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28 March 2016 at 05:54, Anand Jain <anand.jain@oracle.com> wrote:
>
> On 03/26/2016 07:51 PM, Patrik Lundquist wrote:
>>
>> # btrfs device stats /mnt
>>
>> [/dev/sde].write_io_errs   11
>> [/dev/sde].read_io_errs    0
>> [/dev/sde].flush_io_errs   2
>> [/dev/sde].corruption_errs 0
>> [/dev/sde].generation_errs 0
>>
>> The old counters are back. That's good, but wtf?
>
>
>  No. I doubt if they are old counters. The steps above didn't
>  show old error counts, but since you have created a file
>  test3 so there will be some write_io_errors, which we don;t
>  see after the balance. So I doubt if they are old counter
>  but instead they are new flush errors.

No, /mnt/test3 doesn't generate errors, only 'single' block groups.
The old counters seem to be cached somewhere and replace doesn't reset
them everywhere.

One more time with more device stats and I've upgraded the kernel to
Linux debian 4.5.0-trunk-amd64 #1 SMP Debian 4.5-1~exp1 (2016-03-20)
x86_64 GNU/Linux

# mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde

# mount /dev/sdb /mnt; dmesg | tail
# touch /mnt/test1; sync; btrfs device usage /mnt

Only raid10 profiles.

# echo 1 >/sys/block/sde/device/delete; dmesg | tail

[  426.831037] sd 5:0:0:0: [sde] Synchronizing SCSI cache
[  426.831517] sd 5:0:0:0: [sde] Stopping disk
[  426.845199] ata6.00: disabled

We lost a disk.

# touch /mnt/test2; sync; dmesg | tail

[  467.126471] BTRFS error (device sde): bdev /dev/sde errs: wr 1, rd
0, flush 0, corrupt 0, gen 0
[  467.127386] BTRFS error (device sde): bdev /dev/sde errs: wr 2, rd
0, flush 0, corrupt 0, gen 0
[  467.128125] BTRFS error (device sde): bdev /dev/sde errs: wr 3, rd
0, flush 0, corrupt 0, gen 0
[  467.128640] BTRFS error (device sde): bdev /dev/sde errs: wr 4, rd
0, flush 0, corrupt 0, gen 0
[  467.129215] BTRFS error (device sde): bdev /dev/sde errs: wr 4, rd
0, flush 1, corrupt 0, gen 0
[  467.129331] BTRFS warning (device sde): lost page write due to IO
error on /dev/sde
[  467.129334] BTRFS error (device sde): bdev /dev/sde errs: wr 5, rd
0, flush 1, corrupt 0, gen 0
[  467.129420] BTRFS warning (device sde): lost page write due to IO
error on /dev/sde
[  467.129422] BTRFS error (device sde): bdev /dev/sde errs: wr 6, rd
0, flush 1, corrupt 0, gen 0

We've got write errors on the lost disk.

# btrfs device usage /mnt

No 'single' profiles because we haven't remounted yet.

# btrfs device stat /mnt

[/dev/sde].write_io_errs   6
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   1
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

# reboot
# wipefs -a /dev/sde; reboot

# mount -o degraded /dev/sdb /mnt; dmesg | tail

[   52.876897] BTRFS info (device sdb): allowing degraded mounts
[   52.876901] BTRFS info (device sdb): disk space caching is enabled
[   52.876902] BTRFS: has skinny extents
[   52.878008] BTRFS warning (device sdb): devid 4 uuid
231d7892-3f31-40b5-8dff-baf8fec1a8aa is missing
[   52.879057] BTRFS info (device sdb): bdev (null) errs: wr 6, rd 0,
flush 1, corrupt 0, gen 0

# btrfs device usage /mnt

Still only raid10 profiles.

# btrfs device stat /mnt

[(null)].write_io_errs   6
[(null)].read_io_errs    0
[(null)].flush_io_errs   1
[(null)].corruption_errs 0
[(null)].generation_errs 0

/dev/sde is now called "(null)". Print device id instead? E.g.
"[devid:4].write_io_errs   6"

# touch /mnt/test3; sync; btrfs device usage /mnt
/dev/sdb, ID: 1
   Device size:             2.00GiB
   Data,single:           624.00MiB
   Data,RAID10:           102.38MiB
   Metadata,RAID10:       102.38MiB
   System,RAID10:           4.00MiB
   Unallocated:             1.19GiB

/dev/sdc, ID: 2
   Device size:             2.00GiB
   Data,RAID10:           102.38MiB
   Metadata,RAID10:       102.38MiB
   System,single:          32.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             1.76GiB

/dev/sdd, ID: 3
   Device size:             2.00GiB
   Data,RAID10:           102.38MiB
   Metadata,single:       256.00MiB
   Metadata,RAID10:       102.38MiB
   System,RAID10:           4.00MiB
   Unallocated:             1.55GiB

missing, ID: 4
   Device size:               0.00B
   Data,RAID10:           102.38MiB
   Metadata,RAID10:       102.38MiB
   System,RAID10:           4.00MiB
   Unallocated:             1.80GiB

Now we've got 'single' profiles on all devices except the missing one.
Replace missing device before unmount or get stuck with a read-only
filesystem.

# btrfs device stat /mnt

Same as before. Only old errors on the missing device.

# btrfs replace start -B 4 /dev/sde /mnt; dmesg | tail

[ 1268.598652] BTRFS info (device sdb): dev_replace from <missing
disk> (devid 4) to /dev/sde started
[ 1268.615601] BTRFS info (device sdb): dev_replace from <missing
disk> (devid 4) to /dev/sde finished

# btrfs device stats /mnt

[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

Device "(null)" is back to /dev/sde and the error counts have been reset.

# btrfs balance start -dconvert=raid10,soft -mconvert=raid10,soft
-sconvert=raid10,soft -vf /mnt; dmesg | tail

[ 1460.660739] BTRFS info (device sdb): relocating block group
1198522368 flags 1
[ 1460.667802] BTRFS info (device sdb): relocating block group
1164967936 flags 2
[ 1460.674128] BTRFS info (device sdb): relocating block group 896532480 flags 4

# btrfs device usage /mnt

Back to only 'raid10' profiles.

# btrfs device stat /dev/sde
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

No new errors after balance.

# umount /mnt; mount /dev/sdb /mnt; dmesg | tail

[ 1705.259074] BTRFS info (device sde): disk space caching is enabled
[ 1705.259078] BTRFS: has skinny extents
[ 1705.261887] BTRFS info (device sde): bdev /dev/sde errs: wr 6, rd
0, flush 1, corrupt 0, gen 0

# btrfs device stat /dev/sde
[/dev/sde].write_io_errs   6
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   1
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0

The old device counters are back! No errors in dmesg since last
reboot, so they are definitely old errors.

# btrfs device stats -z /dev/sde

Give /dev/sde a clean bill of health. Won't warn when mounting again.
