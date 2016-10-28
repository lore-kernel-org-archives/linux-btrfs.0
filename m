Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:37107 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965126AbcJ1Blb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:31 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 2/6] Btrfs: incremental send, add generation check for the inode waiting for rmdir operation.
Date: Fri, 28 Oct 2016 09:40:46 +0800
Message-Id: <1477618850-12922-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Example scenario:
Parent snapshot:
|---- dir258/ (ino 258, gen 15, dir)
    |--- dir257/ (ino 257, gen 15, dir)
|---- dir259/ (ino 259, gen 15, dir)

Send snapshot:
|---- file258 (ino 258, gen 21, file)
|---- new_dir259/ (ino 259, gen 21, dir)
    |--- dir257/ (ino 257, gen 15, dir)

utimes
mkdir o259-21-0
rename dir258 -> o258-15-0
utimes
mkfile o258-21-0
rename o258-21-0 -> file258
utimes
truncate o258-21-0 size=0
ERROR: truncate o258-21-0 failed: No such file or directory

While computing the send stream the following steps happen:

1) While processing inode 257, we create o259-21-0 and delay
   dir257 rename operation, because its new parent in the send
   snapshot, inode 259, was not yet processed and therefore not
   yet renamed.

2) Later when processing inode 258, we delay rmdir operation for dir258
   because it's not empty, and then orphanize it.

3) After we create o258-21-0 and rename it to file258, we get ENOENT on
   truncate file258. The reason is that the dir258 with inode 258 is
   waiting for rmdir operation and file258's inode is also 258, then
   get_current_path called before truncate will return a unique name.

Fix this by adding generation check for the inode waiting for rmdir
operation.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2060e75..22eca86 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -311,7 +311,7 @@ static int is_waiting_for_move(struct send_ctx *sctx, u64 ino);
 static struct waiting_dir_move *
 get_waiting_dir_move(struct send_ctx *sctx, u64 ino);
 
-static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino);
+static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 dir_gen);
 
 static int need_send_hole(struct send_ctx *sctx)
 {
@@ -2292,7 +2292,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino)) {
+		if (is_waiting_for_rm(sctx, ino, gen)) {
 			ret = gen_unique_name(sctx, ino, gen, name);
 			if (ret < 0)
 				goto out;
@@ -2899,11 +2899,11 @@ get_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
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
@@ -3166,7 +3166,7 @@ static int path_loop(struct send_ctx *sctx, struct fs_path *name,
 	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino))
+		if (is_waiting_for_rm(sctx, ino, gen))
 			break;
 		if (is_waiting_for_move(sctx, ino)) {
 			if (*ancestor_ino == 0)
-- 
1.9.1

