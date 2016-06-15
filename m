Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34138 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbcFOK7x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 06:59:53 -0400
Received: by mail-vk0-f41.google.com with SMTP id t129so24277011vka.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 03:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKzrAgSGRQk_wEairoCUhK6GDCFOVbVWJLub4M_fu7uHC-pO0w@mail.gmail.com>
References: <CAKzrAgSGRQk_wEairoCUhK6GDCFOVbVWJLub4M_fu7uHC-pO0w@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Wed, 15 Jun 2016 10:59:50 +0000
Message-ID: <CAKzrAgSP31D+qAVF7fVMRY4qsXMpXDhJxxBAKdbE8=0fkh3N7w@mail.gmail.com>
Subject: Re: Cannot balance FS (No space left on device)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 2:58 PM, ojab // <ojab@ojab.ru> wrote:
> [Please CC me since I'm not subscribed to the list]

So I'm still playing w/ btrfs and again I have 'No space left on
device' during balance:
>$ sudo /usr/bin/btrfs balance start --full-balance /mnt/xxx/
>ERROR: error during balancing '/mnt/xxx/': No space left on device
>There may be more info in syslog - try dmesg | tail
>$ sudo dmesg -T  | grep BTRFS | tail
>[Wed Jun 15 10:28:53 2016] BTRFS info (device sdc1): relocating block group 13043037372416 flags 9
>[Wed Jun 15 10:28:53 2016] BTRFS info (device sdc1): relocating block group 13041963630592 flags 20
>[Wed Jun 15 10:29:54 2016] BTRFS info (device sdc1): found 25155 extents
>[Wed Jun 15 10:29:54 2016] BTRFS info (device sdc1): relocating block group 13040889888768 flags 20
>[Wed Jun 15 10:30:50 2016] BTRFS info (device sdc1): found 63700 extents
>[Wed Jun 15 10:30:50 2016] BTRFS info (device sdc1): relocating block group 13040856334336 flags 18
>[Wed Jun 15 10:30:51 2016] BTRFS info (device sdc1): found 9 extents
>[Wed Jun 15 10:30:52 2016] BTRFS info (device sdc1): relocating block group 13039782592512 flags 20
>[Wed Jun 15 10:32:08 2016] BTRFS info (device sdc1): found 61931 extents
>[Wed Jun 15 10:32:08 2016] BTRFS info (device sdc1): 896 enospc errors during balance
>$ sudo /usr/bin/btrfs balance start -dusage=75 /mnt/xxx/
>Done, had to relocate 1 out of 901 chunks
>$ sudo /usr/bin/btrfs balance start -dusage=76 /mnt/xxx/
>ERROR: error during balancing '/mnt/xxx/': No space left on device
>There may be more info in syslog - try dmesg | tail
>$ sudo /usr/bin/btrfs fi usage /mnt/xxx/
>Overall:
>    Device size:                   1.98TiB
>    Device allocated:              1.85TiB
>    Device unallocated:            135.06GiB
>    Device missing:                0.00B
>    Used:                          1.85TiB
>    Free (estimated):              135.68GiB      (min: 68.15GiB)
>    Data ratio:                    1.00
>    Metadata ratio:                2.00
>    Global reserve:                512.00MiB      (used: 0.00B)
>
>Data,RAID0: Size:1.84TiB, Used:1.84TiB
>   /dev/sdb1               895.27GiB
>   /dev/sdc1               895.27GiB
>   /dev/sdd1               37.27GiB
>   /dev/sdd2               37.27GiB
>   /dev/sde1               11.27GiB
>   /dev/sde2               11.27GiB
>
>Metadata,RAID1: Size:4.00GiB, Used:2.21GiB
>   /dev/sdb1       2.00GiB
>   /dev/sdc1       2.00GiB
>   /dev/sde1       2.00GiB
>   /dev/sde2       2.00GiB
>
>System,RAID1: Size:32.00MiB, Used:160.00KiB
>   /dev/sde1    32.00MiB
>   /dev/sde2    32.00MiB
>
>Unallocated:
>   /dev/sdb1      34.25GiB
>   /dev/sdc1      34.25GiB
>   /dev/sdd1      1.11MiB
>   /dev/sdd2      1.05MiB
>   /dev/sde1      33.28GiB
>   /dev/sde2      33.28GiB
>$ sudo /usr/bin/btrfs fi show /mnt/xxx/
>Label: none  uuid: 8a65465d-1a8c-4f80-abc6-c818c38567c3
>       Total devices 6 FS bytes used 1.84TiB
>       devid    1 size 931.51GiB used 897.27GiB path /dev/sdc1
>       devid    2 size 931.51GiB used 897.27GiB path /dev/sdb1
>       devid    3 size 37.27GiB used 37.27GiB path /dev/sdd1
>       devid    4 size 37.27GiB used 37.27GiB path /dev/sdd2
>       devid    5 size 46.58GiB used 13.30GiB path /dev/sde1
>       devid    6 size 46.58GiB used 13.30GiB path /dev/sde2

show_usage.py output can be found here:
https://gist.github.com/ojab/a24ce373ce5bede001140c572879fce8

Balance always fails with '896 enospc errors during balance' message
in dmesg. I don't quite understand the logic: there is a plenty of
space on four devices, why `btrfs` apparently trying to use sdd[0-1]
drives, is it a bug or intended behaviour?
What is the proper way of fixing such an issue in general, adding more
devices and rebalancing? How can I determine how many devices should
be added and their capacity?

I'm still on 4.6.2 vanilla kernel and using btrfs-progs-4.6.

//wbr ojab
