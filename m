Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54431 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBLPJM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 10:09:12 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so1869027wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 07:09:11 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 2/2] Btrfs: cleanup delayed-ref.c:find_ref_head()
Date: Wed, 12 Feb 2014 15:07:53 +0000
Message-Id: <1392217673-11075-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1392217673-11075-1-git-send-email-fdmanana@gmail.com>
References: <1392217673-11075-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The argument last wasn't used, all callers supplied a NULL value
for it. Also removed unnecessary intermediate storage of the result
of key comparisons.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/delayed-ref.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 56cdfe9..2502ba5 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -199,42 +199,30 @@ static struct btrfs_delayed_ref_head *htree_insert(struct rb_root *root,
  */
 static struct btrfs_delayed_ref_head *
 find_ref_head(struct rb_root *root, u64 bytenr,
-	      struct btrfs_delayed_ref_head **last, int return_bigger)
+	      int return_bigger)
 {
 	struct rb_node *n;
 	struct btrfs_delayed_ref_head *entry;
-	int cmp = 0;
 
 	n = root->rb_node;
 	entry = NULL;
 	while (n) {
 		entry = rb_entry(n, struct btrfs_delayed_ref_head, href_node);
-		if (last)
-			*last = entry;
 
 		if (bytenr < entry->node.bytenr)
-			cmp = -1;
-		else if (bytenr > entry->node.bytenr)
-			cmp = 1;
-		else
-			cmp = 0;
-
-		if (cmp < 0)
 			n = n->rb_left;
-		else if (cmp > 0)
+		else if (bytenr > entry->node.bytenr)
 			n = n->rb_right;
 		else
 			return entry;
 	}
 	if (entry && return_bigger) {
-		if (cmp > 0) {
+		if (bytenr > entry->node.bytenr) {
 			n = rb_next(&entry->href_node);
 			if (!n)
 				n = rb_first(root);
 			entry = rb_entry(n, struct btrfs_delayed_ref_head,
 					 href_node);
-			if (last)
-				*last = entry;
 			return entry;
 		}
 		return entry;
@@ -414,12 +402,12 @@ btrfs_select_ref_head(struct btrfs_trans_handle *trans)
 
 again:
 	start = delayed_refs->run_delayed_start;
-	head = find_ref_head(&delayed_refs->href_root, start, NULL, 1);
+	head = find_ref_head(&delayed_refs->href_root, start, 1);
 	if (!head && !loop) {
 		delayed_refs->run_delayed_start = 0;
 		start = 0;
 		loop = true;
-		head = find_ref_head(&delayed_refs->href_root, start, NULL, 1);
+		head = find_ref_head(&delayed_refs->href_root, start, 1);
 		if (!head)
 			return NULL;
 	} else if (!head && loop) {
@@ -897,7 +885,7 @@ btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	return find_ref_head(&delayed_refs->href_root, bytenr, NULL, 0);
+	return find_ref_head(&delayed_refs->href_root, bytenr, 0);
 }
 
 void btrfs_delayed_ref_exit(void)
-- 
1.7.9.5

