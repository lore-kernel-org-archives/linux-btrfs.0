Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54866 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaK0Ohz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 09:37:55 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 28CE820717
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Nov 2014 01:37:53 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Balance and RAID-1
Date: Fri, 28 Nov 2014 01:37:50 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201411280137.51086.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a RAID-1 filesystem with 2*3TB disks and 330G of disk space free 
according to df -h.  I replaced a 3TB disk with a 4TB disk and df reported no 
change in the free space (as expected).

I added a 1TB disk to the filesystem and there was still no change!  I 
expected that adding a 1TB disk would give 3TB+1TB on one side and 4TB on the 
other so I would instantly get an extra 1TB of free space according to df -h.

1072 out of about 2734 chunks balanced (1073 considered),  61% left

I ran btrfs balance for just over a day and a btrfs balance status reported 
the above.  But it still only showed 860G free according to df -h.  I've 
cancelled the balance because 860G of free space is enough for the moment and 
I don't want that server running slowly and making noise any more.

I think that the allocation of disk space needs to be improved.  If I added a 
1TB disk to a pair of 3TB disks then it would be quite reasonably for some 
serious reallocation to be required to make use of the extra space.  But when 
I added a 1TB disk to an array that had a 3TB and a 4TB then it should be able 
to make use of the space quite easily.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
