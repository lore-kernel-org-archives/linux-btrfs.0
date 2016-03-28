Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33331 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbcC1IFM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 04:05:12 -0400
Received: by mail-oi0-f50.google.com with SMTP id d205so161808659oia.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 01:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r0EDazr3755UBr0XvNsExQ5bn0aKg2B0YPPLTixwa1sPQ@mail.gmail.com>
References: <CAEtw4r0EDazr3755UBr0XvNsExQ5bn0aKg2B0YPPLTixwa1sPQ@mail.gmail.com>
Date: Mon, 28 Mar 2016 10:05:10 +0200
Message-ID: <CAGGqMYTE+Ev5CjJBLMq0beg1tOP2J1RsTZz5mB9rE-WZ8rLXeA@mail.gmail.com>
Subject: Re: btrfs filesystem du - Failed to lookup root id - Inappropriate
 ioctl for device
From: Alexander Fougner <fougner89@gmail.com>
To: Peter Becker <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-27 22:26 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> Hi i found the descriped error in if i execute du with btrfs-progs
> v4.5 with kernel v4.5.
>
> floyd@nas ~ $ sudo btrfs version
> btrfs-progs v4.5
>
> floyd@nas ~ $ uname -r
> 4.5.0-040500-generic
>
> floyd@nas ~ $ sudo btrfs fi show
> Label: 'RAID'  uuid: 3247737b-87f9-4e8c-8db3-2beed50fb104
> Total devices 4 FS bytes used 3.71TiB
> devid    1 size 2.73TiB used 1.40TiB path /dev/sdf
> devid    2 size 2.73TiB used 1.40TiB path /dev/sdb
> devid    3 size 2.73TiB used 1.40TiB path /dev/sde
> devid    4 size 4.55TiB used 3.22TiB path /dev/sdd
>
> Label: 'BACKUP'  uuid: 35e6ff5f-2612-4ef2-9cdb-07b3ccd0f517
> Total devices 1 FS bytes used 27.29GiB
> devid    1 size 1.36TiB used 29.06GiB path /dev/sdc
>
> floyd@nas ~ $ sudo btrfs subv list -o /media/RAID/
> ID 258 gen 214551 top level 5 path apps
> ID 259 gen 214722 top level 5 path downloads
> ID 260 gen 214711 top level 5 path filme
> ID 261 gen 214553 top level 5 path misc
> ID 262 gen 214722 top level 5 path musik
> ID 263 gen 214555 top level 5 path owncloud
> ID 264 gen 214556 top level 5 path serien
>
> -- now the error --
>
> floyd@nas ~ $ sudo btrfs fi du /media/RAID/
>      Total   Exclusive  Set shared  Filename
>  500.00KiB       0.00B           -  /media/RAID//apps/Drive Snapshot
>  167.96MiB       0.00B           -  /media/RAID//apps/vmware
>  .. [46 rows] ..
> ERROR: cannot check space of '/media/RAID/': Unknown error -1
>
> floyd@nas ~ $ sudo btrfs fi du /media/RAID/apps
>      Total   Exclusive  Set shared  Filename
>  500.00KiB       0.00B           -  /media/RAID//apps/Drive Snapshot
>  167.96MiB       0.00B           -  /media/RAID//apps/vmware
>  .. [46 rows] ..
> ERROR: cannot check space of '/media/RAID/': Unknown error -1
>
> floyd@nas ~ $ sudo btrfs fi du /media/RAID/musik
> ERROR: cannot check space of '/media/RAID/': Unknown error -1
>

Fixed in btrfs-progs devel branch. Will probably be released as a 4.5.1 soon.

> but for subvolume "downloads" it finished without error
>
> floyd@nas ~ $ sudo btrfs fi du /media/RAID/
>      Total   Exclusive  Set shared  Filename
>  500.00KiB       0.00B           -  /media/RAID//apps/Drive Snapshot
>  167.96MiB       0.00B           -  /media/RAID//apps/vmware
>  ..
>
> -- more details --
>
> floyd@nas ~ $ sudo btrfs inspect-internal rootid /media/RAID/
> 5
>
> floyd@nas ~ $ sudo btrfs inspect-internal rootid /media/RAID/apps/
> 258
>
> floyd@nas ~ $ sudo btrfs inspect-internal dump-super
> /media/RAID/apps/Drive\ Snapshot/snapshot.exe
> superblock: bytenr=65536, device=/media/RAID/apps/Drive Snapshot/snapshot.exe
> ---------------------------------------------------------
> ERROR: bad magic on superblock on /media/RAID/apps/Drive
> Snapshot/snapshot.exe at 65536

dump-super takes a device as argument, not mountpoints.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
