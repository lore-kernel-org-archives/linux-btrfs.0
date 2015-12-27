Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34189 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbL0S3U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 13:29:20 -0500
Received: by mail-io0-f171.google.com with SMTP id e126so290166533ioa.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 10:29:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567FEEB6.3080701@online.no>
References: <567FEEB6.3080701@online.no>
Date: Sun, 27 Dec 2015 11:29:20 -0700
Message-ID: <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 6:59 AM, Waxhead <waxhead@online.no> wrote:
> Hi,
>
> I have a "toy-array" of 6x USB drives hooked up to a hub where I made a
> btrfs raid 6 data+metadata filesystem.
>
> I copied some files to the filesystem, ripped out one USB drive and ruined
> it dd if=/dev/random to various locations on the drive. Put the USB drive
> back and the filesystem mounts ok.
>
> If i start scrub I after seconds get the following
>
>  kernel:[   50.844026] CPU: 1 PID: 91 Comm: kworker/u4:2 Not tainted
> 4.3.0-1-686-pae #1 Debian 4.3.3-2
>  kernel:[   50.844026] Hardware name: Acer AOA150/        , BIOS v0.3310
> 10/06/2008
>  kernel:[   50.844026] Workqueue: btrfs-endio-raid56
> btrfs_endio_raid56_helper [btrfs]
>  kernel:[   50.844026] task: f642c040 ti: f664c000 task.ti: f664c000
>  kernel:[   50.844026] Stack:
>  kernel:[   50.844026]  00000005 f0d20800 f664ded0 f86d0262 00000000
> f664deac c109a0fc 00000001
>  kernel:[   50.844026]  f79eac40 edb4a000 edb7a000 edb8a000 edbba000
> eccc1000 ecca1000 00000000
>  kernel:[   50.844026]  00000000 f664de68 00000003 f664de74 ecb23000
> f664de5c f5cda6a4 f0d20800
>  kernel:[   50.844026] Call Trace:
>  kernel:[   50.844026]  [<f86d0262>] ? finish_parity_scrub+0x272/0x560
> [btrfs]
>  kernel:[   50.844026]  [<c109a0fc>] ? set_next_entity+0x8c/0xba0
>  kernel:[   50.844026]  [<c127d130>] ? bio_endio+0x40/0x70
>  kernel:[   50.844026]  [<f86891fe>] ? btrfs_scrubparity_helper+0xce/0x270
> [btrfs]
>  kernel:[   50.844026]  [<c107ca7d>] ? process_one_work+0x14d/0x360
>  kernel:[   50.844026]  [<c107ccc9>] ? worker_thread+0x39/0x440
>  kernel:[   50.844026]  [<c107cc90>] ? process_one_work+0x360/0x360
>  kernel:[   50.844026]  [<c10821a6>] ? kthread+0xa6/0xc0
>  kernel:[   50.844026]  [<c1536181>] ? ret_from_kernel_thread+0x21/0x30
>  kernel:[   50.844026]  [<c1082100>] ? kthread_create_on_node+0x130/0x130
>  kernel:[   50.844026] Code: 6e c1 e8 ac dd f2 ff 83 c4 04 5b 5d c3 8d b6 00
> 00 00 00 31 c9 81 3d 84 f0 6e c1 84 f0 6e c1 0f 95 c1 eb b9 8d b4 200 00 00
> 00 0f 0b 8d b4 26 00 00 00 00 8d bc 27 00
>  kernel:[   50.844026] EIP: [<c1174858>] kunmap_high+0xa8/0xc0 SS:ESP
> 0068:f664de40
>
> This is only a test setup and I will keep this filesystem for a while if it
> can be of any use...

Sounds like a bug, but also might be missing functionality still. If
you can include the reproduce steps, including the exact
locations+lengths of the random writes, that's probably useful.

More than one thing could be going on. First, I don't know that Btrfs
even understands the device went missing because it doesn't yet have a
concept of faulty devices, and then I've seen it get confused when
drives reappear with new drive designations (not uncommon), and from
your call trace we don't know if that happened because there's not
enough information posted. Second, if the damage is too much on a
device, it almost certainly isn't recognized when reattached. But this
depends on what locations were damaged. If Btrfs doesn't recognize the
drive as part of the array, then the scrub request is effectively a
scrub for a volume with a missing drive which you probably wouldn't
ever do, you'd first replace the missing device. Scrubs happen on
normally operating arrays not degraded ones. So it's uncertain either
Btrfs, or the user, had any idea what state the volume was actually in
at the time.

Conversely on mdadm, it knows in such a case to mark a device as
faulty, the array automatically goes degraded, but when the drive is
reattached it is not automatically re-added. When the user re-adds,
typically a complete rebuild happens unless there's a write-intent
bitmap, which isn't a default at create time.



-- 
Chris Murphy
