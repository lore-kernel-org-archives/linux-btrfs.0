Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35297 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1173105AbdDXP1n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 11:27:43 -0400
Received: by mail-io0-f182.google.com with SMTP id r16so190184606ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Apr 2017 08:27:43 -0700 (PDT)
MIME-Version: 1.0
From: Fred Van Andel <vanandel@gmail.com>
Date: Mon, 24 Apr 2017 08:27:21 -0700
Message-ID: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
Subject: Problem with file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs file system with a few thousand snapshots.  When I
attempted to delete 20 or so of them the problems started.

The disks are being read but except for the first few minutes there
are no writes.

Memory usage keeps growing until all the memory (24 Gb) is used in a
few hours. Eventually the system will crash with out of memory errors.

The CPU load is low (<5%) but iowait is around 30 to 50%

The drives are mounted but any process that attempts to access them
will just hang so I cannot access any data on the drives.

Smartctl does not show any issues with the drives.

The problem restarts after a reboot once you mount the drives.

I tried to zero the log hoping it wouldn't restart after a reboot but
that didn't work

I am assuming that the attempt to remove the snapshots caused this
problem.  How do I interrupt the process so I can access the
filesystem again?

# uname -a
Linux Backup 4.10.0-19-generic #21-Ubuntu SMP Thu Apr 6 17:04:57 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

#   btrfs --version
btrfs-progs v4.9.1

#   btrfs fi show
Label: none  uuid: 79ba7374-bf77-4868-bb64-656ff5736c44
        Total devices 6 FS bytes used 5.65TiB
        devid    1 size 1.82TiB used 1.29TiB path /dev/sdb
        devid    2 size 1.82TiB used 1.29TiB path /dev/sdc
        devid    3 size 1.82TiB used 1.29TiB path /dev/sdd
        devid    4 size 1.82TiB used 1.29TiB path /dev/sde
        devid    5 size 3.64TiB used 3.11TiB path /dev/sdf
        devid    6 size 3.64TiB used 3.11TiB path /dev/sdg

# btrfs fi df /pubroot
Data, RAID1: total=5.58TiB, used=5.58TiB
System, RAID1: total=32.00MiB, used=828.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=104.00GiB, used=70.64GiB
GlobalReserve, single: total=512.00MiB, used=28.51MiB
