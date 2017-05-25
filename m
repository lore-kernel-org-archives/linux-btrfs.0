Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25075 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1165160AbdEYGWr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 18/20] btrfs-progs: scrub: Introduce a function to scrub one full stripe
Date: Thu, 25 May 2017 14:22:03 +0800
Message-ID: <20170525062205.11660-19-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_one_full_stripe(), to check a full
stripe.

It handles the full stripe scrub in the following steps:
0) Check if we need to check full stripe
   If full stripe contains no extent, why waste our CPU and IO?

1) Read out full stripe
   Then we know how many devices are missing or have read error.
   If out of repair, then exit

   If have missing device or have read error, try recover here.

2) Check data stripe against csum
   We add data stripe with csum error as corrupted stripe, just like
   dev missing or read error.
   Then recheck if csum mismatch is still below tolerance.

Finally we check the full stripe using 2 factors only:
A) If the full stripe go through recover ever
B) If the full stripe has csum error

Combine factor A and B we get:
1) A && B: Recovered, csum mismatch
   Screwed up totally
2) A && !B: Recovered, csum match
   Recoverable, data corrupted but P/Q is good to recover
3) !A && B: Not recovered, csum mismatch
   Try to recover corrupted data stripes
   If recovered csum match, then recoverable
   Else, screwed up
4) !A && !B: Not recovered, no csum mismatch
   Best case, just check if P/Q matches.
   If P/Q matches, everything is good
   Else, just P/Q is screwed up, still recoverable.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 285 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 285 insertions(+)

diff --git a/scrub.c b/scrub.c
index 94981f2b..1c9a7fc4 100644
--- a/scrub.c
+++ b/scrub.c
@@ -918,5 +918,290 @@ static int write_full_stripe(struct scrub_full_stripe *fstripe)
 out:
 	free(ptrs);
 	return ret;
+}
+
+/*
+ * Return 0 if we still have chance to recover
+ * Return <0 if we have no more chance
+ */
+static int report_recoverablity(struct scrub_full_stripe *fstripe)
+{
+	int max_tolerance;
+	u64 start = fstripe->logical_start;
+
+	if (fstripe->bg_type & BTRFS_BLOCK_GROUP_RAID5)
+		max_tolerance = 1;
+	else
+		max_tolerance = 2;
+
+	if (fstripe->nr_corrupted_stripes > max_tolerance) {
+		error(
+	"full stripe %llu CORRUPTED: too many read error or corrupted devices",
+			start);
+		error(
+	"full stripe %llu: tolerance: %d, missing: %d, read error: %d, csum error: %d",
+			start, max_tolerance, fstripe->err_read_stripes,
+			fstripe->err_missing_devs, fstripe->err_csum_dstripes);
+		return -EIO;
+	}
+	return 0;
+}
+
+static void clear_corrupted_stripe_record(struct scrub_full_stripe *fstripe)
+{
+	fstripe->corrupted_index[0] = -1;
+	fstripe->corrupted_index[1] = -1;
+	fstripe->nr_corrupted_stripes = 0;
+}
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
+/*
+ * Scrub one full stripe.
+ *
+ * If everything matches, that's good.
+ * If data stripe corrupted badly, no mean to recovery, it will report it.
+ * If data stripe corrupted, try recovery first and recheck csum, to
+ * determine if it's recoverable or screwed up.
+ */
+static int scrub_one_full_stripe(struct btrfs_fs_info *fs_info,
+				 struct btrfs_scrub_progress *scrub_ctx,
+				 u64 start, u64 *next_ret, int write)
+{
+	struct scrub_full_stripe *fstripe;
+	struct btrfs_map_block *map_block = NULL;
+	u32 stripe_len = BTRFS_STRIPE_LEN;
+	u64 bg_type;
+	u64 len;
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
+	if (ret < 0) {
+		/* Let caller to skip the whole block group */
+		*next_ret = (u64)-1;
+		return ret;
+	}
+	start = map_block->start;
+	len = map_block->length;
+	*next_ret = start + len;
+
+	/*
+	 * Step 0: Check if we need to scrub the full stripe
+	 *
+	 * If no extent lies in the full stripe, not need to check
+	 */
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
+	bg_type = map_block->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	if (bg_type != BTRFS_BLOCK_GROUP_RAID5 &&
+	    bg_type != BTRFS_BLOCK_GROUP_RAID6) {
+		free(map_block);
+		return -EINVAL;
+	}
+
+	fstripe = alloc_full_stripe(map_block->num_stripes,
+				    map_block->stripe_len);
+	if (!fstripe)
+		return -ENOMEM;
+
+	fstripe->logical_start = map_block->start;
+	fstripe->nr_stripes = map_block->num_stripes;
+	fstripe->stripe_len = stripe_len;
+	fstripe->bg_type = bg_type;
+
+	/*
+	 * Step 1: Read out the whole full stripe
+	 *
+	 * Then we have the chance to exit early if too many devices are
+	 * missing.
+	 */
+	for (i = 0; i < map_block->num_stripes; i++) {
+		struct scrub_stripe *s_stripe = &fstripe->stripes[i];
+		struct btrfs_map_stripe *m_stripe = &map_block->stripes[i];
+
+		s_stripe->logical = m_stripe->logical;
+		s_stripe->fd = m_stripe->dev->fd;
+		s_stripe->physical = m_stripe->physical;
+
+		if (m_stripe->dev->fd == -1) {
+			s_stripe->dev_missing = 1;
+			record_corrupted_stripe(fstripe, i);
+			fstripe->err_missing_devs++;
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
+
+	ret = report_recoverablity(fstripe);
+	if (ret < 0)
+		goto out;
+
+	ret = recover_from_parities(fs_info, scrub_ctx, fstripe);
+	if (ret < 0) {
+		error("full stripe %llu CORRUPTED: failed to recover: %s\n",
+		      fstripe->logical_start, strerror(-ret));
+		goto out;
+	}
+
+	/*
+	 * Clear corrupted stripes report, since they are recovered,
+	 * and later checker need to record csum mismatch stripes reusing
+	 * these members
+	 */
+	clear_corrupted_stripe_record(fstripe);
+
+	/*
+	 * Step 2: Check each data stripes against csum
+	 */
+	for (i = 0; i < map_block->num_stripes; i++) {
+		struct scrub_stripe *stripe = &fstripe->stripes[i];
+
+		if (!is_data_stripe(stripe))
+			continue;
+		ret = scrub_one_data_stripe(fs_info, scrub_ctx, stripe,
+					    stripe_len);
+		if (ret < 0) {
+			fstripe->err_csum_dstripes++;
+			record_corrupted_stripe(fstripe, i);
+		}
+	}
+
+	ret = report_recoverablity(fstripe);
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Recovered before, but no csum error
+	 */
+	if (fstripe->err_csum_dstripes == 0 && fstripe->recovered) {
+		error(
+		"full stripe %llu RECOVERABLE: P/Q is good for recovery",
+			start);
+		ret = 0;
+		goto out;
+	}
+	/*
+	 * No csum error, not recovered before.
+	 *
+	 * Only need to check if P/Q matches.
+	 */
+	if (fstripe->err_csum_dstripes == 0 && !fstripe->recovered) {
+		ret = verify_parities(fs_info, scrub_ctx, fstripe);
+		if (ret < 0) {
+			error(
+		"full stripe %llu CORRUPTED: failed to check P/Q: %s",
+				start, strerror(-ret));
+			goto out;
+		}
+		if (ret > 0) {
+			if (write) {
+				ret = write_full_stripe(fstripe);
+				if (ret < 0)
+					error("failed to write full stripe %llu: %s",
+						start, strerror(-ret));
+				else
+					printf("full stripe %llu REPARIED: only P/Q mismatches, repaired\n",
+						start);
+				goto out;
+			} else {
+				printf("full stripe %llu RECOVERABLE: only P/Q is corrupted\n",
+					start);
+				ret = 0;
+			}
+		}
+		goto out;
+	}
 
+	/*
+	 * Still csum error after recovery
+	 *
+	 * No mean to fix further, screwed up already.
+	 */
+	if (fstripe->err_csum_dstripes && fstripe->recovered) {
+		error(
+	"full stripe %llu CORRUPTED: csum still mismatch after recovery",
+			start);
+		ret = -EIO;
+		goto out;
+	}
+
+	/* Csum mismatch, but we still has chance to recover. */
+	ret = recover_from_parities(fs_info, scrub_ctx, fstripe);
+	if (ret < 0) {
+		error(
+	"full stripe %llu CORRUPTED: failed to recover: %s\n",
+			fstripe->logical_start, strerror(-ret));
+		goto out;
+	}
+
+	/* After recovery, recheck data stripe csum */
+	for (i = 0; i < 2; i++) {
+		int index = fstripe->corrupted_index[i];
+		struct scrub_stripe *stripe;
+
+		if (i == -1)
+			continue;
+		stripe = &fstripe->stripes[index];
+		ret = scrub_one_data_stripe(fs_info, scrub_ctx, stripe,
+					    stripe_len);
+		if (ret < 0) {
+			error(
+	"full stripe %llu CORRUPTED: csum still mismatch after recovery",
+				start);
+			goto out;
+		}
+	}
+	if (write) {
+		ret = write_full_stripe(fstripe);
+		if (ret < 0)
+			error("failed to write full stripe %llu: %s",
+				start, strerror(-ret));
+		else
+			printf("full stripe %llu REPARIED: corrupted data with good P/Q, repaired\n",
+				start);
+		goto out;
+	}
+	printf(
+	"full stripe %llu RECOVERABLE: Data stripes corrupted, but P/Q is good\n",
+		start);
+
+out:
+	free_full_stripe(fstripe);
+	free(map_block);
+	return ret;
 }
-- 
2.13.0



