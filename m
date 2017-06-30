Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32952 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdF3JZp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 05:25:45 -0400
Received: by mail-wm0-f46.google.com with SMTP id z75so23774239wmc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 02:25:44 -0700 (PDT)
MIME-Version: 1.0
From: Darryl Barlow <darryl@barlow.com.au>
Date: Fri, 30 Jun 2017 09:25:43 +0000
Message-ID: <CALfAoZ9kP4QboGwn9bEC2dgPUX0bHC5UmJEPvY-mGSE-Zu90aA@mail.gmail.com>
Subject: Cannot mount btrfs file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been running btrfs without problems for years on an up to date
Sabayon Linux.  The btrfs filesystem is on a luks encrypted partition
sdb4, and indludes subvolumes for root, home and swap  Following the
latest upgrade to the Distro I shut the machine down.  When I cae to
reboot it failed to mount it decrypted the partition okay but could
not mount the filesystem.

I have tried some options booting using a manjaro linux (arch) live
usb.  The partitions succesfully decrypts resulting in
/dev/mapper/sdb4.

Any assistance would be much appreciated.

Details as follows:


Trying to mount this partition fails with the followin errors in dmesg:

[manjaro@manjaro ~]$ dmesg | grep -i btrfs
[  371.524030] Btrfs loaded, crc32c=crc32c-intel
[  371.534265] BTRFS: device label sa_sabayon devid 1 transid 1407824 /dev/dm-0
[  418.691592] BTRFS info (device dm-0): disk space caching is enabled
[  422.606271] BTRFS error (device dm-0): failed to read chunk root
[  422.643907] BTRFS error (device dm-0): open_ctree failed

btrfs restore gives teh following terminal output:

[manjaro@manjaro ~]$ sudo btrfs restore -l /dev/mapper/sdb4
bytenr mismatch, want=20971520, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super
bytenr mismatch, want=20971520, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super
bytenr mismatch, want=20971520, have=0
ERROR: cannot read chunk root
Could not open root, trying backup super

Other information (from live usb)

[manjaro@manjaro ~]$ uname -a
Linux manjaro 4.9.13-1-MANJARO #1 SMP PREEMPT Sun Feb 26 13:27:28 UTC
2017 x86_64 GNU/Linux

[manjaro@manjaro ~]$ btrfs --version
btrfs-progs v4.9.1

[manjaro@manjaro ~]$ sudo btrfs fi show
Label: 'sa_sabayon'  uuid: 725ef5b2-e35e-4868-87b3-abea02171364
        Total devices 1 FS bytes used 817.91GiB
        devid    1 size 923.07GiB used 838.04GiB path /dev/mapper/sdb4

A chunk recovery produces the following terminal output:

[manjaro@manjaro ~]$ sudo btrfs rescue chunk-recover -v /dev/mapper/sdb4
All Devices:
        Device: id = 1, name = /dev/mapper/sdb4

Scanning: DONE in dev0
DEVICE SCAN RESULT:
Filesystem Information:
        sectorsize: 4096
        nodesize: 16384
        tree root generation: 1407824
        chunk root generation: 1407235

All Devices:
        Device: id = 1, name = /dev/mapper/sdb4

All Block Groups:
        Block Group: start = 0, len = 4194304, flag = 2
        Block Group: start = 4194304, len = 8388608, flag = 4
        Block Group: start = 12582912, len = 8388608, flag = 1

All Chunks:
        Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
            Stripes list:
            [ 0] Stripe: devid = 1, offset = 0
        Chunk: start = 4194304, len = 8388608, type = 4, num_stripes = 1
            Stripes list:
            [ 0] Stripe: devid = 1, offset = 4194304
        Chunk: start = 12582912, len = 8388608, type = 1, num_stripes = 1
            Stripes list:
            [ 0] Stripe: devid = 1, offset = 12582912

All Device Extents:
        Device extent: devid = 1, start = 0, len = 4194304, chunk offset = 0
        Device extent: devid = 1, start = 4194304, len = 8388608,
chunk offset = 4194304
        Device extent: devid = 1, start = 12582912, len = 8388608,
chunk offset = 12582912

CHECK RESULT:
Recoverable Chunks:
  Chunk: start = 0, len = 4194304, type = 2, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 0
      Block Group: start = 0, len = 4194304, flag = 2
      Device extent list:
          [ 0]Device extent: devid = 1, start = 0, len = 4194304,
chunk offset = 0
  Chunk: start = 4194304, len = 8388608, type = 4, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 4194304
      Block Group: start = 4194304, len = 8388608, flag = 4
      Device extent list:
          [ 0]Device extent: devid = 1, start = 4194304, len =
8388608, chunk offset = 4194304
  Chunk: start = 12582912, len = 8388608, type = 1, num_stripes = 1
      Stripes list:
      [ 0] Stripe: devid = 1, offset = 12582912
      Block Group: start = 12582912, len = 8388608, flag = 1
      Device extent list:
          [ 0]Device extent: devid = 1, start = 12582912, len =
8388608, chunk offset = 12582912
Unrecoverable Chunks:

Total Chunks:           3
  Recoverable:          3
  Unrecoverable:        0

Orphan Block Groups:

Orphan Device Extents:

Check chunks successfully with no orphans
Chunk tree recovered successfully


Then tryting to mount on /mnt results as follows:

[manjaro@manjaro ~]$ sudo mount /dev/mapper/sdb4 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/mapper/sdb4,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so

dmesg result:

[manjaro@manjaro ~]$ dmesg | grep -i btrfs
[  371.524030] Btrfs loaded, crc32c=crc32c-intel
[  371.534265] BTRFS: device label sa_sabayon devid 1 transid 1407824 /dev/dm-0
[  418.691592] BTRFS info (device dm-0): disk space caching is enabled
[  422.606271] BTRFS error (device dm-0): failed to read chunk root
[  422.643907] BTRFS error (device dm-0): open_ctree failed
[ 2644.564748] BTRFS info (device dm-0): disk space caching is enabled
[ 2648.453669] BTRFS error (device dm-0): failed to read chunk root
[ 2648.476572] BTRFS error (device dm-0): open_ctree failed
