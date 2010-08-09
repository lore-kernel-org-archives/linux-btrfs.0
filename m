From: Evert Vorster <evorster@gmail.com>
Subject: quick question...
Date: Mon, 9 Aug 2010 01:57:54 +0000
Message-ID: <AANLkTimTTr0pFw5Y_O7nNUjH4z1UCRUsfYpe+NYtc7wZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there.

Has anybody got a btrfs root filesystem that is running on a bare
block device? Would lilo be able to boot an initramfs that is living
on such a filesystem?

What I intend to do is to erase all the partitions off my system, make
a btrfs volume on /dev/sda, and then just use subvolumes in stead of
partitions.

Is this folly?

Would having an initramfs be a boon or a bane in this endeavour?

Would lilo writing to the mbr of a device that is claimed by btrfs
break the file system?

Do you need to have a partition table to have an MBR?

Thanks for any answers...

-Evert-

-- 
http://magnatune.com - Music shared the way it should be.
