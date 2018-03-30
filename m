Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35410 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752346AbeC3WMK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 18:12:10 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: bail out on error during replay_dir_deletes
Date: Sat, 31 Mar 2018 06:11:58 +0800
Message-Id: <1522447918-19147-4-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If errors were returned by btrfs_next_leaf(), replay_dir_deletes needs
to bail out, otherwise @ret would be forced to be 0 after 'break;' and
the caller won't be aware of it.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ee9431..11e2c26 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2356,8 +2356,10 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
 			nritems = btrfs_header_nritems(path->nodes[0]);
 			if (path->slots[0] >= nritems) {
 				ret = btrfs_next_leaf(root, path);
-				if (ret)
+				if (ret == 1)
 					break;
+				else if (ret < 0)
+					goto out;
 			}
 			btrfs_item_key_to_cpu(path->nodes[0], &found_key,
 					      path->slots[0]);
-- 
1.8.3.1

