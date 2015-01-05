Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753036AbbAEH6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 02:58:19 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t057vg9C005985
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Jan 2015 15:57:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a extent buffer leak in count_csum_range().
Date: Mon, 5 Jan 2015 15:56:15 +0800
Message-ID: <1420444575-23259-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit f495a2ac6611 ("btrfs-progs: fsck: remove unfriendly BUG_ON()
for searching tree failure") is causing tons of extent buffer leak if some
csum mismatches in btrfsck.

This is caused by a misplaced btrfs_release_path(), fix it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index d2d218a..5b644cf 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1186,9 +1186,9 @@ static int count_csum_range(struct btrfs_root *root, u64 start,
 		path.slots[0]++;
 	}
 out:
+	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
-	btrfs_release_path(&path);
 	return 0;
 }
 
-- 
2.2.1

