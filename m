Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02466C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCEB20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="T8eDwPeK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCCEB20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbeLCPVB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:21:01 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43021 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeLCPVA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:21:00 -0500
Received: by mail-yb1-f196.google.com with SMTP id x144so1256117ybg.10
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=7pkuIGhBeFNoexUWutrfJ+o+6+fDIQj9nz0xcSK0ItI=;
        b=T8eDwPeKVEDYoa0A/QHJWJ5aMqTJlGibU9THDACpUESRcPwhUcTQDIKYQwmhgKrOmE
         CflN2TwtRL5YEFc4PMmINkZUywVc8Rw/rI+qKwd6566g+FqmEdiKBYvH06ErdbMYR9/o
         z4ocUb4R5pogCIuVMz7yZEsbv70GKD6DIb32D0GDFWA6xTPm7I9roEKpNUZjuzPhTt9q
         i6s3cuAGOseOPCH/OmixnyBgrr7C/w+5GjA+rOgS3Bf3UBRObgH9nINqWLz5XnfZaOoc
         MN1Vy5/iwJGOVhLEJt+i/WLLn8v60eAHBqNA1LFN9B0pPJ3oxKlh+f/WXuFcj4kuppQj
         9AQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=7pkuIGhBeFNoexUWutrfJ+o+6+fDIQj9nz0xcSK0ItI=;
        b=jxViA4jXePCenWoPrayMkVBfnPb2lIjcI00L7SIU8HdfEtBCsTzAF4pKZtRPRz53qy
         S3qQGghu4zslJzTaM4ldd2fZGFjdy6XBiJBqaK0FG437pXt2AuzmDqMSfFCnJTlY4YNS
         T0PuGwlvWRCAy/xhSk4qvWMcXpkrRz8J9+Eh8tK7kq9bj2ZL7cyhzCigrOoBNMScPRaX
         1+Xu/757zSVzynU43bDP1HOVBJQ+P/7YB5MWqKvBIpDbz0ly3BqQ6BuW9zOi6cfvfgPO
         yHxHp9XMksQLYs53H9li15+/Ud+sXqwIHaLxi5FHCK9i3ksqaksw2gNinZZYpwfhWIW+
         yOrw==
X-Gm-Message-State: AA+aEWbWbEsOrVDFktNDoyvJsv62A6egtkMiHZAcDGc2WAkCn3NeXXwQ
        2AHRvoakK9esaG9pqzEHg9vwtXS+dmQ=
X-Google-Smtp-Source: AFSGD/W3ab+bB+dG401i018CZgl/+710SO+ZOPIEJ1ifyD/U7RWgr5pSmvDueDnsdT7GKmwjlEfAnQ==
X-Received: by 2002:a25:3c43:: with SMTP id j64-v6mr15761303yba.517.1543850458838;
        Mon, 03 Dec 2018 07:20:58 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 136sm5176831ywm.28.2018.12.03.07.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:58 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 10/10] btrfs: fix truncate throttling
Date:   Mon,  3 Dec 2018 10:20:38 -0500
Message-Id: <20181203152038.21388-11-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a bunch of magic to make sure we're throttling delayed refs when
truncating a file.  Now that we have a delayed refs rsv and a mechanism
for refilling that reserve simply use that instead of all of this magic.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 79 ++++++++++++--------------------------------------------
 1 file changed, 17 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8532a2eb56d1..623a71d871d4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4437,31 +4437,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
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
@@ -4506,7 +4481,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
 	bool should_throttle = false;
-	bool should_end = false;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4719,15 +4693,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				btrfs_abort_transaction(trans, ret);
 				break;
 			}
-			if (btrfs_should_throttle_delayed_refs(trans))
-				btrfs_async_run_delayed_refs(fs_info,
-					trans->delayed_ref_updates * 2,
-					trans->transid, 0);
 			if (be_nice) {
-				if (truncate_space_check(trans, root,
-							 extent_num_bytes)) {
-					should_end = true;
-				}
 				if (btrfs_should_throttle_delayed_refs(trans))
 					should_throttle = true;
 			}
@@ -4738,7 +4704,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot ||
-		    should_throttle || should_end) {
+		    should_throttle) {
 			if (pending_del_nr) {
 				ret = btrfs_del_items(trans, root, path,
 						pending_del_slot,
@@ -4750,23 +4716,24 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
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
+				ret = btrfs_delayed_refs_rsv_refill(fs_info,
+							BTRFS_RESERVE_NO_FLUSH);
+				if (ret) {
+					ret = -EAGAIN;
+					break;
+				}
 			}
 			goto search_again;
 		} else {
@@ -4792,18 +4759,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
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

