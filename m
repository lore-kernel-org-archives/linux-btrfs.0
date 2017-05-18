Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755094AbdERDjJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:09 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 08/32] btrfs-progs: Refactor block sizes users in backref.c
Date: Thu, 18 May 2017 11:38:33 +0800
Message-ID: <20170518033857.15002-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 backref.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/backref.c b/backref.c
index e1f41e1a..31681a85 100644
--- a/backref.c
+++ b/backref.c
@@ -451,7 +451,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 			continue;
 		BUG_ON(!ref->wanted_disk_byte);
 		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
-				     fs_info->tree_root->nodesize, 0);
+				     fs_info->nodesize, 0);
 		if (!extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
 			return -EIO;
@@ -804,7 +804,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			    ref->level == 0) {
 				u32 bsz;
 				struct extent_buffer *eb;
-				bsz = fs_info->extent_root->nodesize;
+				bsz = fs_info->nodesize;
 				eb = read_tree_block(fs_info->extent_root,
 							   ref->parent, bsz, 0);
 				if (!extent_buffer_uptodate(eb)) {
@@ -1154,7 +1154,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	}
 	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
 	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
-		size = fs_info->extent_root->nodesize;
+		size = fs_info->nodesize;
 	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
 		size = found_key->offset;
 
-- 
2.13.0



