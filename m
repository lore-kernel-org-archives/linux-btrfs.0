Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50609 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbbEELah (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 07:30:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ypb3a-0006fu-Uf
	for linux-btrfs@vger.kernel.org; Tue, 05 May 2015 13:30:35 +0200
Received: from 168.159.160.53 ([168.159.160.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 13:30:34 +0200
Received: from toyours_sridhar by 168.159.160.53 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 13:30:34 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: btrfs send/receive for backup of subvolumes
Date: Tue, 5 May 2015 11:30:27 +0000 (UTC)
Message-ID: <loom.20150505T131847-769@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

My query speicific to incremental backup/recovery with btrfs 
send/receive option available for btrfs subvolume backups.

say i have /b1/s1 subvolume and snapshot of s1 is /b1/snap1_s1

I run btrfs send /b1/snap_s1 | btrfs receive /backup where /backup is my 
backup btrfs file system.


Now I will take snapshot of s1 again ( after modifiying data in s1) 
which is /b1/snap2_s1

Using btrfs send -p snap1_s1 snap2_s2 and destination as /backup I can 
send incremental to backup store.

My question is is there a way I can have option recover files from 
/backup from incremental backup or full backup (i.e. from copy of 
snap2_s1 or snap1_s1)

And I do not want to make 2 copies of 1 full and 1 incremetal backup 
since if full backup is 1Gb and if there is 0.6Gb change for 
incremental, I would like to backup only difference for incremental 
backup but still would able to get option to recover files from full or 
incremental from backedup subvolume.

is there a way I can achieve this using current btrfs send/receive and 
other snapshot and tracking options?

thank you in advance.

