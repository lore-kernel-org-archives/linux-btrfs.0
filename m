Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19090 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752124AbaLAKCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 05:02:39 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB1A2HwW020996
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Dec 2014 18:02:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix wrong list access on the failure of reading out checksum
Date: Mon, 1 Dec 2014 18:04:13 +0800
Message-ID: <1417428253-3139-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we failed to reading out the checksum, we would free all the checksums
in the list. But the current code accessed the list head, not the entry
in the list. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file-item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 783a943..c26b58f 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -413,7 +413,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	ret = 0;
 fail:
 	while (ret < 0 && !list_empty(&tmplist)) {
-		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
+		sums = list_first_entry(&tmplist, struct btrfs_ordered_sum,
+					list);
 		list_del(&sums->list);
 		kfree(sums);
 	}
-- 
1.9.3

