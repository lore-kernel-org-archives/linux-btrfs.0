From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Cannot resize btrfs volume
Date: Wed, 4 May 2011 08:31:30 +0000 (UTC)
Message-ID: <ipr2t2$70c$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I added a new disk into our RAID5 array, it looks like this:

md2 : active raid5 sdd4[3] sde4[4] sda4[0] sdc4[2] sdb4[1]
      3767274240 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

# btrfs fi sh
Label: none  uuid: 5534d2e7-be31-49c7-8ab7-90c5ab8afe18
	Total devices 1 FS bytes used 2.24TB
	devid    3 size 2.63TB used 2.63TB path /dev/md2

# mount
...
/dev/md2 on /home type btrfs (rw,noatime,compress)

# btrfs filesystem resize max /home
Resize '/home' of 'max'
ERROR: unable to resize '/home'

# umount /home/
# btrfs filesystem resize max /dev/md2
Resize '/dev/md2' of 'max'
ERROR: unable to resize '/dev/md2'

# tail /var/log/messages
May  4 10:28:57 localhost kernel: resizer unable to find device 1

2.6.38-gentoo-r3, latest git btrfs-progs

Can you please advice what to do?

Thank you

Lubos

