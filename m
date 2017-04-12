Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40265 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752672AbdDLKZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 06:25:07 -0400
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 08/25] btrfs: Convert to separately allocated bdi
Date: Wed, 12 Apr 2017 12:24:32 +0200
Message-Id: <20170412102449.16901-9-jack@suse.cz>
In-Reply-To: <20170412102449.16901-1-jack@suse.cz>
References: <20170412102449.16901-1-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allocate struct backing_dev_info separately instead of embedding it
inside superblock. This unifies handling of bdi among users.

CC: Chris Mason <clm@fb.com>
CC: Josef Bacik <jbacik@fb.com>
CC: David Sterba <dsterba@suse.com>
CC: linux-btrfs@vger.kernel.org
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/ctree.h   |  1 -
 fs/btrfs/disk-io.c | 36 +++++++-----------------------------
 fs/btrfs/super.c   |  7 +++++++
 3 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc28c607..f6019ce20035 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -810,7 +810,6 @@ struct btrfs_fs_info {
 	struct btrfs_super_block *super_for_commit;
 	struct super_block *sb;
 	struct inode *btree_inode;
-	struct backing_dev_info bdi;
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08b74daf35d0..a7d8c342f604 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1808,21 +1808,6 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 	return ret;
 }
 
-static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
-{
-	int err;
-
-	err = bdi_setup_and_register(bdi, "btrfs");
-	if (err)
-		return err;
-
-	bdi->ra_pages = VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
-	bdi->congested_fn	= btrfs_congested_fn;
-	bdi->congested_data	= info;
-	bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
-	return 0;
-}
-
 /*
  * called by the kthread helper functions to finally call the bio end_io
  * functions.  This is where read checksum verification actually happens
@@ -2601,16 +2586,10 @@ int open_ctree(struct super_block *sb,
 		goto fail;
 	}
 
-	ret = setup_bdi(fs_info, &fs_info->bdi);
-	if (ret) {
-		err = ret;
-		goto fail_srcu;
-	}
-
 	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
 	if (ret) {
 		err = ret;
-		goto fail_bdi;
+		goto fail_srcu;
 	}
 	fs_info->dirty_metadata_batch = PAGE_SIZE *
 					(1 + ilog2(nr_cpu_ids));
@@ -2718,7 +2697,6 @@ int open_ctree(struct super_block *sb,
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
-	sb->s_bdi = &fs_info->bdi;
 
 	btrfs_init_btree_inode(fs_info);
 
@@ -2915,9 +2893,12 @@ int open_ctree(struct super_block *sb,
 		goto fail_sb_buffer;
 	}
 
-	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
-	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
-				    SZ_4M / PAGE_SIZE);
+	sb->s_bdi->congested_fn = btrfs_congested_fn;
+	sb->s_bdi->congested_data = fs_info;
+	sb->s_bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
+	sb->s_bdi->ra_pages = VM_MAX_READAHEAD * 1024 / PAGE_SIZE;
+	sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
+	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
 
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
@@ -3285,8 +3266,6 @@ int open_ctree(struct super_block *sb,
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
 fail_dirty_metadata_bytes:
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
-fail_bdi:
-	bdi_destroy(&fs_info->bdi);
 fail_srcu:
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 fail:
@@ -4007,7 +3986,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
 	percpu_counter_destroy(&fs_info->bio_counter);
-	bdi_destroy(&fs_info->bdi);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
 	btrfs_free_stripe_hash_table(fs_info);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index da687dc79cce..e0a7503ab31e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1133,6 +1133,13 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_flags |= MS_I_VERSION;
 	sb->s_iflags |= SB_I_CGROUPWB;
+
+	err = super_setup_bdi(sb);
+	if (err) {
+		btrfs_err(fs_info, "super_setup_bdi failed");
+		return err;
+	}
+
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
 		btrfs_err(fs_info, "open_ctree failed");
-- 
2.12.0

