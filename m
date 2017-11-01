Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:43698 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753486AbdKABaw (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 21:30:52 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 1/4] btrfs-progs: mkfs: Enhance minimal device size calculation to fix mkfs failure on small file
Date: Wed,  1 Nov 2017 09:30:40 +0800
Message-Id: <20171101013043.19294-2-wqu@suse.com>
In-Reply-To: <20171101013043.19294-1-wqu@suse.com>
References: <20171101013043.19294-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit c11e36a29e84 ("Btrfs-progs: Do not force mixed block group
creation unless '-M' option is specified"), mkfs no longer use mixed
block group unless specified manually.

This breaks the minimal device size calculation, which only considered
mixed block group use case.

This patch enhances minimal device size calculation for mkfs, by using
different minimal stripe length (calculated from code) for different
profiles, and use them to calculate minimal device size.

Reported-by: Wesley Aptekar-Cassels <W.Aptekar@gmail.com>
Fixes: c11e36a29e84 ("Btrfs-progs: Do not force mixed block group creation unless '-M' option is specified")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 mkfs/common.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 mkfs/common.h |  4 ++--
 mkfs/main.c   |  3 ++-
 3 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index 71318b10fa51..2c400f44dbf3 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -438,12 +438,6 @@ out:
 	return ret;
 }
 
-u64 btrfs_min_dev_size(u32 nodesize)
-{
-	return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
-		    btrfs_min_global_blk_rsv_size(nodesize));
-}
-
 /*
  * Btrfs minimum size calculation is complicated, it should include at least:
  * 1. system group size
@@ -454,11 +448,71 @@ u64 btrfs_min_dev_size(u32 nodesize)
  * To avoid the overkill calculation, (system group + global block rsv) * 2
  * for *EACH* device should be good enough.
  */
-u64 btrfs_min_global_blk_rsv_size(u32 nodesize)
+static u64 btrfs_min_global_blk_rsv_size(u32 nodesize)
 {
 	return (u64)nodesize << 10;
 }
 
+u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
+		       u64 data_profile)
+{
+	u64 reserved = 0;
+	u64 meta_size;
+	u64 data_size;
+
+	if (mixed)
+		return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
+			    btrfs_min_global_blk_rsv_size(nodesize));
+
+	/*
+	 * minimal size calculation is complex due to several factors:
+	 * 1) Temporary chunk resue
+	 *    If specified chunk profile is SINGLE, we can resue
+	 *    temporary chunks, no need to alloc new chunks.
+	 *
+	 * 2) Different minimal chunk size for different profile
+	 *    For initial sys chunk, chunk size is fixed to 4M.
+	 *    For single profile, minimal chunk size is 8M for all.
+	 *    For other profiles, minimal chunk and stripe size
+	 *    differs from 8M to 64M.
+	 *
+	 * To calculate it a little easier, here we assume we don't
+	 * reuse any temporary chunk, and calculate the size all
+	 * by ourselves.
+	 *
+	 * Temporary chunks sizes are always fixed:
+	 * One initial sys chunk, one SINGLE meta, and one SINGLE data.
+	 * The latter two are all 8M, accroding to @calc_size of
+	 * btrfs_alloc_chunk().
+	 */
+	reserved += BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
+
+	/*
+	 * For real chunks, we need to refer different sizes:
+	 * For SINGLE, it's still fixed to 8M (@calc_size).
+	 * For other profiles, refer to max(@min_stripe_size, @calc_size).
+	 *
+	 * And use the stripe size to calculate its physical used space.
+	 */
+	if (meta_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
+		meta_size = SZ_8M + SZ_32M;
+	else
+		meta_size = SZ_8M + SZ_8M;
+	/* Only metadata put 2 stripes into one disk */
+	if (meta_profile & BTRFS_BLOCK_GROUP_DUP)
+		meta_size *= 2;
+	reserved += meta_size;
+
+	if (data_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
+		data_size = SZ_64M;
+	else
+		data_size = SZ_8M;
+	if (data_profile & BTRFS_BLOCK_GROUP_DUP)
+		data_size *= 2;
+	reserved += data_size;
+	return reserved;
+}
+
 #define isoctal(c)	(((c) & ~7) == '0')
 
 static inline void translate(char *f, char *t)
diff --git a/mkfs/common.h b/mkfs/common.h
index 3757e9e7fd0a..e9e3b3eb43a6 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -66,8 +66,8 @@ struct btrfs_mkfs_config {
 };
 
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
-u64 btrfs_min_dev_size(u32 nodesize);
-u64 btrfs_min_global_blk_rsv_size(u32 nodesize);
+u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
+		       u64 data_profile);
 int test_minimum_size(const char *file, u64 min_dev_size);
 int is_vol_small(const char *file);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
diff --git a/mkfs/main.c b/mkfs/main.c
index 6669a4b901af..982cafc07b84 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -979,7 +979,8 @@ int main(int argc, char **argv)
 		goto error;
 	}
 
-	min_dev_size = btrfs_min_dev_size(nodesize);
+	min_dev_size = btrfs_min_dev_size(nodesize, mixed, metadata_profile,
+					  data_profile);
 	/* Check device/block_count after the nodesize is determined */
 	if (block_count && block_count < min_dev_size) {
 		error("size %llu is too small to make a usable filesystem",
-- 
2.14.3

