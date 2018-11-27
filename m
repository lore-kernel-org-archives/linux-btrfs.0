Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC372C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB9D820873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB9D820873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbeK1GxC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:35238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC745AC3E
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BE6C8DAC3A; Tue, 27 Nov 2018 20:53:45 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/9] btrfs: switch BTRFS_FS_* to enums
Date:   Tue, 27 Nov 2018 20:53:45 +0100
Message-Id: <9ff441008db0d0bb2780cb94830c66fa65c78f60.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
References: <cover.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can use simple enum for values that are not part of on-disk format:
internal filesystem states.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 63 ++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 40c405d74a01..7176b95b40e7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -757,38 +757,37 @@ struct btrfs_swapfile_pin {
 
 bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
 
-#define BTRFS_FS_BARRIER			1
-#define BTRFS_FS_CLOSING_START			2
-#define BTRFS_FS_CLOSING_DONE			3
-#define BTRFS_FS_LOG_RECOVERING			4
-#define BTRFS_FS_OPEN				5
-#define BTRFS_FS_QUOTA_ENABLED			6
-#define BTRFS_FS_UPDATE_UUID_TREE_GEN		9
-#define BTRFS_FS_CREATING_FREE_SPACE_TREE	10
-#define BTRFS_FS_BTREE_ERR			11
-#define BTRFS_FS_LOG1_ERR			12
-#define BTRFS_FS_LOG2_ERR			13
-#define BTRFS_FS_QUOTA_OVERRIDE			14
-/* Used to record internally whether fs has been frozen */
-#define BTRFS_FS_FROZEN				15
-
-/*
- * Indicate that a whole-filesystem exclusive operation is running
- * (device replace, resize, device add/delete, balance)
- */
-#define BTRFS_FS_EXCL_OP			16
-
-/*
- * To info transaction_kthread we need an immediate commit so it doesn't
- * need to wait for commit_interval
- */
-#define BTRFS_FS_NEED_ASYNC_COMMIT		17
-
-/*
- * Indicate that balance has been set up from the ioctl and is in the main
- * phase. The fs_info::balance_ctl is initialized.
- */
-#define BTRFS_FS_BALANCE_RUNNING		18
+enum {
+	BTRFS_FS_BARRIER,
+	BTRFS_FS_CLOSING_START,
+	BTRFS_FS_CLOSING_DONE,
+	BTRFS_FS_LOG_RECOVERING,
+	BTRFS_FS_OPEN,
+	BTRFS_FS_QUOTA_ENABLED,
+	BTRFS_FS_UPDATE_UUID_TREE_GEN,
+	BTRFS_FS_CREATING_FREE_SPACE_TREE,
+	BTRFS_FS_BTREE_ERR,
+	BTRFS_FS_LOG1_ERR,
+	BTRFS_FS_LOG2_ERR,
+	BTRFS_FS_QUOTA_OVERRIDE,
+	/* Used to record internally whether fs has been frozen */
+	BTRFS_FS_FROZEN,
+	/*
+	 * Indicate that a whole-filesystem exclusive operation is running
+	 * (device replace, resize, device add/delete, balance)
+	 */
+	BTRFS_FS_EXCL_OP,
+	/*
+	 * To info transaction_kthread we need an immediate commit so it
+	 * doesn't need to wait for commit_interval
+	 */
+	BTRFS_FS_NEED_ASYNC_COMMIT,
+	/*
+	 * Indicate that balance has been set up from the ioctl and is in the
+	 * main phase. The fs_info::balance_ctl is initialized.
+	 */
+	BTRFS_FS_BALANCE_RUNNING,
+};
 
 struct btrfs_fs_info {
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
-- 
2.19.1

