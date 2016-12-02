Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbcLBFHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:48 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7D0CEAAD0
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:47 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 06/18] btrfs: struct reada_control.root -> reada_control.fs_info
Date: Fri,  2 Dec 2016 00:07:26 -0500
Message-Id: <1480655258-15400-7-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The root is never used.  We substitute extent_root in for the
reada_find_extent call, since it's only ever used to obtain the node
size.  This call site will be changed to use fs_info in a later patch.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/reada.c | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 74110c7..9a3ca79 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3652,7 +3652,7 @@ static inline void btrfs_bio_counter_dec(struct btrfs_fs_info *fs_info)
 
 /* reada.c */
 struct reada_control {
-	struct btrfs_root	*root;		/* tree to prefetch */
+	struct btrfs_fs_info	*fs_info;		/* tree to prefetch */
 	struct btrfs_key	key_start;
 	struct btrfs_key	key_end;	/* exclusive */
 	atomic_t		elems;
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index f0beb63..540e729 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -544,17 +544,18 @@ static void reada_control_release(struct kref *kref)
 static int reada_add_block(struct reada_control *rc, u64 logical,
 			   struct btrfs_key *top, u64 generation)
 {
-	struct btrfs_root *root = rc->root;
+	struct btrfs_fs_info *fs_info = rc->fs_info;
 	struct reada_extent *re;
 	struct reada_extctl *rec;
 
-	re = reada_find_extent(root, logical, top); /* takes one ref */
+	/* takes one ref */
+	re = reada_find_extent(fs_info->tree_root, logical, top);
 	if (!re)
 		return -1;
 
 	rec = kzalloc(sizeof(*rec), GFP_KERNEL);
 	if (!rec) {
-		reada_extent_put(root->fs_info, re);
+		reada_extent_put(fs_info, re);
 		return -ENOMEM;
 	}
 
@@ -914,7 +915,7 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 	if (!rc)
 		return ERR_PTR(-ENOMEM);
 
-	rc->root = root;
+	rc->fs_info = root->fs_info;
 	rc->key_start = *key_start;
 	rc->key_end = *key_end;
 	atomic_set(&rc->elems, 0);
@@ -942,7 +943,7 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 int btrfs_reada_wait(void *handle)
 {
 	struct reada_control *rc = handle;
-	struct btrfs_fs_info *fs_info = rc->root->fs_info;
+	struct btrfs_fs_info *fs_info = rc->fs_info;
 
 	while (atomic_read(&rc->elems)) {
 		if (!atomic_read(&fs_info->reada_works_cnt))
@@ -963,7 +964,7 @@ int btrfs_reada_wait(void *handle)
 int btrfs_reada_wait(void *handle)
 {
 	struct reada_control *rc = handle;
-	struct btrfs_fs_info *fs_info = rc->root->fs_info;
+	struct btrfs_fs_info *fs_info = rc->fs_info;
 
 	while (atomic_read(&rc->elems)) {
 		if (!atomic_read(&fs_info->reada_works_cnt))
-- 
2.7.1

