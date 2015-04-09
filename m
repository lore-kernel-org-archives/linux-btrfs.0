Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22081 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbbDIEgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 00:36:23 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t394ZDws019923
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Apr 2015 12:35:13 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/9] btrfs: Adjust commit-transaction condition to avoid NO_SPACE more
Date: Thu, 9 Apr 2015 12:34:38 +0800
Message-ID: <6b512123aa6fc29751a03f029bb11ebde9a7b697.1428554023.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

If we have any chance to make a successful write, we should not give up.

This patch adjust commit-transaction condition from:
  pinned >= wanted
to
  left + pinned >= wanted

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ebeedb4..644468b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3713,7 +3713,8 @@ alloc:
 		 * don't bother committing the transaction.
 		 */
 		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
-					   bytes) < 0)
+					   used + bytes -
+					   data_sinfo->total_bytes) < 0)
 			have_pinned_space = 0;
 		spin_unlock(&data_sinfo->lock);
 
-- 
1.8.5.1

