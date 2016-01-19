Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbcASKn5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:43:57 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Geliang Tang <geliangtang@163.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: fix iterator with update error in backref.c
Date: Tue, 19 Jan 2016 11:43:51 +0100
Message-Id: <8e217858eea0d63de9d818f52fa98b5f9e502e5a.1453199864.git.dsterba@suse.com>
In-Reply-To: <cover.1453199864.git.dsterba@suse.com>
References: <cover.1453199864.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Geliang Tang <geliangtang@163.com>

Fix the following error:

fs/btrfs/backref.c:565:1-20: iterator with update on line 577

Fixes: a7ca422('btrfs: use list_for_each_entry* in backref.c')
Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 08405a3da6b1..b90cd3776f8e 100644
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
2.6.3

