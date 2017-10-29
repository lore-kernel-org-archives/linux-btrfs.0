Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40729 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbdJ2DU4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Oct 2017 23:20:56 -0400
Message-Id: <1509247255.1470208.1154302000.6571EE79@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com>
 <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <1509174195.600847.1153723936.0D8751F2@webmail.messagingengine.com>
 <8cff4fc5-6a33-e076-bfdb-d40dca8023ed@gmx.com>
Subject: Re: USB upgrade fun
Date: Sun, 29 Oct 2017 11:20:55 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 28 Oct 2017, at 03:58 PM, Qu Wenruo wrote:
> Don't get confused with the name, to use "fix-dev-size" you need to run
> "btrfs rescue fix-dev-size"

[hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdc1
warning, device 2 is missing
ERROR: devid 2 is missing or not writeable
ERROR: fixing device size needs all device(s) present and writeable
[hendry@nuc btrfs-progs]$ lsblk -f
NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
sda
├─sda1 vfat            0C95-8576                            /boot
└─sda2 btrfs           c5f98288-5ab3-4236-b00e-f2cd15c0616d /
sdb
sdc
└─sdc1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73cdf77
[hendry@nuc btrfs-progs]$ lsblk -f
NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
sda
├─sda1 vfat            0C95-8576                            /boot
└─sda2 btrfs           c5f98288-5ab3-4236-b00e-f2cd15c0616d /
sdb
└─sdb1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73cdf77
sdc
└─sdc1 btrfs  extraid1 5cab2a4a-e282-4931-b178-bec4c73cdf77
[hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdc1
Couldn't setup extent tree
Couldn't setup device tree
ERROR: could not open btrfs
[hendry@nuc btrfs-progs]$ sudo ./btrfs rescue fix-device-size /dev/sdb1
leaf parent key incorrect 1320477425664
ERROR: could not open btrfs
[hendry@nuc btrfs-progs]$ sudo mount -o degraded /dev/sdb1 /mnt/raid1/
mount: /mnt/raid1: wrong fs type, bad option, bad superblock on
/dev/sdb1, missing codepage or helper program, or other error.


Still unable to mount. Damn. Maybe I'm chasing a red herring? Here are
the relevant kernel logs:

Oct 29 10:56:45 nuc kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): allowing degraded
mounts
Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): disk space caching
is enabled
Oct 29 10:57:32 nuc kernel: BTRFS info (device sdc1): has skinny extents
Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): super_total_bytes
4000795746304 mismatch with fs_devices total_rw_bytes 4000795749888
Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): failed to read
chunk tree: -22
Oct 29 10:57:33 nuc kernel: BTRFS error (device sdc1): open_ctree failed


Nonetheless if I reboot to 4.4, I can still mount. However my root is
bizarrely out of space or inodes so journalctl et al is unusable.


Kind regards,
