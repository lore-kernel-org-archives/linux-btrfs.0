Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:36934 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964894AbcJ1Bl1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:27 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 6/6] Btrfs: incremental send, add generation check in existence demtermination for the parent directory
Date: Fri, 28 Oct 2016 09:40:50 +0800
Message-Id: <1477618850-12922-7-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Exampla scenario:
Parent snapshot:
|---- dir258/         (ino 258, gen 7, dir)
    |--- dir257/      (ino 257, gen 7, dir)
|---- dir259/         (ino 259, gen 7, dir)

Send snapshot:
|---- file258         (ino 258, gen 10, file)
|---- new_dir259/     (ino 259, gen 10, dir)
    |--- dir257/      (ino 257, gen 7, dir)

mkdir o259-10-0
rename dir258 -> o258-7-0
utimes
mkfile o258-10-0
rename o258-10-0 -> file258
utimes
truncate file258 size=0
chown file258 - uid=0, gid=0
chmod file258 - mode=0644
utimes file258
rmdir dir259
utimes
rename o259-10-0 -> new_dir259
utimes
chown new_dir259 - uid=0, gid=0
chmod new_dir259 - mode=0755
rename o258-7-0/dir257 -> new_dir259/dir257
rmdir o258-7-0
utimes new_dir259/dir257
utimes o258-7-0
ERROR: utimes o258-7-0 failed: No such file or directory

While computing the send stream the following steps happen:

1) While processing inode 257 we create o259-10-0, and delaying dir257
   rename operation because its new parent in the send snapshot, inode
   259, was not yet processed and therefore not yet renamed;

2) Later when processing inode 258 we orphanize dir258, and rename it to
   o258-7-0, because under dir258 there is a dir257 waiting to be moved;

3) Finally, when 259 is finished processing we rename o258-7-0/dir257 to
   new_dir259/dir257, and then remove directory o258-7-0. After updating
   the time in the two parents if it's exist, we only check whether
   the inode number exists in the send snapshot, which result in utimes
   error, because old parent has been deleted;

Fix this by adding generation check in existence demtermination for
the parent directory.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 81a2bee..b4a4724 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3338,14 +3338,17 @@ finish:
 		/*
 		 * The parent inode might have been deleted in the send snapshot
 		 */
+		u64 gen;
 		ret = get_inode_info(sctx->send_root, cur->dir, NULL,
-				     NULL, NULL, NULL, NULL, NULL);
-		if (ret == -ENOENT) {
+				     &gen, NULL, NULL, NULL, NULL);
+
+		if (ret < 0 && ret != -ENOENT)
+			goto out;
+
+		if (ret == -ENOENT || gen != cur->dir_gen) {
 			ret = 0;
 			continue;
 		}
-		if (ret < 0)
-			goto out;
 
 		ret = send_utimes(sctx, cur->dir, cur->dir_gen);
 		if (ret < 0)
-- 
1.9.1

