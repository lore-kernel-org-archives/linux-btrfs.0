Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.clear-code.com ([219.94.234.64]:45973 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992600Ab2KOE6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 23:58:17 -0500
From: Kenji Okimoto <okimoto@clear-code.com>
To: linux-btrfs@vger.kernel.org
Cc: Kenji Okimoto <okimoto@clear-code.com>
Subject: [PATCH 1/3] btrfs-progs: plug a memory leak reported by cppcheck
Date: Thu, 15 Nov 2012 13:47:50 +0900
Message-Id: <1352954872-13770-2-git-send-email-okimoto@clear-code.com>
In-Reply-To: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
References: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[src/btrfs/disk-io.c:462]: (error) Memory leak: log_root

Signed-off-by: Kenji Okimoto <okimoto@clear-code.com>
---
 disk-io.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 0395205..32f45dc 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -458,8 +458,10 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 	u64 blocknr = btrfs_super_log_root(disk_super);
 	struct btrfs_root *log_root = malloc(sizeof(struct btrfs_root));
 
-	if (blocknr == 0)
+	if (blocknr == 0) {
+		free(log_root);
 		return 0;
+	}
 
 	blocksize = btrfs_level_size(tree_root,
 			     btrfs_super_log_root_level(disk_super));
@@ -474,8 +476,12 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 
 	fs_info->log_root_tree = log_root;
 
-	if (!extent_buffer_uptodate(log_root->node))
+	if (!extent_buffer_uptodate(log_root->node)) {
+		free(log_root);
 		return -EIO;
+	}
+
+	free(log_root);
 	return 0;
 }
 
-- 
1.7.10.4

