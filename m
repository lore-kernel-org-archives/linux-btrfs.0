Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbcEaIto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 04:49:44 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: convert: Fix bugs in backup superblock migration
Date: Tue, 31 May 2016 16:49:33 +0800
Message-Id: <20160531084933.17577-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New convert has several bugs with backup superblock migration

1) Backup superblocks are not migrated due to bad judgement
   Two wrong judgement cause backup superblocks are not migrated at all

2) Converted ext* image doesn't keep hole for backup superblocks
   Since we are creating file extents according to tmp_used, which has
   wiped out backup superblock ranges.
   In that case, later superblock migration will fail, since migration
   will insert file extent range into ext* image.

Fix above bugs will make convert on ext2 image filled about 100M data
successful.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 30dd6e8..ce4ca1d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1263,12 +1263,32 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *bg_cache;
 	u64 len = *ret_len;
 	u64 disk_bytenr;
+	int i;
 	int ret;
 
 	BUG_ON(bytenr != round_down(bytenr, root->sectorsize));
 	BUG_ON(len != round_down(len, root->sectorsize));
 	len = min_t(u64, len, BTRFS_MAX_EXTENT_SIZE);
 
+	/*
+	 * Skip sb ranges first
+	 * [0, 1M), [sb_offset(1), +64K), [sb_offset(2), +64K].
+	 *
+	 * Or we will insert a hole into current image file, and later
+	 * migrate block will fail as there is already a file extent.
+	 */
+	if (bytenr < 1024 * 1024) {
+		*ret_len = 1024 * 1024 - bytenr;
+		return 0;
+	}
+	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		u64 cur = btrfs_sb_offset(i);
+		if (bytenr >= cur && bytenr < cur + BTRFS_STRIPE_LEN) {
+			*ret_len = cur + BTRFS_STRIPE_LEN - bytenr;
+			return 0;
+		}
+	}
+
 	cache = search_cache_extent(used, bytenr);
 	if (cache) {
 		if (cache->start <= bytenr) {
@@ -1425,7 +1445,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 	/* second sb(fisrt sb is included in 0~1M) */
 	cur_off = btrfs_sb_offset(1);
 	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
-	if (cur_off < total_bytes)
+	if (cur_off > total_bytes)
 		return ret;
 	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
 					 cur_off, cur_len, datacsum);
@@ -1435,7 +1455,7 @@ static int migrate_reserved_ranges(struct btrfs_trans_handle *trans,
 	/* Last sb */
 	cur_off = btrfs_sb_offset(2);
 	cur_len = min(total_bytes, cur_off + BTRFS_STRIPE_LEN) - cur_off;
-	if (cur_off < total_bytes)
+	if (cur_off > total_bytes)
 		return ret;
 	ret = migrate_one_reserved_range(trans, root, used, inode, fd, ino,
 					 cur_off, cur_len, datacsum);
-- 
2.8.3



