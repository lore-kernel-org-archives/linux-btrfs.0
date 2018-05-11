Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:33030 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKGa2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 02:30:28 -0400
Received: by mail-pl0-f68.google.com with SMTP id n10-v6so2721773plp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:30:28 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/3] fs: add private argument to dio_submit_t
Date: Thu, 10 May 2018 23:30:11 -0700
Message-Id: <500e3ef7031d83e75255721ff23504021393279b.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

get_block() already has access to this through bh_result->b_private, and
it gets passed to end_io() as private, so do the same for submit_io().
Along with the previous change, this will allow us to get rid Btrfs'
current->journal_info abuse in btrfs_direct_IO().

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c   | 2 +-
 fs/direct-io.c     | 3 ++-
 include/linux/fs.h | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d8b0a7eacd19..46e3d366df8b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8418,7 +8418,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 }
 
 static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
-				loff_t file_offset)
+				loff_t file_offset, void *private)
 {
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *bio = NULL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9bb33d9c206c..3f3aa2d95ca1 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -475,7 +475,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->bio_disk = bio->bi_disk;
 
 	if (sdio->submit_io) {
-		sdio->submit_io(bio, dio->inode, sdio->logical_offset_in_bio);
+		sdio->submit_io(bio, dio->inode, sdio->logical_offset_in_bio,
+				dio->private);
 		dio->bio_cookie = BLK_QC_T_NONE;
 	} else
 		dio->bio_cookie = submit_bio(bio);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b9ef2fb1224b..9e5e6ea1c144 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2978,7 +2978,7 @@ extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_BLOCK
 typedef void (dio_submit_t)(struct bio *bio, struct inode *inode,
-			    loff_t file_offset);
+			    loff_t file_offset, void *private);
 
 enum {
 	/* need locking between buffered and direct access */
-- 
2.17.0

