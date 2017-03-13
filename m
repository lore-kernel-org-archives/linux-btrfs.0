Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33802 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdCMUb2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 16:31:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id u132so11768355wmg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 13:31:27 -0700 (PDT)
From: ednadolski@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Edmund Nadolski <enadolski@suse.com>
Subject: [PATCH 1/2] btrfs: provide enumeration for __merge_refs mode argument
Date: Mon, 13 Mar 2017 14:32:03 -0600
Message-Id: <20170313203204.11857-2-enadolski@suse.com>
In-Reply-To: <20170313203204.11857-1-enadolski@suse.com>
References: <20170313203204.11857-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Edmund Nadolski <enadolski@suse.com>

Replace hardcoded numeric values for __merge_refs 'mode' argument
with descriptive constants.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
Reviewed-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7699e16..e794b6e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -26,6 +26,11 @@
 #include "delayed-ref.h"
 #include "locking.h"
 
+enum merge_mode {
+	MERGE_IDENTICAL_KEYS = 1,
+	MERGE_IDENTICAL_PARENTS,
+};
+
 /* Just an arbitrary number so we can be sure this happened */
 #define BACKREF_FOUND_SHARED 6
 
@@ -809,14 +814,12 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 /*
  * merge backrefs and adjust counts accordingly
  *
- * mode = 1: merge identical keys, if key is set
  *    FIXME: if we add more keys in __add_prelim_ref, we can merge more here.
  *           additionally, we could even add a key range for the blocks we
  *           looked into to merge even more (-> replace unresolved refs by those
  *           having a parent).
- * mode = 2: merge identical parents
  */
-static void __merge_refs(struct list_head *head, int mode)
+static void __merge_refs(struct list_head *head, enum merge_mode mode)
 {
 	struct __prelim_ref *pos1;
 
@@ -829,7 +832,7 @@ static void __merge_refs(struct list_head *head, int mode)
 
 			if (!ref_for_same_block(ref1, ref2))
 				continue;
-			if (mode == 1) {
+			if (mode == MERGE_IDENTICAL_KEYS) {
 				if (!ref1->parent && ref2->parent)
 					swap(ref1, ref2);
 			} else {
@@ -1374,7 +1377,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	__merge_refs(&prefs, 1);
+	__merge_refs(&prefs, MERGE_IDENTICAL_KEYS);
 
 	ret = __resolve_indirect_refs(fs_info, path, time_seq, &prefs,
 				      extent_item_pos, total_refs,
@@ -1382,7 +1385,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	__merge_refs(&prefs, 2);
+	__merge_refs(&prefs, MERGE_IDENTICAL_PARENTS);
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-- 
2.10.2

