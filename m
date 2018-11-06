Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42642C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2DF52081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2DF52081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbeKFQFP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:15 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32866 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387399AbeKFQFP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:15 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417651"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:32 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 383CF4B714D9;
        Tue,  6 Nov 2018 14:41:32 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:35 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15.1 03/13] btrfs: dedupe: Introduce function to add hash into in-memory tree
Date:   Tue, 6 Nov 2018 14:41:12 +0800
Message-ID: <20181106064122.6154-4-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 383CF4B714D9.A93F0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce static function inmem_add() to add hash into in-memory tree.
And now we can implement the btrfs_dedupe_add() interface.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/dedupe.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 150 insertions(+)

diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
index 06523162753d..784bb3a8a5ab 100644
--- a/fs/btrfs/dedupe.c
+++ b/fs/btrfs/dedupe.c
@@ -19,6 +19,14 @@ struct inmem_hash {
 	u8 hash[];
 };
 
+static inline struct inmem_hash *inmem_alloc_hash(u16 algo)
+{
+	if (WARN_ON(algo >= ARRAY_SIZE(btrfs_hash_sizes)))
+		return NULL;
+	return kzalloc(sizeof(struct inmem_hash) + btrfs_hash_sizes[algo],
+			GFP_NOFS);
+}
+
 static struct btrfs_dedupe_info *
 init_dedupe_info(struct btrfs_ioctl_dedupe_args *dargs)
 {
@@ -167,3 +175,145 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
 	/* Place holder for bisect, will be implemented in later patches */
 	return 0;
 }
+
+static int inmem_insert_hash(struct rb_root *root,
+			     struct inmem_hash *hash, int hash_len)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, hash_node);
+		if (memcmp(hash->hash, entry->hash, hash_len) < 0)
+			p = &(*p)->rb_left;
+		else if (memcmp(hash->hash, entry->hash, hash_len) > 0)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->hash_node, parent, p);
+	rb_insert_color(&hash->hash_node, root);
+	return 0;
+}
+
+static int inmem_insert_bytenr(struct rb_root *root,
+			       struct inmem_hash *hash)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct inmem_hash *entry = NULL;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inmem_hash, bytenr_node);
+		if (hash->bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (hash->bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+	rb_link_node(&hash->bytenr_node, parent, p);
+	rb_insert_color(&hash->bytenr_node, root);
+	return 0;
+}
+
+static void __inmem_del(struct btrfs_dedupe_info *dedupe_info,
+			struct inmem_hash *hash)
+{
+	list_del(&hash->lru_list);
+	rb_erase(&hash->hash_node, &dedupe_info->hash_root);
+	rb_erase(&hash->bytenr_node, &dedupe_info->bytenr_root);
+
+	if (!WARN_ON(dedupe_info->current_nr == 0))
+		dedupe_info->current_nr--;
+
+	kfree(hash);
+}
+
+/*
+ * Insert a hash into in-memory dedupe tree
+ * Will remove exceeding last recent use hash.
+ *
+ * If the hash mathced with existing one, we won't insert it, to
+ * save memory
+ */
+static int inmem_add(struct btrfs_dedupe_info *dedupe_info,
+		     struct btrfs_dedupe_hash *hash)
+{
+	int ret = 0;
+	u16 algo = dedupe_info->hash_algo;
+	struct inmem_hash *ihash;
+
+	ihash = inmem_alloc_hash(algo);
+
+	if (!ihash)
+		return -ENOMEM;
+
+	/* Copy the data out */
+	ihash->bytenr = hash->bytenr;
+	ihash->num_bytes = hash->num_bytes;
+	memcpy(ihash->hash, hash->hash, btrfs_hash_sizes[algo]);
+
+	mutex_lock(&dedupe_info->lock);
+
+	ret = inmem_insert_bytenr(&dedupe_info->bytenr_root, ihash);
+	if (ret > 0) {
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	ret = inmem_insert_hash(&dedupe_info->hash_root, ihash,
+				btrfs_hash_sizes[algo]);
+	if (ret > 0) {
+		/*
+		 * We only keep one hash in tree to save memory, so if
+		 * hash conflicts, free the one to insert.
+		 */
+		rb_erase(&ihash->bytenr_node, &dedupe_info->bytenr_root);
+		kfree(ihash);
+		ret = 0;
+		goto out;
+	}
+
+	list_add(&ihash->lru_list, &dedupe_info->lru_list);
+	dedupe_info->current_nr++;
+
+	/* Remove the last dedupe hash if we exceed limit */
+	while (dedupe_info->current_nr > dedupe_info->limit_nr) {
+		struct inmem_hash *last;
+
+		last = list_entry(dedupe_info->lru_list.prev,
+				  struct inmem_hash, lru_list);
+		__inmem_del(dedupe_info, last);
+	}
+out:
+	mutex_unlock(&dedupe_info->lock);
+	return 0;
+}
+
+int btrfs_dedupe_add(struct btrfs_fs_info *fs_info,
+		     struct btrfs_dedupe_hash *hash)
+{
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	if (!fs_info->dedupe_enabled || !hash)
+		return 0;
+
+	if (WARN_ON(dedupe_info == NULL))
+		return -EINVAL;
+
+	if (WARN_ON(!btrfs_dedupe_hash_hit(hash)))
+		return -EINVAL;
+
+	/* ignore old hash */
+	if (dedupe_info->blocksize != hash->num_bytes)
+		return 0;
+
+	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY)
+		return inmem_add(dedupe_info, hash);
+	return -EINVAL;
+}
-- 
2.19.1



