Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43577 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEOJAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 05:00:15 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id F0B9020941
	for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 19:00:11 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: staggered stripes
Date: Thu, 15 May 2014 19:00:10 +1000
Message-ID: <2751140.Zb1qMBeNgk@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://www.cs.wisc.edu/adsl/Publications/corruption-fast08.html

Page 13 of the above paper says:

# Figure 12 presents for each block number, the number of disk drives of disk
# model ‘E-1’ that developed a checksum mismatch at that block number. We see
# in the figure that many disks develop corruption for a specific set of block
# numbers. We also verified that (i) other disk models did not develop
# multiple check-sum mismatches for the same set of block numbers (ii) the
# disks that developed mismatches at the same block numbers belong to
# different storage systems, and (iii) our software stack has no specific data
# structure that is placed at the block numbers of interest.
#
# These observations indicate that hardware or firmware bugs that affect
# specific sets of block numbers might exist. Therefore, RAID system designers
# may be well-advised to use staggered stripes such that the blocks that form
# a stripe (providing the required redundancy) are placed at different block
# numbers on different disks.

Does the BTRFS RAID functionality do such staggered stripes?  If not could it 
be added?

I guess there's nothing stopping a sysadmin from allocating an unused 
partition at the start of each disk and use a different size for each disk.  
But I think it would be best to do this inside the filesystem.

Also this is another reason for having DUP+RAID-1.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

