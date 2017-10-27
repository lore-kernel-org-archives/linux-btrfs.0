Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ble59-2-81-56-123-40.fbx.proxad.net ([81.56.123.40]:49776 "EHLO
        jmuchemb.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752842AbdJ0Ws6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 18:48:58 -0400
Received: from [10.236.3.1] (tecra [10.236.3.1])
        by jmuchemb.eu (Postfix) with ESMTP id E3E7C142B25
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Oct 2017 00:40:10 +0200 (CEST)
From: Julien Muchembled <jm@jmuchemb.eu>
Subject: raid1: can't readd removed dev while the fs is mounted
To: linux-btrfs@vger.kernel.org
Message-ID: <1e230313-112b-c685-f02b-e99cdcb287a8@jmuchemb.eu>
Date: Sat, 28 Oct 2017 00:40:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have 2 disks in RAID1, each one having 2 partitions:
- 1 for / (BtrFS)
- 1 for /home (MD/XFS)

For some reasons, 1 disk was removed and readded. I had no issue at readding it to the MD array, but for BtrFS, I had to reboot.

Then, I tried to investigate more using qemu with systemrescuecd (kernel 4.9.30 and btrfs-progs v4.9.1). From:

  /sys/devices/pci0000:00/0000:00:01.1/ata1/host0

I use:

  # echo 1 > target0:0:1/0:0:1:0/delete

to remove sdb and after some changes in the mount point:

  # echo '- - -' > scsi_host/host0/scan

to readd it.

Then I executed

  # btrfs scrub start -B -d /mnt/tmp 

to fix things but I only get uncorrectable errors and the dmesg is full of 'i/o error' lines

Maybe some command is required so that BtrFS accept to reuse the device. I tried:

  # btrfs replace start -B -f 2 /dev/sdb /mnt/tmp
  ERROR: ioctl(DEV_REPLACE_STATUS) failed on "/mnt/tmp": Inappropriate ioctl for device

Julien
