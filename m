From: Peter Klotz <peter.klotz@aon.at>
Subject: 2.6.29-rc1: Cannot loopback mount btrfs formatted file
Date: Sun, 11 Jan 2009 22:44:26 +0100
Message-ID: <496A683A.6090004@aon.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since 2.6.29-rc1 contains btrfs I had to try it.

However the loopback mount of my btrfs formatted file fails:

user@host:~$ dd if=/dev/zero of=btrfs.img bs=1MB count=512

user@host:~$ mkfs.btrfs btrfs.img
fs created label (null) on btrfs.img
     nodesize 4096 leafsize 4096 sectorsize 4096 size 488.28MB
Btrfs v0.16+da35ab2b0b54

user@host:~$ sudo mount -t btrfs -o loop btrfs.img /mnt/btrfs
mount: /dev/loop1: can't read superblock


Is this version of mkfs.btrfs compatible with the kernel module in 
2.6.29-rc1?

Any help is appreciated.

Regards, Peter.
