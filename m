Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:57160 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728175AbeIMW4o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 18:56:44 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: assert page dirty bit
Date: Fri, 14 Sep 2018 01:46:08 +0800
Message-Id: <1536860768-42604-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
References: <1536703587-94565-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just in case that someone breaks the rule that pages are dirty as long
as eb is dirty.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
v2: fix typo of CONFIG_BTRFS_DEBUG

 fs/btrfs/extent_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fb2bf50134a1..f88231171009 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5184,6 +5184,11 @@ bool set_extent_buffer_dirty(struct extent_buffer *eb)
 			set_page_dirty(eb->pages[i]);
 	}
 
+#ifdef CONFIG_BTRFS_DEBUG
+	for (i = 0; i < num_pages; i++)
+		ASSERT(PageDirty(eb->pages[i]));
+#endif
+
 	return was_dirty;
 }
 
-- 
1.8.3.1
