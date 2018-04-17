Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49311 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbeDQBrb (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 16 Apr 2018 21:47:31 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: Do super block verification before writing it to disk
Date: Tue, 17 Apr 2018 09:47:19 +0800
Message-Id: <20180417014719.3799-1-wqu@suse.com>
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
changelog:
v2:
  Fix false alerts by moving the check to write_dev_supers() as
  btrfs_check_super_valid() only handles the primary superblock.
v3:
  Update commit message to show the corruption in details.
  Modify the kernel error message to show corruption is detected before
  transaction commitment.
---
 fs/btrfs/disk-io.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 23803102aa0d..2d543ba2b7af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -68,7 +68,8 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_fs_info *fs_info);
@@ -2680,7 +2681,7 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info);
+	ret = btrfs_check_super_valid(fs_info, fs_info->super_copy);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
 		err = -EINVAL;
@@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device *device,
 
 		btrfs_set_super_bytenr(sb, bytenr);
 
+		/* check the validation of the primary sb before writing */
+		if (i == 0) {
+			ret = btrfs_check_super_valid(device->fs_info, sb);
+			if (ret) {
+				btrfs_err(device->fs_info,
+"superblock corruption detected before transaction commitment for device %llu",
+					  device->devid);
+				return -EUCLEAN;
+			}
+			/*
+			 * Unknown incompat flags can't be mounted, so newly
+			 * developed flags means corruption
+			 */
+			if (btrfs_super_incompat_flags(sb) &
+			    ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+				btrfs_err(device->fs_info,
+"superblock corruption detected before transaction commitment for device %llu",
+					  device->devid);
+				return -EUCLEAN;
+			}
+		}
 		crc = ~(u32)0;
 		crc = btrfs_csum_data((const char *)sb + BTRFS_CSUM_SIZE, crc,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
@@ -3985,9 +4007,9 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
 					      level, first_key);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
+static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				   struct btrfs_super_block *sb)
 {
-	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
 	int ret = 0;
-- 
2.17.0

