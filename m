Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35489 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbcLFNMI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 08:12:08 -0500
Received: by mail-oi0-f54.google.com with SMTP id b126so376510715oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Dec 2016 05:12:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e0d82d3d-1379-854f-97c2-8a1f1dc7be33@sigma-it.ru>
References: <e0d82d3d-1379-854f-97c2-8a1f1dc7be33@sigma-it.ru>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Tue, 6 Dec 2016 13:12:06 +0000
Message-ID: <CAMU1PDixma3MnxXcJqfPS7gXsESMmg5_e3OFL1Nt7L7y=WQBgQ@mail.gmail.com>
Subject: Re: Free space missing
To: =?UTF-8?B?0JrRgNCw0LLRhtC+0LIg0KDQvtC80LDQvSDQktC70LDQtNC40LzQuNGA0L7QstC40Yc=?=
        <r.kravtsov@sigma-it.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 December 2016 at 12:40, Кравцов Роман Владимирович
<r.kravtsov@sigma-it.ru> wrote:
> Hello.
>
> Why 'BTRFS used size' and 'du -s' are different?
>
>
> [root@OraCI2 ~]# btrfs --version
> btrfs-progs v4.8.3
> [root@OraCI2 ~]# btrfs fi show /dev/nvme0n1
> Label: 'OLD_PES'  uuid: bd542f37-6baa-4af8-b87a-20d4e335e4b3
>     Total devices 1 FS bytes used 2.53TiB
>     devid    1 size 2.91TiB used 2.90TiB path /dev/nvme0n1
> [root@OraCI2 ~]# btrfs fi usage /mnt/OLD/
> Overall:
>     Device size:           2.91TiB
>     Device allocated:           2.90TiB
>     Device unallocated:           9.97GiB
>     Device missing:             0.00B
>     Used:               2.53TiB
>     Free (estimated):         385.31GiB    (min: 385.31GiB)
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:         512.00MiB    (used: 0.00B)
>
> Data,single: Size:2.89TiB, Used:2.53TiB <-------------------------
>    /dev/nvme0n1       2.89TiB
>
> Metadata,single: Size:6.01GiB, Used:3.52GiB
>    /dev/nvme0n1       6.01GiB
>
> System,single: Size:32.00MiB, Used:432.00KiB
>    /dev/nvme0n1      32.00MiB
>
> Unallocated:
>    /dev/nvme0n1       9.97GiB
>
> [root@OraCI2 ~]# df -h | grep nvme0n1
> /dev/nvme0n1                              3,0T         2,6T 386G
> 88% /mnt/OLD
> [root@OraCI2 ~]# du -sh /mnt/OLD/
> 2,0T    /mnt/OLD/    <-------------------------
> [root@OraCI2 ~]#
> /dev/nvme0n1 on /mnt/OLD type btrfs
> (rw,relatime,ssd,discard,space_cache,subvolid=5,subvol=/)
>
> WBR,
> Roman Kravtsov

These entries in the FAQ should help
https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_free_space_do_I_have.3F

Mike
