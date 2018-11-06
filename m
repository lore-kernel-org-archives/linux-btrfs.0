Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52616C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8662081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A8662081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbeKFQFW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:22 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44988 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387505AbeKFQFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:22 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417657"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:32 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F1E2A4B71EB5;
        Tue,  6 Nov 2018 14:41:33 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:37 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15.1 06/13] btrfs: dedupe: Introduce function to search for an existing hash
Date:   Tue, 6 Nov 2018 14:41:15 +0800
Message-ID: <20181106064122.6154-7-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: F1E2A4B71EB5.AB98E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_search() to handle the job for in-memory
hash tree.

The trick is, we must ensure the delayed ref head is not being run at
the time we search the for the hash.

With inmem_search(), we can implement the btrfs_dedupe_search()
interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 210 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 209 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 951fefd19fde..03ad41423c01 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -7,6 +7,8 @@
 #include "dedupe.h"
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
+#include "qgroup.h"
+#include "transaction.h"
 
 struct inmem_hash {
 	struct rb_node hash_node;
@@ -242,7 +244,6 @@ static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
 	struct inmem_hash *ihash;
 
 	ihash = inmem_alloc_hash(algo);
-
 	if (!ihash)
 		return -ENOMEM;
 
@@ -436,3 +437,210 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	kfree(dedupe_info);
 	return 0;
 }
+
+/*
+ * Caller must ensure the corresponding ref head is not being run.
+ */
+static struct inmem_hash *
+inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
+{
+	struct rb_node **p = &dedupe_info->hash_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+	u16 hash_algo = dedupe_info->hash_algo;
+	int hash_len = btrfs_hash_sizes[hash_algo];
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, hash_node);
+
+		if (memcmp(hash, entry->hash, hash_len) < 0) {
+			p = &(*p)->rb_left;
+		} else if (memcmp(hash, entry->hash, hash_len) > 0) {
+			p = &(*p)->rb_right;
+		} else {
+			/* Found, need to re-add it to LRU list head */
+			list_del(&entry->lru_list);
+			list_add(&entry->lru_list, &dedupe_info->lru_list);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedupe_hash *hash)
+{
+	int ret;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
+	struct btrfs_delayed_ref_head *insert_head;
+	struct btrfs_delayed_data_ref *insert_dref;
+	struct btrfs_qgroup_extent_record *insert_qrecord = NULL;
+	struct inmem_hash *found_hash;
+	int free_insert = 1;
+	int qrecord_inserted = 0;
+	u64 ref_root = root->root_key.objectid;
+	u64 bytenr;
+	u32 num_bytes;
+
+	insert_head = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
+	if (!insert_head)
+		return -ENOMEM;
+	insert_head->extent_op = NULL;
+
+	insert_dref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
+	if (!insert_dref) {
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, insert_head);
+		return -ENOMEM;
+	}
+	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags) &&
+	    is_fstree(ref_root)) {
+		insert_qrecord = kmalloc(sizeof(*insert_qrecord), GFP_NOFS);
+		if (!insert_qrecord) {
+			kmem_cache_free(btrfs_delayed_ref_head_cachep,
+					insert_head);
+			kmem_cache_free(btrfs_delayed_data_ref_cachep,
+					insert_dref);
+			return -ENOMEM;
+		}
+	}
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto free_mem;
+	}
+
+again:
+	mutex_lock(&dedupe_info->lock);
+	found_hash = inmem_search_hash(dedupe_info, hash->hash);
+	/* If we don't find a duplicated extent, just return. */
+	if (!found_hash) {
+		ret = 0;
+		goto out;
+	}
+	bytenr = found_hash->bytenr;
+	num_bytes = found_hash->num_bytes;
+
+	btrfs_init_delayed_ref_head(insert_head, insert_qrecord, bytenr,
+			num_bytes, ref_root, 0, BTRFS_ADD_DELAYED_REF, true,
+			false);
+
+	btrfs_init_delayed_ref_common(trans->fs_info, &insert_dref->node,
+			bytenr, num_bytes, ref_root, BTRFS_ADD_DELAYED_REF,
+			BTRFS_EXTENT_DATA_REF_KEY);
+	insert_dref->root = ref_root;
+	insert_dref->parent = 0;
+	insert_dref->objectid = btrfs_ino(BTRFS_I(inode));
+	insert_dref->offset = file_pos;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(&trans->transaction->delayed_refs,
+					   bytenr);
+	if (!head) {
+		/*
+		 * We can safely insert a new delayed_ref as long as we
+		 * hold delayed_refs->lock.
+		 * Only need to use atomic inc_extent_ref()
+		 */
+		btrfs_add_delayed_data_ref_locked(trans, insert_head,
+				insert_qrecord, insert_dref,
+				BTRFS_ADD_DELAYED_REF, &qrecord_inserted, NULL,
+				NULL);
+		spin_unlock(&delayed_refs->lock);
+
+		trace_add_delayed_data_ref(trans->fs_info, &insert_dref->node,
+				insert_dref, BTRFS_ADD_DELAYED_REF);
+
+		if (ret > 0)
+			kmem_cache_free(btrfs_delayed_data_ref_cachep,
+					insert_dref);
+
+		/* add_delayed_data_ref_locked will free unused memory */
+		free_insert = 0;
+		hash->bytenr = bytenr;
+		hash->num_bytes = num_bytes;
+		ret = 1;
+		goto out;
+	}
+
+	/*
+	 * We can't lock ref head with dedupe_info->lock hold or we will cause
+	 * ABBA dead lock.
+	 */
+	mutex_unlock(&dedupe_info->lock);
+	ret = btrfs_delayed_ref_lock(delayed_refs, head);
+	spin_unlock(&delayed_refs->lock);
+	if (ret == -EAGAIN)
+		goto again;
+
+	mutex_lock(&dedupe_info->lock);
+	/* Search again to ensure the hash is still here */
+	found_hash = inmem_search_hash(dedupe_info, hash->hash);
+	if (!found_hash) {
+		ret = 0;
+		mutex_unlock(&head->mutex);
+		goto out;
+	}
+	ret = 1;
+	hash->bytenr = bytenr;
+	hash->num_bytes = num_bytes;
+
+	/*
+	 * Increase the extent ref right now, to avoid delayed ref run
+	 * Or we may increase ref on non-exist extent.
+	 */
+	btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+			     ref_root,
+			     btrfs_ino(BTRFS_I(inode)), file_pos);
+	mutex_unlock(&head->mutex);
+out:
+	mutex_unlock(&dedupe_info->lock);
+	btrfs_end_transaction(trans);
+
+free_mem:
+	if (free_insert) {
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, insert_head);
+		kmem_cache_free(btrfs_delayed_data_ref_cachep, insert_dref);
+	}
+	if (!qrecord_inserted)
+		kfree(insert_qrecord);
+	return ret;
+}
+
+int btrfs_dedupe_search(struct btrfs_fs_info *fs_info,
+			struct inode *inode, u64 file_pos,
+			struct btrfs_dedupe_hash *hash)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	int ret = -EINVAL;
+
+	if (!hash)
+		return 0;
+
+	/*
+	 * This function doesn't follow fs_info->dedupe_enabled as it will need
+	 * to ensure any hashed extent to go through dedupe routine
+	 */
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	if (WARN_ON(btrfs_dedupe_hash_hit(hash)))
+		return -EINVAL;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		ret = inmem_search(dedupe_info, inode, file_pos, hash);
+
+	/* It's possible hash->bytenr/num_bytenr already changed */
+	if (ret == 0) {
+		hash->num_bytes = 0;
+		hash->bytenr = 0;
+	}
+	return ret;
+}
-- 
2.19.1



