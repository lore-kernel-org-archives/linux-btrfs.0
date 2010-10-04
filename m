From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: how can I copy files bigger than ~32 GB when using compress-force?
Date: Mon, 04 Oct 2010 22:26:26 +0200
Message-ID: <4CAA3872.3080106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to copy a ~220 GB file from a ext4 to btrfs filesystem with 
336 GB free space on it. System is running 2.6.36-rc6.

File size on a ext4 filesystem:

# ls -l srv1-backup.qcow2
-rw-r--r-- 1 root root 219564146688 2010-09-26 21:56 srv1-backup.qcow2


Unfortunately it fails when only about 32 GB is copied (with 
compress-force mount option enabled).

Copying to btrfs mount point stops, no reads or writes from any 
filesystem, after file copied to btrfs is around 32 GB:

$ ls -l /mnt/btrfs/srv1-backup.qcow2
-rw-r--r-- 1 root root 32328482816 2010-10-04 21:49 
/mnt/btrfs/srv1-backup.qcow2

This is 100% reproducible, when it gets to ~32 GB (varies by +/- 2 GB), 
cp can't be interrupted, killed and the only way to get this "fixed" 
seem to be rebooting the machine.

_Sometimes_, cp quits after waiting for longer with "no space left".


To reproduce:

Let's create a btrfs filesystem:

#  mkfs.btrfs /dev/sdb4

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb4
         nodesize 4096 leafsize 4096 sectorsize 4096 size 335.72GB
Btrfs Btrfs v0.19


# mount -o noatime,compress-force /dev/sdb4 /mnt/btrfs/

# df -h /mnt/btrfs
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb4             336G   56K  336G   1% /mnt/btrfs

# cp -v srv1-backup.qcow2 /mnt/btrfs/
`srv1-backup.qcow2' -> `/mnt/btrfs/srv1-backup.qcow2'


It always hands for me after copying ~32 GB, or quits with "no space left".


-- 
Tomasz Chmielewski
http://wpkg.org
