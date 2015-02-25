Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40333 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753062AbbBYCx5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 21:53:57 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1P2r5os031612
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 10:53:05 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: add WARN_ON() to check is space_info op current
Date: Wed, 25 Feb 2015 10:52:47 +0800
Message-ID: <1424832767-25076-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1424832762-24926-1-git-send-email-zhaolei@cn.fujitsu.com>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

space_info's value calculation is some complex and easy to cause
bug, add WARN_ON() to help debug.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3e7a4af..8b51eb5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9471,9 +9471,17 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_lock(&block_group->space_info->lock);
 	list_del_init(&block_group->ro_list);
+
+	WARN_ON(block_group->space_info->total_bytes
+		< block_group->key.offset);
+	WARN_ON(block_group->space_info->bytes_readonly
+		< block_group->key.offset);
+	WARN_ON(block_group->space_info->disk_total
+		< block_group->key.offset * factor);
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
 	block_group->space_info->disk_total -= block_group->key.offset * factor;
+
 	spin_unlock(&block_group->space_info->lock);
 
 	memcpy(&key, &block_group->key, sizeof(key));
-- 
1.8.5.1

