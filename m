Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46167 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbaF3GmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 02:42:04 -0400
Message-ID: <53B105BD.4010907@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 14:37:49 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Florian Lindner <mailinglists@xgm.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub being stuck
References: <lophhk$nj1$2@ger.gmane.org>
In-Reply-To: <lophhk$nj1$2@ger.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2014 01:14 AM, Florian Lindner wrote:
> Hello,
>
> I've just completed a scrub on my home filesystem and now I wanted to start
> on my Archiv btrfs RAID 0.
>
> root@horus ~ # uname -
> a
> Linux horus 3.15.2-1-ARCH #1 SMP PREEMPT Fri Jun 27 07:41:19 CEST 2014
> x86_64 GNU/Linux
>
> root@horus ~ # btrfs --version
> Btrfs v3.14.2-dirty
>
> root@horus ~ # btrfs fi show
> Label: 'home'  uuid: 571009c0-6cc4-4598-a77b-f175501d23fd
>          Total devices 1 FS bytes used 2.03TiB
>          devid    1 size 2.73TiB used 2.04TiB path /dev/sdb1
>
> Label: 'Archiv'  uuid: b2504193-efeb-4ef3-8797-a8d73536a416
>          Total devices 2 FS bytes used 5.14TiB
>          devid    1 size 2.73TiB used 2.73TiB path /dev/sdd1
>          devid    2 size 2.73TiB used 2.73TiB path /dev/sde1
>
> Btrfs v3.14.2-dirty
>
> root@horus ~ # btrfs fi df /mnt/Archiv
> Data, RAID0: total=5.44TiB, used=5.13TiB
> Data, single: total=8.00MiB, used=244.00KiB
> System, RAID1: total=32.00MiB, used=396.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=10.94GiB, used=8.71GiB
> unknown, single: total=512.00MiB, used=0.00
>
> root@horus ~ # btrfs scrub status /mnt/Archiv
> scrub status for b2504193-efeb-4ef3-8797-a8d73536a416
>          scrub started at Thu Jan  2 21:13:35 2014, running for 1336 seconds
>          total bytes scrubbed: 473.28GiB with 0 errors
>
> root@horus ~ # btrfs scrub cancel /mnt/Archiv
> ERROR: scrub cancel failed on /mnt/Archiv: not running
>
> root@horus ~ # btrfs scrub resume
> /mnt/Archiv
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /mnt/Archiv'.
> To see the status use 'btrfs scrub status [-d] /mnt/Archiv'.
>
> root@horus ~ # btrfs scrub start
> /mnt/Archiv
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /mnt/Archiv'.
> To see the status use 'btrfs scrub status [-d] /mnt/Archiv'.
>
>
> A scrub I started at Jan 02 seems to be stuck somehow. The command outputs
> above were generated right now.
>
> I'll be hapy to provide any more information.
>
> Thx!
>
> Florian
Scrub log record file seems corrupted sometimes, if you use latest 
btrfs-progs version.
There should be an option '-f' for 'btrfs scrub start' which will allow 
scrub to skip check in userspace.

Actually, i am thinking whether it would be better to remove userspace 
check about
scrub status since log record file is not so reliable.

Thanks,
Wang
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

