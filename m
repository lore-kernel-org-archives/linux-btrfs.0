Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57235 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbbCXEAd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 00:00:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 6E74D2018D
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 00:00:30 -0400 (EDT)
Message-Id: <1427169632.2878415.244369134.44ED7B24@webmail.messagingengine.com>
From: Chris Severance <linuxkernel.severach@spamgourmet.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Btrfs RAID 1 Very poor file re read cache
Date: Tue, 24 Mar 2015 00:00:32 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

System:

Thinkserver TS140 E3-1225, 32GB ECC RAM, LSI9211-8i (IT unraid), 2 WD xe
SAS as mdraid-raid1-ext4, 2 WD xe SAS as btrfs-raid1

Linux xyzzy 3.19.2-1-ARCH #1 SMP PREEMPT Wed Mar 18 16:21:02 CET 2015
x86_64 GNU/Linux

btrfs-progs v3.19

btrfs fi: partition already removed, created with mkfs.btrfs -m raid1 -d
raid1 -L sdmdata /dev/sdc /dev/sdd

dmesg: (not a problem with crashing)

Problem:

Very poor file reread cache. The database I use organizes both data and
keys in a single file as a btree. This means that each successive record
is located randomly around the file. Reading from first to last
generates a lot of seeks.

On btrfs the speed is consistent throughout the whole file as it is on
any system with too little memory for an effective cache. Every reread
runs at the same slow and consistent speed.

So I unmount btrfs, quick zero the drives, mkfs.ext4, mount, and unpack
the same data and run the same test on the same drives.

On ext4 (and xfs from other testing) the first time I read through the
whole file it starts slow as it seeks around to uncached data and
speeds up as more of the file is found in the cache. It is very fast by
the end. Once in the cache I can read the file over and over super
fast. The ext4 read cache is mitigating the time cost from the poor
arrangement of the file.

I'm the only user on this test system so nothing is clearing my 32GB.
