Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:48274 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755562AbdKJHmq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 02:42:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 10 Nov 2017 16:42:42 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: E V <eliventer@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <CAJtFHUQ34uyt-iAQKuQ-WqXMrCqxsPeqFc5LvYmZHrz+Rxs66A@mail.gmail.com>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
 <64e4c4c4341f5880349a02cf57eb3ff7@wpkg.org>
 <CAJtFHUQ34uyt-iAQKuQ-WqXMrCqxsPeqFc5LvYmZHrz+Rxs66A@mail.gmail.com>
Message-ID: <011ae8c4281f0f8799d48189f540a302@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-07 23:49, E V wrote:

> Hmm, I used to see these phantom no space issues quite a bit on older
> 4.x kernels, and haven't seen them since switching to space_cache=v2.
> So it could be space cache corruption. You might try either clearing
> you space cache, or mounting with nospace_cache, or try converting to
> space_cache=v2 after reading up on it's caveats.

We have space_cache=v2.

Unfortunately yet one more system running 4.14-rc8 with "No space left" 
during balance:


[68443.535664] BTRFS info (device sdb3): relocating block group 
591771009024 flags data|raid1
[68463.203330] BTRFS info (device sdb3): found 8578 extents
[68492.238676] BTRFS info (device sdb3): found 8559 extents
[68500.751792] BTRFS info (device sdb3): 1 enospc errors during balance


# btrfs balance start /var/lib/lxd
WARNING:

         Full balance without filters requested. This operation is very
         intense and takes potentially very long. It is recommended to
         use the balance filters to narrow down the balanced data.
         Use 'btrfs balance start --full-balance' option to skip this
         warning. The operation will start in 10 seconds.
         Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
ERROR: error during balancing '/var/lib/lxd': No space left on device
There may be more info in syslog - try dmesg | tail


# btrfs fi usage /var/lib/lxd
Overall:
     Device size:                 846.26GiB
     Device allocated:            622.27GiB
     Device unallocated:          223.99GiB
     Device missing:                  0.00B
     Used:                        606.40GiB
     Free (estimated):            116.68GiB      (min: 116.68GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:306.00GiB, Used:301.31GiB
    /dev/sda3     306.00GiB
    /dev/sdb3     306.00GiB

Metadata,RAID1: Size:5.10GiB, Used:1.89GiB
    /dev/sda3       5.10GiB
    /dev/sdb3       5.10GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
    /dev/sda3      32.00MiB
    /dev/sdb3      32.00MiB

Unallocated:
    /dev/sda3     112.00GiB
    /dev/sdb3     112.00GiB


# btrfs fi show /var/lib/lxd
Label: 'btrfs'  uuid: 6340f5de-f635-4d09-bbb2-1e03b1e1b160
         Total devices 2 FS bytes used 303.20GiB
         devid    1 size 423.13GiB used 311.13GiB path /dev/sda3
         devid    2 size 423.13GiB used 311.13GiB path /dev/sdb3


# btrfs fi df /var/lib/lxd
Data, RAID1: total=306.00GiB, used=301.32GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=5.10GiB, used=1.89GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



So far out of all systems which were giving us "No space left on device" 
with 4.13.x, all but one are still giving us "No space left on device" 
during balance with 4.14-rc7 and later.
We've seen it on a mix of servers with SSD or HDD disks, with 
filesystems ranging from 0.5 TB to 20 TB, and use % from 30% to 90%.

Combined with evidence that "No space left on device" during balance can 
lead to various file corruption (we've witnessed it with MySQL), I'd day 
btrfs balance is a dangerous operation and decision to use it should be 
considered very thoroughly.


Shouldn't "Balance" be marked as "mostly OK" or "Unstable" here? Giving 
it "OK" status is misleading.

https://btrfs.wiki.kernel.org/index.php/Status


Tomasz Chmielewski
https://lxadm.com
