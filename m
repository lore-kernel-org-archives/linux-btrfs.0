Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44608 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaGGNzO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 09:55:14 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so4424125wes.23
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 06:55:13 -0700 (PDT)
Message-ID: <53BAA67D.1050101@gmail.com>
Date: Mon, 07 Jul 2014 16:54:05 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?Q?Andr=c3=a9-Sebastian_Liebe?= <andre@lianse.eu>,
        linux-btrfs@vger.kernel.org
Subject: Re: mount time of multi-disk arrays
References: <53BAA2E5.2090801@lianse.eu>
In-Reply-To: <53BAA2E5.2090801@lianse.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/7/2014 4:38 μμ, André-Sebastian Liebe wrote:
> Hello List,
>
> can anyone tell me how much time is acceptable and assumable for a
> multi-disk btrfs array with classical hard disk drives to mount?
>
> I'm having a bit of trouble with my current systemd setup, because it
> couldn't mount my btrfs raid anymore after adding the 5th drive. With
> the 4 drive setup it failed to mount once in a few times. Now it fails
> everytime because the default timeout of 1m 30s is reached and mount is
> aborted.
> My last 10 manual mounts took between 1m57s and 2m12s to finish.
I have the exact same problem, and have to manually mount my large 
multi-disk btrfs filesystems, so I would be interested in a solution as 
well.

>
> My hardware setup contains a
> - Intel Core i7 4770
> - Kernel 3.15.2-1-ARCH
> - 32GB RAM
> - dev 1-4 are 4TB Seagate ST4000DM000 (5900rpm)
> - dev 5 is a 4TB Wstern Digital WDC WD40EFRX (5400rpm)
>
> Thanks in advance
>
> André-Sebastian Liebe
> --------------------------------------------------------------------------------------------------
>
> # btrfs fi sh
> Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
>          Total devices 5 FS bytes used 14.21TiB
>          devid    1 size 3.64TiB used 2.86TiB path /dev/sdd
>          devid    2 size 3.64TiB used 2.86TiB path /dev/sdc
>          devid    3 size 3.64TiB used 2.86TiB path /dev/sdf
>          devid    4 size 3.64TiB used 2.86TiB path /dev/sde
>          devid    5 size 3.64TiB used 2.88TiB path /dev/sdb
>
> Btrfs v3.14.2-dirty
>
> # btrfs fi df /data/pool0/
> Data, single: total=14.28TiB, used=14.19TiB
> System, RAID1: total=8.00MiB, used=1.54MiB
> Metadata, RAID1: total=26.00GiB, used=20.20GiB
> unknown, single: total=512.00MiB, used=0.00
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Konstantinos Skarlatos

