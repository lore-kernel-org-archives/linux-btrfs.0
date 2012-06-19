Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2FSNm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 09:42:27 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so5098156bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 06:42:26 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 1/2] Btrfs: introduce btrfs_next_old_item
Date: Tue, 19 Jun 2012 15:42:25 +0200
Message-Id: <1340113346-12987-2-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340113346-12987-1-git-send-email-ablock84@googlemail.com>
References: <1340113346-12987-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We introduce btrfs_next_old_item that uses
btrfs_next_old_leaf instead of btrfs_next_leaf.
btrfs_next_item is also changed to simply call
btrfs_next_old_item with time_seq being 0.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/ctree.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index db15e9e..84ac723 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2755,13 +2755,18 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 			u64 time_seq);
-static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
+static inline int btrfs_next_old_item(struct btrfs_root *root,
+				      struct btrfs_path *p, u64 time_seq)
 {
 	++p->slots[0];
 	if (p->slots[0] >= btrfs_header_nritems(p->nodes[0]))
-		return btrfs_next_leaf(root, p);
+		return btrfs_next_old_leaf(root, p, time_seq);
 	return 0;
 }
+static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
+{
+	return btrfs_next_old_item(root, p, 0);
+}
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 int __must_check btrfs_drop_snapshot(struct btrfs_root *root,
-- 
1.7.10

