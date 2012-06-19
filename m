Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FSNm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 09:42:29 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so5098156bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 06:42:29 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 2/2] Btrfs: don't assume to be on the correct extent in add_all_parents
Date: Tue, 19 Jun 2012 15:42:26 +0200
Message-Id: <1340113346-12987-3-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340113346-12987-1-git-send-email-ablock84@googlemail.com>
References: <1340113346-12987-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_all_parents did assume that path is already at a correct extent data
item, which may not be true in case of data extents that were partly
rewritten and splitted.

We need to check if we're on a matching extent for every item and only
for the ones after the first. The loop is changed to do this now.

This patch also fixes a bug introduced with commit 3b127fd8 "Btrfs:
remove obsolete btrfs_next_leaf call from __resolve_indirect_ref".
The removal of next_leaf did sometimes result in slot==nritems when
the above described case happens, and thus resulting in invalid values
(e.g. wanted_obejctid) in add_all_parents (leading to missed backrefs
or even crashes).

Signed-off-by: Alexander Block <ablock84@googlemail.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c |   94 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8f7d123..7301cdb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -179,61 +179,74 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 
 static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 				struct ulist *parents, int level,
-				struct btrfs_key *key, u64 time_seq,
+				struct btrfs_key *key_for_search, u64 time_seq,
 				u64 wanted_disk_byte,
 				const u64 *extent_item_pos)
 {
-	int ret;
-	int slot = path->slots[level];
-	struct extent_buffer *eb = path->nodes[level];
+	int ret = 0;
+	int slot;
+	struct extent_buffer *eb;
+	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	struct extent_inode_elem *eie = NULL;
 	u64 disk_byte;
-	u64 wanted_objectid = key->objectid;
 
-add_parent:
-	if (level == 0 && extent_item_pos) {
-		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
-		ret = check_extent_in_eb(key, eb, fi, *extent_item_pos, &eie);
+	if (level != 0) {
+		eb = path->nodes[level];
+		ret = ulist_add(parents, eb->start, 0, GFP_NOFS);
 		if (ret < 0)
 			return ret;
-	}
-	ret = ulist_add(parents, eb->start, (unsigned long)eie, GFP_NOFS);
-	if (ret < 0)
-		return ret;
-
-	if (level != 0)
 		return 0;
+	}
 
 	/*
-	 * if the current leaf is full with EXTENT_DATA items, we must
-	 * check the next one if that holds a reference as well.
-	 * ref->count cannot be used to skip this check.
-	 * repeat this until we don't find any additional EXTENT_DATA items.
+	 * We normally enter this function with the path already pointing to
+	 * the first item to check. But sometimes, we may enter it with
+	 * slot==nritems. In that case, go to the next leaf before we continue.
 	 */
-	while (1) {
-		eie = NULL;
+	if (path->slots[0] >= btrfs_header_nritems(path->nodes[0]))
 		ret = btrfs_next_old_leaf(root, path, time_seq);
-		if (ret < 0)
-			return ret;
-		if (ret)
-			return 0;
 
+	while (!ret) {
 		eb = path->nodes[0];
-		for (slot = 0; slot < btrfs_header_nritems(eb); ++slot) {
-			btrfs_item_key_to_cpu(eb, key, slot);
-			if (key->objectid != wanted_objectid ||
-			    key->type != BTRFS_EXTENT_DATA_KEY)
-				return 0;
-			fi = btrfs_item_ptr(eb, slot,
-						struct btrfs_file_extent_item);
-			disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
-			if (disk_byte == wanted_disk_byte)
-				goto add_parent;
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(eb, &key, slot);
+
+		if (key.objectid != key_for_search->objectid ||
+		    key.type != BTRFS_EXTENT_DATA_KEY)
+			break;
+
+		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
+
+		if (disk_byte == wanted_disk_byte) {
+			eie = NULL;
+			if (extent_item_pos) {
+				ret = check_extent_in_eb(&key, eb, fi,
+						*extent_item_pos,
+						&eie);
+				if (ret < 0)
+					break;
+			}
+			if (!ret) {
+				ret = ulist_add(parents, eb->start,
+						(unsigned long)eie, GFP_NOFS);
+				if (ret < 0)
+					break;
+				if (!extent_item_pos) {
+					ret = btrfs_next_old_leaf(root, path,
+							time_seq);
+					continue;
+				}
+			}
 		}
+		ret = btrfs_next_old_item(root, path, time_seq);
 	}
 
-	return 0;
+	if (ret > 0)
+		ret = 0;
+	return ret;
 }
 
 /*
@@ -250,7 +263,6 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_path *path;
 	struct btrfs_root *root;
 	struct btrfs_key root_key;
-	struct btrfs_key key = {0};
 	struct extent_buffer *eb;
 	int ret = 0;
 	int root_level;
@@ -295,11 +307,9 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	if (level == 0)
-		btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
-
-	ret = add_all_parents(root, path, parents, level, &key, time_seq,
-				ref->wanted_disk_byte, extent_item_pos);
+	ret = add_all_parents(root, path, parents, level, &ref->key_for_search,
+				time_seq, ref->wanted_disk_byte,
+				extent_item_pos);
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.7.10

