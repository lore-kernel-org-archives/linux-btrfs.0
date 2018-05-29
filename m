Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754791AbeE2Hpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 03:45:31 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C75ACAF70
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 07:45:29 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check: Also compare data between mirrors to detect corruption for NODATASUM extents
Date: Tue, 29 May 2018 15:45:27 +0800
Message-Id: <20180529074527.7333-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As the lzo corruption reported by James Harvey, for data extents without
checksum, neither btrfs check nor kernel scrub could detect anything
wrong.

However if our profile supports duplication, we still have a chance to
detect such corruption, as in that case the mirrors will mismatch with
each other.

So enhance --check-data-csum option to do such check, and this could
help us to detect such corruption in an autonomous test case.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-check.asciidoc |   2 +
 check/main.c                       | 161 ++++++++++++++++++++++++++++-
 2 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index b963eae5cdce..34173acbc523 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -51,6 +51,8 @@ verify checksums of data blocks
 +
 This expects that the filesystem is otherwise OK, and is basically and offline
 'scrub' but does not repair data from spare copies.
+Also, for data extent without checksum (NODATASUM), it will compare data
+between mirrors to detect any possible mismatch.
 
 --chunk-root <bytenr>::
 use the given offset 'bytenr' for the chunk tree root
diff --git a/check/main.c b/check/main.c
index 68da994f7ae0..2ea965fc2fed 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5602,6 +5602,148 @@ out:
 	return ret;
 }
 
+/*
+ * Return 0 if both mirrors match
+ * Return >0 if mirrors mismatch
+ * Return <0 for fatal error
+ */
+static int compare_extent_mirrors(struct btrfs_fs_info *fs_info, u64 bytenr,
+				  u64 len)
+{
+	u64 cur;
+	const int buf_size = SZ_128K;
+	char buf1[buf_size];
+	char buf2[buf_size];
+	int ret;
+
+	if (btrfs_num_copies(fs_info, bytenr, len) != 2)
+		return -EINVAL;
+
+	for (cur = bytenr; cur < bytenr + len; cur += buf_size) {
+		u64 cur_len = min_t(u64, buf_size, bytenr + len - cur);
+
+		ret = read_data_from_disk(fs_info, buf1, cur, cur_len, 1);
+		if (ret < 0)
+			return ret;
+		ret = read_data_from_disk(fs_info, buf2, cur, cur_len, 2);
+		if (ret < 0)
+			return ret;
+		if (memcmp(buf1, buf2, cur_len))
+			return 1;
+	}
+	return 0;
+}
+
+static int check_bg_mirrors_for_nodatasum(struct btrfs_fs_info *fs_info,
+					  struct btrfs_block_group_cache *bg)
+{
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	int errors = 0;
+	int ret;
+
+	key.objectid = bg->key.objectid;
+	key.type = 0;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret < 0)
+		return ret;
+	if (ret == 0) {
+		/* Such key should not exist, something goes wrong */
+		ret = -EUCLEAN;
+		goto error;
+	}
+
+	while (1) {
+		u64 csum_found;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.type != BTRFS_EXTENT_ITEM_KEY)
+			goto next;
+		ret = count_csum_range(fs_info, key.objectid, key.offset,
+				       &csum_found);
+		if (ret < 0)
+			goto error;
+		/*
+		 * Here we don't care if csum is covering the whole extent,
+		 * as if it's true it's half csumed, file extent check will
+		 * report, we only care if it's without csum at all
+		 */
+		if (csum_found)
+			goto next;
+		ret = compare_extent_mirrors(fs_info, key.objectid, key.offset);
+		if (ret < 0) {
+			error(
+	"failed to compare data extent mirrors for bytenr %llu len %llu: %s",
+			      key.objectid, key.offset, strerror(-ret));
+			goto error;
+		}
+		if (ret > 0) {
+			error(
+	"found data mismatch for NODATASUM extent, at bytenr %llu len %llu",
+			      key.objectid, key.offset);
+			errors++;
+		}
+next:
+		ret = btrfs_next_extent_item(extent_root, &path,
+					bg->key.objectid + bg->key.offset - 1);
+		if (ret < 0)
+			goto error;
+		if (ret > 0)
+			break;
+	}
+	btrfs_release_path(&path);
+	return errors;
+
+error:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
+ * Check for any data extent without csum, and then compare its data with
+ * any existing mirror to detect any possible corruption.
+ *
+ * Return 0 for all good.
+ * Return <0 for fatal error. (Like failed to read tree blocks)
+ * Return >0 for how many mismatched extents found.
+ */
+static int check_mirrors_for_nodatasum(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group_cache *bg;
+	int ret;
+	int errors = 0;
+
+	bg = btrfs_lookup_first_block_group(fs_info, 0);
+	if (!bg)
+		return -EUCLEAN;
+
+	while (bg) {
+		/* Here we only care about data block groups */
+		if (!(bg->flags & BTRFS_BLOCK_GROUP_DATA))
+			goto next;
+		/*
+		 * And it must be mirrored profile
+		 * NOTE: For RAID5/6 it's not yet supported yet.
+		 */
+		if (!((BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP |
+		       BTRFS_BLOCK_GROUP_RAID10) & bg->flags))
+			goto next;
+		ret = check_bg_mirrors_for_nodatasum(fs_info, bg);
+		/* Fatal error, exist right now */
+		if (ret < 0)
+			return ret;
+		errors += ret;
+next:
+		bg = btrfs_lookup_first_block_group(fs_info,
+					bg->key.objectid + bg->key.offset);
+	}
+	return errors;
+}
+
 static int check_csums(struct btrfs_root *root)
 {
 	struct btrfs_path path;
@@ -5697,8 +5839,25 @@ skip_csum_check:
 		num_bytes += data_len;
 		path.slots[0]++;
 	}
-
 	btrfs_release_path(&path);
+
+	/*
+	 * Do extra check on mirror consistence for NODATASUM case if
+	 * --check-datasum is specified.
+	 * For NODATASUM case, we can still check if both copies match.
+	 */
+	if (verify_csum) {
+		ret = check_mirrors_for_nodatasum(root->fs_info);
+		if (ret < 0) {
+			error(
+		"failed to check consistence for data without checksum: %s",
+			      strerror(-ret));
+			errors++;
+		}
+		if (ret > 0)
+			errors += ret;
+	}
+
 	return errors;
 }
 
-- 
2.17.0

