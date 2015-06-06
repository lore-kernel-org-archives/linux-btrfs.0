Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc1s20.hotmail.com ([157.55.0.219]:56384 "EHLO
	DUB004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbbFFRHl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Jun 2015 13:07:41 -0400
Message-ID: <DUB130-W13A9BCD95146CF38BE7E1BF8B10@phx.gbl>
From: Markus <markus.suvanto@hotmail.fi>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs snapshot leaks memory
Date: Sat, 6 Jun 2015 20:02:37 +0300
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=99511

My btrfs backup script don't work any more (4.0 was OK). 
It seems that btrfs snapshot leaks memory and finally OOM killer goes mad...
Test scrip below demonstrates situation. 

It seems that ssd disk (/mnt/ssd) is not so bad
but traditional disk (/mnt/wd) using RAID1 leaks memory.

-Markus


uname -a
Linux xxx.xxx.com 4.1.0-rc6 #1 SMP Mon Jun 1 08:55:34 EEST 2015 x86_64 Intel(R) Xeon(R) CPU E5530 @ 2.40GHz GenuineIntel GNU/Linux

gcc-versio 5.1.0 (Gentoo 5.1.0 p1.0, pie-0.6.3)
btrfs-progs v4.0.1


btrfs filesystem df /mnt/wd/
Data, RAID1: total=2.28TiB, used=2.26TiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=368.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=112.50GiB, used=5.77GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

btrfs filesystem df /mnt/ssd/
Data, single: total=97.49GiB, used=91.54GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=3.01GiB, used=2.02GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



#!/bin/bash

btrfs subvolume delete /mnt/wd/foo*
btrfs subvolume snapshot /mnt/wd/root-vol /mnt/wd/foo

while [ 1 ]; do
    btrfs subvolume delete /mnt/wd/foo1
    #btrfs subvolume snapshot -r /mnt/wd/foo /mnt/wd/foo1
    btrfs subvolume snapshot  /mnt/wd/foo /mnt/wd/foo1
    cat /proc/meminfo |grep MemFree
done



 		 	   		  