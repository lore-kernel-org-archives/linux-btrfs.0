Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:46537 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753627Ab3GJCys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 22:54:48 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id CBBD8218D1
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 12:54:45 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: performance loss with lots of snapshots
Date: Wed, 10 Jul 2013 12:54:44 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201307101254.44583.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two uses of backups, recovering from user errors (IE deleting the 
wrong file) and recovering from sysadmin errors or hardware failures (IE disks 
are dead or wiped).  For the former use I'm mainly using BTRFS snapshots on 
many systems.

A problem that I have had on more than a few occasions (most recently on the 
latest Debian 3.9 kernel) is of severe performance loss.  A few days ago this 
happened on a workstation running an Intel 120G SSD device for the root 
filesystem which was being used for basic workstation tasks (kmail, GIMP, 
OpenOffice, etc).  The /home and / subvols had about 400 snapshots between 
them (which doesn't seem like a huge number) when the system became unusably 
slow while running a scrub from a cron job, programs like GIMP became stuck in 
D state.  The system in question has 8G of RAM and very light load, there 
shouldn't be any reason for it not giving good performance while the scrub was 
in progress and it definitely should have performed well when the scrub was 
cancelled.  But it didn't return to decent performance until I deleted about 
300 snapshots.

This has happened to me often enough that I can probably reproduce it on a VM.  
What kernel should I use for such tests?

If I get a virtual machine in a state where it has ongoing performance 
problems would any of the BTRFS developers like root access to debug it?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
