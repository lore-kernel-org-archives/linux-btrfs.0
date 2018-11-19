Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF83FC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD76020823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="baCobnnL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD76020823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbeKSULX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbeKSULX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:11:23 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FB820823
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542620896;
        bh=Jkm269E+7toSTY9W0uoeEnXHwD2OQ4x348FPYMdknTg=;
        h=From:To:Subject:Date:From;
        b=baCobnnLO6y0EACuktg7sZozjmNc3duJTW2sMstgVJieY3wn5hHyBZMpfy7NHdeRV
         Eyg07eyttG7w3IX/OOK6JL9WwdFP8ygX1FfdP/5eE4+WmQc0z8PD0NAoKKm7MKJJHL
         BHJRfHe51FohQnJCuoRJOBx3a4+qdNspMezM/qzw=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix access to available allocation bits when starting balance
Date:   Mon, 19 Nov 2018 09:48:12 +0000
Message-Id: <20181119094812.27296-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The available allocation bits members from struct btrfs_fs_info are
protected by a sequence lock, and when starting balance we access them
incorrectly in two different ways:

1) In the read sequence lock loop at btrfs_balance() we use the values we
   read from fs_info->avail_*_alloc_bits and we can immediately do actions
   that have side effects and can not be undone (printing a message and
   jumping to a label). This is wrong because a retry might be needed, so
   our actions must not have side effects and must be repeatable as long
   as read_seqretry() returns a non-zero value. In other words, we were
   essentially ignoring the sequence lock;

2) Right below the read sequence lock loop, we were reading the values
   from avail_metadata_alloc_bits and avail_data_alloc_bits without any
   protection from concurrent writers, that is, reading them outside of
   the read sequence lock critical section.

So fix this by making sure we only read the available allocation bits
while in a read sequence lock critical section and that what we do in the
critical section is repeatable (has nothing that can not be undone) so
that any eventual retry that is needed is handled properly.

Fixes: de98ced9e743 ("Btrfs: use seqlock to protect fs_info->avail_{data, metadata, system}_alloc_bits")
Fixes: 14506127979a ("btrfs: fix a bogus warning when converting only data or metadata")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4405e430da6..223334f08530 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3712,6 +3712,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	int ret;
 	u64 num_devices;
 	unsigned seq;
+	bool reducing_integrity;
 
 	if (btrfs_fs_closing(fs_info) ||
 	    atomic_read(&fs_info->balance_pause_req) ||
@@ -3796,24 +3797,30 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		     !(bctl->sys.target & allowed)) ||
 		    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 		     (fs_info->avail_metadata_alloc_bits & allowed) &&
-		     !(bctl->meta.target & allowed))) {
-			if (bctl->flags & BTRFS_BALANCE_FORCE) {
-				btrfs_info(fs_info,
-				"balance: force reducing metadata integrity");
-			} else {
-				btrfs_err(fs_info,
-	"balance: reduces metadata integrity, use --force if you want this");
-				ret = -EINVAL;
-				goto out;
-			}
-		}
+		     !(bctl->meta.target & allowed)))
+			reducing_integrity = true;
+		else
+			reducing_integrity = false;
+
+		/* if we're not converting, the target field is uninitialized */
+		meta_target = (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
+			bctl->meta.target : fs_info->avail_metadata_alloc_bits;
+		data_target = (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
+			bctl->data.target : fs_info->avail_data_alloc_bits;
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
-	/* if we're not converting, the target field is uninitialized */
-	meta_target = (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
-		bctl->meta.target : fs_info->avail_metadata_alloc_bits;
-	data_target = (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
-		bctl->data.target : fs_info->avail_data_alloc_bits;
+	if (reducing_integrity) {
+		if (bctl->flags & BTRFS_BALANCE_FORCE) {
+			btrfs_info(fs_info,
+				   "balance: force reducing metadata integrity");
+		} else {
+			btrfs_err(fs_info,
+	  "balance: reduces metadata integrity, use --force if you want this");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	if (btrfs_get_num_tolerated_disk_barrier_failures(meta_target) <
 		btrfs_get_num_tolerated_disk_barrier_failures(data_target)) {
 		int meta_index = btrfs_bg_flags_to_raid_index(meta_target);
-- 
2.11.0

