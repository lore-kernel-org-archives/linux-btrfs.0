Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50301 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaACKXy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 05:23:54 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s03ANpLF012575
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Jan 2014 18:23:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: only fua the first superblock when writting supers
Date: Fri, 3 Jan 2014 18:22:57 +0800
Message-Id: <1388744577-13968-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We only intent to fua the first superblock in every device from
comments, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9417b73..b016657 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3142,7 +3142,10 @@ static int write_dev_supers(struct btrfs_device *device,
 		 * we fua the first super.  The others we allow
 		 * to go down lazy.
 		 */
-		ret = btrfsic_submit_bh(WRITE_FUA, bh);
+		if (i == 0)
+			ret = btrfsic_submit_bh(WRITE_FUA, bh);
+		else
+			ret = btrfsic_submit_bh(WRITE_SYNC, bh);
 		if (ret)
 			errors++;
 	}
-- 
1.8.3.1

