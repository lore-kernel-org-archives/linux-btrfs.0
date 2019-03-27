Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40197C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 19:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1C3204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713625;
	bh=dq14Ui6MinerqReU55BDs0HhZmU0AuT2Xe8ZLcevFWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Z/3u9VRt6WKI1e3pqXI2qRO7J1dKCgXE4V06iYyLy20qgBjD6ygWwiJBDCgMRUM4l
	 GpQsYBZfuzkKrTWSeripofb6S47R7izoAs3Q+wbfGkLLtSkjAcT+SigHVGzWEQdICl
	 tkcwAjZO7+uPCSL4J2rjnvr0lYqFqo48VSwLhAYo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbfC0SMU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388324AbfC0SMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:12:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 254AD2177E;
        Wed, 27 Mar 2019 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710333;
        bh=dq14Ui6MinerqReU55BDs0HhZmU0AuT2Xe8ZLcevFWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLYmK6dBhAllRSexHpoupFQU1gLqHdzsulAjnbg3qQGzpcRAf8xuxbhP8SIc3NksP
         5A01GVNDMJqvM/VCrM0bViNAMwnGBbM7isdTHkQb16f9UTPFbUpbkY4pBxegKnq8/5
         oXS0UME+Lq+1ZWzH8U4uRv8RXCfXUazMWszcJVHI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 061/192] btrfs: qgroup: Make qgroup async transaction commit more aggressive
Date:   Wed, 27 Mar 2019 14:08:13 -0400
Message-Id: <20190327181025.13507-61-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit f5fef4593653dfa2a865c485bb81415de51d5c99 ]

[BUG]
Btrfs qgroup will still hit EDQUOT under the following case:

  $ dev=/dev/test/test
  $ mnt=/mnt/btrfs
  $ umount $mnt &> /dev/null
  $ umount $dev &> /dev/null

  $ mkfs.btrfs -f $dev
  $ mount $dev $mnt -o nospace_cache

  $ btrfs subv create $mnt/subv
  $ btrfs quota enable $mnt
  $ btrfs quota rescan -w $mnt
  $ btrfs qgroup limit -e 1G $mnt/subv

  $ fallocate -l 900M $mnt/subv/padding
  $ sync

  $ rm $mnt/subv/padding

  # Hit EDQUOT
  $ xfs_io -f -c "pwrite 0 512M" $mnt/subv/real_file

[CAUSE]
Since commit a514d63882c3 ("btrfs: qgroup: Commit transaction in advance
to reduce early EDQUOT"), btrfs is not forced to commit transaction to
reclaim more quota space.

Instead, we just check pertrans metadata reservation against some
threshold and try to do asynchronously transaction commit.

However in above case, the pertrans metadata reservation is pretty small
thus it will never trigger asynchronous transaction commit.

[FIX]
Instead of only accounting pertrans metadata reservation, we calculate
how much free space we have, and if there isn't much free space left,
commit transaction asynchronously to try to free some space.

This may slow down the fs when we have less than 32M free qgroup space,
but should reduce a lot of false EDQUOT, so the cost should be
acceptable.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e1fcb28ad4cc..e46e83e87600 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2427,16 +2427,15 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 /*
  * Two limits to commit transaction in advance.
  *
- * For RATIO, it will be 1/RATIO of the remaining limit
- * (excluding data and prealloc meta) as threshold.
+ * For RATIO, it will be 1/RATIO of the remaining limit as threshold.
  * For SIZE, it will be in byte unit as threshold.
  */
-#define QGROUP_PERTRANS_RATIO		32
-#define QGROUP_PERTRANS_SIZE		SZ_32M
+#define QGROUP_FREE_RATIO		32
+#define QGROUP_FREE_SIZE		SZ_32M
 static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
 				const struct btrfs_qgroup *qg, u64 num_bytes)
 {
-	u64 limit;
+	u64 free;
 	u64 threshold;
 
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
@@ -2455,20 +2454,21 @@ static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
 	 */
 	if ((qg->lim_flags & (BTRFS_QGROUP_LIMIT_MAX_RFER |
 			      BTRFS_QGROUP_LIMIT_MAX_EXCL))) {
-		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
-			limit = qg->max_excl;
-		else
-			limit = qg->max_rfer;
-		threshold = (limit - qg->rsv.values[BTRFS_QGROUP_RSV_DATA] -
-			    qg->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC]) /
-			    QGROUP_PERTRANS_RATIO;
-		threshold = min_t(u64, threshold, QGROUP_PERTRANS_SIZE);
+		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
+			free = qg->max_excl - qgroup_rsv_total(qg) - qg->excl;
+			threshold = min_t(u64, qg->max_excl / QGROUP_FREE_RATIO,
+					  QGROUP_FREE_SIZE);
+		} else {
+			free = qg->max_rfer - qgroup_rsv_total(qg) - qg->rfer;
+			threshold = min_t(u64, qg->max_rfer / QGROUP_FREE_RATIO,
+					  QGROUP_FREE_SIZE);
+		}
 
 		/*
 		 * Use transaction_kthread to commit transaction, so we no
 		 * longer need to bother nested transaction nor lock context.
 		 */
-		if (qg->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS] > threshold)
+		if (free < threshold)
 			btrfs_commit_transaction_locksafe(fs_info);
 	}
 
-- 
2.19.1

