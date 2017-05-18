Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755072AbdERDjJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:09 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 04/32] btrfs-progs: Refactor block sizes users in btrfs-corrupt-block.c
Date: Thu, 18 May 2017 11:38:29 +0800
Message-ID: <20170518033857.15002-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert root->sectorsize/nodesize users in btrfs-corrupt-block.

This provides the basis to further refactor incorrect btrfs_root
parameter to btrfs_fs_info parameter.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 71b4d771..20a4c1df 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -169,7 +169,7 @@ static int corrupt_keys_in_block(struct btrfs_root *root, u64 bytenr)
 {
 	struct extent_buffer *eb;
 
-	eb = read_tree_block(root, bytenr, root->nodesize, 0);
+	eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb))
 		return -EIO;;
 
@@ -297,7 +297,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 		struct extent_buffer *next;
 
 		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
-				       root->nodesize,
+				       root->fs_info->nodesize,
 				       btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next))
 			continue;
@@ -764,7 +764,7 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 		return -EINVAL;
 	}
 
-	eb = read_tree_block(root, block, root->nodesize, 0);
+	eb = read_tree_block(root, block, root->fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb)) {
 		fprintf(stderr, "Couldn't read in tree block %s\n", field);
 		return -EINVAL;
@@ -1352,10 +1352,9 @@ int main(int argc, char **argv)
 		print_usage(1);
 
 	if (bytes == 0)
-		bytes = root->sectorsize;
+		bytes = root->fs_info->sectorsize;
 
-	bytes = (bytes + root->sectorsize - 1) / root->sectorsize;
-	bytes *= root->sectorsize;
+	bytes = round_up(bytes, root->fs_info->sectorsize);
 
 	while (bytes > 0) {
 		if (corrupt_block_keys) {
@@ -1364,7 +1363,7 @@ int main(int argc, char **argv)
 			struct extent_buffer *eb;
 
 			eb = btrfs_find_create_tree_block(root->fs_info,
-					logical, root->sectorsize);
+					logical, root->fs_info->sectorsize);
 			if (!eb) {
 				error(
 		"not enough memory to allocate extent buffer for bytenr %llu",
@@ -1373,12 +1372,12 @@ int main(int argc, char **argv)
 				goto out_close;
 			}
 
-			debug_corrupt_block(eb, root, logical, root->sectorsize,
-					copy);
+			debug_corrupt_block(eb, root, logical,
+					    root->fs_info->sectorsize, copy);
 			free_extent_buffer(eb);
 		}
-		logical += root->sectorsize;
-		bytes -= root->sectorsize;
+		logical += root->fs_info->sectorsize;
+		bytes -= root->fs_info->sectorsize;
 	}
 	return ret;
 out_close:
-- 
2.13.0



