Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09757C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA478215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="UTVAeyO1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA478215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbeI1RmE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:04 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40136 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:04 -0400
Received: by mail-qk1-f194.google.com with SMTP id c126-v6so3556743qkd.7
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=09uUQnLegRaGDa0gAKaXhW+r7F/us0LEAwdMnUEs3rc=;
        b=UTVAeyO1rD3U0Vi+yP2tIQqOB55NjYupSWEkX0IfZuqsGLKr9woE9Q/uLbTb/eRojC
         gp/SOsBuV8MSecePRD+E2eFIWlhCgE+zpnRtnGtkjIn+6/lpO2P8mWnf8VlbXX2wM07q
         CXaSyeXL+qhT1Cr5AFR4oN0lDpxK0vcqpNqXw8Xqd32L2oDnT3pMGwV/2bePtPqlxWEv
         EjMccYD+wFCR5TDJXRI5l777VNtK/I4hbM1TEQv90jyMcyMaO+0lb4hsFRrlrbsb1QHi
         EnXuCuE93ucgHjBxgx+SUP2sH8QFyzMMaAWjJCPjj+Ry4TbLyoYBW2Us6eMszJzJFgSu
         Cy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=09uUQnLegRaGDa0gAKaXhW+r7F/us0LEAwdMnUEs3rc=;
        b=s6gWg54OulHsD2LdTxLBhtQZa4NsScOUvvz+ZraSoKad53xvoW8WZwpKF1hu4ovwtM
         dCFiX5tcgIOWO2YRt2wp1bAr97yBwoOlacMdny3RqVimKG7XLGpVaG+q4VL2u8pwH055
         7541TTBm81So5kFwiOTMoje//ENQnKLRR9yk6txoOCScWTurHOC0+3dpnwYyLm2pfmRf
         RMCr4NCv17xqpMMJZ5dOK66HQSVo+6pRiUGHH3wUyTF1deQPmnD331Wa/N43lslDsJ4+
         Ak7g6B+EKuhdvyH42ap6dQAXqLnbpTyXWNtE+PwODdVGAO/DgqzInhbsHTh4iYRFOWmm
         ZBgQ==
X-Gm-Message-State: ABuFfojgoucDyN41jQk+n3rjJ8TIlpB80+g/gNhpxN2EutGLba+K+uL2
        rAfa9FFsCGT/K52vrp6e7yZgYgSgUH4=
X-Google-Smtp-Source: ACcGV60CPA7tJufJTV2vBvfjF/TqC/yLeFrp19DsAlcY4nn73zOuy769JwM7jiNZSV47e7NGWW4L1w==
X-Received: by 2002:a37:8106:: with SMTP id c6-v6mr11203883qkd.261.1538133526015;
        Fri, 28 Sep 2018 04:18:46 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e195-v6sm2816447qka.2.2018.09.28.04.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:44 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 11/42] btrfs: fix truncate throttling
Date:   Fri, 28 Sep 2018 07:17:50 -0400
Message-Id: <20180928111821.24376-12-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a bunch of magic to make sure we're throttling delayed refs when
truncating a file.  Now that we have a delayed refs rsv and a mechanism
for refilling that reserve simply use that instead of all of this magic.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 79 ++++++++++++--------------------------------------------
 1 file changed, 17 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cd00ec869c96..5a91055a13b2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4493,31 +4493,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static int truncate_space_check(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				u64 bytes_deleted)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	int ret;
-
-	/*
-	 * This is only used to apply pressure to the enospc system, we don't
-	 * intend to use this reservation at all.
-	 */
-	bytes_deleted = btrfs_csum_bytes_to_leaves(fs_info, bytes_deleted);
-	bytes_deleted *= fs_info->nodesize;
-	ret = btrfs_block_rsv_add(root, &fs_info->trans_block_rsv,
-				  bytes_deleted, BTRFS_RESERVE_NO_FLUSH);
-	if (!ret) {
-		trace_btrfs_space_reservation(fs_info, "transaction",
-					      trans->transid,
-					      bytes_deleted, 1);
-		trans->bytes_reserved += bytes_deleted;
-	}
-	return ret;
-
-}
-
 /*
  * Return this if we need to call truncate_block for the last bit of the
  * truncate.
@@ -4562,7 +4537,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
 	bool should_throttle = false;
-	bool should_end = false;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4775,15 +4749,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				btrfs_abort_transaction(trans, ret);
 				break;
 			}
-			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
-				btrfs_async_run_delayed_refs(fs_info,
-					trans->delayed_ref_updates * 2,
-					trans->transid, 0);
 			if (be_nice) {
-				if (truncate_space_check(trans, root,
-							 extent_num_bytes)) {
-					should_end = true;
-				}
 				if (btrfs_should_throttle_delayed_refs(trans,
 								       fs_info))
 					should_throttle = true;
@@ -4795,7 +4761,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot ||
-		    should_throttle || should_end) {
+		    should_throttle) {
 			if (pending_del_nr) {
 				ret = btrfs_del_items(trans, root, path,
 						pending_del_slot,
@@ -4807,23 +4773,24 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				pending_del_nr = 0;
 			}
 			btrfs_release_path(path);
-			if (should_throttle) {
-				unsigned long updates = trans->delayed_ref_updates;
-				if (updates) {
-					trans->delayed_ref_updates = 0;
-					ret = btrfs_run_delayed_refs(trans,
-								   updates * 2);
-					if (ret)
-						break;
-				}
-			}
+
 			/*
-			 * if we failed to refill our space rsv, bail out
-			 * and let the transaction restart
+			 * We can generate a lot of delayed refs, so we need to
+			 * throttle every once and a while and make sure we're
+			 * adding enough space to keep up with the work we are
+			 * generating.  Since we hold a transaction here we
+			 * can't flush, and we don't want to FLUSH_LIMIT because
+			 * we could have generated too many delayed refs to
+			 * actually allocate, so just bail if we're short and
+			 * let the normal reservation dance happen higher up.
 			 */
-			if (should_end) {
-				ret = -EAGAIN;
-				break;
+			if (should_throttle) {
+				ret = btrfs_throttle_delayed_refs(fs_info,
+							BTRFS_RESERVE_NO_FLUSH);
+				if (ret) {
+					ret = -EAGAIN;
+					break;
+				}
 			}
 			goto search_again;
 		} else {
@@ -4849,18 +4816,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_free_path(path);
-
-	if (be_nice && bytes_deleted > SZ_32M && (ret >= 0 || ret == -EAGAIN)) {
-		unsigned long updates = trans->delayed_ref_updates;
-		int err;
-
-		if (updates) {
-			trans->delayed_ref_updates = 0;
-			err = btrfs_run_delayed_refs(trans, updates * 2);
-			if (err)
-				ret = err;
-		}
-	}
 	return ret;
 }
 
-- 
2.14.3

