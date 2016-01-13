Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:54529 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbcAMOId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 09:08:33 -0500
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: Geliang Tang <geliangtang@163.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix iterator with update error in backref.c
Date: Wed, 13 Jan 2016 22:08:01 +0800
Message-Id: <142e43282b047d5fb5229d93fa3be527113ca8d7.1452693903.git.geliangtang@163.com>
In-Reply-To: <20160112181348.GM4227@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following error:

fs/btrfs/backref.c:565:1-20: iterator with update on line 577

Fixes: a7ca422('btrfs: use list_for_each_entry* in backref.c')
Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/btrfs/backref.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 08405a3..b90cd37 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -560,13 +560,13 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
  */
 static void __merge_refs(struct list_head *head, int mode)
 {
-	struct __prelim_ref *ref1;
+	struct __prelim_ref *pos1;
 
-	list_for_each_entry(ref1, head, list) {
-		struct __prelim_ref *ref2 = ref1, *tmp;
+	list_for_each_entry(pos1, head, list) {
+		struct __prelim_ref *pos2 = pos1, *tmp;
 
-		list_for_each_entry_safe_continue(ref2, tmp, head, list) {
-			struct __prelim_ref *xchg;
+		list_for_each_entry_safe_continue(pos2, tmp, head, list) {
+			struct __prelim_ref *xchg, *ref1 = pos1, *ref2 = pos2;
 			struct extent_inode_elem *eie;
 
 			if (!ref_for_same_block(ref1, ref2))
-- 
2.5.0


