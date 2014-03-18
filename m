Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbaCRMFF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4u1s001918
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs-progs: fsck: reduce memory usage of extent record struct
Date: Tue, 18 Mar 2014 20:02:46 +0800
Message-Id: <1395144167-775-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two changes:
	1.use bit filed for @found_rec
	2.u32 is enough to calculate duplicate extent number.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e1238d7..34f8fa6 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -92,7 +92,6 @@ struct extent_record {
 	struct list_head list;
 	struct cache_extent cache;
 	struct btrfs_disk_key parent_key;
-	unsigned int found_rec;
 	u64 start;
 	u64 max_size;
 	u64 nr;
@@ -101,8 +100,9 @@ struct extent_record {
 	u64 generation;
 	u64 parent_generation;
 	u64 info_objectid;
-	u64 num_duplicates;
+	u32 num_duplicates;
 	u8 info_level;
+	unsigned int found_rec:1;
 	unsigned int content_checked:1;
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
@@ -2742,7 +2742,10 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	rec->start = start;
 	rec->max_size = max_size;
 	rec->nr = max(nr, max_size);
-	rec->found_rec = extent_rec;
+	if (extent_rec)
+		rec->found_rec = 1;
+	else
+		rec->found_rec = 0;
 	rec->content_checked = 0;
 	rec->owner_ref_checked = 0;
 	rec->num_duplicates = 0;
-- 
1.9.0

