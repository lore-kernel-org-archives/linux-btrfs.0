Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2467 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751629AbcH3HW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:29 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 46AE44334C75
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 15:22:21 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] btrfs-progs: fsck: Check bytenr alignment for extent item
Date: Tue, 30 Aug 2016 15:22:15 +0800
Message-ID: <20160830072217.8599-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check bytenr alignment for extent item to filter invalid items early.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 2aa0a7b..c56b176 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5422,6 +5422,11 @@ static int process_extent_item(struct btrfs_root *root,
 		num_bytes = key.offset;
 	}
 
+	if (!IS_ALIGNED(key.objectid, root->sectorsize)) {
+		error("ignoring invalid extent, bytenr %llu is not aligned to %u",
+		      key.objectid, root->sectorsize);
+		return -EIO;
+	}
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		struct btrfs_extent_item_v0 *ei0;
@@ -5448,6 +5453,16 @@ static int process_extent_item(struct btrfs_root *root,
 		metadata = 1;
 	else
 		metadata = 0;
+	if (metadata && num_bytes != root->nodesize) {
+		error("ignore invalid metadata extent, length %llu does not equal to %u",
+		      num_bytes, root->nodesize);
+		return -EIO;
+	}
+	if (!metadata && !IS_ALIGNED(num_bytes, root->sectorsize)) {
+		error("ignore invalid data extent, length %llu is not aligned to %u",
+		      num_bytes, root->sectorsize);
+		return -EIO;
+	}
 
 	memset(&tmpl, 0, sizeof(tmpl));
 	tmpl.start = key.objectid;
-- 
2.9.3



