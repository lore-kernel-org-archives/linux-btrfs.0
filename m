Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF5AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA0B20663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADA0B20663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbeK1GxQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:53:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:35316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeK1GxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:53:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5C13ABE7
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 19:54:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C9115DAC3A; Tue, 27 Nov 2018 20:53:59 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 9/9] btrfs: drop extra enum initialization where using defaults
Date:   Tue, 27 Nov 2018 20:53:59 +0100
Message-Id: <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543348078.git.dsterba@suse.com>
References: <cover.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The first auto-assigned value to enum is 0, we can use that and not
initialize all members where the auto-increment does the same. This is
used for values that are not part of on-disk format.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/btrfs_inode.h |  2 +-
 fs/btrfs/ctree.h       | 28 ++++++++++++++--------------
 fs/btrfs/disk-io.h     | 10 +++++-----
 fs/btrfs/qgroup.h      |  2 +-
 fs/btrfs/sysfs.h       |  2 +-
 fs/btrfs/transaction.h | 14 +++++++-------
 6 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4de321aee7a5..fc25607304f2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -20,7 +20,7 @@
  * new data the application may have written before commit.
  */
 enum {
-	BTRFS_INODE_ORDERED_DATA_CLOSE = 0,
+	BTRFS_INODE_ORDERED_DATA_CLOSE,
 	BTRFS_INODE_DUMMY,
 	BTRFS_INODE_IN_DEFRAG,
 	BTRFS_INODE_HAS_ASYNC_EXTENT,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4bb0ac3050ff..f1d1c6ba3aa1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -334,7 +334,7 @@ struct btrfs_node {
  * The slots array records the index of the item or block pointer
  * used while walking the tree.
  */
-enum { READA_NONE = 0, READA_BACK, READA_FORWARD };
+enum { READA_NONE, READA_BACK, READA_FORWARD };
 struct btrfs_path {
 	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
 	int slots[BTRFS_MAX_LEVEL];
@@ -532,18 +532,18 @@ struct btrfs_free_cluster {
 };
 
 enum btrfs_caching_type {
-	BTRFS_CACHE_NO		= 0,
-	BTRFS_CACHE_STARTED	= 1,
-	BTRFS_CACHE_FAST	= 2,
-	BTRFS_CACHE_FINISHED	= 3,
-	BTRFS_CACHE_ERROR	= 4,
+	BTRFS_CACHE_NO,
+	BTRFS_CACHE_STARTED,
+	BTRFS_CACHE_FAST,
+	BTRFS_CACHE_FINISHED,
+	BTRFS_CACHE_ERROR,
 };
 
 enum btrfs_disk_cache_state {
-	BTRFS_DC_WRITTEN	= 0,
-	BTRFS_DC_ERROR		= 1,
-	BTRFS_DC_CLEAR		= 2,
-	BTRFS_DC_SETUP		= 3,
+	BTRFS_DC_WRITTEN,
+	BTRFS_DC_ERROR,
+	BTRFS_DC_CLEAR,
+	BTRFS_DC_SETUP,
 };
 
 struct btrfs_caching_control {
@@ -2621,10 +2621,10 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 /* extent-tree.c */
 
 enum btrfs_inline_ref_type {
-	BTRFS_REF_TYPE_INVALID =	 0,
-	BTRFS_REF_TYPE_BLOCK =		 1,
-	BTRFS_REF_TYPE_DATA =		 2,
-	BTRFS_REF_TYPE_ANY =		 3,
+	BTRFS_REF_TYPE_INVALID,
+	BTRFS_REF_TYPE_BLOCK,
+	BTRFS_REF_TYPE_DATA,
+	BTRFS_REF_TYPE_ANY,
 };
 
 int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4cccba22640f..987a64bc0c66 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -21,11 +21,11 @@
 #define BTRFS_BDEV_BLOCKSIZE	(4096)
 
 enum btrfs_wq_endio_type {
-	BTRFS_WQ_ENDIO_DATA = 0,
-	BTRFS_WQ_ENDIO_METADATA = 1,
-	BTRFS_WQ_ENDIO_FREE_SPACE = 2,
-	BTRFS_WQ_ENDIO_RAID56 = 3,
-	BTRFS_WQ_ENDIO_DIO_REPAIR = 4,
+	BTRFS_WQ_ENDIO_DATA,
+	BTRFS_WQ_ENDIO_METADATA,
+	BTRFS_WQ_ENDIO_FREE_SPACE,
+	BTRFS_WQ_ENDIO_RAID56,
+	BTRFS_WQ_ENDIO_DIO_REPAIR,
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d8f78f5ab854..e4e6ee44073a 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -70,7 +70,7 @@ struct btrfs_qgroup_extent_record {
  *	be converted into META_PERTRANS.
  */
 enum btrfs_qgroup_rsv_type {
-	BTRFS_QGROUP_RSV_DATA = 0,
+	BTRFS_QGROUP_RSV_DATA,
 	BTRFS_QGROUP_RSV_META_PERTRANS,
 	BTRFS_QGROUP_RSV_META_PREALLOC,
 	BTRFS_QGROUP_RSV_LAST,
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index c6ee600aff89..40716b357c1d 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -9,7 +9,7 @@
 extern u64 btrfs_debugfs_test;
 
 enum btrfs_feature_set {
-	FEAT_COMPAT = 0,
+	FEAT_COMPAT,
 	FEAT_COMPAT_RO,
 	FEAT_INCOMPAT,
 	FEAT_MAX
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 703d5116a2fc..f1ba78949d1b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -12,13 +12,13 @@
 #include "ctree.h"
 
 enum btrfs_trans_state {
-	TRANS_STATE_RUNNING		= 0,
-	TRANS_STATE_BLOCKED		= 1,
-	TRANS_STATE_COMMIT_START	= 2,
-	TRANS_STATE_COMMIT_DOING	= 3,
-	TRANS_STATE_UNBLOCKED		= 4,
-	TRANS_STATE_COMPLETED		= 5,
-	TRANS_STATE_MAX			= 6,
+	TRANS_STATE_RUNNING,
+	TRANS_STATE_BLOCKED,
+	TRANS_STATE_COMMIT_START,
+	TRANS_STATE_COMMIT_DOING,
+	TRANS_STATE_UNBLOCKED,
+	TRANS_STATE_COMPLETED,
+	TRANS_STATE_MAX,
 };
 
 #define BTRFS_TRANS_HAVE_FREE_BGS	0
-- 
2.19.1

