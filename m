Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55659 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaESInq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 04:43:46 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id EB286208AE
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 18:43:39 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: 3.14.2 Debian kernel BTRFS corruption after balance
Date: Mon, 19 May 2014 18:43:38 +1000
Message-ID: <2019232.PTU0Tffgio@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last night my cron job that runs "/sbin/btrfs fi balance start -dusage=30 -
musage=30 /" failed with no space for balancing.  Then I manually ran it to 
free space for further balancing and ended up running -musage=0 -dusage=60 
(dusage=40 resulted in nothing being done).

http://www.coker.com.au/bug/btrfs-3.14.2-dmesg.txt.gz

After running the dusage=60 balance I had a kernel panic apparently due to a 
corrupted filesystem, the above URL has the dmesg.

http://www.coker.com.au/bug/btrfs-3.14.2-dmesg2.txt.gz

Then I rebooted the system and got the above error.  It now seems impossible 
to get a read-write filesystem.  I'll try booting with the latest Debian kernel 
(3.14.4) and see if that makes it work.  Otherwise I guess it's 
backup/format/restore.

Would it be worth keeping an image of that filesystem to see if a newer kernel 
can handle it better?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

