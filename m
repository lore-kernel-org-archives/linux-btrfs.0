Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19605 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753635AbdIHIts (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 04:49:48 -0400
Subject: [PATCH] btrfs: propagate error to btrfs_cmp_data_prepare caller
From: Naohiro Aota <naohiro.aota@wdc.com>
To: linux-btrfs@vger.kernel.org
Cc: mfasheh@suse.de, dsterba@suse.com
Date: Fri, 08 Sep 2017 17:48:55 +0900
Message-ID: <150486053591.31637.4198233649091096390.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_cmp_data_prepare() (almost) always returns 0 i.e. ignoring errors
from gather_extent_pages(). While the pages are freed by
btrfs_cmp_data_free(), cmp->num_pages still has > 0. Then,
btrfs_extent_same() try to access the already freed pages causing faults
(or violates PageLocked assertion).

This patch just return the error as is so that the caller stop the process.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: f441460202cb ("btrfs: fix deadlock with extent-same and readpage")
Cc: <stable@vger.kernel.org> # 4.2
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ae8fbf9d3de2..b5971923f15f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3028,7 +3028,7 @@ static int btrfs_cmp_data_prepare(struct inode *src, u64 loff,
 out:
 	if (ret)
 		btrfs_cmp_data_free(cmp);
-	return 0;
+	return ret;
 }
 
 static int btrfs_cmp_data(u64 len, struct cmp_pages *cmp)

