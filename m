Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39221 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3G1C7K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 22:59:10 -0400
Received: by mail-oa0-f44.google.com with SMTP id l20so7121269oag.3
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jul 2013 19:59:09 -0700 (PDT)
MIME-Version: 1.0
From: Kyriakos <kyriakosbrastianos@gmail.com>
Date: Sun, 28 Jul 2013 05:58:49 +0300
Message-ID: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com>
Subject: Recovering from btrfs error Couldn't read chunk root.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentally dd'ed the wrong disc /dev/sdb when it should be
/dev/sdc but i stopped in something like 2 sec. and a small part of my
2tb disc was overwritten with openSUSE  milestone 3 the ruby baked
yast flavor :).

I was able to see, access and use my data in the /dev/sdb disc, but
not after the reboot, so at the moment unsuccessfully am trying to
mount with different options like:

mount -t btrfs -o compress=lzo /dev/sdb /mnt/Kyrios
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

Or
mount /dev/sdb /mnt/Kyrios
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
Or
mount -t /dev/sdb /mnt/Kyrios
mount: can't find /mnt/Kyrios in /etc/fstab

Or
mount -t btrfs -o compress=lzo /dev/sdb /mnt/Kyrios
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so

LABEL=btrfs /mnt/Kyrios btrfs noatime, compress=lzo 0 0
bash: /mnt/Kyrios: Is a directory

btrfs subvolume list /mnt/Kyrios/Media
ERROR: error accessing '/mnt/Kyrios/Media'

My btrfs fi show output:
failed to read /dev/sr0
Label: 'Kyrios'  uuid: b5d84724-f93a-4478-a3eb-3c45c7e5ac72
        Total devices 1 FS bytes used 1.57TB
        devid    1 size 1.82TB used 1.58TB path /dev/sdb

My btrfs fi df output:
btrfs fi df /dev/sdb
ERROR: couldn't get space info on '/dev/sdb' - Inappropriate ioctl for device

My btrfsck output:
btrfsck /dev/sdb
Check tree block failed, want=20971520, have=14982790533290893935
Check tree block failed, want=20971520, have=14982790533290893935
Check tree block failed, want=20971520, have=15644090216945910062
Check tree block failed, want=20971520, have=14982790533290893935
Check tree block failed, want=20971520, have=14982790533290893935
read block failed check_tree_block
Couldn't read chunk root
Segmentation fault (core dumped)

My blkid output:
/dev/sdb: LABEL="Kyrios" UUID="b5d84724-f93a-4478-a3eb-3c45c7e5ac72"
UUID_SUB="22a11e2f-7347-4aee-b490-9d9a8f3b9425" TYPE="btrfs"
/dev/sda1: UUID="A270FB3270FB0C33" TYPE="ntfs"
/dev/sda2: LABEL="Swap" UUID="517fc7b8-3b92-4f21-8761-4ffb8af74e0d" TYPE="swap"
/dev/sda3: UUID="e3be6b5b-0d8c-4731-bfe1-10510fd50b79" TYPE="ext4"

dmesg output:
btrfs loaded
device label Kyrios devid 1 transid 38257 /dev/sdb
btrfs: use lzo compression
btrfs: disk space caching is enabled
btrfs bad tree block start 14982790533290893935 20971520
btrfs bad tree block start 15644090216945910062 20971520
btrfs: failed to read chunk root on sdb

mnt-Kyrios.mount mount process exited status=32
failed to mount /mnt/Kyrios defined by systemd
dependency failed for local file systems unit local-fs.target has
failed unit mnt-Kyrios.mount entered failed state.

Useful info:
I am using btrfs-progs 0.20 rc1 and kernel 3.9.2
The whole (1.8TB) disc is pure btrfs with no gpt or other formats like
ext4 is just created by mkfs.btrfs /dev/sdb and all my files are in
subvolumes Root, Media, Home, Opt, etc.

What i did till now was to use wipefs and delete the opensuse and the
dos filesystems that were created by the dd command on top of the pure
btrfs disc. Before i use the wipefs i wasnt able to see sdb btrfs info
at all with blkid command but now i can as can confirm the blkid
output above. At the moment i play with etc/fstab but adding the line:
UUID=b5d84724-f93a-4478-a3eb-3c45c7e5ac72    /mnt/Kyrios    btrfs
defaults,compress=lzo    0    1

Or
/dev/sdb /mnt               btrfs   defaults,compress=lzo 0       1

leaves my system unbootable and asks me to see the journalctl

Not sure what i do next. Can anyone spot the error? How can i fix it?


Big headache with lots of valuable data (no i did not use snapper for
backup as was a new disc migration and left it for a month in the back
of my mind:()

Any help will be appreciated.
