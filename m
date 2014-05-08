Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58120 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaEHJu3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 05:50:29 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 87CCB2086F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 May 2014 19:50:25 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Balance performance problem with 3.14.1
Date: Thu, 8 May 2014 19:50:23 +1000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201405081950.23922.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a server/workstation (KDE desktop and file server) running kernel 
3.14.1 from the Debian package 3.14-trunk-amd64.

It was running well until I decided to do a full balance of the BTRFS RAID-1 
array of 3TB SATA disks (which hadn't been balanced before due to previous 
kernels performing badly with scrub or balance).  I canceled the balance after 
about 5 days when it had been claiming to be about 65% done for a day while 
doing a lot of disk IO.

After canceling the balance the performance of the array has been poor.  It 
has a cron job that runs twice a week to rsync data from a Maildir based mail 
server that currently has 2401473 Inodes in use according to ZFS on the mail 
server (unfortunately BTRFS won't tell me how many Inodes are in use).  The 
cron job does an "rsync -va" type backup WITHOUT the -c option, so we're 
basically doing a recursive stat on all files and then transferring new files 
(Dovecot index files are excluded so files tend never to change).  After the 
rsync is complete "cp -rl" is used to make a backup of the tree.

The cp -rl usually takes something less than 30 minutes (not long enough for 
me to even notice) but today cp has been running for 5.5 hours and seems to be 
about 3/5 done (9000/15000 subdirectories linked).

The backup script that runs rsync and cp is run at 2AM and usually finishes 
well before 9AM to avoid interfering with the workstation use of the system.  
Today the script is still running at 7:38PM and seems likely to run for some 
hours.

The system in question has a SSD for /, /home, and swap.  The RAID-1 array of 
SATA disks is used for file serving and online backup.  I am not aware of any 
performance problems with the SSD, but a reasonably fast Intel SSD used for 
light desktop use could probably run at 10% normal speed and still seem fast.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
