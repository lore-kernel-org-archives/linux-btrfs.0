Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41988 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571Ab3IWV5Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 17:57:25 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49179 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOE88-000yLX-Vl
	for linux-btrfs@vger.kernel.org; Mon, 23 Sep 2013 15:57:22 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=iso-8859-1
Subject: balance induced csum errors
Message-Id: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
Date: Mon, 23 Sep 2013 15:57:18 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

SAMSUNG SSD 830 Series
CPU0: Intel® Core(TM) i7-2820QM CPU @ 2.30GHz (fam: 06, model: 2a, stepping: 07)
8GB RAM (quite heavily tested, not recently, with several days of memtest)
kernel 3.11.1-200.fc19.x86_64 running on baremetal
btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64

Today I did a scrub on a btrfs volume, with no message or errors in console or dmesg or journal. Immediately after the scrub I did a balance on the volume which resulted in:
ERROR: error during balancing '/' - Input/output error

In dmesg for the time of that error, this is reported:
[  567.921661] btrfs: relocating block group 6463422464 flags 1
[  568.282371] btrfs: found 200 extents
[  568.800974] btrfs: found 200 extents
[  568.868567] btrfs: relocating block group 5389680640 flags 1
[  571.929662] btrfs: found 4410 extents
[  572.896410] btrfs: found 4410 extents
[  572.962479] btrfs: relocating block group 4315938816 flags 1
[  574.681576] BTRFS info (device sda6): csum failed ino 259 off 428470272 csum 2566472073 private 2181120065
[  574.692047] BTRFS info (device sda6): csum failed ino 259 off 428470272 csum 2566472073 private 2181120065

Upon reboot with kernel 3.11.1-200.fc19.x86_64 and also kernel-3.10.4-300.fc19.x86_64 the following is reported in dmesg:


[    6.053511] btrfs no csum found for inode 37693 start 25538560
[    6.054463] BTRFS info (device sda6): csum failed ino 37693 off 25538560 csum 3474434693 private 0
[    6.055299] btrfs no csum found for inode 37693 start 26218496
[    6.056086] BTRFS info (device sda6): csum failed ino 37693 off 26218496 csum 2772176352 private 0
[    6.085993] btrfs no csum found for inode 37693 start 22286336
[    6.086093] btrfs no csum found for inode 37693 start 22368256
[    6.087636] BTRFS info (device sda6): csum failed ino 37693 off 22286336 csum 396494483 private 0
[    6.087741] BTRFS info (device sda6): csum failed ino 37693 off 22368256 csum 2249156591 private 0

[root@f19l chris]# btrfs fi show
failed to open /dev/sr0: No medium found
Label: 'fedora'  uuid: d505bdee-ba7c-4a64-9481-d5cd76ab8b3e
	Total devices 1 FS bytes used 3.64GB
	devid    1 size 12.99GB used 6.51GB path /dev/sda6

The file system is on an SSD, so single profile for both data and metadata:
[root@f19l chris]# btrfs fi df /
Data: total=6.01GB, used=3.39GB
System: total=4.00MB, used=4.00KB
Metadata: total=512.00MB, used=258.93MB


If this is not the result of a known bug, let me know if there's more information I should provide, I do have a ~22MB btrfs-image -c9 -t4 of the file system.

This fs is disposable, but I might try btrfsck --repair --init-csum-tree with a slightly newer btrfs-progs.


Chris Murphy