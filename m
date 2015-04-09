Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34844 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbbDIQDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 12:03:31 -0400
Received: by wgyo15 with SMTP id o15so114416300wgy.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 09:03:30 -0700 (PDT)
Received: from [192.168.2.3] (p4FF79CD5.dip0.t-ipconnect.de. [79.247.156.213])
        by mx.google.com with ESMTPSA id a6sm20744217wiy.17.2015.04.09.09.03.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2015 09:03:29 -0700 (PDT)
Message-ID: <5526A2D0.2030103@lianse.eu>
Date: Thu, 09 Apr 2015 18:03:28 +0200
From: =?UTF-8?B?QW5kcsOpLVNlYmFzdGlhbiBMaWViZQ==?= <andre@lianse.eu>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem resize <ID>:max not working
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey list,

I've got a problem with resizing a multi drive filesystem.
I had a 5 disk array of 4TB drives. Then I added a 5th (6TB) drive to
the array and replaced one of the 4TB ones with a 6TB drive. As you can
see in my `btrfs fi sh` output below, my newly added drive (ID=6) has
the expected size of 5.46TiB, but my replaced drive (ID=4) won't show up
as 6TB as expected. Neither a `btrfs fi res max /data/pool0` nor a
`btrfs fi res 4:max /data/pool0` had any effect.

Any suggestions how to reclaim the 2TB free space of drive 4?


Thanks in advance

André-Sebastian Liebe


> Kernel:Linux apc01 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02
CET 2015 x86_64 GNU/Linux
> btrfs-progs: btrfs-progs v3.19

My 6 drives used by the apc01_pool (none of them has a partition table)
Konsole output
> # hdparm -I /dev/sdb | grep "device size"           
>        device size with M = 1024*1024:     3815447 MBytes
>        device size with M = 1000*1000:     4000787 MBytes (4000 GB)
> # hdparm -I /dev/sdc | grep "device size"  
>        device size with M = 1024*1024:     3815447 MBytes
>        device size with M = 1000*1000:     4000787 MBytes (4000 GB)
> # hdparm -I /dev/sdd | grep "device size"  
>        device size with M = 1024*1024:     3815447 MBytes
>        device size with M = 1000*1000:     4000787 MBytes (4000 GB)
> # hdparm -I /dev/sde | grep "device size"  
>        device size with M = 1024*1024:     3815447 MBytes
>        device size with M = 1000*1000:     4000787 MBytes (4000 GB)
> # hdparm -I /dev/sdf | grep "device size"  
>        device size with M = 1024*1024:     5723166 MBytes
>        device size with M = 1000*1000:     6001175 MBytes (6001 GB)
> # hdparm -I /dev/sdg | grep "device size"  
>        device size with M = 1024*1024:     5723166 MBytes
>        device size with M = 1000*1000:     6001175 MBytes (6001 GB)


btrfs filesystem:
Konsole output
> # btrfs fi sh
> Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
>        Total devices 6 FS bytes used 23.43TiB
>        devid    1 size 3.64TiB used 3.61TiB path /dev/sdd
>        devid    2 size 3.64TiB used 3.61TiB path /dev/sdc
>        devid    3 size 3.64TiB used 3.61TiB path /dev/sde
>        devid    4 size 3.64TiB used 3.61TiB path /dev/sdg
>        devid    5 size 3.64TiB used 3.61TiB path /dev/sdb
>        devid    6 size 5.46TiB used 5.43TiB path /dev/sdf



