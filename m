Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9838CC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6097C2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hjUsEk57"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6097C2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbeJMDHX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33475 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id q40-v6so15083780qte.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=09uUQnLegRaGDa0gAKaXhW+r7F/us0LEAwdMnUEs3rc=;
        b=hjUsEk57aQgcQAlklygzfUJWcpB011TV45foxKQ3boafHCWPqPcBhaSNdE16BuC6RB
         BoTIzsSVVuqkgVb4UNLboOzR3TGr9okTPknoesaVDEwY1kOQKkoHTGaoiBf3Asa4bUY7
         Gt0++E5pm3s/3PC6BtHK75R341eWDV5jrnAjifiteVjRs0q9dvCLy3lvJ2TAuiZAjhSR
         WBKPZUxVTZWKxRQpLYSFfrZAldmxc3S4e1iFv2Z1rE8oMVbTKygHCj2WgdAkhEwPGI73
         ogsbADsbEMJ7OYqmXce0WGlo4MAIoU+CiA9oNAk06ZdImMI2Z28lwHJ3Ft9j1pecG9i0
         iqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=09uUQnLegRaGDa0gAKaXhW+r7F/us0LEAwdMnUEs3rc=;
        b=elBQvMNygTKmkEDEBScaaXpGLr0Gwed4e53GWdjIU7pa0nWC0H4dAt4aIJ4w3SUlUo
         95XtlW2BIeWCvUmJ7HseVcYU4A34/VWzETsulK2sa0vqlNOU+1wpHD5PbBGdTuXran4v
         zS0TUFn/uvAOr0kwpfl+WyIbkLSr+Wzxtle4XgnYiRYx9jzngTGsDpPZpPjJe+WUXma4
         BT/g5hyBr6cQXCi5CIYmUtg1vOwngL2m1Gz63u8/i+jLIXhmw6RFwLTaJyKnVNwHmjtD
         X0ghrk0tuDcBOgxJlBWeXNAVjbo8t+kiVmZ7b0MxVLBLtJI7cYREqcUySg4B9U31Lpya
         s+DA==
X-Gm-Message-State: ABuFfoj08Omzwj76a7MxSu4CQf5gK9TJMV/B3sGdQ64ij7msvkcxx1VV
        ymtLXPyR1COH6gPoVpw2AjS5ZiVeHXQ=
X-Google-Smtp-Source: ACcGV62jymBiZTblRGNfkbQug4eiM72uSf5Buo2UFMW40KdbK/WBf0ubG4w2aiRmQ4RI0NR5CA3uPA==
X-Received: by 2002:a0c:d1d6:: with SMTP id k22-v6mr7581355qvh.156.1539372801376;
        Fri, 12 Oct 2018 12:33:21 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m9-v6sm1697236qkl.32.2018.10.12.12.33.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 11/42] btrfs: fix truncate throttling
Date:   Fri, 12 Oct 2018 15:32:25 -0400
Message-Id: <20181012193256.13735-12-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

