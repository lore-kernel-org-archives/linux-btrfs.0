Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50927 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751844AbeERDAc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 23:00:32 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 6/6] Btrfs: remove always true check in unlock_up
Date: Fri, 18 May 2018 11:00:24 +0800
Message-Id: <1526612424-97061-7-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As unlock_up() is written as

for () {
   if (!path->locks[i])
       break;
   ...
   if (... && path->locks[i]) {
   }
}

Apparently, @path->locks[i] is always true at this 'if'.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e619f7e01794..65dbebb8cc59 100644
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

