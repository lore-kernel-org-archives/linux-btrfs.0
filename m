Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634D0C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C07216E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:06:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21C07216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbeI1I0S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EC373ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/6] btrfs-progs: print-tree: Introduce breadth-first search
Date:   Fri, 28 Sep 2018 10:04:44 +0800
Message-Id: <20180928020446.21467-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce a new function, bfs_print_children(), to do breadth-first
search to print a node.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index 31f6fa12522f..685d2be8c35a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1381,6 +1381,78 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 	}
 }
 
+/* Helper function to reach the most left tree block at @path->lowest_level */
+static int search_leftmost_tree_block(struct btrfs_fs_info *fs_info,
+				      struct btrfs_path *path, int root_level)
+{
+	int i;
+	int ret = 0;
+
+	/* Release all nodes expect path->nodes[root_level] */
+	for (i = 0; i < root_level; i++) {
+		path->slots[i] = 0;
+		if (!path->nodes[i])
+			continue;
+		free_extent_buffer(path->nodes[i]);
+	}
+
+	/* Reach the leftmost tree block by always reading out slot 0 */
+	for (i = root_level; i > path->lowest_level; i--) {
+		struct extent_buffer *eb;
+
+		path->slots[i] = 0;
+		eb = read_node_slot(fs_info, path->nodes[i], 0);
+		if (!extent_buffer_uptodate(eb)) {
+			ret = -EIO;
+			goto out;
+		}
+		path->nodes[i - 1] = eb;
+	}
+out:
+	return ret;
+}
+
+static void bfs_print_children(struct extent_buffer *root_eb)
+{
+	struct btrfs_fs_info *fs_info = root_eb->fs_info;
+	struct btrfs_path path;
+	int root_level = btrfs_header_level(root_eb);
+	int cur_level;
+	int ret;
+
+	if (root_level < 1)
+		return;
+
+	btrfs_init_path(&path);
+	/* For path */
+	extent_buffer_get(root_eb);
+	path.nodes[root_level] = root_eb;
+
+	for (cur_level = root_level - 1; cur_level >= 0; cur_level--) {
+		path.lowest_level = cur_level;
+
+		/* Use the leftmost tree block as start point */
+		ret = search_leftmost_tree_block(fs_info, &path, root_level);
+		if (ret < 0)
+			goto out;
+
+		/* Print all sibling tree blocks */
+		while (1) {
+			btrfs_print_tree(path.nodes[cur_level], 0);
+			ret = btrfs_next_sibling_tree_block(fs_info, &path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return;
+}
+
 void btrfs_print_tree(struct extent_buffer *eb, int follow)
 {
 	u32 i;
-- 
2.19.0

