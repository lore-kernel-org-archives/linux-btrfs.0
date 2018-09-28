Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F16C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20758215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wJ3twJIV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20758215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbeI1Rm5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33362 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rm4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id 84-v6so3595160qkf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ClFA1IppPtkTYcFpzPGI9iJqwl/ciCdtCKaL1iQ0hJo=;
        b=wJ3twJIV0AP0IzKg432zczGQI0GzmMg85cwYcv5GMRggM7MTnaon7s0lSQF5uptocI
         qa1wRlpCgbz0Dy9T+i/O+G/HdFhv/nPrJy13DN6waTyWlq2wR8UD06meZTT+4GQ6oo3g
         u3juzb3ikQoNHlyVksYQPoXbsxapVM69JLDvQzRjWrma2TctR039x4QMPUcfm6nxcZu/
         cteJk9hGZDn985ScPHAyfQNh8Ckjrx939yiwQbCTjt0enJEkEVdeb//rE3E6U7hESiil
         9kkQ90zJSe3+ITqjndUYL3YcpPW6URC5iXMbaCrHVF/y/Oe1KGI9Wuc5o3kGMqS+r5Yk
         6tgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ClFA1IppPtkTYcFpzPGI9iJqwl/ciCdtCKaL1iQ0hJo=;
        b=CJSSiyB+oZ+CloWHG8rgRc2cZ6JaFf9noBX39qsGyp9EVkcnedpfrbabxdum8HKa11
         PGDRYZUcDwNSJzygwvursiu3f6/9a6JQnCTv98xUqY5PrMybd0gbPIxJxMYnrVkj1vZC
         TrrqhHb1sgs34/u0nMEERf1BVPIAiAX61BAldExNsMBya82S1ts/41Y0XOv9MmTWgJfL
         ZYdywB4YDmSs3pl5UrDvZe3FKRTiTnqi2fHFwiopg6zoBqLauj/Ren+RpKB47fV3e7BU
         ahrXxyNa0an2RyTPyXKzl8z2Vv3cYc60O09/298CmHwhe5Pb5Tlfmcws77tGZXzndUtW
         b0VA==
X-Gm-Message-State: ABuFfohCe2qxDcfgFf91JFD8lwZXkITmboCtJHOQjo9Izg/n7HEmEk2w
        UfZY+HcZhr5JfElG/nIctvlGUVQXxww=
X-Google-Smtp-Source: ACcGV639ynIomDL2c2foqsVHBS8UQH6Z8a7RJWySpOD76xQMO3r7B3v2urDbOGzHYSWGmbGmOS9slw==
X-Received: by 2002:a37:5e82:: with SMTP id s124-v6mr11386086qkb.313.1538133578821;
        Fri, 28 Sep 2018 04:19:38 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g14-v6sm3179563qtc.66.2018.09.28.04.19.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:37 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 40/42] btrfs: drop min_size from evict_refill_and_join
Date:   Fri, 28 Sep 2018 07:18:19 -0400
Message-Id: <20180928111821.24376-41-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We don't need it, rsv->size is set once and never changes throughout
its lifetime, so just use that for the reserve size.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ab8242b10601..dbcca915e681 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5339,8 +5339,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 }
 
 static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
-							struct btrfs_block_rsv *rsv,
-							u64 min_size)
+							struct btrfs_block_rsv *rsv)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
@@ -5350,7 +5349,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		struct btrfs_trans_handle *trans;
 		int ret;
 
-		ret = btrfs_block_rsv_refill(root, rsv, min_size,
+		ret = btrfs_block_rsv_refill(root, rsv, rsv->size,
 					     BTRFS_RESERVE_FLUSH_LIMIT);
 
 		if (ret && ++failures > 2) {
@@ -5368,7 +5367,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * it.
 		 */
 		if (!btrfs_check_space_for_delayed_refs(fs_info) &&
-		    !btrfs_block_rsv_migrate(global_rsv, rsv, min_size, 0))
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, 0))
 			return trans;
 
 		/* If not, commit and try again. */
@@ -5384,7 +5383,6 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
-	u64 min_size;
 	int ret;
 
 	trace_btrfs_inode_evict(inode);
@@ -5394,8 +5392,6 @@ void btrfs_evict_inode(struct inode *inode)
 		return;
 	}
 
-	min_size = btrfs_calc_trunc_metadata_size(fs_info, 1);
-
 	evict_inode_truncate_pages(inode);
 
 	if (inode->i_nlink &&
@@ -5428,13 +5424,13 @@ void btrfs_evict_inode(struct inode *inode)
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv)
 		goto no_delete;
-	rsv->size = min_size;
+	rsv->size = btrfs_calc_trunc_metadata_size(fs_info, 1);
 	rsv->failfast = 1;
 
 	btrfs_i_size_write(BTRFS_I(inode), 0);
 
 	while (1) {
-		trans = evict_refill_and_join(root, rsv, min_size);
+		trans = evict_refill_and_join(root, rsv);
 		if (IS_ERR(trans))
 			goto free_rsv;
 
@@ -5459,7 +5455,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * If it turns out that we are dropping too many of these, we might want
 	 * to add a mechanism for retrying these after a commit.
 	 */
-	trans = evict_refill_and_join(root, rsv, min_size);
+	trans = evict_refill_and_join(root, rsv);
 	if (!IS_ERR(trans)) {
 		trans->block_rsv = rsv;
 		btrfs_orphan_del(trans, BTRFS_I(inode));
-- 
2.14.3

