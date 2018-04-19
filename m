Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33196 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbeDSK53 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Apr 2018 06:57:29 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: Do super block verification before writing it to disk
Date: Thu, 19 Apr 2018 18:57:15 +0800
Message-Id: <20180419105715.10375-3-wqu@suse.com>
In-Reply-To: <20180419105715.10375-1-wqu@suse.com>
References: <20180419105715.10375-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are already 2 reports about strangely corrupted super blocks,
where csum still matches but extra garbage gets slipped into super block.

The corruption would looks like:
------
superblock: bytenr=65536, device=/dev/sdc1
---------------------------------------------------------
csum_type               41700 (INVALID)
csum                    0x3b252d3a [match]
bytenr                  65536
flags                   0x1
                        ( WRITTEN )
magic                   _BHRfS_M [match]
...
incompat_flags          0x5b22400000000169
                        ( MIXED_BACKREF |
                          COMPRESS_LZO |
                          BIG_METADATA |
                          EXTENDED_IREF |
                          SKINNY_METADATA |
                          unknown flag: 0x5b22400000000000 )
...
------
Or
------
superblock: bytenr=65536, device=/dev/mapper/x
---------------------------------------------------------
csum_type              35355 (INVALID)
csum_size              32
csum                   0xf0dbeddd [match]
bytenr                 65536
flags                  0x1
                       ( WRITTEN )
magic                  _BHRfS_M [match]
...
incompat_flags         0x176d200000000169
                       ( MIXED_BACKREF |
                         COMPRESS_LZO |
                         BIG_METADATA |
                         EXTENDED_IREF |
                         SKINNY_METADATA |
                         unknown flag: 0x176d200000000000 )
------

Obviously, csum_type and incompat_flags get some garbage, but its csum
still matches, which means kernel calculates the csum based on corrupted
super block memory.
And after manually fixing these values, the filesystem is completely
healthy without any problem exposed by btrfs check.

Although the cause is still unknown, at least detect it and prevent further
corruption.

Reported-by: Ken Swenson <flat@imo.uto.moe>
Reported-by: Ben Parsons <9parsonsb@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Add new comment for why we could skip bytenr check at sb write time.
  Spell fix.
  Remove unrelated intermediate number fix.
---
 fs/btrfs/disk-io.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 23d70c3fdc22..3f380e3d0195 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -55,7 +55,9 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb,
+				   int super_mirror);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2668,7 +2670,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info);
+	ret = btrfs_check_super_valid(fs_info, fs_info->super_copy, 0);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
@@ -3563,6 +3565,16 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 	sb = fs_info->super_for_commit;
 	dev_item = &sb->dev_item;
 
+	/*
+	 * super_bytenr will be updated in write_dev_supers(), even if it is
+	 * corrupted in current copy, it won't reach disk. So skip bytenr check.
+	 */
+	if (btrfs_check_super_valid(fs_info, sb, -1)) {
+		btrfs_err(fs_info,
+		"superblock corruption detected before transaction commit");
+		return -EUCLEAN;
+	}
+
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	head = &fs_info->fs_devices->devices;
 	max_errors = btrfs_super_num_devices(fs_info->super_copy) - 1;
@@ -3974,9 +3986,18 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
 					      level, first_key);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+/*
+ * Check the validation of btrfs super block.
+ *
+ * @sb:			super block to check
+ * @super_mirror:	the super block number to check its bytenr.
+ * 			0 means the primary (1st) sb, 1 and 2 means 2nd and
+ * 			3rd backup sb, while -1 means to skip bytenr check.
+ */
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb,
+				   int super_mirror)
 {
-	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
@@ -4088,9 +4109,10 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
-	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
-		btrfs_err(fs_info, "super offset mismatch %llu != %u",
-			  btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+	if (super_mirror >= 0 && btrfs_super_bytenr(sb) !=
+	    btrfs_sb_offset(super_mirror)) {
+		btrfs_err(fs_info, "super offset mismatch %llu != %llu",
+			btrfs_super_bytenr(sb), btrfs_sb_offset(super_mirror));
 		ret = -EINVAL;
 	}
 
-- 
2.17.0

