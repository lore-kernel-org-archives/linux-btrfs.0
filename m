Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752742AbdHWAAP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 20:00:15 -0400
Subject: Re: Btrfs Raid5 issue.
To: Robert LeBlanc <robert@leblancnet.us>, lists@colorremedies.com,
        linux-btrfs@vger.kernel.org
References: <CAANLjFq0vwWBuNKXoOLp0D3n8K8ULowOxa1er_4pMZpLu61zWA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8eaeb550-e707-731b-2bc6-d1722de6f4df@gmx.com>
Date: Wed, 23 Aug 2017 08:00:05 +0800
MIME-Version: 1.0
In-Reply-To: <CAANLjFq0vwWBuNKXoOLp0D3n8K8ULowOxa1er_4pMZpLu61zWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月23日 00:37, Robert LeBlanc wrote:
> Thanks for the explanations. Chris, I don't think 'degraded' did
> anything to help the mounting, I just passed it in to see if it would
> help (I'm not sure if btrfs is "smart" enough to ignore a drive if it
> would increase the chance of mounting the volume even if it is
> degraded, but one could hope). I believe the key was 'nologreplay'.
> Here is some info about the corrupted fs:
> 
> # btrfs fi show /tmp/root/
> Label: 'kvm-btrfs'  uuid: fef29f0a-dc4c-4cc4-b524-914e6630803c
>          Total devices 3 FS bytes used 3.30TiB
>          devid    1 size 2.73TiB used 2.09TiB path /dev/bcache32
>          devid    2 size 2.73TiB used 2.09TiB path /dev/bcache0
>          devid    3 size 2.73TiB used 2.09TiB path /dev/bcache16
> 
> # btrfs fi usage /tmp/root/
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> Overall:
>      Device size:                   8.18TiB
>      Device allocated:                0.00B
>      Device unallocated:            8.18TiB
>      Device missing:                  0.00B
>      Used:                            0.00B
>      Free (estimated):                0.00B      (min: 8.00EiB)
>      Data ratio:                       0.00
>      Metadata ratio:                   0.00
>      Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,RAID5: Size:4.15TiB, Used:3.28TiB
>     /dev/bcache0    2.08TiB
>     /dev/bcache16           2.08TiB
>     /dev/bcache32           2.08TiB
> 
> Metadata,RAID5: Size:22.00GiB, Used:20.69GiB
>     /dev/bcache0   11.00GiB
>     /dev/bcache16          11.00GiB
>     /dev/bcache32          11.00GiB
> 
> System,RAID5: Size:64.00MiB, Used:400.00KiB
>     /dev/bcache0   32.00MiB
>     /dev/bcache16          32.00MiB
>     /dev/bcache32          32.00MiB
> 
> Unallocated:
>     /dev/bcache0  655.00GiB
>     /dev/bcache16         655.00GiB
>     /dev/bcache32         656.49GiB
> 
> So it looks like I set the metadata and system data to RAID5 and not
> RAID1. I guess that it could have been affected by the write hole
> causing the problem I was seeing.
> 
> Since I get the same space usage with RAID1 and RAID5,

Well, RAID1 has larger space usage than 3-disk RAID5.
Space efficiency will be 50% for RAID1 while 66% for 3-disk RAID5.

So you may lost some available space.

> I think I'm
> just going to use RAID1. I don't need stripe performance or anything
> like that.

And RAID5/6 won't always improve performance.
Especially when IO blocksize is smaller than full stripe size (in your 
case it's 128K).

When doing sequential IO with blocksize smaller than 128K, there will be 
an obvious performance drop due to RMW cycle.
This is not limited to Btrfs RAID56 but all RAID56.

> It would be nice if btrfs supported hotplug and re-plug a
> little better so that it is more "production" quality, but I just have
> to be patient. I'm familiar with Gluster and contributed code to Ceph,
> so I'm familiar with those types of distributed systems. I really like
> them, but the complexity is quite overkill for my needs at home.
> 
> As far as bcache performance:
> I have two Crucial MX200 250GB drives that were md raid1 containing
> /boot (ext2), swap and then bcache. I have 2 WD Reds and a Seagate
> Barracuda Desktop drive all 3TB. With bcache in writeback, apt-get
> would be painfully slow. Running iostat, the SSDs would be doing a few
> hundred IOPs and the backing disks would be very busy and would be the
> limiting factor overall. Even though apt-get just downloaded the file
> (should be on the SSDs because of writeback), it still involved the
> backend disks way too much. The amount of dirty data was always less
> than 10% so there should have been plenty of space to free up cache
> without having to flush. I experimented with changing the size of
> contiguous IO to force more to cache, increasing the dirty ratio, etc,
> nothing seemed to provide the performance I was hoping. To be fair
> having a pair of SSDs (md raid1) caching three spindles (btrfs raid5)
> may not be an ideal configuration. If I had three SSDs, one for each
> drive, then it may have performed better?? I have also ~980 snapshots
> spread over a years time, so I don't know how much that impacts
> things. I did use a btrfs utility to help find duplicate files/chunks
> and dedupe them so that updated system binaries between upgraded LXC
> containers would use the same space on disk and be more efficient in
> bcache cache usage.

Well, RAID1 ssd, offline dedupe, bcache, many snapshots, way more 
complex than I though.
So I'm uncertain where the bottleneck is.

> 
> After restoring the root and LXC roots snapshots on the SSD (broke the
> md raid1 so I could restore to one of them), I ran apt-get and got
> upwards to 2,400 IOPs with it being sustained around 1,200 IOPs (btrfs
> single on md raid1 degraded). I know that btrfs has some performance
> challenges, but I don't think I was hitting those. I was most likely a
> very unusual set-up of bcache and btrfs raid that caused the problem.
> I have bcache on 10 year old desktop box with a single nvme drive that
> performs a little better, but it is hard to be certain because of its
> age. It has bcache in write-around (since there is only a single nvme)
> and btrfs in raid1. I haven't watched that box as closely because it
> is responsive enough. It also only has four Gb of RAM so it constantly
> has to swap (web pages are hogs these days) and one of the reasons to
> retrofit that box with nvme rather than MX200.

Good to know it works for you now.

Thanks,
Qu

> 
> If you have any other questions, feel free to ask.
> 
> Thanks
> 
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> 
