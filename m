Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56871 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755814AbeCHOgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 260D6AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 21/22] btrfs: remove unused parameters from extent_submit_bio_done_t
Date: Thu,  8 Mar 2018 15:33:54 +0100
Message-Id: <7b2ca8fc02bf0c7e018da8f9a582fc8c28742ccb.1520518877.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove parameters not used by any of the callbacks.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 6 ++----
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e396ed366751..f24522a6f36f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -743,8 +743,7 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	async->submit_bio_done(async->private_data, async->bio, async->mirror_num,
-			       async->bio_flags, async->bio_offset);
+	async->submit_bio_done(async->private_data, async->bio, async->mirror_num);
 }
 
 static void run_one_async_free(struct btrfs_work *work)
@@ -817,8 +816,7 @@ static blk_status_t __btree_submit_bio_start(void *private_data, struct bio *bio
 }
 
 static blk_status_t __btree_submit_bio_done(void *private_data, struct bio *bio,
-					    int mirror_num, unsigned long bio_flags,
-					    u64 bio_offset)
+					    int mirror_num)
 {
 	struct inode *inode = private_data;
 	blk_status_t ret;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 1d3792568e64..d69c106077fc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -100,8 +100,7 @@ typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
 		struct bio *bio, u64 bio_offset);
 
 typedef blk_status_t (extent_submit_bio_done_t)(void *private_data,
-		struct bio *bio, int mirror_num, unsigned long bio_flags,
-		u64 bio_offset);
+		struct bio *bio, int mirror_num);
 
 struct extent_io_ops {
 	/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b33544caaf8..5cfba8be73be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1941,8 +1941,7 @@ static blk_status_t __btrfs_submit_bio_start(void *private_data, struct bio *bio
  * are inserted into the btree
  */
 static blk_status_t __btrfs_submit_bio_done(void *private_data, struct bio *bio,
-			  int mirror_num, unsigned long bio_flags,
-			  u64 bio_offset)
+			  int mirror_num)
 {
 	struct inode *inode = private_data;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-- 
2.16.2

