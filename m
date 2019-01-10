Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3372C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA5C20675
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 18:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbfAJSQ5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 13:16:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:53397 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729882AbfAJSQ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 13:16:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 10:16:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="117129265"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2019 10:16:54 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A6B6DF7; Thu, 10 Jan 2019 20:16:53 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] Btrfs: Switch to use new generic UUID API
Date:   Thu, 10 Jan 2019 20:16:53 +0200
Message-Id: <20190110181653.66048-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are new types and helpers that are supposed to be used in new code.

As a preparation to get rid of legacy types and API functions do
the conversion here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
- not tested on actual FS
 fs/btrfs/disk-io.c     |  6 +++---
 fs/btrfs/ioctl.c       | 12 ++----------
 fs/btrfs/root-tree.c   |  4 +---
 fs/btrfs/transaction.c |  7 +++----
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e0ad52804c26..f618661f5fa4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1259,7 +1259,6 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	int ret = 0;
-	uuid_le uuid = NULL_UUID_LE;
 
 	root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	if (!root)
@@ -1293,8 +1292,9 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_last_snapshot(&root->root_item, 0);
 	btrfs_set_root_dirid(&root->root_item, 0);
 	if (is_fstree(objectid))
-		uuid_le_gen(&uuid);
-	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
+		guid_gen((guid_t *)&root->root_item.uuid);
+	else
+		guid_copy((guid_t *)&root->root_item.uuid, &guid_null);
 	root->root_item.drop_level = 0;
 
 	key.objectid = objectid;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c8e1734429c..a40bf7ea9393 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -541,13 +541,7 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 
 int btrfs_is_empty_uuid(u8 *uuid)
 {
-	int i;
-
-	for (i = 0; i < BTRFS_UUID_SIZE; i++) {
-		if (uuid[i])
-			return 0;
-	}
-	return 1;
+	return guid_is_null((guid_t *)uuid);
 }
 
 static noinline int create_subvol(struct inode *dir,
@@ -572,7 +566,6 @@ static noinline int create_subvol(struct inode *dir,
 	u64 objectid;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
-	uuid_le new_uuid;
 
 	root_item = kzalloc(sizeof(*root_item), GFP_KERNEL);
 	if (!root_item)
@@ -642,8 +635,7 @@ static noinline int create_subvol(struct inode *dir,
 
 	btrfs_set_root_generation_v2(root_item,
 			btrfs_root_generation(root_item));
-	uuid_le_gen(&new_uuid);
-	memcpy(root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
+	guid_gen((guid_t *)&root_item->uuid);
 	btrfs_set_stack_timespec_sec(&root_item->otime, cur_time.tv_sec);
 	btrfs_set_stack_timespec_nsec(&root_item->otime, cur_time.tv_nsec);
 	root_item->ctime = root_item->otime;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 65bda0682928..b797792d66bf 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -20,7 +20,6 @@
 static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 				struct btrfs_root_item *item)
 {
-	uuid_le uuid;
 	int len;
 	int need_reset = 0;
 
@@ -42,8 +41,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 			sizeof(*item) - offsetof(struct btrfs_root_item,
 					generation_v2));
 
-		uuid_le_gen(&uuid);
-		memcpy(item->uuid, uuid.b, BTRFS_UUID_SIZE);
+		guid_gen((guid_t *)&item->uuid);
 	}
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 127fa1535f58..394120c9c1f3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1422,7 +1422,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 index = 0;
 	u64 objectid;
 	u64 root_flags;
-	uuid_le new_uuid;
 
 	ASSERT(pending->path);
 	path = pending->path;
@@ -1515,8 +1514,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	btrfs_set_root_generation_v2(new_root_item,
 			trans->transid);
-	uuid_le_gen(&new_uuid);
-	memcpy(new_root_item->uuid, new_uuid.b, BTRFS_UUID_SIZE);
+	guid_gen((guid_t *)&new_root_item->uuid);
 	memcpy(new_root_item->parent_uuid, root->root_item.uuid,
 			BTRFS_UUID_SIZE);
 	if (!(root_flags & BTRFS_ROOT_SUBVOL_RDONLY)) {
@@ -1627,7 +1625,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
-	ret = btrfs_uuid_tree_add(trans, new_uuid.b, BTRFS_UUID_KEY_SUBVOL,
+	ret = btrfs_uuid_tree_add(trans, new_root_item->uuid,
+				  BTRFS_UUID_KEY_SUBVOL,
 				  objectid);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-- 
2.20.1

