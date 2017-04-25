Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44024 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S979462AbdDYA00 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 20:26:26 -0400
Subject: Re: Problem with file system
To: Fred Van Andel <vanandel@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
Date: Tue, 25 Apr 2017 08:26:21 +0800
MIME-Version: 1.0
In-Reply-To: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/24/2017 11:27 PM, Fred Van Andel wrote:
> I have a btrfs file system with a few thousand snapshots.  When I
> attempted to delete 20 or so of them the problems started.
> 
> The disks are being read but except for the first few minutes there
> are no writes.
> 
> Memory usage keeps growing until all the memory (24 Gb) is used in a
> few hours. Eventually the system will crash with out of memory errors.

Are you using qgroup/quota?

IIRC qgroup for subvolume deletion will cause full subtree rescan which 
can cause tons of memory.

Thanks,
Qu

> 
> The CPU load is low (<5%) but iowait is around 30 to 50%
> 
> The drives are mounted but any process that attempts to access them
> will just hang so I cannot access any data on the drives.
> 
> Smartctl does not show any issues with the drives.
> 
> The problem restarts after a reboot once you mount the drives.
> 
> I tried to zero the log hoping it wouldn't restart after a reboot but
> that didn't work
> 
> I am assuming that the attempt to remove the snapshots caused this
> problem.  How do I interrupt the process so I can access the
> filesystem again?
> 
> # uname -a
> Linux Backup 4.10.0-19-generic #21-Ubuntu SMP Thu Apr 6 17:04:57 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> #   btrfs --version
> btrfs-progs v4.9.1
> 
> #   btrfs fi show
> Label: none  uuid: 79ba7374-bf77-4868-bb64-656ff5736c44
>          Total devices 6 FS bytes used 5.65TiB
>          devid    1 size 1.82TiB used 1.29TiB path /dev/sdb
>          devid    2 size 1.82TiB used 1.29TiB path /dev/sdc
>          devid    3 size 1.82TiB used 1.29TiB path /dev/sdd
>          devid    4 size 1.82TiB used 1.29TiB path /dev/sde
>          devid    5 size 3.64TiB used 3.11TiB path /dev/sdf
>          devid    6 size 3.64TiB used 3.11TiB path /dev/sdg
> 
> # btrfs fi df /pubroot
> Data, RAID1: total=5.58TiB, used=5.58TiB
> System, RAID1: total=32.00MiB, used=828.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=104.00GiB, used=70.64GiB
> GlobalReserve, single: total=512.00MiB, used=28.51MiB
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


