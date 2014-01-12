Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail01.jit-creatives.de ([188.40.162.6]:37294 "EHLO
	mail01.jit-creatives.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaALTl1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 14:41:27 -0500
To: <linux-btrfs@vger.kernel.org>
Subject: RAID 1 with no data on it when accidentally switched HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 12 Jan 2014 20:35:21 +0100
From: Ingo Ebel <ingo.ebel@ingoebel.de>
Message-ID: <7e169377e2a149281902ebbce55a9f7e@www.jitmail.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm not sure whether it's a bug in btrfs or my distro but I discovered 
an odd behavior today.

My Setup:

* Btrfs v3.12+20131125
* /dev/sda – Boot OS - opensuse 13.1
* Btrfs RAID 1 on /dev/sdb1 and /dev/sdc1

I added an extra HDD with an other OS and Data on it witch accidentally 
became /dev/sdc.

Btrfs got mounted at boot time without any complains but in the main 
volume was empty.
Some subvolumes still had Data.

I took the extra HDD out but still no data in the Btrfs main volume. 
Bfrfsck reported no error.
Some Parts on the (accidentally) /dev/sdc are now corrupt.

I would expect that btrfs would throw an error when getting in the kind 
of scenario.

Regards

Ingo
