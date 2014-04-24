Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21762 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbaDXDWb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:22:31 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O3MF3S005672
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 11:22:15 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs-progs: fsck: avoid pinning same block several times
Date: Thu, 24 Apr 2014 11:19:17 +0800
Message-ID: <1398309558-29509-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1398309558-29509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1398309558-29509-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This can not only give some speedups but also avoid forever loop
with a really broken filesystem.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 15806a4..e6fb380 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6189,6 +6189,15 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 	int ret;
 	int i;
 
+	/*
+	 * If we have pinned this block before, don't pin it again.
+	 * This can not only avoid forever loop with broken filesystem
+	 * but also give us some speedups.
+	 */
+	if (test_range_bit(&fs_info->pinned_extents, eb->start,
+			   eb->start + eb->len - 1, EXTENT_DIRTY, 0))
+		return 0;
+
 	btrfs_pin_extent(fs_info, eb->start, eb->len);
 
 	leafsize = btrfs_super_leafsize(fs_info->super_copy);
-- 
1.9.0

