Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh2.e.nsc.no ([193.213.121.73]:41247 "EHLO nmsh2.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbbL0XGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 18:06:51 -0500
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <567FEEB6.3080701@online.no>
 <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
From: Waxhead <waxhead@online.no>
Message-ID: <56806F06.50309@online.no>
Date: Mon, 28 Dec 2015 00:06:46 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:
> On Sun, Dec 27, 2015 at 6:59 AM, Waxhead <waxhead@online.no> wrote:
>> Hi,
>>
>> I have a "toy-array" of 6x USB drives hooked up to a hub where I made a
>> btrfs raid 6 data+metadata filesystem.
>>
>> I copied some files to the filesystem, ripped out one USB drive and ruined
>> it dd if=/dev/random to various locations on the drive. Put the USB drive
>> back and the filesystem mounts ok.
>>
>> If i start scrub I after seconds get the following
>>
>>   kernel:[   50.844026] CPU: 1 PID: 91 Comm: kworker/u4:2 Not tainted
>> 4.3.0-1-686-pae #1 Debian 4.3.3-2
>>   kernel:[   50.844026] Hardware name: Acer AOA150/        , BIOS v0.3310
>> 10/06/2008
>>   kernel:[   50.844026] Workqueue: btrfs-endio-raid56
>> btrfs_endio_raid56_helper [btrfs]
>>   kernel:[   50.844026] task: f642c040 ti: f664c000 task.ti: f664c000
>>   kernel:[   50.844026] Stack:
>>   kernel:[   50.844026]  00000005 f0d20800 f664ded0 f86d0262 00000000
>> f664deac c109a0fc 00000001
>>   kernel:[   50.844026]  f79eac40 edb4a000 edb7a000 edb8a000 edbba000
>> eccc1000 ecca1000 00000000
>>   kernel:[   50.844026]  00000000 f664de68 00000003 f664de74 ecb23000
>> f664de5c f5cda6a4 f0d20800
>>   kernel:[   50.844026] Call Trace:
>>   kernel:[   50.844026]  [<f86d0262>] ? finish_parity_scrub+0x272/0x560
>> [btrfs]
>>   kernel:[   50.844026]  [<c109a0fc>] ? set_next_entity+0x8c/0xba0
>>   kernel:[   50.844026]  [<c127d130>] ? bio_endio+0x40/0x70
>>   kernel:[   50.844026]  [<f86891fe>] ? btrfs_scrubparity_helper+0xce/0x270
>> [btrfs]
>>   kernel:[   50.844026]  [<c107ca7d>] ? process_one_work+0x14d/0x360
>>   kernel:[   50.844026]  [<c107ccc9>] ? worker_thread+0x39/0x440
>>   kernel:[   50.844026]  [<c107cc90>] ? process_one_work+0x360/0x360
>>   kernel:[   50.844026]  [<c10821a6>] ? kthread+0xa6/0xc0
>>   kernel:[   50.844026]  [<c1536181>] ? ret_from_kernel_thread+0x21/0x30
>>   kernel:[   50.844026]  [<c1082100>] ? kthread_create_on_node+0x130/0x130
>>   kernel:[   50.844026] Code: 6e c1 e8 ac dd f2 ff 83 c4 04 5b 5d c3 8d b6 00
>> 00 00 00 31 c9 81 3d 84 f0 6e c1 84 f0 6e c1 0f 95 c1 eb b9 8d b4 200 00 00
>> 00 0f 0b 8d b4 26 00 00 00 00 8d bc 27 00
>>   kernel:[   50.844026] EIP: [<c1174858>] kunmap_high+0xa8/0xc0 SS:ESP
>> 0068:f664de40
>>
>> This is only a test setup and I will keep this filesystem for a while if it
>> can be of any use...
> Sounds like a bug, but also might be missing functionality still. If
> you can include the reproduce steps, including the exact
> locations+lengths of the random writes, that's probably useful.
>
> More than one thing could be going on. First, I don't know that Btrfs
> even understands the device went missing because it doesn't yet have a
> concept of faulty devices, and then I've seen it get confused when
> drives reappear with new drive designations (not uncommon), and from
> your call trace we don't know if that happened because there's not
> enough information posted. Second, if the damage is too much on a
> device, it almost certainly isn't recognized when reattached. But this
> depends on what locations were damaged. If Btrfs doesn't recognize the
> drive as part of the array, then the scrub request is effectively a
> scrub for a volume with a missing drive which you probably wouldn't
> ever do, you'd first replace the missing device. Scrubs happen on
> normally operating arrays not degraded ones. So it's uncertain either
> Btrfs, or the user, had any idea what state the volume was actually in
> at the time.
>
> Conversely on mdadm, it knows in such a case to mark a device as
> faulty, the array automatically goes degraded, but when the drive is
> reattached it is not automatically re-added. When the user re-adds,
> typically a complete rebuild happens unless there's a write-intent
> bitmap, which isn't a default at create time.
>
I am afraid I can't exactly include the how to reproduce steps.
I do however have the filesystem in a "bad state" so if there is 
anything I can do - let me know.

First of all ... a "btrfs filesystem show" does list all drives
Label: none  uuid: 2832346e-0720-499f-8239-355534e5721b
         Total devices 6 FS bytes used 8.53GiB
         devid    1 size 7.68GiB used 3.08GiB path /dev/sdb1
         devid    2 size 7.68GiB used 3.08GiB path /dev/sdc1
         devid    3 size 7.68GiB used 3.08GiB path /dev/sdd1
         devid    4 size 7.68GiB used 3.08GiB path /dev/sde1
         devid    5 size 7.68GiB used 3.08GiB path /dev/sdf1
         devid    6 size 7.68GiB used 3.08GiB path /dev/sdg1

mount /dev/sdb1 /mnt/
btrfs filesystem df /mnt

Data, RAID6: total=12.00GiB, used=8.45GiB
System, RAID6: total=64.00MiB, used=16.00KiB
Metadata, RAID6: total=256.00MiB, used=84.58MiB
GlobalReserve, single: total=32.00MiB, used=0.00B

btrfs scrub status /mnt
scrub status for 2832346e-0720-499f-8239-355534e5721b
         scrub started at Sun Mar 29 23:21:04 2015 and finished after 
00:01:04
         total bytes scrubbed: 1.97GiB with 14549 errors
         error details: super=2 csum=14547
         corrected errors: 0, uncorrectable errors: 14547, unverified 
errors: 0

Now here is the first worrying part... it says that scrub started at Sun 
Mar 29. That is NOT true, the first scrub I did on this filesystem was a 
few days ago and it claims it is a lot of uncorrectable errors. Why? 
This is after all a raid6 filesystem correct?!

btrfs scrub start -B /mnt

Message from syslogd@a150 at Dec 27 23:44:22 ...
  kernel:[  611.478448] CPU: 0 PID: 1200 Comm: kworker/u4:1 Not tainted 
4.3.0-1-686-pae #1 Debian 4.3.3-2

Message from syslogd@a150 at Dec 27 23:44:22 ...
  kernel:[  611.478448] Hardware name: Acer AOA150/        , BIOS 
v0.3310 10/06/2008
  kernel:[  611.478448] Workqueue: btrfs-endio-raid56 
btrfs_endio_raid56_helper [btrfs]
  kernel:[  611.478448] task: ec403040 ti: ec4a2000 task.ti: ec4a2000
  kernel:[  611.478448] Stack:
  kernel:[  611.478448]  00000005 ecd78800 ec4a3ed0 f8768262 00000000 
0000008e 5ead4067 0000008e
  kernel:[  611.478448]  5ead3301 ec5bd000 ec5ce000 ec5fd000 ec62d000 
ec5a9000 ec5a8000 f79d27cc
  kernel:[  611.478448]  00000000 ec4a3e68 00000003 ec4a3e74 ec32d700 
ec4a3e5c f5ccaba0 ecd78800
  kernel:[  611.478448] Call Trace:
  kernel:[  611.478448]  [<f8768262>] ? finish_parity_scrub+0x272/0x560 
[btrfs]
  kernel:[  611.478448]  [<c127d130>] ? bio_endio+0x40/0x70
  kernel:[  611.478448]  [<f87211fe>] ? 
btrfs_scrubparity_helper+0xce/0x270 [btrfs]
  kernel:[  611.478448]  [<c107ca7d>] ? process_one_work+0x14d/0x360
  kernel:[  611.482350]  [<c107ccc9>] ? worker_thread+0x39/0x440
  kernel:[  611.482350]  [<c107cc90>] ? process_one_work+0x360/0x360
  kernel:[  611.482350]  [<c10821a6>] ? kthread+0xa6/0xc0
  kernel:[  611.482350]  [<c1536181>] ? ret_from_kernel_thread+0x21/0x30
  kernel:[  611.482350]  [<c1082100>] ? kthread_create_on_node+0x130/0x130
  kernel:[  611.482350] Code: c4 04 5b 5d c3 8d b6 00 00 00 00 31 c9 81 
3d 84 f0 6e c1 84 f0 6e c1 0f 95 c1 eb b9 8d b4 26 00 00 00 00 0f 0b 8d 
b6 00 00 00 00 <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 
e5 56 53
  kernel:[  611.482350] EIP: [<c1174860>] kunmap_high+0xb0/0xc0 SS:ESP 
0068:ec4a3e40

This is what I got from my ssh login , there is a longer stacktrace on 
the computer I am testing this on... what I can read on the screen is 
(hope I got all the numbers right):

? print_oops_end_marker+0x41/0x70
? oops_end+0x92/0xd0
? no_context+0x100/0x2b0
? __bad_area_nosemaphore+0xb5/0x140
? dequeue_task_fair+0x4c/0xbd0
? check_preempt_curr+0x7a/0x90
? __do_page_fault+0x460/0x460
? bad_area_nosemaphore+0x17/0x20
? error_code+0x67/0x6c
? alloc_pid+0x5b/0x420
? kthread_data+0xf/0x20
? wq_worker_sleeping+0x10/0x90
? __schedule+0x4e2/0x8c0
? schedule+0x2b/0x80
? do_exit+0x746/0x9f0
? vprintk_default+0x37/0x40
? printk_0x17/0x19
? oops_end+0x92
? do_error_trap+0x8a/0x120
? kunmap_high+0xb0/0xc0
? __alloc_pages_nodemask+0x13b/0x850
? do_overflow+0x30/0x30
? do_invalid_op+0x24/0x30
? error_code+0x67/0x6c
? compact_unblock_should_abort.isra.31+0x7b/0x90
? kunmap_high+0xb0/0xc0
? finish_parity_scrub+0x272/0x556 [btrfs]
? bio_endio+0x40/0x70
? btrfs_scrubparity_helper+0xce/0x270 [btrfs]
? process_one_work+0x14d/0x360
? worker_thread+0x39/0x440
? process_one_work+0x360/0x360
? kthread+0xa6/0xc0
? ret_from_kernel_thread+0x21/0x30
? kthread_create_on_node+0x130/0x130
---[end trace....]

I hope this is of more help. Again if there is anything I can do I am 
happy to help. I don't need this filesystem so no need to recover it.
