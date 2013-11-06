Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53281 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3KFBwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 20:52:43 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id DF4AB2089F
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Nov 2013 12:52:40 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: 3.11.5 kernel infinite loop
Date: Wed, 6 Nov 2013 12:52:38 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201311061252.39398.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a system running the Debian package of 3.11.5 with an Amd Opteron 1212 
processor (2*64bit cores), 8G of RAM, and an Intel 120G SSD for the root and 
home subvols.  It has a RAID-1 array of 2*3TB disks for bulk storage (movies 
etc) but that probably isn't relevant to this problem.

On the root filesystem I have cron jobs making daily snapshots of / and /home 
and additional snapshots of /home every 15 minutes.  At midnight a cron job 
removes older snapshots.  For the last 8 days the system has been reliably 
hanging at about 5 minutes after midnight and the subvol removal cron job is 
the only thing that has happened then.

So it seems clear to me that on my system 3.11.5 has a crash a few minutes 
after removing ~98 subvols at the same time.

Last night I watched it happen and deleted a few dozen extra subvols to test 
whether it would repeat.  That wasn't such a good idea and I rebooted the 
system many times before giving up and booting 3.10.11 which is now working 
correctly.

When running 3.11.5 I was seeing kernel log messages such as the following 
shortly after boot.  Then after that it got into a state where a ssh session 
didn't work and the X login prompt didn't even flash it's cursor.  In that 
state it could still forward packets (the system in question is an ethernet 
bridge which I use to connect my workstation to the Internet) but couldn't do 
much else.  The NFS server processes locked and sshd wouldn't complete the 
login process for new connection attempts.

[   68.056003] BUG: soft lockup - CPU#0 stuck for 22s! [btrfs-cleaner:270]     
[   68.144004] BUG: soft lockup - CPU#1 stuck for 22s! [btrfs-transacti:271]

Prior to the lockup those two kernel processes had used most CPU time.  I'm 
not sure whether prior to the lockup they were in some sort of CPU loop or 
whether they were just reading a lot of data from a fast SSD and acting 
correctly.

As an aside I ordered a replacement server last week when I wasn't sure if 
this was a hardware or a software problem.  This will allow me to test some 
things in more detail on the old server after the new one is running, however 
I don't own a spare SSD so if it's a SSD specific issue then I have limited 
ability to test.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
