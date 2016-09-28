Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24620 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751573AbcI1IaS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 04:30:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: Remove unnecessary parameter to clear_extent_uptodate
Date: Wed, 28 Sep 2016 16:30:04 +0800
Message-Id: <20160928083004.17860-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160928083004.17860-1-quwenruo@cn.fujitsu.com>
References: <20160928083004.17860-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c   | 4 ++--
 extent_io.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 854c285..08d3f79 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -241,7 +241,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 
 	ret = 1;
 out:
-	clear_extent_buffer_uptodate(io_tree, eb);
+	clear_extent_buffer_uptodate(eb);
 	return ret;
 
 }
@@ -976,7 +976,7 @@ static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
 			btrfs_find_create_tree_block(fs_info, 0, nodesize);
 		if (!info_root->node)
 			return -ENOMEM;
-		clear_extent_buffer_uptodate(NULL, info_root->node);
+		clear_extent_buffer_uptodate(info_root->node);
 	}
 
 	return 0;
diff --git a/extent_io.h b/extent_io.h
index 208c4fe..bd6cf9e 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -125,8 +125,7 @@ static inline int set_extent_buffer_uptodate(struct extent_buffer *eb)
 	return 0;
 }
 
-static inline int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
-				struct extent_buffer *eb)
+static inline int clear_extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	eb->flags &= ~EXTENT_UPTODATE;
 	return 0;
-- 
2.10.0



