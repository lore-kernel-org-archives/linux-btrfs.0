Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34710 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdGFEKn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 00:10:43 -0400
Received: by mail-qk0-f181.google.com with SMTP id d78so6501031qkb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jul 2017 21:10:37 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Brady <drbrady@gmail.com>
Date: Wed, 5 Jul 2017 22:10:35 -0600
Message-ID: <CABRvOkNWpaKB=mAEF9UvUUveFLBQroTWLpC5H=Fqc+okQ_BU3Q@mail.gmail.com>
Subject: Chunk root problem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My system suddenly decided it did not want to mount my BTRFS setup. I
recently rebooted the computer. When it came back, the file system was
in read only mode. I gave it another boot, but now it does not want to
mount at all. Anything I can do to recover? This is a Rockstor setup
that I have had running for about a year.

uname -a
Linux hobonas 4.10.6-1.el7.elrepo.x86_64 #1 SMP Sun Mar 26 12:19:32
EDT 2017 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.10.1

btrfs fi show
Label: 'rockstor_rockstor'  uuid: 33e2af57-c30a-468a-9ed5-22994780f6b4
        Total devices 1 FS bytes used 5.50GiB
        devid    1 size 215.39GiB used 80.02GiB path /dev/sda3

Label: 'Nexus'  uuid: 1c3595a9-3faa-4973-affc-ee8d14d922bf
        Total devices 5 FS bytes used 3.93TiB
        devid    1 size 2.73TiB used 1.12TiB path /dev/sdd
        devid    2 size 2.73TiB used 1.12TiB path /dev/sdb
        devid    3 size 2.73TiB used 1.12TiB path /dev/sdc
        devid    4 size 2.73TiB used 1.12TiB path /dev/sdf
        devid    5 size 2.73TiB used 1.12TiB path /dev/sde

dmesg
[   18.572846] BTRFS: device label Nexus devid 2 transid 595679 /dev/sdb
[   18.572933] BTRFS: device label Nexus devid 3 transid 595679 /dev/sdc
[   18.573027] BTRFS: device label Nexus devid 1 transid 595679 /dev/sdd
[   18.573119] BTRFS: device label Nexus devid 5 transid 595679 /dev/sde
[   18.573200] BTRFS: device label Nexus devid 4 transid 595679 /dev/sdf
[   20.846060] device-mapper: uevent: version 1.0.3
[   20.846114] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23)
initialised: dm-devel@redhat.com
[   21.073884] BTRFS info (device sdf): use no compression
[   21.073886] BTRFS info (device sdf): disk space caching is enabled
[   21.073887] BTRFS info (device sdf): has skinny extents
[   21.084353] BTRFS error (device sdf): parent transid verify failed
on 8419247390720 wanted 542466 found 485869
[   21.230919] BTRFS info (device sdf): bdev /dev/sde errs: wr 402545,
rd 234683174, flush 194501, corrupt 0, gen 0
[   21.794749] BTRFS error (device sdf): parent transid verify failed
on 8939150000128 wanted 594920 found 490791
[   21.841317] BTRFS error (device sdf): parent transid verify failed
on 8939187814400 wanted 594923 found 490824
[   21.870392] BTRFS error (device sdf): parent transid verify failed
on 8418984427520 wanted 594877 found 490575
[   21.951901] BTRFS error (device sdf): parent transid verify failed
on 8939107860480 wanted 594915 found 465207
[   22.015789] BTRFS error (device sdf): parent transid verify failed
on 8939284430848 wanted 594958 found 465274
[   22.034840] BTRFS error (device sdf): parent transid verify failed
on 8418907701248 wanted 594869 found 351596
[   22.070516] BTRFS error (device sdf): parent transid verify failed
on 8939032035328 wanted 594899 found 465175
[   22.091734] BTRFS error (device sdf): parent transid verify failed
on 8939123818496 wanted 594917 found 490777
[   22.110531] BTRFS error (device sdf): parent transid verify failed
on 8939121917952 wanted 594917 found 490775
[   23.393973] BTRFS error (device sdf): failed to read block groups: -5
[   23.419807] BTRFS error (device sdf): open_ctree failed

mount -t btrfs -o recovery,ro /dev/sdb /mnt2/Nexus
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

Thanks,
Dan
