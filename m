Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756108AbbJ2Jdl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:41 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X5nR015828
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:05 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/6] btrfs-progs: Fix uninitialized key.type for btrfs_find_free_objectid
Date: Thu, 29 Oct 2015 17:31:46 +0800
Message-ID: <36a8a7fc4a466fbdee71312b5da2773fdeef4588.1446111097.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To avoid using uninitialized value in btrfs_search_slot().

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 inode-map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/inode-map.c b/inode-map.c
index 1321bfb..346952b 100644
--- a/inode-map.c
+++ b/inode-map.c
@@ -44,6 +44,7 @@ int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 				BTRFS_FIRST_FREE_OBJECTID);
 	search_key.objectid = search_start;
 	search_key.offset = 0;
+	search_key.type = 0;
 
 	btrfs_init_path(path);
 	start_found = 0;
-- 
1.8.5.1

