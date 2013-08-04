Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:48172 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3HDLtc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Aug 2013 07:49:32 -0400
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 5F2B0218E1
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Aug 2013 21:42:13 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: error count
Date: Sun, 4 Aug 2013 21:42:11 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201308042142.12310.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a 3TB SATA disk that is known to have problems (it failed in a zpool 
for one of my clients).  For test purposes I'm running a BTRFS RAID-1 on two 
partitions on that disk, bad for performance and not something you'd normally 
do but good for testing.

BTRFS recovers from read errors quite well and gives informative log messages.

But it doesn't seem possible to get a count of the number of errors.  I think 
that at the minimum I should be able to get a count of the number of errors 
from a device since it was attached to the system.  I think that the ideal 
would be to have an error count stored on the device and available to the 
sysadmin.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
