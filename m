From: Daniel J Blueman <daniel@quora.org>
Subject: 'bad tree block start' mount failure...
Date: Tue, 20 Mar 2012 23:43:34 +0800
Message-ID: <CAMVG2suJw2miSP9QUi-ArFrzS0-okN0_MsLPZTc6Xv7xkjLHDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Booting linux 3.3, I found a particular set of steps [1] produces an
fs which is unmountable [2]. This also occurs when data is written
after mounting, so is entirely possible to hit in practice if RAID-0
is used.

Many thanks,
  Daniel

--- [1]

mkfs.btrfs -m raid0 -d raid0 /dev/sdb1 /dev/sdc1
mount /dev/sdb1 /mnt
umount /mnt
mount /dev/sdb1 /mnt -o compress
umount /mnt
mount /dev/sdb1 /mnt -o ssd
umount /mnt
mount /dev/sdb1 /mnt -o discard
umount /mnt
mount /dev/sdb1 /mnt
<mount failure>

--- [2]

[13259.593809] btrfs bad tree block start 0 37715968
[13259.593832] btrfs: failed to read tree root on sdc1
[13259.594221] btrfs: open_ctree failed
-- 
Daniel J Blueman
