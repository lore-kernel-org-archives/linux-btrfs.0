Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34080 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBGElP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 23:41:15 -0500
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 10CFC21889
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2014 15:41:12 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: user creation/deletion of snapshots permissions bug
Date: Fri, 07 Feb 2014 15:41:09 +1100
Message-ID: <2524068.SeylZtQnKR@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ /sbin/btrfs subvol create /tmp/test
Create subvolume '/tmp/test'
$ /sbin/btrfs subvol delete /tmp/test
Delete subvolume '/tmp/test'
ERROR: cannot delete '/tmp/test' - Operation not permitted

The above is when running Debian kernel 3.12 based on Linux upstream 3.12.8.  
I believe that the BTRFS kernel code should do a capabilities check for 
CAP_SYS_ADMIN (which is used for mount/umount among many other things) before 
creating a snapshot.  Currently it appears that the only access control is 
write access to the parent directory.

There is some possibility of debate about the access control needed for 
creating a subvol.  I want to use capabilities set by SE Linux policy to 
prevent unwanted actions by hostile root processes and I think that such use 
of capabilities (which is used by more than just SE Linux) should be 
supported.  I don't think that there is any downside to such checks.

In any case allowing a subvol to be created but not deleted with the same 
level of access is obviously a bug.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

