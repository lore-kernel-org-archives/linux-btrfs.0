Return-Path: <SRS0=Lj+Q=5C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8D1C10F29
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1641120674
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 08:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgCQINQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 04:13:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:43292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgCQINQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Mar 2020 04:13:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 65C69AE7F
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2020 08:13:14 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 37/39] btrfs: qgroup: Introduce verification for function to ensure old roots ulist matches btrfs_find_all_roots() result
Date:   Tue, 17 Mar 2020 16:11:23 +0800
Message-Id: <20200317081125.36289-38-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317081125.36289-1-wqu@suse.com>
References: <20200317081125.36289-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will introduce a new function, verify_old_roots(), for qgroup
to verify the backref cache based result and old btrfs_find_all_roots()
result.

Since it will impact performance heavily as we are doing two different
backref walk, this verification will only be enabled for
CONFIG_BTRFS_FS_CHECK_INTEGRITY.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 52c491d0d3b1..a29f255874e9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1826,6 +1826,78 @@ static int get_tree_info(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
+/*
+ * Compare the result with old btrfs_find_all_roots() to ensure the new backref
+ * cache based result is correct.
+ */
+static int verify_old_roots(struct btrfs_fs_info *fs_info,
+			    struct ulist *result, u64 bytenr)
+{
+	struct ulist *old;
+	struct ulist_iterator uiter;
+	struct ulist_node *unode;
+	bool not_fstree = false;
+	int ret = 0;
+
+	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old, true);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check the first node, as find_all_roots() will also return
+	 * non-subvolume tree owner.
+	 * Since subvolume tree block won't be shared with non-subvolume
+	 * trees, if we find a non-subolume tree root, we don't need
+	 * to verify at all.
+	 */
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(old, &uiter))) {
+		if (!is_fstree(unode->val))
+			not_fstree = true;
+		break;
+	}
+
+	if (not_fstree && result->nnodes != 0) {
+		btrfs_err(fs_info,
+"qgroup backref cached error, bytenr=%llu found cached node for non-fs tree",
+			  bytenr);
+		ret = -EUCLEAN;
+		goto out;
+	}
+	if (not_fstree)
+		goto out;
+
+	if (result->nnodes != old->nnodes) {
+		btrfs_err(fs_info,
+"qgroup backref cache error, bytenr=%llu nr nodes mismatch, old method=%lu cache method=%lu",
+			  bytenr, old->nnodes, result->nnodes);
+		ret = -EUCLEAN;
+		goto out;
+	}
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(result, &uiter))) {
+		/*
+		 * @result and @old have the same amount of nodes, so if we
+		 * delete each @result node from @old, we either delete all
+		 * nodes from @old (verification pass), or we will hit
+		 * a missing node (verification failure).
+		 */
+		ret = ulist_del(old, unode->val, 0);
+		if (ret) {
+			btrfs_err(fs_info,
+	"qgroup backref cache error, bytenr=%llu root %llu not found in cached result",
+				  bytenr, unode->val);
+			ret = -EUCLEAN;
+			goto out;
+		}
+	}
+out:
+	ulist_free(old);
+	return ret;
+}
+#endif
+
 /* Iterate all roots in the backref_cache, and add root objectid into @roots */
 static int iterate_all_roots(struct backref_node *node, struct ulist *roots)
 {
-- 
2.25.1

