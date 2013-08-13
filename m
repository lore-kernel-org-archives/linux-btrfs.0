Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from y235201.ppp.asahi-net.or.jp ([118.243.235.201]:44063 "EHLO
	mactop" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756462Ab3HMBhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Aug 2013 21:37:12 -0400
Received: from [10.81.1.3] (mydomain.com [10.81.1.3])
	by mactop (Postfix) with ESMTP id 79451611E4
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 10:29:00 +0900 (JST)
Message-ID: <52098BDB.5010400@parallels.com>
Date: Tue, 13 Aug 2013 10:28:59 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-ino-cache is running on each reboot
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

About a week or so ago I noticed that [btrfs-ino-cache] process was 
appearing in the 'top' on each reboot and disk is spinning like crazy 
for about five minutes or so. Quite so often this caused X failing to 
start because all I/O was busy with caching.
Even after letting it to calm down and seeing [btrfs-ino-cache] 
disappearing from the process list, on next reboot it starts all over again.

Here is the fstab entry that I have

UUID=430dca92-9541-4201-0f62-373e30beadac / btrfs 
subvol=root_subvolume,defaults,noatime,noacl,compress=lzo,inode_cache,space_cache,autodefrag 
0 0

inode_cache was always enabled since the FS was created about a year or 
so ago, and actually I have never had any problems with it up until 
recently.

Removing inode_cache option from fstab solves the problem, but I am not 
sure if it is the right choice.
I can observe the problem at least in the vanilla kernel 3.10.4 ~ 6 (did 
not try older versions)

What could be the reason for such behavior and how to avoid it?

thanks
