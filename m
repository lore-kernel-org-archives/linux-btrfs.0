Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54514 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaEKEQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 00:16:33 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 9836720852
	for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 14:16:30 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: known UUID and metadata consistency
Date: Sun, 11 May 2014 14:16:27 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201405111416.28012.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of the problems with ReiserFS was that a fsck --rebuild-tree would look 
through all the disk contents for blocks that appeared to be metadata. A 
hostile user could create a file in their home directory (or /tmp or anywhere 
else) that contained ReiserFS metadata which would be linked into the 
filesystem on a --rebuild-tree, by doing that I created a SUID root file as 
non-root on a ReiserFS system. Also ReiserFS was inherently unsuitable for 
storing filesystem images as that could mess up the filesystem.

I believe that BTRFS uses a UUID for each filesystem that is included in every 
metadata block which will make it very unlikely that two runs of mkfs.btrfs 
will result in the same UUID.  Therefore there should be no risk of a 
filesystem image stored in a file messing up a filesystem.

Is it possible for a hostile user to create a file that could get linked in to 
a filesystem by btrfsck?  /dev/disk/by-uuid/ is world readable so the UUID of 
the filesystem is not secret.  Apart from the fact that a correct tree (which 
can be verified by checksums) won't link to data blocks as metadata what 
assurance do we have that hostile or corrupt data blocks can't be treated as 
metadata?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
