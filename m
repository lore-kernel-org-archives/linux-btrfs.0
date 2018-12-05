Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93EBC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA0C2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AA0C2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbeLEGkm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:49754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGkm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1CD97AEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/13] btrfs-progs: Fix missing-prototypes warning caused by non-static functions
Date:   Wed,  5 Dec 2018 14:40:14 +0800
Message-Id: <20181205064018.27755-10-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Make the following functions static to avoid missing-prototypes warning:
 - btrfs.c::handle_special_globals()
 - check/mode-lowmem.c::repair_ternary_lowmem()
 - extent-tree.c::btrfs_search_overlap_extent()
 - free-space-tree.c::convert_free_space_to_bitmaps()
 - free-space-tree.c::convert_free_space_to_extents()
 - free-space-tree.c::__remove_from_free_space_tree()
 - free-space-tree.c::__add_to_free_space_tree()
 - free-space-tree.c::btrfs_create_tree()

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs.c             |  2 +-
 check/mode-lowmem.c |  6 +++---
 extent-tree.c       |  2 +-
 free-space-tree.c   | 30 +++++++++++++++---------------
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 2d39f2ced3e8..78c468d2e050 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
 	return shift;
 }
 
-void handle_special_globals(int shift, int argc, char **argv)
+static void handle_special_globals(int shift, int argc, char **argv)
 {
 	int has_help = 0;
 	int has_full = 0;
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 14bbc9ee6cb6..f56b5e8d45dc 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -953,9 +953,9 @@ out:
  * returns 0 means success.
  * returns not 0 means on error;
  */
-int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
-			  u64 index, char *name, int name_len, u8 filetype,
-			  int err)
+static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
+				 u64 index, char *name, int name_len,
+				 u8 filetype, int err)
 {
 	struct btrfs_trans_handle *trans;
 	int stage = 0;
diff --git a/extent-tree.c b/extent-tree.c
index cd98633992ac..8c9cdeff3b02 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
  * Return >0 for not found.
  * Return <0 for err
  */
-int btrfs_search_overlap_extent(struct btrfs_root *root,
+static int btrfs_search_overlap_extent(struct btrfs_root *root,
 				struct btrfs_path *path, u64 bytenr, u64 len)
 {
 	struct btrfs_key key;
diff --git a/free-space-tree.c b/free-space-tree.c
index 6641cdfa42ba..b3ffa90f704c 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -202,9 +202,9 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 	}
 }
 
-int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path)
+static int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
@@ -341,9 +341,9 @@ out:
 	return ret;
 }
 
-int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path)
+static int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = fs_info->free_space_root;
@@ -780,9 +780,9 @@ out:
 	return ret;
 }
 
-int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
-				  struct btrfs_block_group_cache *block_group,
-				  struct btrfs_path *path, u64 start, u64 size)
+static int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path, u64 start, u64 size)
 {
 	struct btrfs_free_space_info *info;
 	u32 flags;
@@ -960,9 +960,9 @@ out:
 	return ret;
 }
 
-int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_block_group_cache *block_group,
-			     struct btrfs_path *path, u64 start, u64 size)
+static int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *block_group,
+				struct btrfs_path *path, u64 start, u64 size)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_free_space_info *info;
@@ -1420,9 +1420,9 @@ out:
 	return ret;
 }
 
-struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
-				     u64 objectid)
+static struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+					    struct btrfs_fs_info *fs_info,
+					    u64 objectid)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-- 
2.19.2

