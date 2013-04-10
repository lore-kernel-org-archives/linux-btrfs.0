Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35362 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935448Ab3DJLXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 07:23:23 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so214095pbc.15
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2013 04:23:23 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, list.btrfs@jan-o-sch.net
Subject: [PATCH 2/2] Btrfs: make some functions return type be void in backref.c
Date: Wed, 10 Apr 2013 19:22:51 +0800
Message-Id: <1365592971-1535-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
References: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

__merge_refs() and __add_missing_keys() always return 0, it is unnecessary
for the caller to check the return value.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index dc200f6..3521206 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -404,7 +404,7 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
 /*
  * read tree blocks and add keys where required.
  */
-static int __add_missing_keys(struct btrfs_fs_info *fs_info,
+static void __add_missing_keys(struct btrfs_fs_info *fs_info,
 			      struct list_head *head)
 {
 	struct list_head *pos;
@@ -430,7 +430,6 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 		btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
 	}
-	return 0;
 }
 
 /*
@@ -443,7 +442,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
  *           having a parent).
  * mode = 2: merge identical parents
  */
-static int __merge_refs(struct list_head *head, int mode)
+static void __merge_refs(struct list_head *head, int mode)
 {
 	struct list_head *pos1;
 
@@ -489,7 +488,6 @@ static int __merge_refs(struct list_head *head, int mode)
 		}
 
 	}
-	return 0;
 }
 
 /*
@@ -880,22 +878,16 @@ again:
 
 	list_splice_init(&prefs_delayed, &prefs);
 
-	ret = __add_missing_keys(fs_info, &prefs);
-	if (ret)
-		goto out;
+	__add_missing_keys(fs_info, &prefs);
 
-	ret = __merge_refs(&prefs, 1);
-	if (ret)
-		goto out;
+	__merge_refs(&prefs, 1);
 
 	ret = __resolve_indirect_refs(fs_info, search_commit_root, time_seq,
 				      &prefs, extent_item_pos);
 	if (ret)
 		goto out;
 
-	ret = __merge_refs(&prefs, 2);
-	if (ret)
-		goto out;
+	__merge_refs(&prefs, 2);
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-- 
1.7.7.6

