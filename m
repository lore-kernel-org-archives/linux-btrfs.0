From: Anupam Garg <garga@soe.ucsc.edu>
Subject: btrfsctl snapshot question
Date: Sat, 7 Feb 2009 20:11:15 -0800
Message-ID: <EF9B3EFE-9DDE-4CBC-8536-7180B61799EB@soe.ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I am using btrfsctl to snapshot, however it does not seem to be working.
I am doing:


+ umount /btrfs
+ mkfs.btrfs /dev/sdb1

WARNING! - Btrfs v0.18-12-ge3b0f66 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdb1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 19.99GB
Btrfs v0.18-12-ge3b0f66
+ btrfsctl -A /dev/sdb1
operation complete
Btrfs v0.18-12-ge3b0f66
+ mount -t btrfs /dev/sdb1 /btrfs
+ cd /btrfs
+ btrfsctl -S base .
operation complete
Btrfs v0.18-12-ge3b0f66
+ dd if=/dev/urandom of=/btrfs/base/data bs=1M count=20
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied, 3.82335 s, 5.5 MB/s
+ ls -l /btrfs/base/data
-rw-r--r-- 1 root root 20971520 2009-02-07 19:59 /btrfs/base/data
+ btrfsctl -s rev1 /btrfs/base
operation complete
Btrfs v0.18-12-ge3b0f66
+ ls -l /btrfs/base/data
-rw-r--r-- 1 root root 20971520 2009-02-07 19:59 /btrfs/base/data
+ ls -l /btrfs/rev1/data
-rw-r--r-- 1 root root 0 2009-02-07 19:59 /btrfs/rev1/data

At the end, I expect the sizes of /btrfs/base/data & /btrfs/rev1/data  
to be the same.
Is that expectation correct?

I'm sure I'm missing something fundamental here. I'm at the latest  
progs and kernel according to git.
I've read the wiki, but can't figure out what I'm missing.


thanks in advance for any help or pointers to additional docs,
-anupam
