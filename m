Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35456 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab3DYA2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 20:28:25 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 303C8182F3
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 10:28:21 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Failed to lookup path for root 0
Date: Thu, 25 Apr 2013 10:28:12 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201304251028.13714.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs subvol list /home
ERROR: Failed to lookup path for root 0 - No such file or directory
# btrfs subvol list /home
ID 269 gen 449406 top level 5 path backup
...

I'm getting errors from the "btrfs subvol list" command as above, I'm running 
the Debian 3.8.3 kernel.  The errors occur after deleting a snapshot, so if I 
delete a snapshot and then immediately do a list of snapshots then the error 
is likely to occur.  It's repeatable in my cron jobs to remove old backups, 
they do a snapshot list, delete the hourly backups, then do another list to 
find daily snapshots to delete which fails.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
