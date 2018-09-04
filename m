Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34387 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbeIDQSQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 12:18:16 -0400
Received: by mail-oi0-f48.google.com with SMTP id 13-v6so6163874ois.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 04:53:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdf3gp5RLHxSqhFjjOtNaGpDPvK+UO9eGh+UmmnPxXNa+v-Qg@mail.gmail.com>
 <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
In-Reply-To: <3374b776-071f-ec7f-f5ad-58d0e7dc3059@gmx.com>
From: Etienne Champetier <champetier.etienne@gmail.com>
Date: Tue, 4 Sep 2018 07:53:14 -0400
Message-ID: <CAOdf3goVwcAwKXhNDcO0va-PJFu0mAWbBUeu-yQWkb-2SNPnxQ@mail.gmail.com>
Subject: Re: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: quwenruo.btrfs@gmx.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Le lun. 3 sept. 2018 à 20:27, Qu Wenruo <quwenruo.btrfs@gmx.com> a écrit :
>
> On 2018/9/3 下午10:18, Etienne Champetier wrote:
> > Hello btfrs hackers,
> >
> > I have a computer acting as backup server with BTRFS RAID1, and I
> > would like to know the different options to rebuild this RAID
> > (I saw this thread
> > https://www.spinics.net/lists/linux-btrfs/msg68679.html but there was
> > no raid 1)
> >
> > # uname -a
> > Linux servmaison 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:00
> > UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> >
> > # btrfs --version
> > btrfs-progs v4.4
> >
> > # dmesg
> > ...
> > [ 1955.581972] BTRFS critical (device sda2): corrupt leaf, bad key
> > order: block=6020235362304,root=1, slot=63
> > [ 1955.582299] BTRFS critical (device sda2): corrupt leaf, bad key
> > order: block=6020235362304,root=1, slot=63

Now running a Fedora 28 install kernel

# uname -a
Linux servmaison 4.16.3-301.fc28.x86_64 #1 SMP Mon Apr 23 21:59:58 UTC
2018 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
btrfs-progs v4.15.1

>
> Please provide the following dump:
>
> # btrfs inspect dump-tree -t root /dev/sda2
> # btrfs inspect dump-tree -b 6020235362304 /dev/sda2

All requested dump are in this repo:
https://github.com/champtar/debugraidbtrfs

>
> The first one is to inspect current root tree to find any corruption.
> The second one is to show that corrupted tree block, and compare with
> first output to make sure if it's already in the committed tree.
>
> And the critical error message already shows what's causing the bug,
> your root tree is corrupted, some keys are not in correct order.
>
> All the following errors could be caused by this problem.
>
> [snip]
> >
> > # btrfs fi show /
> > Label: none  uuid: 4917db5e-fc20-4369-9556-83082a32d4cd
> >     Total devices 2 FS bytes used 2.25TiB
> >     devid    1 size 3.64TiB used 2.34TiB path /dev/sda2
> >     devid    2 size 3.64TiB used 2.34TiB path /dev/sdb2
> >
> > # btrfs device stats /
> > [/dev/sda2].write_io_errs   0
> > [/dev/sda2].read_io_errs    0
> > [/dev/sda2].flush_io_errs   0
> > [/dev/sda2].corruption_errs 0
> > [/dev/sda2].generation_errs 0
> > [/dev/sdb2].write_io_errs   0
> > [/dev/sdb2].read_io_errs    0
> > [/dev/sdb2].flush_io_errs   0
> > [/dev/sdb2].corruption_errs 0
> > [/dev/sdb2].generation_errs 0
> >
> > device stats report no errors :(
> >
> > # btrfs fi df /
> > Data, RAID1: total=2.32TiB, used=2.23TiB
> > System, RAID1: total=96.00MiB, used=368.00KiB
> > Metadata, RAID1: total=22.00GiB, used=19.12GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> >
> > # btrfs scrub status /
> > scrub status for 4917db5e-fc20-4369-9556-83082a32d4cd
> >     scrub started at Mon Sep  3 05:32:52 2018, interrupted after
> > 00:27:35, not running
> >     total bytes scrubbed: 514.05GiB with 0 errors
> >
> > I've already tried 2 times to run btrfs scrub (after reboot), but it
> > stops before the end, with the previous dmesg error
> >
> > My question is what is the safest way to rebuild this BTRFS RAID1?
>
> It depends on the inspect dump-tree output.
>
> > I haven't tried "btrfs check --repair" yet
>
> We need "btrfs check --readonly" output to verify if the bad key order
> is the only problem.
>
> If it's the only problem, "btrfs check --repair" indeed could fix it.

Also available in https://github.com/champtar/debugraidbtrfs, here
"btrfs check --readonly /dev/sda2" output
~~~~~~~~~~~~~~~~~~~~
checking extents
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad key ordering 63 64
bad block 6020235362304
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
there is no free space entry for 6011561750528-5942842273792
there is no free space entry for 6011561750528-6012044050432
cache appears valid but isn't 6010970308608
there is no free space entry for 6015529828352-5946810351616
there is no free space entry for 6015529828352-6016339017728
cache appears valid but isn't 6015265275904
there is no free space entry for 6139476623360-6070757146624
there is no free space entry for 6139476623360-6139852881920
cache appears valid but isn't 6138779140096
ERROR: errors found in free space cache
Checking filesystem on /dev/sda2
UUID: 4917db5e-fc20-4369-9556-83082a32d4cd
found 1321120776195 bytes used, error(s) found
total csum bytes: 0
total tree bytes: 1163182080
total fs tree bytes: 0
total extent tree bytes: 1161740288
btree space waste bytes: 290512355
file data blocks allocated: 618135552
 referenced 618135552
~~~~~~~~~~~~~~~~~~~~

Thanks
Etienne

P.S: sorry for the initial duplicate email, it took a very long time
to show up in https://www.spinics.net/lists/linux-btrfs/maillist.html,
thought it was discarded as I was not subscribed to the list

>
> Thanks,
> Qu
>
> > (I can boot on a more up to date Linux live if it helps)
> >
> > Thanks
> > Etienne
> >
>
