Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42977 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab2GYLKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 07:10:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1StzTk-0001xm-4F
	for linux-btrfs@vger.kernel.org; Wed, 25 Jul 2012 13:10:08 +0200
Received: from gut75-8-83-156-244-239.fbx.proxad.net ([83.156.244.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:10:07 +0200
Received: from cbay by gut75-8-83-156-244-239.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:10:07 +0200
To: linux-btrfs@vger.kernel.org
From: "Cyril B. " <cbay@excellency.fr>
Subject: Btrfs-progs: segfault when re-creating filesystem with 3+ devices
Date: Wed, 25 Jul 2012 13:08:21 +0200
Message-ID: <juok36$stg$1@dough.gmane.org>
Reply-To: cbay@excellency.fr
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Running on Linux 3.5.0, with the latest btrfs-progs from today. I was doing 
some tests with my 7 devices, and mkfs.btrfs segfaults when executed twice, 
creating a filesystem with 3+ devices:


# ./mkfs.btrfs /dev/sdc /dev/sdd /dev/sde

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdd id 2
adding device /dev/sde id 3
fs created label (null) on /dev/sdc
        nodesize 4096 leafsize 4096 sectorsize 4096 size 8.19TB
Btrfs Btrfs v0.19


# ./mkfs.btrfs /dev/sdc /dev/sdd /dev/sde

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

adding device /dev/sdd id 2
Segmentation fault


If executed a third time, everything is fine and the filesystem is created 
normally. The segfault doesn't happen with 2 or less devices (but still 
happens with 4 or more devices).

Backtrace:

#0  0x00007fba810faaf0 in strcmp () from /lib/libc.so.6
#1  0x000000000041e17c in device_list_add (path=0x7fff10a8a810 "/dev/sdd", 
disk_super=0xac9570, devid=2, fs_devices_ret=0x7fff10a8ac88) at 
volumes.c:119
#2  0x000000000041e556 in btrfs_scan_one_device (fd=11, path=0x7fff10a8a810 
"/dev/sdd", fs_devices_ret=0x7fff10a8ac88, total_devs=0x7fff10a8ac80, 
super_offset=65536)
    at volumes.c:221
#3  0x000000000042607b in btrfs_scan_block_devices (run_ioctl=1) at 
utils.c:1209
#4  0x0000000000425bf0 in btrfs_scan_for_fsid (fs_devices=0xab5020, 
total_devs=7, run_ioctls=1) at utils.c:1057
#5  0x000000000042551e in check_mounted_where (fd=9, file=0x7fff10a8ca01 
"/dev/sde", where=0x0, size=0, fs_dev_ret=0x0) at utils.c:843
#6  0x0000000000425494 in check_mounted (file=0x7fff10a8ca01 "/dev/sde") at 
utils.c:820
#7  0x000000000042be74 in main (ac=4, av=0x7fff10a8b058) at mkfs.c:1402

Thanks.

-- 
Cyril B.

