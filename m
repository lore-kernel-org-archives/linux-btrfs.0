Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:56129 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbdGMGkQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 02:40:16 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dVXnI-0002Qd-7P
        for linux-btrfs@vger.kernel.org; Thu, 13 Jul 2017 08:40:12 +0200
Date: Thu, 13 Jul 2017 08:40:12 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: degraded raid scribbling upon wrong device
Message-ID: <20170713064011.gweixjxdrq3gjc23@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qgpg6w7rpaeebbus"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qgpg6w7rpaeebbus
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi!
Here's a set of test cases, two of them in some cases seem to scribble upon
the wrong device:

* deg-mid-missing
* deg-last-replaced (not on the innocent "re")
* but never deg-last-missing

When all goes ok, there are no errors other than wrong generation on the
re-added disk (expected).   When it goes bad, there's a lot of corruption.
In all cases, though, the "Device missing:" field is wrong.

I'm not yet sure how to trigger this, perhaps someone would have a clue?

8:30am, hitting the sack, will try again todorrow.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.

--qgpg6w7rpaeebbus
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=deg-mid-missing

#!/bin/sh
set -e
set -x

umount /mnt/vol1 ||:
losetup -D

dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rc
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rd

mkfs.btrfs -draid1 -mraid1 ra rb rc rd

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
cp -pr /bin /mnt/vol1
btrfs fi sync /mnt/vol1
btrfs fi us /mnt/vol1
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rd
sleep 1
mount -odegraded /dev/loop0 /mnt/vol1
btrfs fi us /mnt/vol1
dd if=/dev/zero of=/mnt/vol1/foo bs=1048576 count=2222
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
btrfs scrub start -B /mnt/vol1

--qgpg6w7rpaeebbus
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=deg-last-missing

#!/bin/sh
set -e
set -x

umount /mnt/vol1 ||:
losetup -D

dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rc
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rd

mkfs.btrfs -draid1 -mraid1 ra rb rc rd

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
cp -pr /bin /mnt/vol1
btrfs fi sync /mnt/vol1
btrfs fi us /mnt/vol1
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
sleep 1
mount -odegraded /dev/loop0 /mnt/vol1
btrfs fi us /mnt/vol1
dd if=/dev/zero of=/mnt/vol1/foo bs=1048576 count=2222
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
btrfs scrub start -B /mnt/vol1

--qgpg6w7rpaeebbus
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=deg-last-replaced

#!/bin/sh
set -e
set -x

umount /mnt/vol1 ||:
losetup -D

dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rc
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rd
dd if=/dev/zero bs=1048576 count=1 seek=4095 of=re

mkfs.btrfs -draid1 -mraid1 ra rb rc rd

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
cp -pr /bin /mnt/vol1
btrfs fi sync /mnt/vol1
btrfs fi us /mnt/vol1
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f re
sleep 1
mount -odegraded /dev/loop0 /mnt/vol1
btrfs fi us /mnt/vol1
dd if=/dev/zero of=/mnt/vol1/foo bs=1048576 count=2222
umount /mnt/vol1

losetup -D
losetup -f ra
losetup -f rb
losetup -f rc
losetup -f rd
sleep 1
mount /dev/loop0 /mnt/vol1
btrfs scrub start -B /mnt/vol1

--qgpg6w7rpaeebbus--
