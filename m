Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:45961 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728018AbeILDIQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:16 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: assert page dirty bit
Date: Wed, 12 Sep 2018 06:06:21 +0800
Message-Id: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just in case that someone breaks the rule that pages are dirty as long
as eb is dirty.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/extent_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fb2bf50134a1..99895f196ecb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5184,6 +5184,11 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
 			set_page_dirty(eb->pages[i]);
 	}
 
+#ifdef BTRFS_DEBUG
+	for (i = 0; i < num_pages; i++)
+		ASSERT(PageDirty(eb->pages[i]));
+#endif
+
 	return was_dirty;
 }
 
-- 
1.8.3.1
