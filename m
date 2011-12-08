From: =?ISO-8859-1?Q?Ricardo_B=E1nffy?= <rbanffy@gmail.com>
Subject: Filesystem acting up during balance
Date: Thu, 8 Dec 2011 09:12:34 -0200
Message-ID: <CA+NZatJO2U8PhQC_xK9O0uAb9jbVTpfNwuPj-14rffbXhBfu2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks.

Last night one of the USB attached disks malfunctioned during a
balance. I strongly suspect the drive will die soon. A couple hours
later, with the drive cold, I got a

Dec  8 07:34:49 adams kernel: [84890.433235] device label quatrocentao
devid 1 transid 1659 /dev/sde1
Dec  8 07:34:49 adams kernel: [84890.460448] btrfs: open_ctree failed

I ran btrfsck on it and got

root@adams:~# btrfsck /dev/sde1
found 396558811136 bytes used err is 0
total csum bytes: 385961240
total tree bytes: 1334501376
total fs tree bytes: 756809728
btree space waste bytes: 346120636
file data blocks allocated: 396065329152
 referenced 396065329152
Btrfs Btrfs v0.19

But, when I tried to mount it, I got the much feared:

root@adams:~# mount /dev/sde1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sde1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Running Ubuntu 11.04 here.

Now would be a terrific time to have a "salvage broken filesystem"
utiliy so I could move the data to another disk. Are we there yet?

--=20
Ricardo B=E1nffy
http://www.dieblinkenlights.com
http://twitter.com/rbanffy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
