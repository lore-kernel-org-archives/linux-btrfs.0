From: Ravi Pinjala <ravi@p-static.net>
Subject: Mounting multiple regular files as a filesystem
Date: Mon, 15 Jun 2009 00:36:22 -0500
Message-ID: <4A35DDD6.9020307@p-static.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to create a multi-device filesystem on top of regular files
(not actual disks), and mount that to a loopback device. For a
filesystem created on a single file, it works fine, but for a filesystem
across multiple files, it doesn't.



dd if=/dev/zero of=img1 bs=4096 count=65536
dd if=/dev/zero of=img2 bs=4096 count=65536
dd if=/dev/zero of=img3 bs=4096 count=65536
dd if=/dev/zero of=img4 bs=4096 count=65536

mkfs.btrfs img1
mount -o loop -t btrfs img1 /mnt/test # works

mkfs.btrfs img1 img2 img3 img4
mount -o loop -t btrfs img1 /mnt/test # fails



When I try to mount with multiple files, it also prints a message to syslog:

Jun 15 00:32:10 3vil device fsid a147d6b950f66dca-3e2e7f52011c93b0 devid
4 transid 9 /dev/loop/0
Jun 15 00:32:10 3vil btrfs: failed to read chunk tree on loop0
Jun 15 00:32:10 3vil btrfs: open_ctree failed

Am I doing something wrong, or is this use case broken right now?

--Ravi
