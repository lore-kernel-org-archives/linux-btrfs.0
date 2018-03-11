Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:42314 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932136AbeCKQ2u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Mar 2018 12:28:50 -0400
Received: by mail-qk0-f169.google.com with SMTP id q3so1097049qke.9
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Mar 2018 09:28:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: a.t.hild@gmail.com
From: Andreas Hild <a.t.hild@gmail.com>
Date: Sun, 11 Mar 2018 23:28:08 +0700
Message-ID: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
Subject: Raid1 volume stuck as read-only: How to dump, recreate and restore
 its content?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

Following a physical disk failure of a RAID1 array, I tried to mount
the remaining volume of a root partition with "-o degraded". For some
reason it ended up as read-only as described here:
https://btrfs.wiki.kernel.org/index.php/Gotchas#raid1_volumes_only_mountable_once_RW_if_degraded


How to precisely do this: dump, recreate and restore its contents?
Could someone please provided more details how to recover this volume
safely?

Device 4 is missing as shown below. /dev/sda4 is a new disk available
now. I'm currently using a live disk to recover this root volume.

Many thanks!

Best wishes,
-Andreas


  *uname -a
Linux debian 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3 (2017-12-03) x86_64 GNU/Linux

  *btrfs --version
btrfs-progs v4.7.3

  *btrfs fi show
warning, device 4 is missing
Label: none  uuid: ce222f62-b31b-44d6-94ac-79de595325be
    Total devices 2 FS bytes used 27.55GiB
    devid    1 size 50.00GiB used 35.31GiB path /dev/sdb2
    *** Some devices missing

Label: none  uuid: f946ebb5-bdf9-43f4-8252-5c2d997f7021
    Total devices 1 FS bytes used 146.54GiB
    devid    1 size 407.69GiB used 153.16GiB path /dev/sdb3

Label: none  uuid: 9e312f97-b2f5-4a53-9fd0-b4fc65653dd1
    Total devices 1 FS bytes used 384.00KiB
    devid    1 size 50.00GiB used 2.02GiB path /dev/sda4

  *dmesg > dmesg.log
[ 1193.006992] BTRFS error (device sda4): unable to start balance with
target data profile 16
[ 1312.905264] BTRFS info (device sdb2): allowing degraded mounts
[ 1312.905271] BTRFS info (device sdb2): disk space caching is enabled
[ 1312.905275] BTRFS info (device sdb2): has skinny extents
[ 1312.907400] BTRFS warning (device sdb2): devid 4 uuid
18d9aa16-4543-41fa-90c8-560944e61b2c is missing
[ 1312.957486] BTRFS info (device sdb2): bdev (null) errs: wr
120118005, rd 38429879, flush 8815049, corrupt 0, gen 0
[ 1313.279140] BTRFS warning (device sdb2): missing devices (1)
exceeds the limit (0), writeable mount is not allowed
[ 1313.312077] BTRFS error (device sdb2): open_ctree failed
