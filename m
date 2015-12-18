Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:48260 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLRORg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 09:17:36 -0500
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] btrfs: use list_for_each_entry* in backref.c
Date: Fri, 18 Dec 2015 22:17:01 +0800
Message-Id: <617786fdb0eb4f593bdc6efffe040ce6ebcb1cc5.1450447999.git.geliangtang@163.com>
In-Reply-To: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
References: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com>
In-Reply-To: <b87e3c3186f2f308924b2e09d112036912233c9d.1450447999.git.geliangtang@163.com>
References: <8a5a49f737a7eed984c8f92f4684d9a6b761f2f2.1450447999.git.geliangtang@163.com> <b87e3c3186f2f308924b2e09d112036912233c9d.1450447999.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use list_for_each_entry*() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/btrfs/backref.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d453d62..fa6f346 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -520,13 +520,10 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
 static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 			      struct list_head *head)
 {
-	struct list_head *pos;
+	struct __prelim_ref *ref;
 	struct extent_buffer *eb;
 
-	list_for_each(pos, head) {
-		struct __prelim_ref *ref;
-		ref = list_entry(pos, struct __prelim_ref, list);
-
+	list_for_each_entry(ref, head, list) {
 		if (ref->parent)
 			continue;
 		if (ref->key_for_search.type)
@@ -563,23 +560,16 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
  */
 static void __merge_refs(struct list_head *head, int mode)
 {
-	struct list_head *pos1;
+	struct __prelim_ref *ref1;
 
-	list_for_each(pos1, head) {
-		struct list_head *n2;
-		struct list_head *pos2;
-		struct __prelim_ref *ref1;
+	list_for_each_entry(ref1, head, list) {
+		struct __prelim_ref *ref2, *tmp;
 
-		ref1 = list_entry(pos1, struct __prelim_ref, list);
-
-		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
-		     pos2 = n2, n2 = pos2->next) {
-			struct __prelim_ref *ref2;
+		ref2 = list_next_entry(ref1, list);
+		list_for_each_entry_safe_from(ref2, tmp, head, list) {
 			struct __prelim_ref *xchg;
 			struct extent_inode_elem *eie;
 
-			ref2 = list_entry(pos2, struct __prelim_ref, list);
-
 			if (!ref_for_same_block(ref1, ref2))
 				continue;
 			if (mode == 1) {
-- 
2.5.0


