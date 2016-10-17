Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55698 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbcJQB2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 21:28:04 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id F335041B4BCB
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 09:27:51 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v0.8 12/14] btrfs-progs: check/scrub: Introduce a function to scrub one full stripe
Date: Mon, 17 Oct 2016 09:27:41 +0800
Message-Id: <20161017012743.9692-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
References: <20161017012743.9692-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_one_full_stripe(), to check a full
stripe.

It can handle the following case:
1) Device missing
   Will try to recover, then check against csum

2) Csum mismatch
   Will try to recover, then check against csum

3) All csum match
   Will check against parity, to ensure if it's OK

4) Csum missing
   Just check against parity.

Not impelmented:
1) RAID6 recovery.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 183 insertions(+), 10 deletions(-)

diff --git a/check/scrub.c b/check/scrub.c
index c965328..1c8e440 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -55,8 +55,9 @@ struct scrub_full_stripe {
 	/* Missing csum data stripes */
 	u32 missing_csum_dstripes;
 
-	/* Missing stripe index */
-	int missing_stripes[2];
+	/* currupted stripe index */
+	int corrupted_index[2];
+	int nr_corrupted_stripes;
 
 	/* Has already been recovered using parities */
 	unsigned int recovered:1;
@@ -87,6 +88,8 @@ static struct scrub_full_stripe *alloc_full_stripe(int nr_stripes,
 	memset(ret, 0, size);
 	ret->nr_stripes = nr_stripes;
 	ret->stripe_len = stripe_len;
+	ret->corrupted_index[0] = -1;
+	ret->corrupted_index[1] = -1;
 
 	/* Alloc data memory for each stripe */
 	for (i = 0; i < nr_stripes; i++) {
@@ -471,7 +474,7 @@ out:
 	return ret;
 }
 
-static int recovery_from_parities(struct btrfs_fs_info *fs_info,
+static int recover_from_parities(struct btrfs_fs_info *fs_info,
 				  struct btrfs_scrub_progress *scrub_ctx,
 				  struct scrub_full_stripe *fstripe)
 {
@@ -483,22 +486,28 @@ static int recovery_from_parities(struct btrfs_fs_info *fs_info,
 	int ret;
 
 	/* No need to recover */
-	if (!fstripe->err_read_stripes && !fstripe->err_csum_dstripes)
+	if (!fstripe->nr_corrupted_stripes)
 		return 0;
 
-	/* Already recovered once, no more chance */
-	if (fstripe->recovered)
+	if (fstripe->recovered) {
+		error("full stripe %llu has been recovered before, no more chance to recover",
+		      fstripe->logical_start);
 		return -EINVAL;
+	}
 
-	if (fstripe->bg_type == BTRFS_BLOCK_GROUP_RAID6) {
+	if (fstripe->bg_type == BTRFS_BLOCK_GROUP_RAID6 &&
+	    fstripe->nr_corrupted_stripes == 2) {
 		/* Need to recover 2 stripes, not supported yet */
-		error("recover data stripes for RAID6 is not support yet");
+		error("recover 2 data stripes for RAID6 is not support yet");
 		return -ENOTTY;
 	}
 
 	/* Out of repair */
-	if (fstripe->err_read_stripes + fstripe->err_csum_dstripes > 1)
+	if (fstripe->nr_corrupted_stripes > 1) {
+		error("full stripe %llu has too many missing stripes and csum mismatch, unable to recover",
+		      fstripe->logical_start);
 		return -EINVAL;
+	}
 
 	ptrs = malloc(sizeof(void *) * fstripe->nr_stripes);
 	if (!ptrs)
@@ -507,7 +516,7 @@ static int recovery_from_parities(struct btrfs_fs_info *fs_info,
 	/* Construct ptrs */
 	for (i = 0; i < nr_stripes; i++)
 		ptrs[i] = fstripe->stripes[i].data;
-	corrupted = fstripe->missing_stripes[0];
+	corrupted = fstripe->corrupted_index[0];
 
 	/* Recover the corrupted data csum */
 	ret = raid5_gen_result(nr_stripes, stripe_len, corrupted, ptrs);
@@ -516,3 +525,167 @@ static int recovery_from_parities(struct btrfs_fs_info *fs_info,
 	free(ptrs);
 	return ret;
 }
+
+static void record_corrupted_stripe(struct scrub_full_stripe *fstripe,
+				    int index)
+{
+	int i = 0;
+
+	for (i = 0; i < 2; i++) {
+		if (fstripe->corrupted_index[i] == -1) {
+			fstripe->corrupted_index[i] = index;
+			break;
+		}
+	}
+	fstripe->nr_corrupted_stripes++;
+}
+
+static int scrub_one_full_stripe(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 u64 start, u64 *next_ret)
+{
+	struct scrub_full_stripe *fstripe;
+	struct btrfs_map_block *map_block = NULL;
+	u32 stripe_len = BTRFS_STRIPE_LEN;
+	u64 bg_type;
+	u64 len;
+	int max_tolerance;
+	int i;
+	int ret;
+
+	if (!next_ret) {
+		error("invalid argument for %s", __func__);
+		return -EINVAL;
+	}
+
+	ret = __btrfs_map_block_v2(fs_info, WRITE, start, stripe_len,
+				   &map_block);
+	if (ret < 0)
+		return ret;
+	start = map_block->start;
+	len = map_block->length;
+	*next_ret = start + len;
+	bg_type = map_block->type;
+	if (bg_type == BTRFS_BLOCK_GROUP_RAID5)
+		max_tolerance = 1;
+	else if (bg_type == BTRFS_BLOCK_GROUP_RAID6)
+		max_tolerance = 2;
+	else {
+		free(map_block);
+		return -EINVAL;
+	}
+
+	/* Before going on, check if there is any extent in the range */
+	ret = btrfs_check_extent_exists(fs_info, start, len);
+	if (ret < 0) {
+		free(map_block);
+		return ret;
+	}
+	/* No extents in range, no need to check */
+	if (ret == 0) {
+		free(map_block);
+		return 0;
+	}
+
+	fstripe = alloc_full_stripe(map_block->num_stripes,
+				    map_block->stripe_len);
+	if (!fstripe)
+		return -ENOMEM;
+
+	/* Fill scrub_full_stripes */
+	fstripe->logical_start = map_block->start;
+	fstripe->nr_stripes = map_block->num_stripes;
+	fstripe->stripe_len = stripe_len;
+	fstripe->bg_type = bg_type;
+
+	/* Fill each stripe, including its data */
+	for (i = 0; i < map_block->num_stripes; i++) {
+		struct scrub_stripe *s_stripe = &fstripe->stripes[i];
+		struct btrfs_map_stripe *m_stripe = &map_block->stripes[i];
+
+		s_stripe->logical = m_stripe->logical;
+
+		if (m_stripe->dev->fd == -1) {
+			s_stripe->dev_missing = 1;
+			record_corrupted_stripe(fstripe, i);
+			fstripe->err_read_stripes++;
+			continue;
+		}
+
+		ret = pread(m_stripe->dev->fd, s_stripe->data, stripe_len,
+			    m_stripe->physical);
+		if (ret < stripe_len) {
+			record_corrupted_stripe(fstripe, i);
+			fstripe->err_read_stripes++;
+			continue;
+		}
+	}
+	if (fstripe->nr_corrupted_stripes > max_tolerance) {
+		error("full stripe at bytenr: %llu has too many read error, can't be recovered",
+			start);
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = recover_from_parities(fs_info, scrub_ctx, fstripe);
+	if (ret < 0) {
+		error("failed to recover full stripe %llu: %s\n",
+		      fstripe->logical_start, strerror(-ret));
+		goto out;
+	}
+
+	/* Check data stripes against csum tree */
+	for (i = 0; i < map_block->num_stripes; i++) {
+		struct scrub_stripe *stripe = &fstripe->stripes[i];
+
+		if (!is_data_stripe(stripe))
+			continue;
+		ret = scrub_one_data_stripe(fs_info, scrub_ctx, stripe,
+					    stripe_len);
+		if (ret < 0)
+			fstripe->err_csum_dstripes++;
+		if (stripe->csum_missing)
+			fstripe->missing_csum_dstripes++;
+	}
+	if (fstripe->err_csum_dstripes == 0) {
+		/*
+		 * No csum error, data stripes are all OK, only need to
+		 * check parity
+		 */
+		ret = verify_parities(fs_info, scrub_ctx, fstripe);
+		if (ret < 0 && fstripe->missing_csum_dstripes == 0) {
+			error("full stripe at bytenr: %llu has correct data, but corrupted P/Q stripe",
+				start);
+			ret = 0;
+		} else if (ret < 0 && fstripe->missing_csum_dstripes) {
+			error("full stripe at bytenr: %llu has mismatch P/Q stripes, but csum is not enough to determine which is correct",
+				start);
+			ret = -EIO;
+		}
+		goto out;
+	}
+
+	/* Csum mismatch, try recover */
+	ret = recover_from_parities(fs_info, scrub_ctx, fstripe);
+	if (ret < 0) {
+		error("failed to recover full stripe %llu: %s\n",
+		      fstripe->logical_start, strerror(-ret));
+		goto out;
+	}
+
+	/* Recheck recovered stripes */
+	ret = scrub_one_data_stripe(fs_info, scrub_ctx,
+			&fstripe->stripes[fstripe->corrupted_index[0]],
+			stripe_len);
+	if (ret < 0)
+		error("full stripe %llu has unrecoverable csum mismatch",
+		      fstripe->logical_start);
+	else
+		error("full stripe %llu has csum mismatch, but can be recovered from parity",
+		      fstripe->logical_start);
+	ret = 0;
+out:
+	free_full_stripe(fstripe);
+	free(map_block);
+	return ret;
+}
-- 
2.10.0



