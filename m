Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:42619 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420Ab3EOFZf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 01:25:35 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 4BF008E3EE
	for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 15:25:34 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: subvol copying
Date: Wed, 15 May 2013 15:25:27 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201305151525.27913.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user of a workstation has a home directory /home/john as a subvolume.  I 
wrote a cron job to make read-only snapshots of it under /home/john/backup 
which was fortunate as they just ran a script that did something like
"rm -rf ~".

Apart from copying dozens of gigs of data back, is there a good way of 
recovering it all?  Whatever you suggest isn't going to work for this time 
(the copy is almost done) but will be useful for next time.

I'm guessing that I can't delete a subvol that has other subvols under it.

Should I have put the backups under /backup instead so that I could just 
delete the corrupted subvol and make a read-write snapshot of the last good 
one?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
