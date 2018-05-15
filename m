Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:41956 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753427AbeEORwY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 13:52:24 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 6/6] Btrfs: remove always true check in unlock_up
Date: Wed, 16 May 2018 01:52:08 +0800
Message-Id: <1526406728-109055-7-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526406728-109055-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@path->lock[i] is always true at this point.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index f7c3f581f647..16d28a4ec54f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2330,7 +2330,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
 			no_skips = 1;
 
 		t = path->nodes[i];
-		if (i >= lowest_unlock && i > skip_level && path->locks[i]) {
+		if (i >= lowest_unlock && i > skip_level) {
 			btrfs_tree_unlock_rw(t, path->locks[i]);
 			path->locks[i] = 0;
 			if (write_lock_level &&
-- 
1.8.3.1

