Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:52715 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754363AbcJLINr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 04:13:47 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 2/5] Btrfs: incremental send, add gen for is_waiting_for_rm when some corner case
Date: Wed, 12 Oct 2016 16:12:47 +0800
Message-Id: <1476259970-1866-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1476259970-1866-1-git-send-email-robbieko@synology.com>
References: <1476259970-1866-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

There a one case for old_gen waiting_for_rm,
but new_gen use get_cur_path with the same inode.

Example:
    Parent snapshot:
    |---- dir258/ (ino 258, dir)
        |--- dir257/ (ino 257, dir)
    |---- dir259/ (ino 259, dir)

    Send snapshot:
    |---- file258 (ino 258, file)
    |---- new_dir259/ (ino 259, dir)
        |--- dir257/ (ino 257, dir)

utimes
mkdir o259-21-0
rename dir258 -> o258-15-0
utimes
mkfile o258-21-0
rename o258-21-0 -> file258
utimes
truncate o258-21-0 size=0
ERROR: truncate o258-21-0 failed: No such file or directory

dir258 will be delete, but dir257 is waiting for move,
so dir258 is waiting for rm, and then file258 be create,
and rename it, and then need to truncate it, so use get_cur_path
to get path, but is_waiting_for_rm olny check ino, dosen't check gen,
match dir258 is waiting for rm, so get error path o258-21-0.

therefore, add gen check in is_waiting_for_rm.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1862f8a..95d3718 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -311,7 +311,7 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino);
 static struct waiting_dir_move *
 get_waiting_dir_move(struct send_ctx *sctx, u64 ino);
 
-static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino);
+static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 dir_gen);
 
 static int need_send_hole(struct send_ctx *sctx)
 {
@@ -2293,7 +2293,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino)) {
+		if (is_waiting_for_rm(sctx, ino, gen)) {
 			ret = gen_unique_name(sctx, ino, gen, name);
 			if (ret < 0)
 				goto out;
@@ -2900,11 +2900,11 @@ get_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
 	return NULL;
 }
 
-static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino)
+static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 dir_gen)
 {
 	struct orphan_dir_info *odi = get_orphan_dir_info(sctx, dir_ino);
 
-	return odi != NULL;
+	return (odi != NULL && odi->gen == dir_gen);
 }
 
 static void free_orphan_dir_info(struct send_ctx *sctx,
@@ -3167,7 +3167,7 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
 	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino))
+		if (is_waiting_for_rm(sctx, ino, gen))
 			break;
 		if (is_waiting_for_move(sctx, ino)) {
 			if (*ancestor_ino == 0)
-- 
1.9.1

