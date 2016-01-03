Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35933 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbcACTAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 14:00:23 -0500
Received: by mail-pf0-f173.google.com with SMTP id 65so145530176pff.3
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 11:00:23 -0800 (PST)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Zach Brown <zab@redhat.com>
Subject: [PATCH 6/6] btrfs-progs: fix using on-disk structure to store in memory data
Date: Mon,  4 Jan 2016 03:59:58 +0900
Message-Id: <1451847598-30666-7-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
References: <1451847598-30666-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In 'qgroup_count' structure 'diskinfo' and 'info' are used to store only
in memory data but its types are for on-disk structure as a result sparse
warns it (different base types).  So fix it by adding new structure
'qgroup_info' to store in memory data and replace on-disk structure
'btrfs_qgroup_info_item' by 'qgroup_info'.  In addition in alloc_cnt()
'generation' is set but not used after that so remove the relevant code.

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 qgroup-verify.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 0ee52ff5c857..a0a4d4a5f5d9 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -37,16 +37,23 @@ static unsigned long tot_extents_scanned = 0;
 
 static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive);
 
+struct qgroup_info {
+	u64 referenced;
+	u64 referenced_compressed;
+	u64 exclusive;
+	u64 exclusive_compressed;
+};
+
 struct qgroup_count {
-	u64				qgroupid;
-	int				subvol_exists;
+	u64			qgroupid;
+	int			subvol_exists;
 
-	struct btrfs_disk_key		key;
-	struct btrfs_qgroup_info_item	diskinfo;
+	struct btrfs_disk_key	key;
+	struct qgroup_info	diskinfo;
 
-	struct btrfs_qgroup_info_item	info;
+	struct qgroup_info	info;
 
-	struct rb_node			rb_node;
+	struct rb_node		rb_node;
 };
 
 static struct counts_tree {
@@ -647,14 +654,13 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 					struct btrfs_qgroup_info_item *disk)
 {
 	struct qgroup_count *c = calloc(1, sizeof(*c));
-	struct btrfs_qgroup_info_item *item;
+	struct qgroup_info *item;
 
 	if (c) {
 		c->qgroupid = btrfs_disk_key_offset(key);
 		c->key = *key;
 
 		item = &c->diskinfo;
-		item->generation = btrfs_qgroup_info_generation(leaf, disk);
 		item->referenced = btrfs_qgroup_info_referenced(leaf, disk);
 		item->referenced_compressed =
 			btrfs_qgroup_info_referenced_compressed(leaf, disk);
@@ -673,7 +679,7 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive)
 {
 	struct qgroup_count *count = find_count(root_objectid);
-	struct btrfs_qgroup_info_item *qg;
+	struct qgroup_info *qg;
 
 	BUG_ON(num_bytes < 4096); /* Random sanity check. */
 
@@ -1014,8 +1020,8 @@ static void print_fields_signed(long long bytes,
 static void print_qgroup_difference(struct qgroup_count *count, int verbose)
 {
 	int is_different;
-	struct btrfs_qgroup_info_item *info = &count->info;
-	struct btrfs_qgroup_info_item *disk = &count->diskinfo;
+	struct qgroup_info *info = &count->info;
+	struct qgroup_info *disk = &count->diskinfo;
 	long long excl_diff = info->exclusive - disk->exclusive;
 	long long ref_diff = info->referenced - disk->referenced;
 
-- 
2.6.4

