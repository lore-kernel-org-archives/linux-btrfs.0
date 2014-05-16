Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51665 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaEPDHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 23:07:09 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id CB39320797
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 13:07:06 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: ditto blocks on ZFS
Date: Fri, 16 May 2014 13:07:05 +1000
Message-ID: <2308735.51F3c4eZQ7@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://blogs.oracle.com/bill/entry/ditto_blocks_the_amazing_tape

Probably most of you already know about this, but for those of you who haven't 
the above describes ZFS "ditto blocks" which is a good feature we need on 
BTRFS.  The briefest summary is that on top of the RAID redundancy there is 
one more copy of metadata than there is of data, so copies=2 implies 3 copies 
of metadata and the default option of 1 copy of data means that metadata is 
"dup" in addition to whatever RAID redundancy is in place.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

