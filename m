Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10721 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbbBZGt3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 01:49:29 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1Q6mZOO006727
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2015 14:48:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 2/2] btrfs: add WARN_ON() to check is space_info op current
Date: Thu, 26 Feb 2015 14:48:14 +0800
Message-ID: <b7eb09ad2f4c52a27560c1822700821ea9d68c3c.1424932917.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1424932917.git.zhaolei@cn.fujitsu.com>
References: <cover.1424932917.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

space_info's value calculation is some complex and easy to cause
bug, add WARN_ON() to help debug.

Changelog v1->v2:
 Put WARN_ON()s under the ENOSPC_DEBUG mount option.
 Suggested by: David Sterba <dsterba@suse.cz>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bfb9105..6c19033 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9415,9 +9415,19 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	spin_lock(&block_group->space_info->lock);
 	list_del_init(&block_group->ro_list);
+
+	if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
+		WARN_ON(block_group->space_info->total_bytes
+			< block_group->key.offset);
+		WARN_ON(block_group->space_info->bytes_readonly
+			< block_group->key.offset);
+		WARN_ON(block_group->space_info->disk_total
+			< block_group->key.offset * factor);
+	}
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
 	block_group->space_info->disk_total -= block_group->key.offset * factor;
+
 	spin_unlock(&block_group->space_info->lock);
 
 	memcpy(&key, &block_group->key, sizeof(key));
-- 
1.8.5.1

