Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55022 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756509AbbGGIPe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 04:15:34 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/7] btrfs-progs: disk-io: Support commit transaction on chunk tree.
Date: Tue, 7 Jul 2015 16:15:22 +0800
Message-ID: <1436256928-23812-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As chunk tree is only stored in super block, chunk tree commit doesn't
need to go through tree root update.
Or a BUG_ON will be triggered.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 6a53843..fdcfd6d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -571,6 +571,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto commit_tree;
 	if (root == root->fs_info->tree_root)
 		goto commit_tree;
+	if (root == root->fs_info->chunk_root)
+		goto commit_tree;
 
 	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
-- 
2.4.4

