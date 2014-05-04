Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53088 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaEDCQ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 22:16:58 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id D06BD20903
	for <linux-btrfs@vger.kernel.org>; Sun,  4 May 2014 12:16:55 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: copies= option
Date: Sun, 4 May 2014 12:16:54 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201405041216.54348.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Are there any plans for a feature like the ZFS copies= option?

I'd like to be able to set copies= separately for data and metadata.  In most 
cases RAID-1 provides adequate data protection but I'd like to have RAID-1 and 
copies=2 for metadata so that if one disk dies and another has some bad 
sectors during recovery I'm unlikely to lose metadata.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
