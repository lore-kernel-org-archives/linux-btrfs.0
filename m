Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:46901 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbbHNMMy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 08:12:54 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id BA145ECEE
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 22:12:51 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: can we make balance delete missing devices?
Date: Fri, 14 Aug 2015 22:12:50 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201508142212.50580.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ 2918.502237] BTRFS info (device loop1): disk space caching is enabled
[ 2918.503213] BTRFS: failed to read chunk tree on loop1
[ 2918.540082] BTRFS: open_ctree failed

I just had a test RAID-1 filesystem with a missing device.  I mounted it with 
the degraded option and added a new device.  I balanced it (to make it do 
RAID-1 again) and thought everything was good.  Then when I tried to mount it 
again it gave errors such as the above (not sure why).  Then I tried wiping 
/dev/loop1 and it refused to mount entirely due to having 2 missing devices.

Obviously it was my mistake to not remove the missing device, and wiping 
/dev/loop1 was a bad idea.  Failing to remove a missing device seems likely to 
be a common mistake.  Could we make the balance operation automatically delete 
the missing device?  I can't imagine a situation in which a balance would be 
desired but deleting the missing device wouldn't be desired.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
