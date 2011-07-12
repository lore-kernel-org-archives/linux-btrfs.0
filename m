From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: after mounting with -o degraded: ioctl: LOOP_CLR_FD: Device or
 resource busy
Date: Tue, 12 Jul 2011 02:47:41 +0200
Message-ID: <CAJ1PRS=uL3xyJi57xz1taqh1mOYLUJDSRzUs3LsGBx7UVBG=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

dd if=/dev/null of=img5 bs=1 seek=2G
dd if=/dev/null of=img6 bs=1 seek=2G
mkfs.btrfs -d raid1 -m raid1 img5 img6
losetup /dev/loop4 img5
losetup /dev/loop5 img6
btrfs device scan
mount -t btrfs /dev/loop4 dir
umount dir
losetup -d /dev/loop5
mount -t btrfs -o degraded /dev/loop4 dir
umount dir
losetup -d /dev/loop4
ioctl: LOOP_CLR_FD: Device or resource busy
mkfs.ext3 /dev/loop4
mke2fs 1.39 (29-May-2006)
/dev/loop4 is apparently in use by the system; will not make a filesystem here!

this only happens after mouting with -o degraded. loopback device is
unusable until next reboot
