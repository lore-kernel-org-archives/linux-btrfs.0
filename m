Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47059 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933898AbcIUPrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:47:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 901CDAAEF
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 15:45:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: silence compiler warning when fs_info is not used
Date: Wed, 21 Sep 2016 17:43:19 +0200
Message-Id: <1474472599-11278-1-git-send-email-dsterba@suse.com>
In-Reply-To: <1474380303-25995-1-git-send-email-jeffm@suse.com>
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some functions introduced a local fs_info pointer for the message
helpers. If btrfs_debug results to an empty macro, the fs_info pointer
is reported to be unused. Splitting the variable declaration and setting
will silence the warning, without any functional change.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  4 +++-
 fs/btrfs/send.c      | 33 ++++++++++++++++++++++-----------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dac448f056ae..e9364f2cff11 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2188,7 +2188,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 		struct io_failure_record **failrec_ret)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info;
 	struct io_failure_record *failrec;
 	struct extent_map *em;
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
@@ -2197,6 +2197,8 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 	int ret;
 	u64 logical;
 
+	fs_info = btrfs_sb(inode->i_sb);
+
 	ret = get_state_failrec(failure_tree, start, &failrec);
 	if (ret) {
 		failrec = kzalloc(sizeof(*failrec), GFP_NOFS);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 978796865bfc..596dbab0618d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -723,9 +723,10 @@ static int send_cmd(struct send_ctx *sctx)
 static int send_rename(struct send_ctx *sctx,
 		     struct fs_path *from, struct fs_path *to)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_rename %s -> %s", from->start, to->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_RENAME);
@@ -748,9 +749,10 @@ static int send_rename(struct send_ctx *sctx,
 static int send_link(struct send_ctx *sctx,
 		     struct fs_path *path, struct fs_path *lnk)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_link %s -> %s", path->start, lnk->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_LINK);
@@ -772,9 +774,10 @@ static int send_link(struct send_ctx *sctx,
  */
 static int send_unlink(struct send_ctx *sctx, struct fs_path *path)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_unlink %s", path->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_UNLINK);
@@ -795,9 +798,10 @@ static int send_unlink(struct send_ctx *sctx, struct fs_path *path)
  */
 static int send_rmdir(struct send_ctx *sctx, struct fs_path *path)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_rmdir %s", path->start);
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_RMDIR);
@@ -2422,10 +2426,11 @@ static int send_subvol_begin(struct send_ctx *sctx)
 
 static int send_truncate(struct send_ctx *sctx, u64 ino, u64 gen, u64 size)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_truncate %llu size=%llu", ino, size);
 
 	p = fs_path_alloc();
@@ -2452,10 +2457,11 @@ static int send_truncate(struct send_ctx *sctx, u64 ino, u64 gen, u64 size)
 
 static int send_chmod(struct send_ctx *sctx, u64 ino, u64 gen, u64 mode)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_chmod %llu mode=%llu", ino, mode);
 
 	p = fs_path_alloc();
@@ -2482,10 +2488,11 @@ static int send_chmod(struct send_ctx *sctx, u64 ino, u64 gen, u64 mode)
 
 static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_chown %llu uid=%llu, gid=%llu",
 		    ino, uid, gid);
 
@@ -2514,7 +2521,7 @@ static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
 
 static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p = NULL;
 	struct btrfs_inode_item *ii;
@@ -2523,6 +2530,7 @@ static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
 	struct btrfs_key key;
 	int slot;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_utimes %llu", ino);
 
 	p = fs_path_alloc();
@@ -2577,7 +2585,7 @@ static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
  */
 static int send_create_inode(struct send_ctx *sctx, u64 ino)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p;
 	int cmd;
@@ -2585,6 +2593,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 	u64 mode;
 	u64 rdev;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_create_inode %llu", ino);
 
 	p = fs_path_alloc();
@@ -3643,7 +3652,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
  */
 static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct recorded_ref *cur;
 	struct recorded_ref *cur2;
@@ -3656,6 +3665,7 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 	u64 last_dir_ino_rm = 0;
 	bool can_rename = true;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "process_recorded_refs %llu", sctx->cur_ino);
 
 	/*
@@ -4666,7 +4676,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
  */
 static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 {
-	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct btrfs_fs_info *fs_info;
 	int ret = 0;
 	struct fs_path *p;
 	ssize_t num_read = 0;
@@ -4675,6 +4685,7 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 	if (!p)
 		return -ENOMEM;
 
+	fs_info = sctx->send_root->fs_info;
 	btrfs_debug(fs_info, "send_write offset=%llu, len=%d", offset, len);
 
 	num_read = fill_read_buf(sctx, offset, len);
-- 
2.7.1

