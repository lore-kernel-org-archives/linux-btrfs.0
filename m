Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35804 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJRDyX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 23:54:23 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 0E61C208CF
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Oct 2014 14:54:21 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: strange 3.16.3 problem
Date: Sat, 18 Oct 2014 14:54:19 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201410181454.19375.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a system running the Debian 3.16.3-2 AMD64 kernel for the Xen Dom0 and 
the DomUs.

The Dom0 has a pair of 500G SATA disks in a BTRFS RAID-1 array.  The RAID-1 
array has some subvols exported by NFS as well as a subvol for the disk images 
for the DomUs - I am not using NoCOW as performance is fine without it and I 
like having checksums on everything.

I have started having some problems with a mail server that is running in a 
DomU.  The mail server has 32bit user-space because it was copied from a 32bit 
system and I had no reason to upgrade it to 64bit, but it's running a 64bit 
kernel so I don't think that 32bit user-space is related to my problem.

# find . -name "*546"
./1412233213.M638209P10546
# ls -l ./1412233213.M638209P10546
ls: cannot access ./1412233213.M638209P10546: No such file or directory

Above is the problem, find says that the file in question exists but ls 
doesn't think so, the file in question is part of a Maildir spool that's NFS 
mounted.  This problem persisted across a reboot of the DomU, so it's a 
problem with the Dom0 (the NFS server).

The dmesg output on the Dom0 doesn't appear to have anything relevant, and a 
find command doesn't find the file.  I don't know if this is a NFS problem or 
a BTRFS problem.  I haven't rebooted the Dom0 yet because a remote reboot of a 
server running a kernel from Debian/Unstable is something I try to avoid.

Any suggestions?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
