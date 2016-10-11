Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34037 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932256AbcJKRms (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 13:42:48 -0400
Received: by mail-oi0-f48.google.com with SMTP id t73so32499424oie.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 10:41:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e8601d223da$0cbf6c00$263e4400$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
 <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
 <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
 <5e8601d223da$0cbf6c00$263e4400$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Oct 2016 11:41:11 -0600
Message-ID: <CAJCQCtSBn1+CqqDkeHx+bBR8zSbN8hYQ9R4p9C2EtpBoVBP+Ww@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 10:10 AM, Jason D. Michaelson
<jasondmichaelson@gmail.com> wrote:
> superblock: bytenr=65536, device=/dev/sda
> ---------------------------------------------------------
> generation              161562
> root                    5752616386560



> superblock: bytenr=65536, device=/dev/sdh
> ---------------------------------------------------------
> generation              161474
> root                    4844272943104

OK so most obvious is that the bad super is many generations back than
the good super. That's expected given all the write errors.


>root@castor:~/logs# btrfs-find-root /dev/sda
>parent transid verify failed on 5752357961728 wanted 161562 found 159746
>parent transid verify failed on 5752357961728 wanted 161562 found 159746
>Couldn't setup extent tree
>Superblock thinks the generation is 161562
>Superblock thinks the level is 1


This squares with the good super. So btrfs-find-root is using a good
super. I don't know what 5752357961728 is for, maybe it's possible to
read that with btrfs-debug-tree -b 5752357961728 <anydev> and see what
comes back. This is not the tree root according to the super though.
So what do you get for btrfs-debug-tree -b 5752616386560 <anydev>

Going back to your logs....


[   38.810575] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   38.810595] NFSD: starting 90-second grace period (net ffffffffb12e5b80)
[  241.292816] INFO: task bfad_worker:234 blocked for more than 120 seconds.
[  241.299135]       Not tainted 4.7.0-0.bpo.1-amd64 #1
[  241.305645] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

I don't know what this kernel is. I think you'd be better off with
stable 4.7.7 or 4.8.1 for this work, so you're not running into a
bunch of weird blocked task problems in addition to whatever is going
on with the fs.
[   38.810575] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   38.810595] NFSD: starting 90-second grace period (net ffffffffb12e5b80)
[  241.292816] INFO: task bfad_worker:234 blocked for more than 120 seconds.
[  241.299135]       Not tainted 4.7.0-0.bpo.1-amd64 #1
[  241.305645] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

I don't know what this kernel is. I think you'd be better off with
stable 4.7.7 or 4.8.1 for this work, so you're not running into a
bunch of weird blocked task problems in addition to whatever is going
on with the fs.


[   20.552205] BTRFS: device fsid 73ed01df-fb2a-4b27-b6fc-12a57da934bd
devid 3 transid 161562 /dev/sdd
[   20.552372] BTRFS: device fsid 73ed01df-fb2a-4b27-b6fc-12a57da934bd
devid 5 transid 161562 /dev/sdf
[   20.552524] BTRFS: device fsid 73ed01df-fb2a-4b27-b6fc-12a57da934bd
devid 6 transid 161562 /dev/sde
[   20.552689] BTRFS: device fsid 73ed01df-fb2a-4b27-b6fc-12a57da934bd
devid 4 transid 161562 /dev/sdg
[   20.552858] BTRFS: device fsid 73ed01df-fb2a-4b27-b6fc-12a57da934bd
devid 1 transid 161562 /dev/sda
[  669.843166] BTRFS warning (device sda): devid 2 uuid
dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c is missing
[232572.871243] sd 0:0:8:0: [sdh] tag#4 Sense Key : Medium Error [current]


Two items missing, in effect, for this failed read. One literally
missing, and the other one missing due to unrecoverable read error.
The fact it's not trying to fix anything suggests it hasn't really
finished mounting, there must be something wrong where it either just
gets confused and won't fix (because it might make things worse) or
there isn't reduncancy.


[52799.495999] mce: [Hardware Error]: Machine check events logged
[53249.491975] mce: [Hardware Error]: Machine check events logged
[231298.005594] mce: [Hardware Error]: Machine check events logged

Bunch of other hardware issues...

I *really* think you need to get the hardware issues sorted out before
working on this file system unless you just don't care that much about
it. There are already enough unknowns without contributing who knows
what effect the hardware issues are having while trying to repair
things. Or even understand what's going on.



> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
>                 chunk length 4194304 owner 2 stripe_len 65536
>                 type SYSTEM num_stripes 1
>                         stripe 0 devid 1 offset 0
>                         dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4
>         item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520)
>                 chunk length 11010048 owner 2 stripe_len 65536
>                 type SYSTEM|RAID6 num_stripes 6
>                         stripe 0 devid 6 offset 1048576
>                         dev uuid: 390a1fd8-cc6c-40e7-b0b5-88ca7dcbcc32
>                         stripe 1 devid 5 offset 1048576
>                         dev uuid: 2df974c5-9dde-4062-81e9-c6eeee13db62
>                         stripe 2 devid 4 offset 1048576
>                         dev uuid: dce3d159-721d-4859-9955-37a03769bb0d
>                         stripe 3 devid 3 offset 1048576
>                         dev uuid: 6f7142db-824c-4791-a5b2-d6ce11c81c8f
>                         stripe 4 devid 2 offset 1048576
>                         dev uuid: dc8760f1-2c54-4134-a9a7-a0ac2b7a9f1c
>                         stripe 5 devid 1 offset 20971520
>                         dev uuid: 08c50aa9-c2dd-43b7-a631-6dfdc7d69ea4

Huh, well item 0 is damn strange. I wonder how that happened. The dev
uuid of that single system chunk matches devid 1. This is a single
source of failure. This could be an artifact of creating the raid6
with an old btrfs-progs. I just created a volume with btrfs-progs
4.7.3:

# mkfs.btrfs -draid6 -mraid6 /dev/mapper/VG-1 /dev/mapper/VG-2
/dev/mapper/VG-3 /dev/mapper/VG-4 /dev/mapper/VG-5 /dev/mapper/VG-6

And the super block sys_chunk_array has only a SYSTEM|RAID6 chunk.
There is no single SYSTEM chunk. After mounting and copying some data
over, then umounting, same thing. One system chunk, raid6.

So *IF* there is anything wrong with this single system chunk, it's
all bets are off, no way to even attempt to fix the problem. That
might explain why it's not getting past the very earliest stage of
mounting. But it's inconclusive.


-- 
Chris Murphy
