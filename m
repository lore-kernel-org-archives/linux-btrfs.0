Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37852 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753527AbeASFhr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:47 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 05/16] btrfs-progs: check: Export check global variables to check/common.h
Date: Fri, 19 Jan 2018 13:37:20 +0800
Message-Id: <20180119053731.10795-6-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a dozen of variables which are used as "check global"
variables, like @total_csum_bytes or @no_holes.

These variables are used freely across the check code, however since
we're splitting check code, they need to be exported so they can be used
in other files.

This patch just export them and add declarations for them in
check/common.h.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.h | 17 +++++++++++++++++
 check/main.c   | 32 ++++++++++++++++----------------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/check/common.h b/check/common.h
index 25874aec597b..8d93ddbf4afb 100644
--- a/check/common.h
+++ b/check/common.h
@@ -36,4 +36,21 @@ struct node_refs {
 	int full_backref[BTRFS_MAX_LEVEL];
 };
 
+extern u64 bytes_used;
+extern u64 total_csum_bytes;
+extern u64 total_btree_bytes;
+extern u64 total_fs_tree_bytes;
+extern u64 total_extent_tree_bytes;
+extern u64 btree_space_waste;
+extern u64 data_bytes_allocated;
+extern u64 data_bytes_referenced;
+extern struct list_head duplicate_extents;
+extern struct list_head delete_items;
+extern int no_holes;
+extern int init_extent_tree;
+extern int check_data_csum;
+extern struct btrfs_fs_info *global_info;
+extern struct task_ctx ctx;
+extern struct cache_tree *roots_info_cache;
+
 #endif
diff --git a/check/main.c b/check/main.c
index fbd73c42bee8..bb927ecc87ee 100644
--- a/check/main.c
+++ b/check/main.c
@@ -61,22 +61,22 @@ struct task_ctx {
 	struct task_info *info;
 };
 
-static u64 bytes_used = 0;
-static u64 total_csum_bytes = 0;
-static u64 total_btree_bytes = 0;
-static u64 total_fs_tree_bytes = 0;
-static u64 total_extent_tree_bytes = 0;
-static u64 btree_space_waste = 0;
-static u64 data_bytes_allocated = 0;
-static u64 data_bytes_referenced = 0;
-static LIST_HEAD(duplicate_extents);
-static LIST_HEAD(delete_items);
-static int no_holes = 0;
-static int init_extent_tree = 0;
-static int check_data_csum = 0;
-static struct btrfs_fs_info *global_info;
-static struct task_ctx ctx = { 0 };
-static struct cache_tree *roots_info_cache = NULL;
+u64 bytes_used = 0;
+u64 total_csum_bytes = 0;
+u64 total_btree_bytes = 0;
+u64 total_fs_tree_bytes = 0;
+u64 total_extent_tree_bytes = 0;
+u64 btree_space_waste = 0;
+u64 data_bytes_allocated = 0;
+u64 data_bytes_referenced = 0;
+LIST_HEAD(duplicate_extents);
+LIST_HEAD(delete_items);
+int no_holes = 0;
+int init_extent_tree = 0;
+int check_data_csum = 0;
+struct btrfs_fs_info *global_info;
+struct task_ctx ctx = { 0 };
+struct cache_tree *roots_info_cache = NULL;
 
 enum btrfs_check_mode {
 	CHECK_MODE_ORIGINAL,
-- 
2.15.1

