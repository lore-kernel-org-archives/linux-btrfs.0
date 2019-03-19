Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7243CC10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 06:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4310B2133D
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 06:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfCSGE1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 02:04:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:42760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726731AbfCSGE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 02:04:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 414F3AFB8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 06:04:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Introduce new tree block flag, BTRFS_HEADER_FLAG_LOG
Date:   Tue, 19 Mar 2019 14:04:18 +0800
Message-Id: <20190319060418.29575-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190319060418.29575-1-wqu@suse.com>
References: <20190319060418.29575-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This new tree block flag is to indicate the tree block belongs to a log
tree.

For btrfs on-disk format, there are several different trees could use
the same owner number:
- ordinary subvolume tree
- log tree for ordinary subvolume
- reloc tree for ordinary subvolume

It's possible to do the backref walk or use the content to determine the
real owner of the tree block.
But backref walk is too expensive, content detection is not reliable.

So adding a new flag to explicitly show the owner of log tree.

Thankfully, tree-checker hasn't checked header flags yet, and there is
no real user for this flag yet.
So we don't need to introduce any compatibility flag for this
modification.

The introduction of this new flag makes tree block owner easier to
distinguish, making life easier for:
- tree checker on log tree
  Log tree could contain some items impossible for regular trees
- performance profiler
  Now it's much easier to distinguish log tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c              | 1 +
 include/uapi/linux/btrfs_tree.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fe9197f6ee4..8cffdb7789d8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1362,6 +1362,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 		return ERR_CAST(leaf);
 	}
 
+	btrfs_set_header_flag(leaf, BTRFS_HEADER_FLAG_LOG);
 	root->node = leaf;
 
 	btrfs_mark_buffer_dirty(root->node);
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index e974f4bb5378..d4ef80b702a0 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -447,9 +447,15 @@ struct btrfs_free_space_header {
 	__le64 num_bitmaps;
 } __attribute__ ((__packed__));
 
+/* Tree/super has written to disk */
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
+
+/* Tree block which gets relocated */
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
 
+/* Tree block which belows to log tree */
+#define BTRFS_HEADER_FLAG_LOG		(1ULL << 2)
+
 /* Super block flags */
 /* Errors detected */
 #define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
-- 
2.21.0

