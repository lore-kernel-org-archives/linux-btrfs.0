Return-Path: <SRS0=AaGw=3S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E14C2D0DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FE2206D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jan 2020 18:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbgA2SNu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:13:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:42116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgA2SNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jan 2020 13:13:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0DE40AC77;
        Wed, 29 Jan 2020 18:13:48 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     dsterba@suse.com
Cc:     nborisov@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] btrfs: optimize barrier usage for Rmw atomics
Date:   Wed, 29 Jan 2020 10:03:24 -0800
Message-Id: <20200129180324.24099-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use smp_mb__after_atomic() instead of smp_mb() and avoid the
unnecessary barrier for non LL/SC architectures, such as x86.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 fs/btrfs/btrfs_inode.h | 2 +-
 fs/btrfs/file.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4e12a477d32e..54e0d2ae22cc 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -325,7 +325,7 @@ struct btrfs_dio_private {
 static inline void btrfs_inode_block_unlocked_dio(struct btrfs_inode *inode)
 {
 	set_bit(BTRFS_INODE_READDIO_NEED_LOCK, &inode->runtime_flags);
-	smp_mb();
+	smp_mb__after_atomic();
 }
 
 static inline void btrfs_inode_resume_unlocked_dio(struct btrfs_inode *inode)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a16da274c9aa..ea79ab068079 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2143,7 +2143,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 	atomic_inc(&root->log_batch);
 
-	smp_mb();
+	smp_mb__after_atomic();
 	if (btrfs_inode_in_log(BTRFS_I(inode), fs_info->generation) ||
 	    BTRFS_I(inode)->last_trans <= fs_info->last_trans_committed) {
 		/*
-- 
2.16.4

