From: Shen Feng <shen@cn.fujitsu.com>
Subject: What's wrong with snapshot?
Date: Thu, 08 Jan 2009 17:27:52 +0800
Message-ID: <4965C718.8070200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

I tried to ceate a snapshot of a subvol.
But it seems now work.

Please see the test below. I think the file created by dd
should also in the snap directory.

[root@localhost mnt]# ./test2.sh 
+ mkfs.btrfs /dev/sdb8
fs created label (null) on /dev/sdb8
	nodesize 4096 leafsize 4096 sectorsize 4096 size 18.63GB
Btrfs v0.16-35-g6e0e6df-dirty
+ btrfsctl -a
Scanning for Btrfs filesystems
+ mount -t btrfs /dev/sdb8 /mnt/btrfs
+ cd /mnt/btrfs
+ btrfsctl -S sub /mnt/btrfs
operation complete
Btrfs v0.16-35-g6e0e6df-dirty
+ btrfsctl -s snap /mnt/btrfs/sub
operation complete
Btrfs v0.16-35-g6e0e6df-dirty
+ dd if=/dev/zero of=/mnt/btrfs/sub/file bs=1024 count=1024
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB) copied, 0.0208993 s, 50.2 MB/s
+ ls -a snap sub
snap:
.  ..

sub:
.  ..  file
+ cd ..


Anything wrong?
Thanks

-Shen


