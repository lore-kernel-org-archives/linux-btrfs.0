From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: btrfs using inside xen domU and online resizing
Date: Thu, 06 Jan 2011 04:10:00 +0300
Message-ID: <1294276200.26566.14.camel@mobile>
Reply-To: v.tolstov@selfip.ru
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello. I have two questions:

1) When btrfs can be used in systems, that can be rebooted unexpectedly?
btrfs fsck is ready to use? does after power failure or hard reboot file
system can be damaged and can't be corrected?

2) When i use xen domU virtual machine a can dynamically change capacity
of block device (/dev/xvda for example) it can be grows and shrinks.  Is
that possible to use one btrfs file system on all device without
partition table ? In current implementation (i'm use ext3). After block
device change it size, i need to recreate partition table and do
resize2fs.  But in case of root fs i need reboot to update partition
table, because file system is in use. If linux can boot from plain btrfs
device without partition table , as i think - i can resize block device
and do mount -o remount,maxsize /dev/xvda and btrfs resized
automatic... 
Is that possible?

Thank You for all suggestions and answers.

