Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33797 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbCVIXz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Mar 2015 04:23:55 -0400
Received: by wgs2 with SMTP id 2so15513064wgs.1
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2015 01:23:54 -0700 (PDT)
Received: from [192.168.0.2] (gev44-1-78-228-108-65.fbx.proxad.net. [78.228.108.65])
        by mx.google.com with ESMTPSA id hd10sm5691494wib.7.2015.03.22.01.23.53
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2015 01:23:54 -0700 (PDT)
Message-ID: <550E7C19.6040607@gmail.com>
Date: Sun, 22 Mar 2015 09:23:53 +0100
From: Marc Cousin <cousinmarc@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: snapshot destruction making IO extremely slow
References: <550E7917.5030602@gmail.com>
In-Reply-To: <550E7917.5030602@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/03/2015 09:11, Marc Cousin wrote:
> Hi,
>
> I've noticed this problem for a while (I started to use snapper a while ago): while destroying snapshots, it's almost impossible to do IO on the volume.
>
> There is almost no IO active on this volume (it is made of sdb,sdc and sdd).
>
>
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdd               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdc               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sde               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdg               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             1,77    0,00   13,24    0,00    0,00   84,99
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdd               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdc               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sde               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdg               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0,88    0,00   13,03    0,25    0,00   85,84
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sda               0,00     1,00    4,00    2,00     0,08     0,01    30,67     0,01    1,67    0,00    5,00   1,67   1,00
> sdd               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdc               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sde               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-1              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-2              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> dm-3              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
> sdg               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
>
> (sda isn't into this btrfs filesystem)
>
> The btrfs cleaner is 100% active:
>
>   1501 root      20   0       0      0      0 R 100,0  0,0   9:10.40 [btrfs-cleaner]
>
> As soon as it terminates its job, the filesystem becomes usable again. But while waiting it is extremely unresponsive. Any program doing a write there hangs.
>
> Some more information: the 3 disks are 2.7TB, the raid is RAID1
>
> # btrfs fi df /mnt/btrfs
> Data, RAID1: total=3.18TiB, used=3.14TiB
> System, RAID1: total=32.00MiB, used=480.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.32GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> What is "funny" is that the filesystem seems to be working again when there is some IO activity and btrfs-cleaner gets to a lower cpu usage (around 70%).
>
> By the way, there are quite a few snapshots there:
>
> # btrfs subvolume  list /mnt/btrfs | wc -l
> 142
>
> and I think snapper tries to destroy around 10 of them on one go.
>
> I can do whatever test you want, as long as I keep the data on my disks :)
>
> Regards,
>
> Marc
>
I forgot the obvious. Kernel 3.19.2 (from archlinux). :)
