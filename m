Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8BEC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CB1E20823
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfBVKQ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:16:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:44618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfBVKQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:16:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 555B0B158;
        Fri, 22 Feb 2019 10:16:57 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
Subject: [PATCH 2/5] btrfs: extent_io: Unify the return value of __alloc_extent_buffer() with alloc_extent_buffer()
Date:   Fri, 22 Feb 2019 18:16:41 +0800
Message-Id: <20190222101645.4403-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222101645.4403-1-wqu@suse.com>
References: <20190222101645.4403-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although __alloc_extent_buffer() shouldn't fail due to its __GFP_NOFAIL
flag, to unify the return value type, let's pretend it will return
PTR_ERR() and never return NULL.

The direct callers are:
1) alloc_extent_buffer()
   It's the stub of the call chain, as the only caller is
   btrfs_find_create_tree_block(), and all its callers have already
   checked the return value correctly.

2) __alloc_dummy_extent_buffer()/alloc_dummy_extent_buffer
3) btrfs_clone_extent_buffer()

For call sites 2) and 3), this patch only checks the return value from
__alloc_extent_buffer() but still allow its caller to return NULL.
The NULL return value will be addressed in later commits.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b28a75546700..c73da1752041 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4661,6 +4661,11 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 	__free_extent_buffer(eb);
 }
 
+/*
+ * This function should not fail due to its __GFP_NOFAIL flag.
+ *
+ * But caller should check for PTR_ERR() to be future-proof.
+ */
 static struct extent_buffer *
 __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		      unsigned long len)
@@ -4707,7 +4712,7 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
 	int num_pages = num_extent_pages(src);
 
 	new = __alloc_extent_buffer(src->fs_info, src->start, src->len);
-	if (new == NULL)
+	if (IS_ERR(new))
 		return NULL;
 
 	for (i = 0; i < num_pages; i++) {
@@ -4737,7 +4742,7 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 	int i;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
-	if (!eb)
+	if (IS_ERR(eb))
 		return NULL;
 
 	num_pages = num_extent_pages(eb);
@@ -4921,7 +4926,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 
 	eb = __alloc_extent_buffer(fs_info, start, len);
-	if (!eb)
+	if (IS_ERR(eb))
 		return ERR_PTR(-ENOMEM);
 
 	num_pages = num_extent_pages(eb);
-- 
2.20.1

