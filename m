Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omarion.csy.ca ([63.141.233.98]:58788 "EHLO omarion.csy.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaILJiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 05:38:06 -0400
Received: from 127.0.0.1 (helo=authenticated.user-IP.removed)
	by omarion.csy.ca with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.84)
	id 1XSMg0-0003pR-Kw
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 01:57:57 -0700
From: <shane-kernel@csy.ca>
To: <linux-btrfs@vger.kernel.org>
Subject: RAID1 failure and recovery
Date: Fri, 12 Sep 2014 01:57:37 -0700
Message-ID: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am testing BTRFS in a simple RAID1 environment. Default mount options and data and metadata are mirrored between sda2 and sdb2. I have a few questions and a potential bug report. I don't normally have console access to the server so when the server boots with 1 of 2 disks, the mount will fail without -o degraded. Can I use -o degraded by default to force mounting with any number of disks? This is the default behaviour for linux-raid so I was rather surprised when the server didn't boot after a simulated disk failure.

So I pulled sdb to simulate a disk failure. The kernel oops'd but did continue running. I then rebooted encountering the above mount problem. I re-inserted the disk and rebooted again and BTRFS mounted successfully. However, I am now getting warnings like:
BTRFS: read error corrected: ino 1615 off 86016 (dev /dev/sda2 sector 4580382824)
I take it there were writes to SDA and sdb is out of sync. Btrfs is correcting sdb as it goes but I won't have redundancy until sdb resyncs completely. Is there a way to tell btrfs that I just re-added a failed disk and to go through and resync the array as mdraid would do? I know I can do a btrfs fi resync manually but can that be automated if the array goes out of sync for whatever reason (power failure)...

Finally for those using this sort of setup in production, is running btrfs on top of mdraid the way to go at this point?

Cheers,
Shane


