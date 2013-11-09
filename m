Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:38934 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab3KIXsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Nov 2013 18:48:21 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id B44A72089F
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 10:48:17 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: 3.10.11 scrub OOM crash
Date: Sun, 10 Nov 2013 10:48:17 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201311101048.17277.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got an AMD64 system with 8G of RAM and 1G of swap.  It runs as a home 
file server with 2*3TB disks in a RAID-1 array and a 120G SSD for root and 
/home.  It also does some light desktop work (running KDE and web browsing 
with Chromium).

When a btrfs scrub is run from cron the system gives an OOM and then locks up 
after apparently killing some processes (after a reboot I see syslog entries 
about some processes being killed - even though it didn't appear to kill X or 
anything the system is hung).

The system really shouldn't have a OOM.  For light desktop use a total of 8G 
of RAM and 1G of swap should be more than enough.  Most of the time swap is 
hardly used and there are several gigs of RAM used for cache.

The kernel is Debian package 3.10.11-1.

This is the same system about which I reported the 3.11.5 kernel infinite loop 
bug.  I had this crash on scrub issue before I upgraded to 3.11.5.  I'm not 
certain that 3.11.5 fixed the crash on scrub problem, maybe 3.11.5 just 
crashed the system before it could be up for long enough.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
