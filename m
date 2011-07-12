From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: raid1
Date: Tue, 12 Jul 2011 02:22:37 +0200
Message-ID: <CAJ1PRSkz86G+4XfDMp1fq8f7ar5LOPux06FJTQ4WxhkT1Bu6vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I wanted to confirm that btrfs will continue to work on raid1 when one
of devices will be gone.

dd if=/dev/null of=img0 bs=1 seek=2G
dd if=/dev/null of=img1 bs=1 seek=2G
mkfs.btrfs -d raid1 -m raid1 img0 img1
losetup /dev/loop1 img0
losetup /dev/loop2 img1
mkdir dir
mount -t btrfs /dev/loop1 dir
btrfs device scan
mount -t btrfs /dev/loop1 dir
echo abc > dir/a.txt
umount dir
losetup -d /dev/loop2
btrfs device scan
mount -t btrfs /dev/loop1 dir
mount: wrong fs type, bad option, bad superblock on /dev/loop1,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

am I missing some nuance?
