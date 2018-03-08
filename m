Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56855 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755565AbeCHOgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:36:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7052AE85
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:36:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 19/22] btrfs: separate types for submit_bio_start and submit_bio_done
Date: Thu,  8 Mar 2018 15:33:49 +0100
Message-Id: <d3e5469b757c03256790009c8f8b80a8b1efc219.1520518877.git.dsterba@suse.com>
In-Reply-To: <cover.1520518876.git.dsterba@suse.com>
References: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The callbacks make use of different parameters that are passed to the
other type unnecessarily. This patch adds separate types for each and
the unused parameters will be removed.

The type extent_submit_bio_hook_t keeps all parameters and can be used
where the start/done types are not appropriate.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 8 ++++----
 fs/btrfs/disk-io.h   | 4 ++--
 fs/btrfs/extent_io.h | 9 +++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21f34ad0d411..6ffc97305d6a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -124,8 +124,8 @@ struct async_submit_bio {
 	void *private_data;
 	struct btrfs_fs_info *fs_info;
 	struct bio *bio;
-	extent_submit_bio_hook_t *submit_bio_start;
-	extent_submit_bio_hook_t *submit_bio_done;
+	extent_submit_bio_start_t *submit_bio_start;
+	extent_submit_bio_done_t *submit_bio_done;
 	int mirror_num;
 	unsigned long bio_flags;
 	/*
@@ -759,8 +759,8 @@ static void run_one_async_free(struct btrfs_work *work)
 blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset, void *private_data,
-				 extent_submit_bio_hook_t *submit_bio_start,
-				 extent_submit_bio_hook_t *submit_bio_done)
+				 extent_submit_bio_start_t *submit_bio_start,
+				 extent_submit_bio_done_t *submit_bio_done)
 {
 	struct async_submit_bio *async;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 301151a50ac1..dcc94215de4f 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -131,8 +131,8 @@ blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			int mirror_num, unsigned long bio_flags,
 			u64 bio_offset, void *private_data,
-			extent_submit_bio_hook_t *submit_bio_start,
-			extent_submit_bio_hook_t *submit_bio_done);
+			extent_submit_bio_start_t *submit_bio_start,
+			extent_submit_bio_done_t *submit_bio_done);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
 void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a7a850abd600..202546435db6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -95,6 +95,15 @@ struct io_failure_record;
 typedef	blk_status_t (extent_submit_bio_hook_t)(void *private_data, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags,
 				       u64 bio_offset);
+
+typedef blk_status_t (extent_submit_bio_start_t)(void *private_data,
+		struct bio *bio, int mirror_num, unsigned long bio_flags,
+		u64 bio_offset);
+
+typedef blk_status_t (extent_submit_bio_done_t)(void *private_data,
+		struct bio *bio, int mirror_num, unsigned long bio_flags,
+		u64 bio_offset);
+
 struct extent_io_ops {
 	/*
 	 * The following callbacks must be allways defined, the function
-- 
2.16.2

