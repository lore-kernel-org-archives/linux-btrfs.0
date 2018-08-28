Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42107 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbeH1Dw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id g23-v6so307053plq.9
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:35 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: [RFC PATCH v2 5/6] fs: pass iocb to direct I/O submit_io()
Date: Mon, 27 Aug 2018 17:03:18 -0700
Message-Id: <ddb35c231a5204e4d3f835f9d0d23e1561891f1f.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Btrfs abuses current->journal_info in btrfs_direct_IO() in order to pass
around some state to get_block() and submit_io(). However, iocb->private
is free for Btrfs to use, we just need it passed to submit_io(). Btrfs
is the only user of submit_io(), so this doesn't affect any other
filesystems.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c   | 4 ++--
 fs/direct-io.c     | 3 ++-
 include/linux/fs.h | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b61ea6dd9956..6efa6a6e3e20 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8427,8 +8427,8 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 	return 0;
 }
 
-static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
-				loff_t file_offset)
+static void btrfs_submit_direct(struct kiocb *iocb, struct bio *dio_bio,
+				struct inode *inode, loff_t file_offset)
 {
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *bio = NULL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 80e488afe6c6..aa367e70456d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -473,7 +473,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->bio_disk = bio->bi_disk;
 
 	if (sdio->submit_io) {
-		sdio->submit_io(bio, dio->inode, sdio->logical_offset_in_bio);
+		sdio->submit_io(dio->iocb, bio, dio->inode,
+				sdio->logical_offset_in_bio);
 		dio->bio_cookie = BLK_QC_T_NONE;
 	} else
 		dio->bio_cookie = submit_bio(bio);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f1a235f0fa21..daf1df811f67 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3003,8 +3003,8 @@ extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_BLOCK
-typedef void (dio_submit_t)(struct bio *bio, struct inode *inode,
-			    loff_t file_offset);
+typedef void (dio_submit_t)(struct kiocb *iocb, struct bio *bio,
+			    struct inode *inode, loff_t file_offset);
 
 enum {
 	/* need locking between buffered and direct access */
-- 
2.18.0
