Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA2BC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29CDB20830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XqXl3UAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfDJT4U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:56:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38603 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfDJT4T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 15:56:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id g1so2034755qki.5
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 12:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ul+Rs4w4P3vpZqgOYpA4m2zXmattNappSt4Ue1DT7qA=;
        b=XqXl3UATm6RFeqbNdfx90H7Ef3UcFITKhPYPFIs4eL9l3bYthFTvRg2/0gyoU7vOpS
         Gt4XlCrv2/Mh+ihKnSlyRAk2jeuKpgKwr59qa98vDptt1m8m4AdF4yo0V1A5+tgGVoQm
         Ib0OF1ahPMUQT19bfVUekbKulM+HR6KuWqWsiTlMbaVN8d2J3C0TLmCpcbjOy53jopk6
         s8kW/3MjCGjqHtOL6PeWZ0fSn0ledMpxE9L/mCimhMPrz7FY69bUMNb9hl+nXl2ZG6+1
         i4QMg/99ahm5MiIzXvSWTISyDC+IeomHJ0BsRqu7JuxKTWnqowYh8dEob2UpOF+KaO0j
         f5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ul+Rs4w4P3vpZqgOYpA4m2zXmattNappSt4Ue1DT7qA=;
        b=smT1HKnR6qBWzbYhZepEbE5WLHHhc7D8nORgQgfr4ajIkAojPiMz8C4Oq+T/OrA5++
         6U9JXyO0R6skx9jjdUByDdUaDl6EzAXQcGLPtOWrQMQirZLygGs4IeQR75MnK+s2o6WG
         0jg0sjQ4m+v4p0vkCCDyMw2DxZ1J+Pouuxq9Z2rlyyuu9+CZ0dh7wccRT/2EkJ2LfdUv
         4Vjwz5KCbYXmsXakt5L2v8OrvdQGVkpXdEsvOPcxHsLK4bYAm3TLgodQ4wXHeiZCRZZh
         ursmf0McW9d+FZxSZyOaBmpyPBexU+ljsV7Ll5IC3PRzUExoUJ9c7ZY4CHi3C0S4cO++
         ZAfA==
X-Gm-Message-State: APjAAAUln0LU6AcQRkVYdt9FlL6HAp0n8MlYWxhL1XhZ/Bw8gIw8A7YB
        /Gmm6SJZsEC6DdffxLwimvWeppjDcq3tNA==
X-Google-Smtp-Source: APXvYqzszYuNnLQnXmEXN3C+O5hIaDmvan9Zz2GA22SpuHjYnU5ggIdSQCHWMJswIaK59hU/ti3z6w==
X-Received: by 2002:a05:620a:13f3:: with SMTP id h19mr33805018qkl.109.1554926178243;
        Wed, 10 Apr 2019 12:56:18 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s66sm16342693qkd.90.2019.04.10.12.56.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 12:56:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: reserve delalloc metadata differently
Date:   Wed, 10 Apr 2019 15:56:10 -0400
Message-Id: <20190410195610.84110-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190410195610.84110-1-josef@toxicpanda.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With the per-inode block rsvs we started refilling the reserve based on
the calculated size of the outstanding csum bytes and extents for the
inode, including the amount we were adding with the new operation.

However generic/224 exposed a problem with this approach.  With 1000
files all writing at the same time we ended up with a bunch of bytes
being reserved but unusable.

When you write to a file we reserve space for the csum leaves for those
bytes, the number of extent items required to cover those bytes, and a
single credit for updating the inode at ordered extent finish for that
range of bytes.  This is held until the ordered extent finishes and we
release all of the reserved space.

If a second write comes in at this point we would add a single
reservation for the new outstanding extent and however many reservations
for the csum leaves.  At this point we find the delta of how much we
have reserved and how much outstanding size this is and attempt to
reserve this delta.  If the first write finishes it will not release any
space, because the space it had reserved for the initial write is still
needed for the second write.  However some space would have been used,
as we have added csums, extent items, and dirtied the inode.  Our
reserved space would be > 0 but < the total needed reserved space.

This is just for a single inode, now consider generic/224.  This has
1000 inodes writing in parallel to a very small file system, 1gib.  In
my testing this usually means we get about a 120mib metadata area to
work with, more than enough to allow the writes to continue, but not
enough if all of the inodes are stuck trying to reserve the slack space
while continuing to hold their leftovers from their initial writes.

Fix this by pre-reserved _only_ for the space we are currently trying to
add.  Then once that is successful modify our inodes csum count and
outstanding extents, and then add the newly reserved space to the inodes
block_rsv.  This allows us to actually pass generic/224 without running
out of metadata space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 145 ++++++++++++++++++-------------------------------
 1 file changed, 53 insertions(+), 92 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0982456ebabb..9aff7a8817d9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5811,85 +5811,6 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
-static void calc_refill_bytes(struct btrfs_block_rsv *block_rsv,
-				u64 *metadata_bytes, u64 *qgroup_bytes)
-{
-	*metadata_bytes = 0;
-	*qgroup_bytes = 0;
-
-	spin_lock(&block_rsv->lock);
-	if (block_rsv->reserved < block_rsv->size)
-		*metadata_bytes = block_rsv->size - block_rsv->reserved;
-	if (block_rsv->qgroup_rsv_reserved < block_rsv->qgroup_rsv_size)
-		*qgroup_bytes = block_rsv->qgroup_rsv_size -
-			block_rsv->qgroup_rsv_reserved;
-	spin_unlock(&block_rsv->lock);
-}
-
-/**
- * btrfs_inode_rsv_refill - refill the inode block rsv.
- * @inode - the inode we are refilling.
- * @flush - the flushing restriction.
- *
- * Essentially the same as btrfs_block_rsv_refill, except it uses the
- * block_rsv->size as the minimum size.  We'll either refill the missing amount
- * or return if we already have enough space.  This will also handle the reserve
- * tracepoint for the reserved amount.
- */
-static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
-				  enum btrfs_reserve_flush_enum flush)
-{
-	struct btrfs_root *root = inode->root;
-	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
-	u64 num_bytes, last = 0;
-	u64 qgroup_num_bytes;
-	int ret = -ENOSPC;
-
-	calc_refill_bytes(block_rsv, &num_bytes, &qgroup_num_bytes);
-	if (num_bytes == 0)
-		return 0;
-
-	do {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_num_bytes,
-							 true);
-		if (ret)
-			return ret;
-		ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
-		if (ret) {
-			btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
-			last = num_bytes;
-			/*
-			 * If we are fragmented we can end up with a lot of
-			 * outstanding extents which will make our size be much
-			 * larger than our reserved amount.
-			 *
-			 * If the reservation happens here, it might be very
-			 * big though not needed in the end, if the delalloc
-			 * flushing happens.
-			 *
-			 * If this is the case try and do the reserve again.
-			 */
-			if (flush == BTRFS_RESERVE_FLUSH_ALL)
-				calc_refill_bytes(block_rsv, &num_bytes,
-						   &qgroup_num_bytes);
-			if (num_bytes == 0)
-				return 0;
-		}
-	} while (ret && last != num_bytes);
-
-	if (!ret) {
-		block_rsv_add_bytes(block_rsv, num_bytes, false);
-		trace_btrfs_space_reservation(root->fs_info, "delalloc",
-					      btrfs_ino(inode), num_bytes, 1);
-
-		/* Don't forget to increase qgroup_rsv_reserved */
-		spin_lock(&block_rsv->lock);
-		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
-		spin_unlock(&block_rsv->lock);
-	}
-	return ret;
-}
-
 static u64 __btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 				     struct btrfs_block_rsv *block_rsv,
 				     u64 num_bytes, u64 *qgroup_to_release)
@@ -6190,9 +6111,26 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	spin_unlock(&block_rsv->lock);
 }
 
+static inline void calc_inode_reservations(struct btrfs_fs_info *fs_info,
+					   struct btrfs_inode *inode,
+					   u64 num_bytes, u64 *meta_reserve,
+					   u64 *qgroup_reserve)
+{
+	u64 nr_extents = count_max_extents(num_bytes);
+	u64 csum_leaves = btrfs_csum_bytes_to_leaves(fs_info, num_bytes);
+
+	/* We add one for the inode update at finish ordered time. */
+	*meta_reserve = btrfs_calc_trans_metadata_size(fs_info,
+						nr_extents + csum_leaves + 1);
+	*qgroup_reserve = nr_extents * fs_info->nodesize;
+}
+
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
+	u64 meta_reserve, qgroup_reserve;
 	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
@@ -6222,7 +6160,31 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 
-	/* Add our new extents and calculate the new rsv size. */
+	/*
+	 * Josef, we always want to do it this way, every other way is wrong and
+	 * ends in tears.  Pre-reserving the amount we are going to add will
+	 * always be the right way, because otherwise if we have enough
+	 * parallelism we could end up with thousands of inodes all holding
+	 * little bits of reservations they were able to make previously and the
+	 * only way to reclaim that space is to ENOSPC out the operations and
+	 * clear everything out and try again, which is shitty.  This way we
+	 * just over-reserve slightly, and clean up the mess when we are done.
+	 */
+	calc_inode_reservations(fs_info, inode, num_bytes, &meta_reserve,
+				&qgroup_reserve);
+	ret = btrfs_qgroup_reserve_meta_prealloc(root, qgroup_reserve, true);
+	if (ret)
+		goto out_fail;
+	ret = reserve_metadata_bytes(root, block_rsv, meta_reserve, flush);
+	if (ret)
+		goto out_qgroup;
+
+	/*
+	 * Now we need to update our outstanding extents and csum bytes _first_
+	 * and then add the reservation to the block_rsv.  This keeps us from
+	 * racing with an ordered completion or some such that would think it
+	 * needs to free the reservation we just made.
+	 */
 	spin_lock(&inode->lock);
 	nr_extents = count_max_extents(num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
@@ -6230,22 +6192,21 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
-	ret = btrfs_inode_rsv_refill(inode, flush);
-	if (unlikely(ret))
-		goto out_fail;
+	/* Now we can safely add our space to our block rsv. */
+	block_rsv_add_bytes(block_rsv, meta_reserve, false);
+	trace_btrfs_space_reservation(root->fs_info, "delalloc",
+				      btrfs_ino(inode), meta_reserve, 1);
+
+	spin_lock(&block_rsv->lock);
+	block_rsv->qgroup_rsv_reserved += qgroup_reserve;
+	spin_unlock(&block_rsv->lock);
 
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
 	return 0;
-
+out_qgroup:
+	btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
 out_fail:
-	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
-	btrfs_mod_outstanding_extents(inode, -nr_extents);
-	inode->csum_bytes -= num_bytes;
-	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
-	spin_unlock(&inode->lock);
-
 	btrfs_inode_rsv_release(inode, true);
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
-- 
2.13.5

