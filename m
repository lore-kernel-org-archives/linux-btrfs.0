Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:62347 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab3GDNvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jul 2013 09:51:01 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 31.28 OK)
	with ESMTP id X06921p649L5aP for <linux-btrfs@vger.kernel.org>;
	Thu, 4 Jul 2013 15:50:59 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong write offset when replacing a device
Date: Thu,  4 Jul 2013 15:50:59 +0200
Message-Id: <1372945859-23480-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao Xie reported the following issue:

The filesystem was corrupted after we did a device replace.

Steps to reproduce:
 # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
 # mount <device0> <mnt>
 # btrfs replace start -rfB 1 <device4> <mnt>
 # umount <mnt>
 # btrfsck <device4>

The reason for the issue is that we changed the write offset by mistake,
introduced by commit 625f1c8dc.

We read the data from the source device at first, and then write the
data into the corresponding place of the new device. In order to
implement the "-r" option, the source location is remapped using
btrfs_map_block(). The read takes place on the mapped location, and
the write needs to take place on the unmapped location. Currently
the write is using the mapped location, and this commit changes it
back by undoing the change to the write address that the aforementioned
commit added by mistake.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4ba2a69..64a157b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2495,7 +2495,7 @@ again:
 			ret = scrub_extent(sctx, extent_logical, extent_len,
 					   extent_physical, extent_dev, flags,
 					   generation, extent_mirror_num,
-					   extent_physical);
+					   extent_logical - logical + physical);
 			if (ret)
 				goto out;
 
-- 
1.8.3.2

