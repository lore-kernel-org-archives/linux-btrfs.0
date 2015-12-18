Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:50165 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLRORw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 09:17:52 -0500
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] btrfs: use list_for_each_entry_safe in free-space-cache.c
Date: Fri, 18 Dec 2015 22:17:00 +0800
Message-Id: <b87e3c3186f2f308924b2e09d112036912233c9d.1450447999.git.geliangtang@163.com>
In-Reply-To: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
References: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
In-Reply-To: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
References: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use list_for_each_entry_safe() instead of list_for_each_safe() to
simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/btrfs/free-space-cache.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 85a1f86..a368bc8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1086,14 +1086,11 @@ write_pinned_extent_entries(struct btrfs_root *root,
 static noinline_for_stack int
 write_bitmap_entries(struct btrfs_io_ctl *io_ctl, struct list_head *bitmap_list)
 {
-	struct list_head *pos, *n;
+	struct btrfs_free_space *entry, *next;
 	int ret;
 
 	/* Write out the bitmaps */
-	list_for_each_safe(pos, n, bitmap_list) {
-		struct btrfs_free_space *entry =
-			list_entry(pos, struct btrfs_free_space, list);
-
+	list_for_each_entry_safe(entry, next, bitmap_list, list) {
 		ret = io_ctl_add_bitmap(io_ctl, entry->bitmap);
 		if (ret)
 			return -ENOSPC;
@@ -1119,13 +1116,10 @@ static int flush_dirty_cache(struct inode *inode)
 static void noinline_for_stack
 cleanup_bitmap_list(struct list_head *bitmap_list)
 {
-	struct list_head *pos, *n;
+	struct btrfs_free_space *entry, *next;
 
-	list_for_each_safe(pos, n, bitmap_list) {
-		struct btrfs_free_space *entry =
-			list_entry(pos, struct btrfs_free_space, list);
+	list_for_each_entry_safe(entry, next, bitmap_list, list)
 		list_del_init(&entry->list);
-	}
 }
 
 static void noinline_for_stack
-- 
2.5.0


