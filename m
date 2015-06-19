Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59629 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbbFSSyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 14:54:10 -0400
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        wangyf <wangyf-fnst@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>, Omar Sandoval <osandov@fb.com>
Subject: [PATCH v2 5/5] Btrfs: fix parity scrub of RAID 5/6 with missing device
Date: Fri, 19 Jun 2015 11:52:52 -0700
Message-ID: <5b30d6a8eeac1120ef6416f4b7258f184caa02fe.1434739053.git.osandov@fb.com>
In-Reply-To: <cover.1434739053.git.osandov@fb.com>
References: <cover.1434739053.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When testing the previous patch, Zhao Lei reported a similar bug when
attempting to scrub a degraded RAID 5/6 filesystem with a missing
device, leading to NULL pointer dereferences from the RAID 5/6 parity
scrubbing code.

The first cause was the same as in the previous patch: attempting to
call bio_add_page() on a missing block device. To fix this,
scrub_extent_for_parity() can just mark the sectors on the missing
device as errors instead of attempting to read from it.

Additionally, the code uses scrub_remap_extent() to map the extent of
the corresponding data stripe, but the extent wasn't already mapped. If
scrub_remap_extent() finds a missing block device, it doesn't initialize
extent_dev, so we're left with a NULL struct btrfs_device. The solution
is to use btrfs_map_block() directly.

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/scrub.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b75f1e9c6adc..731bab4c0118 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2687,6 +2687,11 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
 	u8 csum[BTRFS_CSUM_SIZE];
 	u32 blocksize;
 
+	if (dev->missing) {
+		scrub_parity_mark_sectors_error(sparity, logical, len);
+		return 0;
+	}
+
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
 		blocksize = sctx->sectorsize;
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
@@ -2884,6 +2889,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
+	struct btrfs_bio *bbio = NULL;
 	u64 flags;
 	int ret;
 	int slot;
@@ -2893,6 +2899,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	u64 extent_logical;
 	u64 extent_physical;
 	u64 extent_len;
+	u64 mapped_length;
 	struct btrfs_device *extent_dev;
 	struct scrub_parity *sparity;
 	int nsectors;
@@ -3015,10 +3022,21 @@ again:
 			scrub_parity_mark_sectors_data(sparity, extent_logical,
 						       extent_len);
 
-			scrub_remap_extent(fs_info, extent_logical,
-					   extent_len, &extent_physical,
-					   &extent_dev,
-					   &extent_mirror_num);
+			mapped_length = extent_len;
+			ret = btrfs_map_block(fs_info, READ, extent_logical,
+					      &mapped_length, &bbio, 0);
+			if (!ret) {
+				if (!bbio || mapped_length < extent_len)
+					ret = -EIO;
+			}
+			if (ret) {
+				btrfs_put_bbio(bbio);
+				goto out;
+			}
+			extent_physical = bbio->stripes[0].physical;
+			extent_mirror_num = bbio->mirror_num;
+			extent_dev = bbio->stripes[0].dev;
+			btrfs_put_bbio(bbio);
 
 			ret = btrfs_lookup_csums_range(csum_root,
 						extent_logical,
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
