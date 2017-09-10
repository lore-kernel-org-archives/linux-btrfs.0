Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34474 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdIJNqY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 09:46:24 -0400
Received: by mail-pf0-f178.google.com with SMTP id e1so10571713pfk.1
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Sep 2017 06:46:23 -0700 (PDT)
MIME-Version: 1.0
From: FLJ <feci2048@gmail.com>
Date: Sun, 10 Sep 2017 15:45:42 +0200
Message-ID: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
Subject: Help me understand what is going on with my RAID1 FS
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I have a BTRFS RAID1 volume running for the past year. I avoided all
pitfalls known to me that would mess up this volume. I never
experimented with quotas, no-COW, snapshots, defrag, nothing really.
The volume is a RAID1 from day 1 and is working reliably until now.

Until yesterday it consisted of two 3 TB drives, something along the lines:

Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
        Total devices 2 FS bytes used 2.47TiB
        devid    1 size 2.73TiB used 2.47TiB path /dev/sdb
        devid    2 size 2.73TiB used 2.47TiB path /dev/sdc

Yesterday I've added a new drive to the FS and did a full rebalance
(without filters) over night, which went through without any issues.

Now I have:
 Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
        Total devices 3 FS bytes used 2.47TiB
        devid    1 size 2.73TiB used 1.24TiB path /dev/sdb
        devid    2 size 2.73TiB used 1.24TiB path /dev/sdc
        devid    3 size 7.28TiB used 2.48TiB path /dev/sda

# btrfs fi df /mnt/BigVault/
Data, RAID1: total=2.47TiB, used=2.47TiB
System, RAID1: total=32.00MiB, used=384.00KiB
Metadata, RAID1: total=4.00GiB, used=2.74GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

But still df -h is giving me:
Filesystem           Size  Used Avail Use% Mounted on
/dev/sdb             6.4T  2.5T  1.5T  63% /mnt/BigVault

Although I've heard and read about the difficulty in reporting free
space due to the flexibility of BTRFS, snapshots and subvolumes, etc.,
but I only have a single volume, no subvolumes, no snapshots, no
quotas and both data and metadata are RAID1.

My expectation would've been that in case of BigVault Size == Used + Avail.

Actually based on http://carfax.org.uk/btrfs-usage/index.html I
would've expected 6 TB of usable space. Here I get 6.4 which is odd,
but that only 1.5 TB is available is even stranger.

Could anyone explain what I did wrong or why my expectations are wrong?

Thank you in advance
