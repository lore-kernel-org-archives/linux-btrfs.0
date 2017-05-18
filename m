Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932209AbdERDj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 28/32] btrfs-progs: Refactor sectorsize users in cmds-inspect-dump-tree.c
Date: Thu, 18 May 2017 11:38:53 +0800
Message-ID: <20170518033857.15002-29-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-inspect-dump-tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 5a5ca536..869ad6ba 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -49,7 +49,7 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 		return;
 	}
 
-	size = root->nodesize;
+	size = root->fs_info->nodesize;
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
 		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
@@ -313,7 +313,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	if (block_only) {
 		leaf = read_tree_block(root,
 				      block_only,
-				      root->nodesize, 0);
+				      info->nodesize, 0);
 
 		if (extent_buffer_uptodate(leaf) &&
 		    btrfs_header_level(leaf) != 0) {
@@ -324,7 +324,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		if (!leaf) {
 			leaf = read_tree_block(root,
 					      block_only,
-					      root->nodesize, 0);
+					      info->nodesize, 0);
 		}
 		if (!extent_buffer_uptodate(leaf)) {
 			error("failed to read %llu",
@@ -441,8 +441,7 @@ again:
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
 			buf = read_tree_block(tree_root_scan,
 					      btrfs_root_bytenr(&ri),
-					      tree_root_scan->nodesize,
-					      0);
+					      info->nodesize, 0);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
 			if (tree_id && found_key.objectid != tree_id) {
-- 
2.13.0



