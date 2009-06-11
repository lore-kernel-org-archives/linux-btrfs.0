From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: [BUG] Cannot Mount Btrfs Volume Created By mkfs.btrfs v0.18-26-g0030f1d
Date: Thu, 11 Jun 2009 15:48:04 +0300
Message-ID: <4A30FD04.4090903@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I try to format a USB memory with a Btrfs. I can format it with 
mkfs.btrfs without problems. But; when I try to mount it, it fails to 
mount with the below error messages. But the USB memory works fine with 
other filesystems (ext4, XFS etc.). So, the hardware is not faulty.


tarkane@tarkane:~$ sudo mkfs.btrfs -d single -n 4096 /dev/sdb1

WARNING! - Btrfs v0.18-26-g0030f1d IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb1
         nodesize 4096 leafsize 4096 sectorsize 4096 size 983.98MB
Btrfs v0.18-26-g0030f1d
tarkane@tarkane:~$ sudo mount -t btrfs /dev/sdb1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so



And here it is the error log in dmesg


[93428.045686] device fsid 5241391784b5b44e-e9443ebc2843ddb0 devid 1 
transid 7 /dev/sdb1
[93428.046593] BTRFS: couldn't mount because of unsupported optional 
features (1).
[93428.046627] btrfs: open_ctree failed

