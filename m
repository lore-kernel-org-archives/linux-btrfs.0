Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41637 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab3ICIVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2013 04:21:44 -0400
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 70258218DB
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Sep 2013 18:21:37 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: how long should btrfs fi balance take?
Date: Tue, 3 Sep 2013 18:21:35 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201309031821.35507.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs filesystem df /
Data: total=101.57GB, used=75.75GB
System, DUP: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.00GB, used=2.09GB
Metadata: total=8.00MB, used=0.00
# btrfs filesystem df /
Data: total=100.57GB, used=77.00GB
System, DUP: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.50GB, used=2.35GB
Metadata: total=8.00MB, used=0.00

I've had btrfs filesystem balance running on a partition of my 120G Intel SSD 
for almost 7 hours.  The above two runs of fi df were before the balance and 
after it had run for almost 7 hours.  The system is in operation during this 
process, I've used it for email, web browsing, and I downloaded a movie from 
Youtube.

Also during the process the usual cron jobs have been running including the 
one that makes a snapshot of /home every 15 minutes.

Is it considered to be a bad idea to make snapshots while doing a balance?

Should a balance take so long anyway?  It's been mostly CPU bound an on E4600 
CPU, that's a bit dated but it's still dual-core 64bit and whatever the btrfs 
utility has done to use 327 minutes of CPU time is probably wrong.

Any suggestions on other information I should provide?  I'm using 3.10.7 in 
Debian package linux-image-3.10-2-amd64 version 3.10.7-1 and version 
0.19+20130705-1 of the btrfs-tools in Debian/Unstable.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
