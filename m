From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: can't mount RAID-1 btrfs after reboot
Date: Fri, 14 Aug 2009 11:34:42 +0200
Message-ID: <4A852FB2.2030205@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can't mount RAID-1 btrfs after reboot (well, sort of).

Using 2.6.31-rc5 and btrfs-progs 0.19, I created a RAID-1 fileystem 
using these command line options:

# mkfs.btrfs -L btrfs-data -m raid1 -d raid1 /dev/sda4 /dev/sdb4


After which I was able to mount the filesystem with either of the below 
(or both):

# mount /dev/sda4 /mnt/btrfs-sda4

# mount /dev/sdb4 /mnt/btrfs-sdb4


After a reboot, I'm no longer able to mount the filesystem from /dev/sda4:

# mount /dev/sda4 /mnt/btrfs/

Mount command complains and doesn't mount it and says I can find more 
info in dmesg:

Btrfs loaded
device label btrfs-data devid 1 transid 67 /dev/sda4
btrfs: failed to read the system array on sda4
btrfs: open_ctree failed


I'm able to mount the filesystem by using /dev/sdb4:

# mount /dev/sdb4 /mnt/btrfs/

After which I can unmount it, and use /dev/sda4 to mount the filesystem:

# umount /dev/sdb4
# mount /dev/sda4 /mnt/btrfs/


Does it make sense?

It behaved like this also with some earlier kernels.


-- 
Tomasz Chmielewski
http://wpkg.org
